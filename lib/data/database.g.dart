// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Flower extends DataClass implements Insertable<Flower> {
  final int id;
  final String name;
  final String description;
  final Uint8List image;
  Flower(
      {@required this.id, @required this.name, this.description, this.image});
  factory Flower.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return Flower(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      image: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<Uint8List>(image);
    }
    return map;
  }

  FlowersCompanion toCompanion(bool nullToAbsent) {
    return FlowersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory Flower.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Flower(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      image: serializer.fromJson<Uint8List>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'image': serializer.toJson<Uint8List>(image),
    };
  }

  Flower copyWith({int id, String name, String description, Uint8List image}) =>
      Flower(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
      );
  @override
  String toString() {
    return (StringBuffer('Flower(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(description.hashCode, image.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Flower &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.image == this.image);
}

class FlowersCompanion extends UpdateCompanion<Flower> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<Uint8List> image;
  const FlowersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  });
  FlowersCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Flower> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> description,
    Expression<Uint8List> image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
    });
  }

  FlowersCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<Uint8List> image}) {
    return FlowersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlowersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $FlowersTable extends Flowers with TableInfo<$FlowersTable, Flower> {
  final GeneratedDatabase _db;
  final String _alias;
  $FlowersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedBlobColumn _image;
  @override
  GeneratedBlobColumn get image => _image ??= _constructImage();
  GeneratedBlobColumn _constructImage() {
    return GeneratedBlobColumn(
      'image',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, description, image];
  @override
  $FlowersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'flowers';
  @override
  final String actualTableName = 'flowers';
  @override
  VerificationContext validateIntegrity(Insertable<Flower> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flower map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Flower.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FlowersTable createAlias(String alias) {
    return $FlowersTable(_db, alias);
  }
}

class Link extends DataClass implements Insertable<Link> {
  final int id;
  final String name;
  final String url;
  final int flower;
  Link(
      {@required this.id,
      this.name,
      @required this.url,
      @required this.flower});
  factory Link.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Link(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      flower: intType.mapFromDatabaseResponse(data['${effectivePrefix}flower']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || flower != null) {
      map['flower'] = Variable<int>(flower);
    }
    return map;
  }

  LinksCompanion toCompanion(bool nullToAbsent) {
    return LinksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      flower:
          flower == null && nullToAbsent ? const Value.absent() : Value(flower),
    );
  }

  factory Link.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Link(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      flower: serializer.fromJson<int>(json['flower']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'flower': serializer.toJson<int>(flower),
    };
  }

  Link copyWith({int id, String name, String url, int flower}) => Link(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        flower: flower ?? this.flower,
      );
  @override
  String toString() {
    return (StringBuffer('Link(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('flower: $flower')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(name.hashCode, $mrjc(url.hashCode, flower.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Link &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.flower == this.flower);
}

class LinksCompanion extends UpdateCompanion<Link> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<int> flower;
  const LinksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.flower = const Value.absent(),
  });
  LinksCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    @required String url,
    @required int flower,
  })  : url = Value(url),
        flower = Value(flower);
  static Insertable<Link> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> url,
    Expression<int> flower,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (flower != null) 'flower': flower,
    });
  }

  LinksCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> url,
      Value<int> flower}) {
    return LinksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      flower: flower ?? this.flower,
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
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (flower.present) {
      map['flower'] = Variable<int>(flower.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('flower: $flower')
          ..write(')'))
        .toString();
  }
}

class $LinksTable extends Links with TableInfo<$LinksTable, Link> {
  final GeneratedDatabase _db;
  final String _alias;
  $LinksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _flowerMeta = const VerificationMeta('flower');
  GeneratedIntColumn _flower;
  @override
  GeneratedIntColumn get flower => _flower ??= _constructFlower();
  GeneratedIntColumn _constructFlower() {
    return GeneratedIntColumn('flower', $tableName, false,
        $customConstraints: 'REFERENCES flowers(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, url, flower];
  @override
  $LinksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'links';
  @override
  final String actualTableName = 'links';
  @override
  VerificationContext validateIntegrity(Insertable<Link> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url'], _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('flower')) {
      context.handle(_flowerMeta,
          flower.isAcceptableOrUnknown(data['flower'], _flowerMeta));
    } else if (isInserting) {
      context.missing(_flowerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Link map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Link.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LinksTable createAlias(String alias) {
    return $LinksTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FlowersTable _flowers;
  $FlowersTable get flowers => _flowers ??= $FlowersTable(this);
  $LinksTable _links;
  $LinksTable get links => _links ??= $LinksTable(this);
  FlowersDao _flowersDao;
  FlowersDao get flowersDao => _flowersDao ??= FlowersDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [flowers, links];
}
