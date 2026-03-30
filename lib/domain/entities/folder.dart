import 'package:flutter/foundation.dart';

/// Represents a folder in the vault.
@immutable
class Folder {
  const Folder({
    required this.path,
    required this.name,
    this.children = const [],
    this.noteCount = 0,
    this.isExpanded = false,
  });

  /// Absolute path to the folder.
  final String path;

  /// Folder display name.
  final String name;

  /// Sub-folders (nested tree).
  final List<Folder> children;

  /// Number of Markdown notes directly in this folder.
  final int noteCount;

  /// Whether the folder is expanded in the sidebar.
  final bool isExpanded;

  Folder copyWith({
    String? path,
    String? name,
    List<Folder>? children,
    int? noteCount,
    bool? isExpanded,
  }) {
    return Folder(
      path: path ?? this.path,
      name: name ?? this.name,
      children: children ?? this.children,
      noteCount: noteCount ?? this.noteCount,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Folder && path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'Folder(path: $path, name: $name)';
}
