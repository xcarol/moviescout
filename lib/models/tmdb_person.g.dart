// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_person.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTmdbPersonCollection on Isar {
  IsarCollection<TmdbPerson> get tmdbPersons => this.collection();
}

const TmdbPersonSchema = CollectionSchema(
  name: r'TmdbPerson',
  id: 8608340689342780335,
  properties: {
    r'biography': PropertySchema(
      id: 0,
      name: r'biography',
      type: IsarType.string,
    ),
    r'birthday': PropertySchema(
      id: 1,
      name: r'birthday',
      type: IsarType.string,
    ),
    r'character': PropertySchema(
      id: 2,
      name: r'character',
      type: IsarType.string,
    ),
    r'combinedCreditsJson': PropertySchema(
      id: 3,
      name: r'combinedCreditsJson',
      type: IsarType.string,
    ),
    r'deathday': PropertySchema(
      id: 4,
      name: r'deathday',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(
      id: 5,
      name: r'gender',
      type: IsarType.long,
    ),
    r'homepage': PropertySchema(
      id: 6,
      name: r'homepage',
      type: IsarType.string,
    ),
    r'imdbId': PropertySchema(
      id: 7,
      name: r'imdbId',
      type: IsarType.string,
    ),
    r'job': PropertySchema(
      id: 8,
      name: r'job',
      type: IsarType.string,
    ),
    r'knownForDepartment': PropertySchema(
      id: 9,
      name: r'knownForDepartment',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 10,
      name: r'lastUpdated',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'originalName': PropertySchema(
      id: 12,
      name: r'originalName',
      type: IsarType.string,
    ),
    r'placeOfBirth': PropertySchema(
      id: 13,
      name: r'placeOfBirth',
      type: IsarType.string,
    ),
    r'posterPath': PropertySchema(
      id: 14,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'profilePath': PropertySchema(
      id: 15,
      name: r'profilePath',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(
      id: 16,
      name: r'tmdbId',
      type: IsarType.long,
    ),
    r'transientListId': PropertySchema(
      id: 17,
      name: r'transientListId',
      type: IsarType.string,
    )
  },
  estimateSize: _tmdbPersonEstimateSize,
  serialize: _tmdbPersonSerialize,
  deserialize: _tmdbPersonDeserialize,
  deserializeProp: _tmdbPersonDeserializeProp,
  idName: r'id',
  indexes: {
    r'tmdbId_transientListId': IndexSchema(
      id: -1085342226625371720,
      name: r'tmdbId_transientListId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'tmdbId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'transientListId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'transientListId': IndexSchema(
      id: -5689325841349742102,
      name: r'transientListId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'transientListId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tmdbPersonGetId,
  getLinks: _tmdbPersonGetLinks,
  attach: _tmdbPersonAttach,
  version: '3.3.0',
);

int _tmdbPersonEstimateSize(
  TmdbPerson object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.biography.length * 3;
  bytesCount += 3 + object.birthday.length * 3;
  bytesCount += 3 + object.character.length * 3;
  {
    final value = object.combinedCreditsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.deathday.length * 3;
  bytesCount += 3 + object.homepage.length * 3;
  bytesCount += 3 + object.imdbId.length * 3;
  bytesCount += 3 + object.job.length * 3;
  bytesCount += 3 + object.knownForDepartment.length * 3;
  bytesCount += 3 + object.lastUpdated.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.originalName.length * 3;
  bytesCount += 3 + object.placeOfBirth.length * 3;
  bytesCount += 3 + object.posterPath.length * 3;
  bytesCount += 3 + object.profilePath.length * 3;
  bytesCount += 3 + object.transientListId.length * 3;
  return bytesCount;
}

void _tmdbPersonSerialize(
  TmdbPerson object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.biography);
  writer.writeString(offsets[1], object.birthday);
  writer.writeString(offsets[2], object.character);
  writer.writeString(offsets[3], object.combinedCreditsJson);
  writer.writeString(offsets[4], object.deathday);
  writer.writeLong(offsets[5], object.gender);
  writer.writeString(offsets[6], object.homepage);
  writer.writeString(offsets[7], object.imdbId);
  writer.writeString(offsets[8], object.job);
  writer.writeString(offsets[9], object.knownForDepartment);
  writer.writeString(offsets[10], object.lastUpdated);
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.originalName);
  writer.writeString(offsets[13], object.placeOfBirth);
  writer.writeString(offsets[14], object.posterPath);
  writer.writeString(offsets[15], object.profilePath);
  writer.writeLong(offsets[16], object.tmdbId);
  writer.writeString(offsets[17], object.transientListId);
}

TmdbPerson _tmdbPersonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TmdbPerson(
    biography: reader.readString(offsets[0]),
    birthday: reader.readString(offsets[1]),
    character: reader.readString(offsets[2]),
    combinedCreditsJson: reader.readStringOrNull(offsets[3]),
    deathday: reader.readString(offsets[4]),
    gender: reader.readLong(offsets[5]),
    homepage: reader.readString(offsets[6]),
    imdbId: reader.readString(offsets[7]),
    job: reader.readString(offsets[8]),
    knownForDepartment: reader.readString(offsets[9]),
    lastUpdated: reader.readString(offsets[10]),
    name: reader.readString(offsets[11]),
    originalName: reader.readString(offsets[12]),
    placeOfBirth: reader.readString(offsets[13]),
    profilePath: reader.readString(offsets[15]),
    tmdbId: reader.readLong(offsets[16]),
    transientListId: reader.readStringOrNull(offsets[17]) ?? '',
  );
  object.id = id;
  return object;
}

P _tmdbPersonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tmdbPersonGetId(TmdbPerson object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tmdbPersonGetLinks(TmdbPerson object) {
  return [];
}

void _tmdbPersonAttach(IsarCollection<dynamic> col, Id id, TmdbPerson object) {
  object.id = id;
}

extension TmdbPersonByIndex on IsarCollection<TmdbPerson> {
  Future<TmdbPerson?> getByTmdbIdTransientListId(
      int tmdbId, String transientListId) {
    return getByIndex(r'tmdbId_transientListId', [tmdbId, transientListId]);
  }

  TmdbPerson? getByTmdbIdTransientListIdSync(
      int tmdbId, String transientListId) {
    return getByIndexSync(r'tmdbId_transientListId', [tmdbId, transientListId]);
  }

  Future<bool> deleteByTmdbIdTransientListId(
      int tmdbId, String transientListId) {
    return deleteByIndex(r'tmdbId_transientListId', [tmdbId, transientListId]);
  }

  bool deleteByTmdbIdTransientListIdSync(int tmdbId, String transientListId) {
    return deleteByIndexSync(
        r'tmdbId_transientListId', [tmdbId, transientListId]);
  }

  Future<List<TmdbPerson?>> getAllByTmdbIdTransientListId(
      List<int> tmdbIdValues, List<String> transientListIdValues) {
    final len = tmdbIdValues.length;
    assert(transientListIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], transientListIdValues[i]]);
    }

    return getAllByIndex(r'tmdbId_transientListId', values);
  }

  List<TmdbPerson?> getAllByTmdbIdTransientListIdSync(
      List<int> tmdbIdValues, List<String> transientListIdValues) {
    final len = tmdbIdValues.length;
    assert(transientListIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], transientListIdValues[i]]);
    }

    return getAllByIndexSync(r'tmdbId_transientListId', values);
  }

  Future<int> deleteAllByTmdbIdTransientListId(
      List<int> tmdbIdValues, List<String> transientListIdValues) {
    final len = tmdbIdValues.length;
    assert(transientListIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], transientListIdValues[i]]);
    }

    return deleteAllByIndex(r'tmdbId_transientListId', values);
  }

  int deleteAllByTmdbIdTransientListIdSync(
      List<int> tmdbIdValues, List<String> transientListIdValues) {
    final len = tmdbIdValues.length;
    assert(transientListIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], transientListIdValues[i]]);
    }

    return deleteAllByIndexSync(r'tmdbId_transientListId', values);
  }

  Future<Id> putByTmdbIdTransientListId(TmdbPerson object) {
    return putByIndex(r'tmdbId_transientListId', object);
  }

  Id putByTmdbIdTransientListIdSync(TmdbPerson object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'tmdbId_transientListId', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTmdbIdTransientListId(List<TmdbPerson> objects) {
    return putAllByIndex(r'tmdbId_transientListId', objects);
  }

  List<Id> putAllByTmdbIdTransientListIdSync(List<TmdbPerson> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'tmdbId_transientListId', objects,
        saveLinks: saveLinks);
  }
}

extension TmdbPersonQueryWhereSort
    on QueryBuilder<TmdbPerson, TmdbPerson, QWhere> {
  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TmdbPersonQueryWhere
    on QueryBuilder<TmdbPerson, TmdbPerson, QWhereClause> {
  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdEqualToAnyTransientListId(int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tmdbId_transientListId',
        value: [tmdbId],
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdNotEqualToAnyTransientListId(int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [],
              upper: [tmdbId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [],
              upper: [tmdbId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdGreaterThanAnyTransientListId(
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId_transientListId',
        lower: [tmdbId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdLessThanAnyTransientListId(
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId_transientListId',
        lower: [],
        upper: [tmdbId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdBetweenAnyTransientListId(
    int lowerTmdbId,
    int upperTmdbId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId_transientListId',
        lower: [lowerTmdbId],
        includeLower: includeLower,
        upper: [upperTmdbId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdTransientListIdEqualTo(int tmdbId, String transientListId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tmdbId_transientListId',
        value: [tmdbId, transientListId],
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      tmdbIdEqualToTransientListIdNotEqualTo(
          int tmdbId, String transientListId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId],
              upper: [tmdbId, transientListId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId, transientListId],
              includeLower: false,
              upper: [tmdbId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId, transientListId],
              includeLower: false,
              upper: [tmdbId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId_transientListId',
              lower: [tmdbId],
              upper: [tmdbId, transientListId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      transientListIdEqualTo(String transientListId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transientListId',
        value: [transientListId],
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterWhereClause>
      transientListIdNotEqualTo(String transientListId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transientListId',
              lower: [],
              upper: [transientListId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transientListId',
              lower: [transientListId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transientListId',
              lower: [transientListId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transientListId',
              lower: [],
              upper: [transientListId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TmdbPersonQueryFilter
    on QueryBuilder<TmdbPerson, TmdbPerson, QFilterCondition> {
  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      biographyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biography',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      biographyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'biography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> biographyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'biography',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      biographyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biography',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      biographyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'biography',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      birthdayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'birthday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      birthdayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'birthday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> birthdayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'birthday',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      birthdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'birthday',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      birthdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'birthday',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      characterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'character',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      characterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'character',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> characterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'character',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      characterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'character',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      characterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'character',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'combinedCreditsJson',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'combinedCreditsJson',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'combinedCreditsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'combinedCreditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'combinedCreditsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'combinedCreditsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      combinedCreditsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'combinedCreditsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      deathdayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deathday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      deathdayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deathday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> deathdayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deathday',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      deathdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deathday',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      deathdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deathday',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> genderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> genderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> genderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> genderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      homepageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'homepage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      homepageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'homepage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> homepageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'homepage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      homepageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'homepage',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      homepageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'homepage',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imdbId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imdbId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> imdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imdbId',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      imdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imdbId',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'job',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'job',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'job',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'job',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> jobIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'job',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'knownForDepartment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'knownForDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'knownForDepartment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'knownForDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      knownForDepartmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'knownForDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastUpdated',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      lastUpdatedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      originalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placeOfBirth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placeOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placeOfBirth',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      placeOfBirthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placeOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> posterPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> posterPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> posterPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      profilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> tmdbIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> tmdbIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> tmdbIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition> tmdbIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tmdbId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transientListId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transientListId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transientListId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transientListId',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterFilterCondition>
      transientListIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transientListId',
        value: '',
      ));
    });
  }
}

extension TmdbPersonQueryObject
    on QueryBuilder<TmdbPerson, TmdbPerson, QFilterCondition> {}

extension TmdbPersonQueryLinks
    on QueryBuilder<TmdbPerson, TmdbPerson, QFilterCondition> {}

extension TmdbPersonQuerySortBy
    on QueryBuilder<TmdbPerson, TmdbPerson, QSortBy> {
  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByBiography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByBiographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByBirthday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByBirthdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByCharacter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'character', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByCharacterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'character', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      sortByCombinedCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combinedCreditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      sortByCombinedCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combinedCreditsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByDeathday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByDeathdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByHomepage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByHomepageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByJob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'job', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByJobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'job', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      sortByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      sortByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByPlaceOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByPlaceOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> sortByTransientListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transientListId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      sortByTransientListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transientListId', Sort.desc);
    });
  }
}

extension TmdbPersonQuerySortThenBy
    on QueryBuilder<TmdbPerson, TmdbPerson, QSortThenBy> {
  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByBiography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByBiographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByBirthday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByBirthdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByCharacter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'character', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByCharacterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'character', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      thenByCombinedCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combinedCreditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      thenByCombinedCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combinedCreditsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByDeathday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByDeathdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByHomepage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByHomepageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByJob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'job', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByJobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'job', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      thenByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      thenByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByPlaceOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByPlaceOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy> thenByTransientListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transientListId', Sort.asc);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>
      thenByTransientListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transientListId', Sort.desc);
    });
  }
}

extension TmdbPersonQueryWhereDistinct
    on QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> {
  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByBiography(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biography', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByBirthday(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'birthday', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByCharacter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'character', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByCombinedCreditsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'combinedCreditsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByDeathday(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deathday', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender');
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByHomepage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'homepage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByImdbId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByJob(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'job', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByKnownForDepartment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'knownForDepartment',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByLastUpdated(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByOriginalName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByPlaceOfBirth(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placeOfBirth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByPosterPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByProfilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<TmdbPerson, TmdbPerson, QDistinct> distinctByTransientListId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transientListId',
          caseSensitive: caseSensitive);
    });
  }
}

extension TmdbPersonQueryProperty
    on QueryBuilder<TmdbPerson, TmdbPerson, QQueryProperty> {
  QueryBuilder<TmdbPerson, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> biographyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biography');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> birthdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'birthday');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> characterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'character');
    });
  }

  QueryBuilder<TmdbPerson, String?, QQueryOperations>
      combinedCreditsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'combinedCreditsJson');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> deathdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deathday');
    });
  }

  QueryBuilder<TmdbPerson, int, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> homepageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'homepage');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> imdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imdbId');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> jobProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'job');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations>
      knownForDepartmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'knownForDepartment');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> originalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalName');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> placeOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placeOfBirth');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> profilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePath');
    });
  }

  QueryBuilder<TmdbPerson, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<TmdbPerson, String, QQueryOperations> transientListIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transientListId');
    });
  }
}
