import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ---------- Table Definitions ----------

class Notes extends Table {
  TextColumn get path => text()();
  TextColumn get name => text()();
  TextColumn get content => text()();
  IntColumn get modifiedAt => integer()();
  IntColumn get createdAt => integer()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  TextColumn get frontmatter => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {path};
}

class Backlinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourcePath => text()();
  TextColumn get targetName => text()();
  TextColumn get context => text()();
  IntColumn get lineNumber => integer()();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get notePaths => text().withDefault(const Constant('[]'))();
}

// ---------- Database ----------

@DriftDatabase(tables: [Notes, Backlinks, Tags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }

  // ---------- Notes ----------

  Future<List<NoteData>> getAllNotes() => select(notes).get();

  Future<NoteData?> getNoteByPath(String path) =>
      (select(notes)..where((n) => n.path.equals(path))).getSingleOrNull();

  Future<void> upsertNote(NotesCompanion note) =>
      into(notes).insertOnConflictUpdate(note);

  Future<void> deleteNote(String path) =>
      (delete(notes)..where((n) => n.path.equals(path))).go();

  // ---------- Backlinks ----------

  Future<List<BacklinkData>> getBacklinksForNote(String noteName) =>
      (select(backlinks)..where((b) => b.targetName.equals(noteName))).get();

  Future<void> upsertBacklink(BacklinksCompanion backlink) =>
      into(backlinks).insertOnConflictUpdate(backlink);

  Future<void> deleteBacklinksFromSource(String sourcePath) =>
      (delete(backlinks)..where((b) => b.sourcePath.equals(sourcePath))).go();

  // ---------- Tags ----------

  Future<List<TagData>> getAllTags() => select(tags).get();

  Future<void> upsertTag(TagsCompanion tag) =>
      into(tags).insertOnConflictUpdate(tag);

  // ---------- Full-text search ----------

  Future<List<NoteData>> searchNotes(String query) async {
    if (query.isEmpty) return getAllNotes();
    final lowerQuery = query.toLowerCase();
    return (select(notes)
          ..where((n) =>
              n.name.lower().contains(lowerQuery) |
              n.content.lower().contains(lowerQuery)))
        .get();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'markcraft_db');
  }
}
