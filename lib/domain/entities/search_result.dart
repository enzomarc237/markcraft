import 'package:flutter/foundation.dart';

/// Represents a full-text search result.
@immutable
class SearchResult {
  const SearchResult({
    required this.notePath,
    required this.noteName,
    required this.snippet,
    required this.lineNumber,
    required this.score,
  });

  /// Path of the matching note.
  final String notePath;

  /// Display name of the note.
  final String noteName;

  /// Text snippet around the match.
  final String snippet;

  /// Line number of the match.
  final int lineNumber;

  /// Relevance score (higher = better match).
  final double score;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          notePath == other.notePath &&
          lineNumber == other.lineNumber;

  @override
  int get hashCode => Object.hash(notePath, lineNumber);

  @override
  String toString() =>
      'SearchResult(note: $noteName, score: $score)';
}
