// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nama_kategoriMeta =
      const VerificationMeta('nama_kategori');
  @override
  late final GeneratedColumn<String> nama_kategori = GeneratedColumn<String>(
      'nama_kategori', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _is_syncMeta =
      const VerificationMeta('is_sync');
  @override
  late final GeneratedColumn<bool> is_sync = GeneratedColumn<bool>(
      'is_sync', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sync" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, nama_kategori, is_sync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama_kategori')) {
      context.handle(
          _nama_kategoriMeta,
          nama_kategori.isAcceptableOrUnknown(
              data['nama_kategori']!, _nama_kategoriMeta));
    } else if (isInserting) {
      context.missing(_nama_kategoriMeta);
    }
    if (data.containsKey('is_sync')) {
      context.handle(_is_syncMeta,
          is_sync.isAcceptableOrUnknown(data['is_sync']!, _is_syncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nama_kategori: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_kategori'])!,
      is_sync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sync']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String nama_kategori;
  final bool? is_sync;
  const Category({required this.id, required this.nama_kategori, this.is_sync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama_kategori'] = Variable<String>(nama_kategori);
    if (!nullToAbsent || is_sync != null) {
      map['is_sync'] = Variable<bool>(is_sync);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nama_kategori: Value(nama_kategori),
      is_sync: is_sync == null && nullToAbsent
          ? const Value.absent()
          : Value(is_sync),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      nama_kategori: serializer.fromJson<String>(json['nama_kategori']),
      is_sync: serializer.fromJson<bool?>(json['is_sync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama_kategori': serializer.toJson<String>(nama_kategori),
      'is_sync': serializer.toJson<bool?>(is_sync),
    };
  }

  Category copyWith(
          {int? id,
          String? nama_kategori,
          Value<bool?> is_sync = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        nama_kategori: nama_kategori ?? this.nama_kategori,
        is_sync: is_sync.present ? is_sync.value : this.is_sync,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nama_kategori: $nama_kategori, ')
          ..write('is_sync: $is_sync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama_kategori, is_sync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nama_kategori == this.nama_kategori &&
          other.is_sync == this.is_sync);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> nama_kategori;
  final Value<bool?> is_sync;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nama_kategori = const Value.absent(),
    this.is_sync = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nama_kategori,
    this.is_sync = const Value.absent(),
  }) : nama_kategori = Value(nama_kategori);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? nama_kategori,
    Expression<bool>? is_sync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama_kategori != null) 'nama_kategori': nama_kategori,
      if (is_sync != null) 'is_sync': is_sync,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id, Value<String>? nama_kategori, Value<bool?>? is_sync}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nama_kategori: nama_kategori ?? this.nama_kategori,
      is_sync: is_sync ?? this.is_sync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama_kategori.present) {
      map['nama_kategori'] = Variable<String>(nama_kategori.value);
    }
    if (is_sync.present) {
      map['is_sync'] = Variable<bool>(is_sync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nama_kategori: $nama_kategori, ')
          ..write('is_sync: $is_sync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categories];
}
