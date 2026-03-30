import 'package:flutter/foundation.dart';

/// Represents a backlink – another note that references the current note.
@immutable
class Backlink {
  const Backlink({
    required this.sourcePath,
    required this.sourceName,
    required this.context,
    required this.lineNumber,
  });

  /// Path of the note that contains the link.
  final String sourcePath;

  /// Display name of the source note.
  final String sourceName;

  /// Surrounding text context for the link.
  final String context;

  /// Line number in the source file where the link appears.
  final int lineNumber;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Backlink &&
          sourcePath == other.sourcePath &&
          lineNumber == other.lineNumber;

  @override
  int get hashCode => Object.hash(sourcePath, lineNumber);

  @override
  String toString() =>
      'Backlink(from: $sourceName, line: $lineNumber)';
}
