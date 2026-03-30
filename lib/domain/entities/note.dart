import 'package:flutter/foundation.dart';

/// Represents a Markdown note file on disk.
@immutable
class Note {
  const Note({
    required this.path,
    required this.name,
    required this.content,
    required this.modifiedAt,
    required this.createdAt,
    this.tags = const [],
    this.aliases = const [],
    this.frontmatter = const {},
  });

  /// Absolute path to the .md file.
  final String path;

  /// File name without extension.
  final String name;

  /// Raw Markdown content.
  final String content;

  /// Last modification timestamp.
  final DateTime modifiedAt;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Tags extracted from frontmatter.
  final List<String> tags;

  /// Aliases extracted from frontmatter.
  final List<String> aliases;

  /// Full YAML frontmatter key-value pairs.
  final Map<String, dynamic> frontmatter;

  /// Returns content without frontmatter block.
  String get contentWithoutFrontmatter {
    final fm = _extractFrontmatter(content);
    return fm != null ? content.substring(fm.end).trim() : content;
  }

  /// First non-empty line of the note body (title preview).
  String get preview {
    final body = contentWithoutFrontmatter;
    final lines = body.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        // Strip leading # for headings
        return trimmed.replaceAll(RegExp(r'^#+\s*'), '');
      }
    }
    return '';
  }

  Note copyWith({
    String? path,
    String? name,
    String? content,
    DateTime? modifiedAt,
    DateTime? createdAt,
    List<String>? tags,
    List<String>? aliases,
    Map<String, dynamic>? frontmatter,
  }) {
    return Note(
      path: path ?? this.path,
      name: name ?? this.name,
      content: content ?? this.content,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      aliases: aliases ?? this.aliases,
      frontmatter: frontmatter ?? this.frontmatter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Note && path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'Note(path: $path, name: $name)';

  static RegExpMatch? _extractFrontmatter(String content) {
    final regex = RegExp(r'^---\s*\n([\s\S]*?)\n---\s*\n?');
    return regex.firstMatch(content);
  }
}
