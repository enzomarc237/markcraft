import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/file_system/file_system_service.dart';
import '../../data/datasources/local_db/app_database.dart';
import '../../data/repositories/note_repository.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/vault.dart';

// ---------- Infrastructure ----------

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final fileSystemServiceProvider = Provider<FileSystemService>(
  (ref) => FileSystemService(),
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) {
    final db = AppDatabase();
    ref.onDispose(() => db.close());
    return db;
  },
);

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(
    fileSystemService: ref.watch(fileSystemServiceProvider),
    database: ref.watch(appDatabaseProvider),
  ),
);

// ---------- Theme ----------

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs)
      : super(_load(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _load(SharedPreferences prefs) {
    final value = prefs.getString(AppConstants.themeModeKey) ?? 'system';
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await _prefs.setString(AppConstants.themeModeKey, value);
  }

  void toggleTheme() {
    setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

// ---------- Vault ----------

final vaultProvider = StateNotifierProvider<VaultNotifier, AsyncValue<Vault?>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repo = ref.watch(noteRepositoryProvider);
  return VaultNotifier(prefs, repo);
});

class VaultNotifier extends StateNotifier<AsyncValue<Vault?>> {
  VaultNotifier(this._prefs, this._repo) : super(const AsyncValue.data(null)) {
    _loadSavedVault();
  }

  final SharedPreferences _prefs;
  final NoteRepository _repo;

  Future<void> _loadSavedVault() async {
    final savedPath = _prefs.getString(AppConstants.vaultPathKey);
    if (savedPath != null) {
      await openVault(savedPath);
    }
  }

  Future<void> openVault(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vault = await _repo.openVault(path);
      await _prefs.setString(AppConstants.vaultPathKey, path);
      return vault;
    });
  }

  Future<void> refreshVault() async {
    final current = state.valueOrNull;
    if (current != null) {
      await openVault(current.path);
    }
  }
}

// ---------- Active Note ----------

final activeNotePathProvider = StateProvider<String?>((ref) => null);

final activeNoteProvider =
    StateNotifierProvider<ActiveNoteNotifier, AsyncValue<Note?>>((ref) {
  return ActiveNoteNotifier(ref.watch(noteRepositoryProvider));
});

class ActiveNoteNotifier extends StateNotifier<AsyncValue<Note?>> {
  ActiveNoteNotifier(this._repo) : super(const AsyncValue.data(null));

  final NoteRepository _repo;

  Future<void> openNote(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getNote(path));
  }

  Future<void> saveNote(Note note) async {
    await _repo.saveNote(note);
    state = AsyncValue.data(note);
  }

  void updateContent(String content) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(
        current.copyWith(
          content: content,
          modifiedAt: DateTime.now(),
        ),
      );
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

// ---------- Editor Mode ----------

enum EditorMode { split, editorOnly, previewOnly }

final editorModeProvider = StateProvider<EditorMode>(
  (ref) => EditorMode.split,
);

// ---------- Sidebar ----------

final sidebarVisibleProvider = StateProvider<bool>((ref) => true);
final sidebarWidthProvider = StateProvider<double>(
  (ref) => AppConstants.defaultSidebarWidth,
);

// ---------- Command Palette ----------

final commandPaletteVisibleProvider = StateProvider<bool>((ref) => false);
final commandPaletteQueryProvider = StateProvider<String>((ref) => '');

// ---------- Search ----------

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final vault = ref.watch(vaultProvider).valueOrNull;
  if (vault == null) return [];
  final repo = ref.watch(noteRepositoryProvider);
  return repo.search(vault.path, query);
});

// ---------- Backlinks ----------

final backlinksProvider =
    FutureProvider.family<List<dynamic>, String>((ref, noteName) async {
  final repo = ref.watch(noteRepositoryProvider);
  return repo.getBacklinks(noteName);
});

// ---------- Notes List ----------

final notesInFolderProvider =
    FutureProvider.family<List<Note>, String>((ref, folderPath) async {
  final repo = ref.watch(noteRepositoryProvider);
  final fs = ref.watch(fileSystemServiceProvider);
  final files = await fs.listMarkdownFiles(folderPath);
  // Only direct children (not recursive) - filter by parent
  final directChildren = files.where((f) {
    final parent = f.substring(0, f.lastIndexOf('/'));
    return parent == folderPath;
  }).toList();

  final notes = <Note>[];
  for (final path in directChildren) {
    try {
      final note = await repo.getNote(path);
      notes.add(note);
    } catch (_) {}
  }
  notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
  return notes;
});

// ---------- Zen Mode ----------

final zenModeProvider = StateProvider<bool>((ref) => false);

// ---------- Selected Folder ----------

final selectedFolderProvider = StateProvider<String?>((ref) => null);
