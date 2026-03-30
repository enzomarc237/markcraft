import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/vault.dart';
import '../../domain/entities/backlink.dart';
import '../../domain/entities/search_result.dart';
import '../datasources/file_system/file_system_service.dart';
import '../datasources/local_db/app_database.dart';
import '../../core/constants/app_constants.dart';

/// Repository that combines file system and database operations.
class NoteRepository {
  NoteRepository({
    required FileSystemService fileSystemService,
    required AppDatabase database,
  })  : _fs = fileSystemService,
        _db = database;

  final FileSystemService _fs;
  final AppDatabase _db;

  // ---------- Vault ----------

  Future<Vault> openVault(String path) async {
    final vault = await _fs.buildVault(path);
    // Index all notes
    await _indexVault(path);
    return vault;
  }

  // ---------- Notes ----------

  Future<Note> getNote(String path) async {
    return _fs.readNote(path);
  }

  Future<void> saveNote(Note note) async {
    await _fs.saveNote(note.path, note.content);
    await _db.upsertNote(NotesCompanion(
      path: Value(note.path),
      name: Value(note.name),
      content: Value(note.content),
      modifiedAt: Value(note.modifiedAt.millisecondsSinceEpoch),
      createdAt: Value(note.createdAt.millisecondsSinceEpoch),
      tags: Value(note.tags.join(',')),
      frontmatter: Value(jsonEncode(note.frontmatter)),
    ));
    await _indexBacklinks(note);
  }

  Future<String> createNote(String directory, String name) async {
    return _fs.createNote(directory, name);
  }

  Future<void> deleteNote(String path) async {
    await _fs.deleteFile(path);
    await _db.deleteNote(path);
    await _db.deleteBacklinksFromSource(path);
  }

  Future<String> renameNote(String oldPath, String newName) async {
    final fileName = newName.endsWith(AppConstants.markdownExtension)
        ? newName
        : '$newName${AppConstants.markdownExtension}';
    final newPath = await _fs.renameFile(oldPath, fileName);
    // Update DB
    final note = await _fs.readNote(newPath);
    await _db.deleteNote(oldPath);
    await _db.deleteBacklinksFromSource(oldPath);
    await saveNote(note);
    return newPath;
  }

  Future<String> moveNote(String filePath, String targetDirectory) async {
    return _fs.moveFile(filePath, targetDirectory);
  }

  Future<List<String>> listNotes(String vaultPath) async {
    return _fs.listMarkdownFiles(vaultPath);
  }

  // ---------- Backlinks ----------

  Future<List<Backlink>> getBacklinks(String noteName) async {
    final rows = await _db.getBacklinksForNote(noteName);
    return rows
        .map((r) => Backlink(
              sourcePath: r.sourcePath,
              sourceName: p.basenameWithoutExtension(r.sourcePath),
              context: r.context,
              lineNumber: r.lineNumber,
            ))
        .toList();
  }

  // ---------- Search ----------

  Future<List<SearchResult>> search(String vaultPath, String query) async {
    if (query.trim().isEmpty) return [];
    final rows = await _db.searchNotes(query);
    return rows
        .map((r) => SearchResult(
              notePath: r.path,
              noteName: r.name,
              snippet: _extractSnippet(r.content, query),
              lineNumber: 1,
              score: 1.0,
            ))
        .toList();
  }

  // ---------- File Watcher ----------

  Stream<WatchEvent> watchVault(String vaultPath) {
    return _fs.watchVault(vaultPath);
  }

  void stopWatching() {
    _fs.stopWatching();
  }

  // ---------- Private ----------

  Future<void> _indexVault(String vaultPath) async {
    final files = await _fs.listMarkdownFiles(vaultPath);
    for (final path in files) {
      try {
        final note = await _fs.readNote(path);
        await _db.upsertNote(NotesCompanion(
          path: Value(note.path),
          name: Value(note.name),
          content: Value(note.content),
          modifiedAt: Value(note.modifiedAt.millisecondsSinceEpoch),
          createdAt: Value(note.createdAt.millisecondsSinceEpoch),
          tags: Value(note.tags.join(',')),
          frontmatter: Value(jsonEncode(note.frontmatter)),
        ));
        await _indexBacklinks(note);
      } catch (_) {
        // Skip files that can't be read
      }
    }
  }

  Future<void> _indexBacklinks(Note note) async {
    await _db.deleteBacklinksFromSource(note.path);

    final regex = RegExp(AppConstants.wikiLinkPattern);
    final lines = note.content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final matches = regex.allMatches(lines[i]);
      for (final match in matches) {
        final targetName = match.group(1)?.trim() ?? '';
        if (targetName.isNotEmpty) {
          await _db.upsertBacklink(BacklinksCompanion(
            sourcePath: Value(note.path),
            targetName: Value(targetName),
            context: Value(lines[i].trim()),
            lineNumber: Value(i + 1),
          ));
        }
      }
    }
  }

  String _extractSnippet(String content, String query) {
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final idx = lowerContent.indexOf(lowerQuery);
    if (idx == -1) return content.substring(0, content.length.clamp(0, 100));

    final start = (idx - 40).clamp(0, content.length);
    final end = (idx + query.length + 40).clamp(0, content.length);
    final snippet = content.substring(start, end).trim();
    return snippet;
  }
}
