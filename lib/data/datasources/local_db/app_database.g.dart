// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<int> modifiedAt = GeneratedColumn<int>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _frontmatterMeta =
      const VerificationMeta('frontmatter');
  @override
  late final GeneratedColumn<String> frontmatter = GeneratedColumn<String>(
      'frontmatter', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns =>
      [path, name, content, modifiedAt, createdAt, tags, frontmatter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('frontmatter')) {
      context.handle(
          _frontmatterMeta,
          frontmatter.isAcceptableOrUnknown(
              data['frontmatter']!, _frontmatterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}modified_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      frontmatter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frontmatter'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String path;
  final String name;
  final String content;
  final int modifiedAt;
  final int createdAt;
  final String tags;
  final String frontmatter;
  const Note(
      {required this.path,
      required this.name,
      required this.content,
      required this.modifiedAt,
      required this.createdAt,
      required this.tags,
      required this.frontmatter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['name'] = Variable<String>(name);
    map['content'] = Variable<String>(content);
    map['modified_at'] = Variable<int>(modifiedAt);
    map['created_at'] = Variable<int>(createdAt);
    map['tags'] = Variable<String>(tags);
    map['frontmatter'] = Variable<String>(frontmatter);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      path: Value(path),
      name: Value(name),
      content: Value(content),
      modifiedAt: Value(modifiedAt),
      createdAt: Value(createdAt),
      tags: Value(tags),
      frontmatter: Value(frontmatter),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String>(json['name']),
      content: serializer.fromJson<String>(json['content']),
      modifiedAt: serializer.fromJson<int>(json['modifiedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      tags: serializer.fromJson<String>(json['tags']),
      frontmatter: serializer.fromJson<String>(json['frontmatter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String>(name),
      'content': serializer.toJson<String>(content),
      'modifiedAt': serializer.toJson<int>(modifiedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'tags': serializer.toJson<String>(tags),
      'frontmatter': serializer.toJson<String>(frontmatter),
    };
  }

  Note copyWith(
          {String? path,
          String? name,
          String? content,
          int? modifiedAt,
          int? createdAt,
          String? tags,
          String? frontmatter}) =>
      Note(
        path: path ?? this.path,
        name: name ?? this.name,
        content: content ?? this.content,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        createdAt: createdAt ?? this.createdAt,
        tags: tags ?? this.tags,
        frontmatter: frontmatter ?? this.frontmatter,
      );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      content: data.content.present ? data.content.value : this.content,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      tags: data.tags.present ? data.tags.value : this.tags,
      frontmatter:
          data.frontmatter.present ? data.frontmatter.value : this.frontmatter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('tags: $tags, ')
          ..write('frontmatter: $frontmatter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      path, name, content, modifiedAt, createdAt, tags, frontmatter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.path == this.path &&
          other.name == this.name &&
          other.content == this.content &&
          other.modifiedAt == this.modifiedAt &&
          other.createdAt == this.createdAt &&
          other.tags == this.tags &&
          other.frontmatter == this.frontmatter);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> path;
  final Value<String> name;
  final Value<String> content;
  final Value<int> modifiedAt;
  final Value<int> createdAt;
  final Value<String> tags;
  final Value<String> frontmatter;
  final Value<int> rowid;
  const NotesCompanion({
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.content = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tags = const Value.absent(),
    this.frontmatter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String path,
    required String name,
    required String content,
    required int modifiedAt,
    required int createdAt,
    this.tags = const Value.absent(),
    this.frontmatter = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : path = Value(path),
        name = Value(name),
        content = Value(content),
        modifiedAt = Value(modifiedAt),
        createdAt = Value(createdAt);
  static Insertable<Note> custom({
    Expression<String>? path,
    Expression<String>? name,
    Expression<String>? content,
    Expression<int>? modifiedAt,
    Expression<int>? createdAt,
    Expression<String>? tags,
    Expression<String>? frontmatter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (tags != null) 'tags': tags,
      if (frontmatter != null) 'frontmatter': frontmatter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? path,
      Value<String>? name,
      Value<String>? content,
      Value<int>? modifiedAt,
      Value<int>? createdAt,
      Value<String>? tags,
      Value<String>? frontmatter,
      Value<int>? rowid}) {
    return NotesCompanion(
      path: path ?? this.path,
      name: name ?? this.name,
      content: content ?? this.content,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      frontmatter: frontmatter ?? this.frontmatter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<int>(modifiedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (frontmatter.present) {
      map['frontmatter'] = Variable<String>(frontmatter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('tags: $tags, ')
          ..write('frontmatter: $frontmatter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BacklinksTable extends Backlinks
    with TableInfo<$BacklinksTable, Backlink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BacklinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourcePathMeta =
      const VerificationMeta('sourcePath');
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
      'source_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetNameMeta =
      const VerificationMeta('targetName');
  @override
  late final GeneratedColumn<String> targetName = GeneratedColumn<String>(
      'target_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextMeta =
      const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
      'context', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lineNumberMeta =
      const VerificationMeta('lineNumber');
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
      'line_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourcePath, targetName, context, lineNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backlinks';
  @override
  VerificationContext validateIntegrity(Insertable<Backlink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_path')) {
      context.handle(
          _sourcePathMeta,
          sourcePath.isAcceptableOrUnknown(
              data['source_path']!, _sourcePathMeta));
    } else if (isInserting) {
      context.missing(_sourcePathMeta);
    }
    if (data.containsKey('target_name')) {
      context.handle(
          _targetNameMeta,
          targetName.isAcceptableOrUnknown(
              data['target_name']!, _targetNameMeta));
    } else if (isInserting) {
      context.missing(_targetNameMeta);
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta,
          this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
          _lineNumberMeta,
          lineNumber.isAcceptableOrUnknown(
              data['line_number']!, _lineNumberMeta));
    } else if (isInserting) {
      context.missing(_lineNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Backlink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Backlink(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourcePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_path'])!,
      targetName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_name'])!,
      context: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context'])!,
      lineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_number'])!,
    );
  }

  @override
  $BacklinksTable createAlias(String alias) {
    return $BacklinksTable(attachedDatabase, alias);
  }
}

class Backlink extends DataClass implements Insertable<Backlink> {
  final int id;
  final String sourcePath;
  final String targetName;
  final String context;
  final int lineNumber;
  const Backlink(
      {required this.id,
      required this.sourcePath,
      required this.targetName,
      required this.context,
      required this.lineNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_path'] = Variable<String>(sourcePath);
    map['target_name'] = Variable<String>(targetName);
    map['context'] = Variable<String>(context);
    map['line_number'] = Variable<int>(lineNumber);
    return map;
  }

  BacklinksCompanion toCompanion(bool nullToAbsent) {
    return BacklinksCompanion(
      id: Value(id),
      sourcePath: Value(sourcePath),
      targetName: Value(targetName),
      context: Value(context),
      lineNumber: Value(lineNumber),
    );
  }

  factory Backlink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Backlink(
      id: serializer.fromJson<int>(json['id']),
      sourcePath: serializer.fromJson<String>(json['sourcePath']),
      targetName: serializer.fromJson<String>(json['targetName']),
      context: serializer.fromJson<String>(json['context']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourcePath': serializer.toJson<String>(sourcePath),
      'targetName': serializer.toJson<String>(targetName),
      'context': serializer.toJson<String>(context),
      'lineNumber': serializer.toJson<int>(lineNumber),
    };
  }

  Backlink copyWith(
          {int? id,
          String? sourcePath,
          String? targetName,
          String? context,
          int? lineNumber}) =>
      Backlink(
        id: id ?? this.id,
        sourcePath: sourcePath ?? this.sourcePath,
        targetName: targetName ?? this.targetName,
        context: context ?? this.context,
        lineNumber: lineNumber ?? this.lineNumber,
      );
  Backlink copyWithCompanion(BacklinksCompanion data) {
    return Backlink(
      id: data.id.present ? data.id.value : this.id,
      sourcePath:
          data.sourcePath.present ? data.sourcePath.value : this.sourcePath,
      targetName:
          data.targetName.present ? data.targetName.value : this.targetName,
      context: data.context.present ? data.context.value : this.context,
      lineNumber:
          data.lineNumber.present ? data.lineNumber.value : this.lineNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Backlink(')
          ..write('id: $id, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('targetName: $targetName, ')
          ..write('context: $context, ')
          ..write('lineNumber: $lineNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourcePath, targetName, context, lineNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backlink &&
          other.id == this.id &&
          other.sourcePath == this.sourcePath &&
          other.targetName == this.targetName &&
          other.context == this.context &&
          other.lineNumber == this.lineNumber);
}

class BacklinksCompanion extends UpdateCompanion<Backlink> {
  final Value<int> id;
  final Value<String> sourcePath;
  final Value<String> targetName;
  final Value<String> context;
  final Value<int> lineNumber;
  const BacklinksCompanion({
    this.id = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.targetName = const Value.absent(),
    this.context = const Value.absent(),
    this.lineNumber = const Value.absent(),
  });
  BacklinksCompanion.insert({
    this.id = const Value.absent(),
    required String sourcePath,
    required String targetName,
    required String context,
    required int lineNumber,
  })  : sourcePath = Value(sourcePath),
        targetName = Value(targetName),
        context = Value(context),
        lineNumber = Value(lineNumber);
  static Insertable<Backlink> custom({
    Expression<int>? id,
    Expression<String>? sourcePath,
    Expression<String>? targetName,
    Expression<String>? context,
    Expression<int>? lineNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourcePath != null) 'source_path': sourcePath,
      if (targetName != null) 'target_name': targetName,
      if (context != null) 'context': context,
      if (lineNumber != null) 'line_number': lineNumber,
    });
  }

  BacklinksCompanion copyWith(
      {Value<int>? id,
      Value<String>? sourcePath,
      Value<String>? targetName,
      Value<String>? context,
      Value<int>? lineNumber}) {
    return BacklinksCompanion(
      id: id ?? this.id,
      sourcePath: sourcePath ?? this.sourcePath,
      targetName: targetName ?? this.targetName,
      context: context ?? this.context,
      lineNumber: lineNumber ?? this.lineNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (targetName.present) {
      map['target_name'] = Variable<String>(targetName.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BacklinksCompanion(')
          ..write('id: $id, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('targetName: $targetName, ')
          ..write('context: $context, ')
          ..write('lineNumber: $lineNumber')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _notePathsMeta =
      const VerificationMeta('notePaths');
  @override
  late final GeneratedColumn<String> notePaths = GeneratedColumn<String>(
      'note_paths', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [id, name, notePaths];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note_paths')) {
      context.handle(_notePathsMeta,
          notePaths.isAcceptableOrUnknown(data['note_paths']!, _notePathsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notePaths: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_paths'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final String notePaths;
  const Tag({required this.id, required this.name, required this.notePaths});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['note_paths'] = Variable<String>(notePaths);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      notePaths: Value(notePaths),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notePaths: serializer.fromJson<String>(json['notePaths']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notePaths': serializer.toJson<String>(notePaths),
    };
  }

  Tag copyWith({int? id, String? name, String? notePaths}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        notePaths: notePaths ?? this.notePaths,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notePaths: data.notePaths.present ? data.notePaths.value : this.notePaths,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notePaths: $notePaths')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notePaths);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.notePaths == this.notePaths);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> notePaths;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notePaths = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notePaths = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notePaths,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notePaths != null) 'note_paths': notePaths,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? notePaths}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notePaths: notePaths ?? this.notePaths,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notePaths.present) {
      map['note_paths'] = Variable<String>(notePaths.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notePaths: $notePaths')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $BacklinksTable backlinks = $BacklinksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notes, backlinks, tags];
}

typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String path,
  required String name,
  required String content,
  required int modifiedAt,
  required int createdAt,
  Value<String> tags,
  Value<String> frontmatter,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> path,
  Value<String> name,
  Value<String> content,
  Value<int> modifiedAt,
  Value<int> createdAt,
  Value<String> tags,
  Value<String> frontmatter,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frontmatter => $composableBuilder(
      column: $table.frontmatter, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frontmatter => $composableBuilder(
      column: $table.frontmatter, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get frontmatter => $composableBuilder(
      column: $table.frontmatter, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> path = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> modifiedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> frontmatter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            path: path,
            name: name,
            content: content,
            modifiedAt: modifiedAt,
            createdAt: createdAt,
            tags: tags,
            frontmatter: frontmatter,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String path,
            required String name,
            required String content,
            required int modifiedAt,
            required int createdAt,
            Value<String> tags = const Value.absent(),
            Value<String> frontmatter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            path: path,
            name: name,
            content: content,
            modifiedAt: modifiedAt,
            createdAt: createdAt,
            tags: tags,
            frontmatter: frontmatter,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()>;
typedef $$BacklinksTableCreateCompanionBuilder = BacklinksCompanion Function({
  Value<int> id,
  required String sourcePath,
  required String targetName,
  required String context,
  required int lineNumber,
});
typedef $$BacklinksTableUpdateCompanionBuilder = BacklinksCompanion Function({
  Value<int> id,
  Value<String> sourcePath,
  Value<String> targetName,
  Value<String> context,
  Value<int> lineNumber,
});

class $$BacklinksTableFilterComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetName => $composableBuilder(
      column: $table.targetName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnFilters(column));
}

class $$BacklinksTableOrderingComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetName => $composableBuilder(
      column: $table.targetName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnOrderings(column));
}

class $$BacklinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => column);

  GeneratedColumn<String> get targetName => $composableBuilder(
      column: $table.targetName, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => column);
}

class $$BacklinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BacklinksTable,
    Backlink,
    $$BacklinksTableFilterComposer,
    $$BacklinksTableOrderingComposer,
    $$BacklinksTableAnnotationComposer,
    $$BacklinksTableCreateCompanionBuilder,
    $$BacklinksTableUpdateCompanionBuilder,
    (Backlink, BaseReferences<_$AppDatabase, $BacklinksTable, Backlink>),
    Backlink,
    PrefetchHooks Function()> {
  $$BacklinksTableTableManager(_$AppDatabase db, $BacklinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BacklinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BacklinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BacklinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sourcePath = const Value.absent(),
            Value<String> targetName = const Value.absent(),
            Value<String> context = const Value.absent(),
            Value<int> lineNumber = const Value.absent(),
          }) =>
              BacklinksCompanion(
            id: id,
            sourcePath: sourcePath,
            targetName: targetName,
            context: context,
            lineNumber: lineNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sourcePath,
            required String targetName,
            required String context,
            required int lineNumber,
          }) =>
              BacklinksCompanion.insert(
            id: id,
            sourcePath: sourcePath,
            targetName: targetName,
            context: context,
            lineNumber: lineNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BacklinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BacklinksTable,
    Backlink,
    $$BacklinksTableFilterComposer,
    $$BacklinksTableOrderingComposer,
    $$BacklinksTableAnnotationComposer,
    $$BacklinksTableCreateCompanionBuilder,
    $$BacklinksTableUpdateCompanionBuilder,
    (Backlink, BaseReferences<_$AppDatabase, $BacklinksTable, Backlink>),
    Backlink,
    PrefetchHooks Function()>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> notePaths,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> notePaths,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notePaths => $composableBuilder(
      column: $table.notePaths, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notePaths => $composableBuilder(
      column: $table.notePaths, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notePaths =>
      $composableBuilder(column: $table.notePaths, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> notePaths = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            notePaths: notePaths,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> notePaths = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            notePaths: notePaths,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$BacklinksTableTableManager get backlinks =>
      $$BacklinksTableTableManager(_db, _db.backlinks);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
}
