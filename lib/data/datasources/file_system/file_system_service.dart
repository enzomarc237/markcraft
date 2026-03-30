import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';
import 'package:yaml/yaml.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/folder.dart';
import '../../domain/entities/vault.dart';
import '../../core/constants/app_constants.dart';

/// Service for interacting with the file system.
class FileSystemService {
  DirectoryWatcher? _watcher;
  Stream<WatchEvent>? _watchStream;

  /// Opens a file and reads its content.
  Future<String> readFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('File not found', path);
    }
    return file.readAsString();
  }

  /// Writes content to a file.
  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  /// Deletes a file (moves to trash on macOS if possible).
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Renames/moves a file.
  Future<String> renameFile(String oldPath, String newName) async {
    final file = File(oldPath);
    final parent = file.parent.path;
    final newPath = p.join(parent, newName);
    await file.rename(newPath);
    return newPath;
  }

  /// Moves a file to a new directory.
  Future<String> moveFile(String filePath, String targetDirectory) async {
    final file = File(filePath);
    final fileName = p.basename(filePath);
    final newPath = p.join(targetDirectory, fileName);
    await file.rename(newPath);
    return newPath;
  }

  /// Creates a new empty note.
  Future<String> createNote(String directory, String name) async {
    final fileName = name.endsWith(AppConstants.markdownExtension)
        ? name
        : '$name${AppConstants.markdownExtension}';
    final filePath = p.join(directory, fileName);
    final file = File(filePath);
    if (await file.exists()) {
      throw FileSystemException('File already exists', filePath);
    }
    final now = DateTime.now().toIso8601String();
    await file.writeAsString('---\ncreated: $now\n---\n\n# $name\n\n');
    return filePath;
  }

  /// Creates a new folder.
  Future<void> createFolder(String parentPath, String name) async {
    final dir = Directory(p.join(parentPath, name));
    await dir.create(recursive: true);
  }

  /// Lists all Markdown files in a directory recursively.
  Future<List<String>> listMarkdownFiles(String vaultPath) async {
    final dir = Directory(vaultPath);
    if (!await dir.exists()) return [];

    final files = <String>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File &&
          p.extension(entity.path).toLowerCase() ==
              AppConstants.markdownExtension) {
        files.add(entity.path);
      }
    }
    return files;
  }

  /// Builds a [Vault] object from a root path.
  Future<Vault> buildVault(String vaultPath) async {
    final dir = Directory(vaultPath);
    if (!await dir.exists()) {
      throw FileSystemException('Vault directory not found', vaultPath);
    }

    final rootFolders = await _buildFolderTree(dir);
    int totalNotes = _countNotes(rootFolders);

    return Vault(
      path: vaultPath,
      name: p.basename(vaultPath),
      rootFolders: rootFolders,
      totalNoteCount: totalNotes,
    );
  }

  /// Reads a note from disk and parses it.
  Future<Note> readNote(String path) async {
    final file = File(path);
    final stat = await file.stat();
    final content = await file.readAsString();
    final parsed = _parseFrontmatter(content);

    return Note(
      path: path,
      name: p.basenameWithoutExtension(path),
      content: content,
      modifiedAt: stat.modified,
      createdAt: parsed['created'] != null
          ? DateTime.tryParse(parsed['created'].toString()) ?? stat.modified
          : stat.modified,
      tags: _extractTags(parsed),
      aliases: _extractAliases(parsed),
      frontmatter: parsed,
    );
  }

  /// Saves note content to disk.
  Future<void> saveNote(String path, String content) async {
    await writeFile(path, content);
  }

  /// Starts watching a vault directory for changes.
  Stream<WatchEvent> watchVault(String vaultPath) {
    _watcher = DirectoryWatcher(vaultPath);
    _watchStream = _watcher!.events;
    return _watchStream!;
  }

  /// Stops the file watcher.
  void stopWatching() {
    _watcher = null;
    _watchStream = null;
  }

  /// Performs full-text search across all markdown files.
  Future<List<Map<String, dynamic>>> searchFiles(
    String vaultPath,
    String query,
  ) async {
    if (query.trim().isEmpty) return [];

    final files = await listMarkdownFiles(vaultPath);
    final results = <Map<String, dynamic>>[];
    final lowerQuery = query.toLowerCase();

    for (final filePath in files) {
      try {
        final content = await readFile(filePath);
        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].toLowerCase().contains(lowerQuery)) {
            results.add({
              'path': filePath,
              'name': p.basenameWithoutExtension(filePath),
              'snippet': lines[i].trim(),
              'lineNumber': i + 1,
              'score': 1.0,
            });
          }
        }
      } catch (_) {
        // Skip files that can't be read
      }
    }

    return results;
  }

  // ---------- Private helpers ----------

  Future<List<Folder>> _buildFolderTree(Directory dir) async {
    final folders = <Folder>[];

    await for (final entity in dir.list()) {
      if (entity is Directory) {
        final name = p.basename(entity.path);
        // Skip hidden directories
        if (name.startsWith('.')) continue;

        final children = await _buildFolderTree(entity);
        int noteCount = 0;
        await for (final f in entity.list()) {
          if (f is File &&
              p.extension(f.path).toLowerCase() ==
                  AppConstants.markdownExtension) {
            noteCount++;
          }
        }

        folders.add(Folder(
          path: entity.path,
          name: name,
          children: children,
          noteCount: noteCount,
        ));
      }
    }

    // Sort alphabetically
    folders.sort((a, b) => a.name.compareTo(b.name));
    return folders;
  }

  int _countNotes(List<Folder> folders) {
    int total = 0;
    for (final folder in folders) {
      total += folder.noteCount;
      total += _countNotes(folder.children);
    }
    return total;
  }

  Map<String, dynamic> _parseFrontmatter(String content) {
    final regex = RegExp(AppConstants.frontmatterPattern);
    final match = regex.firstMatch(content);
    if (match == null) return {};

    try {
      final yaml = loadYaml(match.group(1) ?? '') as YamlMap?;
      if (yaml == null) return {};
      return Map<String, dynamic>.from(yaml);
    } catch (_) {
      return {};
    }
  }

  List<String> _extractTags(Map<String, dynamic> frontmatter) {
    final tags = frontmatter['tags'];
    if (tags == null) return [];
    if (tags is List) return tags.map((t) => t.toString()).toList();
    if (tags is String) {
      return tags
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    }
    return [];
  }

  List<String> _extractAliases(Map<String, dynamic> frontmatter) {
    final aliases = frontmatter['aliases'];
    if (aliases == null) return [];
    if (aliases is List) return aliases.map((a) => a.toString()).toList();
    if (aliases is String) return [aliases];
    return [];
  }
}
