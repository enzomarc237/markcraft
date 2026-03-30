import 'package:flutter/foundation.dart';
import 'folder.dart';

/// Represents the root "Vault" – a user-selected directory.
@immutable
class Vault {
  const Vault({
    required this.path,
    required this.name,
    this.rootFolders = const [],
    this.totalNoteCount = 0,
  });

  /// Absolute path to the vault root directory.
  final String path;

  /// Display name (folder name).
  final String name;

  /// Top-level folders in the vault.
  final List<Folder> rootFolders;

  /// Total number of notes in the vault.
  final int totalNoteCount;

  Vault copyWith({
    String? path,
    String? name,
    List<Folder>? rootFolders,
    int? totalNoteCount,
  }) {
    return Vault(
      path: path ?? this.path,
      name: name ?? this.name,
      rootFolders: rootFolders ?? this.rootFolders,
      totalNoteCount: totalNoteCount ?? this.totalNoteCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Vault && path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'Vault(path: $path, name: $name)';
}
