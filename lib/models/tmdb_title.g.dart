// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_title.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTmdbTitleCollection on Isar {
  IsarCollection<TmdbTitle> get tmdbTitles => this.collection();
}

const TmdbTitleSchema = CollectionSchema(
  name: r'TmdbTitle',
  id: 4353883779297965714,
  properties: {
    r'addedOrder': PropertySchema(
      id: 0,
      name: r'addedOrder',
      type: IsarType.long,
    ),
    r'dateRated': PropertySchema(
      id: 1,
      name: r'dateRated',
      type: IsarType.dateTime,
    ),
    r'effectiveReleaseDate': PropertySchema(
      id: 2,
      name: r'effectiveReleaseDate',
      type: IsarType.string,
    ),
    r'effectiveRuntime': PropertySchema(
      id: 3,
      name: r'effectiveRuntime',
      type: IsarType.long,
    ),
    r'flatrateProviderIds': PropertySchema(
      id: 4,
      name: r'flatrateProviderIds',
      type: IsarType.longList,
    ),
    r'genreIds': PropertySchema(
      id: 5,
      name: r'genreIds',
      type: IsarType.longList,
    ),
    r'hashCode': PropertySchema(
      id: 6,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'isMovie': PropertySchema(
      id: 7,
      name: r'isMovie',
      type: IsarType.bool,
    ),
    r'lastUpdated': PropertySchema(
      id: 8,
      name: r'lastUpdated',
      type: IsarType.string,
    ),
    r'listName': PropertySchema(
      id: 9,
      name: r'listName',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 10,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 12,
      name: r'rating',
      type: IsarType.double,
    ),
    r'tmdbId': PropertySchema(
      id: 13,
      name: r'tmdbId',
      type: IsarType.long,
    ),
    r'tmdbJson': PropertySchema(
      id: 14,
      name: r'tmdbJson',
      type: IsarType.string,
    ),
    r'voteAverage': PropertySchema(
      id: 15,
      name: r'voteAverage',
      type: IsarType.double,
    )
  },
  estimateSize: _tmdbTitleEstimateSize,
  serialize: _tmdbTitleSerialize,
  deserialize: _tmdbTitleDeserialize,
  deserializeProp: _tmdbTitleDeserializeProp,
  idName: r'id',
  indexes: {
    r'tmdbId': IndexSchema(
      id: 7174867214654401712,
      name: r'tmdbId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tmdbId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'listName': IndexSchema(
      id: -9160894145738258075,
      name: r'listName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'listName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tmdbTitleGetId,
  getLinks: _tmdbTitleGetLinks,
  attach: _tmdbTitleAttach,
  version: '3.1.8',
);

int _tmdbTitleEstimateSize(
  TmdbTitle object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.effectiveReleaseDate.length * 3;
  bytesCount += 3 + object.flatrateProviderIds.length * 8;
  bytesCount += 3 + object.genreIds.length * 8;
  bytesCount += 3 + object.lastUpdated.length * 3;
  bytesCount += 3 + object.listName.length * 3;
  bytesCount += 3 + object.mediaType.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.tmdbJson.length * 3;
  return bytesCount;
}

void _tmdbTitleSerialize(
  TmdbTitle object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.addedOrder);
  writer.writeDateTime(offsets[1], object.dateRated);
  writer.writeString(offsets[2], object.effectiveReleaseDate);
  writer.writeLong(offsets[3], object.effectiveRuntime);
  writer.writeLongList(offsets[4], object.flatrateProviderIds);
  writer.writeLongList(offsets[5], object.genreIds);
  writer.writeLong(offsets[6], object.hashCode);
  writer.writeBool(offsets[7], object.isMovie);
  writer.writeString(offsets[8], object.lastUpdated);
  writer.writeString(offsets[9], object.listName);
  writer.writeString(offsets[10], object.mediaType);
  writer.writeString(offsets[11], object.name);
  writer.writeDouble(offsets[12], object.rating);
  writer.writeLong(offsets[13], object.tmdbId);
  writer.writeString(offsets[14], object.tmdbJson);
  writer.writeDouble(offsets[15], object.voteAverage);
}

TmdbTitle _tmdbTitleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TmdbTitle(
    addedOrder: reader.readLong(offsets[0]),
    dateRated: reader.readDateTime(offsets[1]),
    id: id,
    lastUpdated: reader.readString(offsets[8]),
    listName: reader.readString(offsets[9]),
    name: reader.readString(offsets[11]),
    rating: reader.readDouble(offsets[12]),
    tmdbId: reader.readLong(offsets[13]),
    tmdbJson: reader.readString(offsets[14]),
  );
  object.effectiveReleaseDate = reader.readString(offsets[2]);
  object.effectiveRuntime = reader.readLong(offsets[3]);
  object.flatrateProviderIds = reader.readLongList(offsets[4]) ?? [];
  object.genreIds = reader.readLongList(offsets[5]) ?? [];
  return object;
}

P _tmdbTitleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tmdbTitleGetId(TmdbTitle object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tmdbTitleGetLinks(TmdbTitle object) {
  return [];
}

void _tmdbTitleAttach(IsarCollection<dynamic> col, Id id, TmdbTitle object) {
  object.id = id;
}

extension TmdbTitleQueryWhereSort
    on QueryBuilder<TmdbTitle, TmdbTitle, QWhere> {
  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhere> anyTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tmdbId'),
      );
    });
  }
}

extension TmdbTitleQueryWhere
    on QueryBuilder<TmdbTitle, TmdbTitle, QWhereClause> {
  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> idBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> tmdbIdEqualTo(
      int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tmdbId',
        value: [tmdbId],
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> tmdbIdNotEqualTo(
      int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId',
              lower: [],
              upper: [tmdbId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId',
              lower: [tmdbId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId',
              lower: [tmdbId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tmdbId',
              lower: [],
              upper: [tmdbId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> tmdbIdGreaterThan(
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId',
        lower: [tmdbId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> tmdbIdLessThan(
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId',
        lower: [],
        upper: [tmdbId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> tmdbIdBetween(
    int lowerTmdbId,
    int upperTmdbId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tmdbId',
        lower: [lowerTmdbId],
        includeLower: includeLower,
        upper: [upperTmdbId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> listNameEqualTo(
      String listName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listName',
        value: [listName],
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterWhereClause> listNameNotEqualTo(
      String listName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName',
              lower: [],
              upper: [listName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName',
              lower: [listName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName',
              lower: [listName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName',
              lower: [],
              upper: [listName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TmdbTitleQueryFilter
    on QueryBuilder<TmdbTitle, TmdbTitle, QFilterCondition> {
  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> addedOrderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      addedOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> addedOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> addedOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> dateRatedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateRated',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      dateRatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateRated',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> dateRatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateRated',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> dateRatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateRated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'effectiveReleaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'effectiveReleaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'effectiveReleaseDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'effectiveReleaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveReleaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'effectiveReleaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveRuntimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'effectiveRuntime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveRuntimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'effectiveRuntime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveRuntimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'effectiveRuntime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      effectiveRuntimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'effectiveRuntime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flatrateProviderIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flatrateProviderIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flatrateProviderIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flatrateProviderIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      flatrateProviderIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flatrateProviderIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genreIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genreIds',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genreIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> genreIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      genreIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isMovieEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMovie',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastUpdatedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastUpdated',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastUpdatedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastUpdatedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'listName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> listNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      listNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'listName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      mediaTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameContains(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> ratingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> ratingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> ratingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> ratingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbIdGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbIdLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbIdBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tmdbJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tmdbJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tmdbJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> tmdbJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      tmdbJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tmdbJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteAverageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      voteAverageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteAverageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voteAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteAverageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voteAverage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TmdbTitleQueryObject
    on QueryBuilder<TmdbTitle, TmdbTitle, QFilterCondition> {}

extension TmdbTitleQueryLinks
    on QueryBuilder<TmdbTitle, TmdbTitle, QFilterCondition> {}

extension TmdbTitleQuerySortBy on QueryBuilder<TmdbTitle, TmdbTitle, QSortBy> {
  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByAddedOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByDateRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByDateRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByEffectiveReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveReleaseDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByEffectiveReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveReleaseDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByEffectiveRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveRuntime', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByEffectiveRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveRuntime', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByListName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByListNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTmdbJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTmdbJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbTitleQuerySortThenBy
    on QueryBuilder<TmdbTitle, TmdbTitle, QSortThenBy> {
  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByAddedOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByDateRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByDateRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByEffectiveReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveReleaseDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByEffectiveReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveReleaseDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByEffectiveRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveRuntime', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByEffectiveRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveRuntime', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByListName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByListNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTmdbJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTmdbJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbTitleQueryWhereDistinct
    on QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> {
  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedOrder');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByDateRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateRated');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByEffectiveReleaseDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'effectiveReleaseDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByEffectiveRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'effectiveRuntime');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct>
      distinctByFlatrateProviderIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flatrateProviderIds');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByGenreIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreIds');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMovie');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByLastUpdated(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByListName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByMediaType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByTmdbJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }
}

extension TmdbTitleQueryProperty
    on QueryBuilder<TmdbTitle, TmdbTitle, QQueryProperty> {
  QueryBuilder<TmdbTitle, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> addedOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedOrder');
    });
  }

  QueryBuilder<TmdbTitle, DateTime, QQueryOperations> dateRatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateRated');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations>
      effectiveReleaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'effectiveReleaseDate');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> effectiveRuntimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'effectiveRuntime');
    });
  }

  QueryBuilder<TmdbTitle, List<int>, QQueryOperations>
      flatrateProviderIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flatrateProviderIds');
    });
  }

  QueryBuilder<TmdbTitle, List<int>, QQueryOperations> genreIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreIds');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isMovieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMovie');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> listNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listName');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TmdbTitle, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> tmdbJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbJson');
    });
  }

  QueryBuilder<TmdbTitle, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }
}
