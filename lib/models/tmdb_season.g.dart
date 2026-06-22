// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_season.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTmdbSeasonCollection on Isar {
  IsarCollection<TmdbSeason> get tmdbSeasons => this.collection();
}

const TmdbSeasonSchema = CollectionSchema(
  name: r'TmdbSeason',
  id: -1436951935863157232,
  properties: {
    r'airDate': PropertySchema(
      id: 0,
      name: r'airDate',
      type: IsarType.string,
    ),
    r'creditsJson': PropertySchema(
      id: 1,
      name: r'creditsJson',
      type: IsarType.string,
    ),
    r'episodesJson': PropertySchema(
      id: 2,
      name: r'episodesJson',
      type: IsarType.string,
    ),
    r'imagesJson': PropertySchema(
      id: 3,
      name: r'imagesJson',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'overview': PropertySchema(
      id: 6,
      name: r'overview',
      type: IsarType.string,
    ),
    r'posterPathSuffix': PropertySchema(
      id: 7,
      name: r'posterPathSuffix',
      type: IsarType.string,
    ),
    r'seasonNumber': PropertySchema(
      id: 8,
      name: r'seasonNumber',
      type: IsarType.long,
    ),
    r'tmdbId': PropertySchema(
      id: 9,
      name: r'tmdbId',
      type: IsarType.long,
    ),
    r'tvId': PropertySchema(
      id: 10,
      name: r'tvId',
      type: IsarType.long,
    ),
    r'videosJson': PropertySchema(
      id: 11,
      name: r'videosJson',
      type: IsarType.string,
    ),
    r'voteAverage': PropertySchema(
      id: 12,
      name: r'voteAverage',
      type: IsarType.double,
    )
  },
  estimateSize: _tmdbSeasonEstimateSize,
  serialize: _tmdbSeasonSerialize,
  deserialize: _tmdbSeasonDeserialize,
  deserializeProp: _tmdbSeasonDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'tvId_seasonNumber': IndexSchema(
      id: -7655145890713255717,
      name: r'tvId_seasonNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tvId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'seasonNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tmdbSeasonGetId,
  getLinks: _tmdbSeasonGetLinks,
  attach: _tmdbSeasonAttach,
  version: '3.3.2',
);

int _tmdbSeasonEstimateSize(
  TmdbSeason object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.airDate.length * 3;
  {
    final value = object.creditsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.episodesJson.length * 3;
  {
    final value = object.imagesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lastUpdated.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.overview.length * 3;
  {
    final value = object.posterPathSuffix;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.videosJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _tmdbSeasonSerialize(
  TmdbSeason object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.airDate);
  writer.writeString(offsets[1], object.creditsJson);
  writer.writeString(offsets[2], object.episodesJson);
  writer.writeString(offsets[3], object.imagesJson);
  writer.writeString(offsets[4], object.lastUpdated);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.overview);
  writer.writeString(offsets[7], object.posterPathSuffix);
  writer.writeLong(offsets[8], object.seasonNumber);
  writer.writeLong(offsets[9], object.tmdbId);
  writer.writeLong(offsets[10], object.tvId);
  writer.writeString(offsets[11], object.videosJson);
  writer.writeDouble(offsets[12], object.voteAverage);
}

TmdbSeason _tmdbSeasonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TmdbSeason(
    airDate: reader.readString(offsets[0]),
    creditsJson: reader.readStringOrNull(offsets[1]),
    episodesJson: reader.readStringOrNull(offsets[2]) ?? '[]',
    imagesJson: reader.readStringOrNull(offsets[3]),
    lastUpdated: reader.readString(offsets[4]),
    name: reader.readString(offsets[5]),
    overview: reader.readString(offsets[6]),
    posterPathSuffix: reader.readStringOrNull(offsets[7]),
    seasonNumber: reader.readLong(offsets[8]),
    tmdbId: reader.readLong(offsets[9]),
    tvId: reader.readLong(offsets[10]),
    videosJson: reader.readStringOrNull(offsets[11]),
    voteAverage: reader.readDouble(offsets[12]),
  );
  object.isarId = id;
  return object;
}

P _tmdbSeasonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '[]') as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tmdbSeasonGetId(TmdbSeason object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _tmdbSeasonGetLinks(TmdbSeason object) {
  return [];
}

void _tmdbSeasonAttach(IsarCollection<dynamic> col, Id id, TmdbSeason object) {
  object.isarId = id;
}

extension TmdbSeasonQueryWhereSort
    on QueryBuilder<TmdbSeason, TmdbSeason, QWhere> {
  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhere> anyTvIdSeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tvId_seasonNumber'),
      );
    });
  }
}

extension TmdbSeasonQueryWhere
    on QueryBuilder<TmdbSeason, TmdbSeason, QWhereClause> {
  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdEqualToAnySeasonNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tvId_seasonNumber',
        value: [tvId],
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdNotEqualToAnySeasonNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [],
              upper: [tvId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [],
              upper: [tvId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdGreaterThanAnySeasonNumber(
    int tvId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [tvId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdLessThanAnySeasonNumber(
    int tvId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [],
        upper: [tvId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdBetweenAnySeasonNumber(
    int lowerTvId,
    int upperTvId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [lowerTvId],
        includeLower: includeLower,
        upper: [upperTvId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdSeasonNumberEqualTo(int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tvId_seasonNumber',
        value: [tvId, seasonNumber],
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdEqualToSeasonNumberNotEqualTo(int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId],
              upper: [tvId, seasonNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId, seasonNumber],
              includeLower: false,
              upper: [tvId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId, seasonNumber],
              includeLower: false,
              upper: [tvId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber',
              lower: [tvId],
              upper: [tvId, seasonNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdEqualToSeasonNumberGreaterThan(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [tvId, seasonNumber],
        includeLower: include,
        upper: [tvId],
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdEqualToSeasonNumberLessThan(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [tvId],
        upper: [tvId, seasonNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterWhereClause>
      tvIdEqualToSeasonNumberBetween(
    int tvId,
    int lowerSeasonNumber,
    int upperSeasonNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber',
        lower: [tvId, lowerSeasonNumber],
        includeLower: includeLower,
        upper: [tvId, upperSeasonNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TmdbSeasonQueryFilter
    on QueryBuilder<TmdbSeason, TmdbSeason, QFilterCondition> {
  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      airDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'airDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'airDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'airDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> airDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'airDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      airDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'airDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'creditsJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'creditsJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creditsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creditsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creditsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      creditsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creditsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'episodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'episodesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      episodesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'episodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> imagesJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> imagesJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> imagesJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      imagesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      lastUpdatedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      lastUpdatedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastUpdated',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      lastUpdatedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      lastUpdatedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameContains(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      overviewGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      overviewStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> overviewMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'overview',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      overviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      overviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'posterPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'posterPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterPathSuffix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterPathSuffix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      posterPathSuffixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      seasonNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      seasonNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      seasonNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      seasonNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tmdbIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tmdbIdGreaterThan(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tmdbIdLessThan(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tmdbIdBetween(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tvIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tvId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tvIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tvId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tvIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tvId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> tvIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tvId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> videosJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> videosJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videosJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition> videosJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videosJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      videosJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videosJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      voteAverageEqualTo(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      voteAverageLessThan(
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

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterFilterCondition>
      voteAverageBetween(
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

extension TmdbSeasonQueryObject
    on QueryBuilder<TmdbSeason, TmdbSeason, QFilterCondition> {}

extension TmdbSeasonQueryLinks
    on QueryBuilder<TmdbSeason, TmdbSeason, QFilterCondition> {}

extension TmdbSeasonQuerySortBy
    on QueryBuilder<TmdbSeason, TmdbSeason, QSortBy> {
  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByEpisodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByEpisodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByPosterPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy>
      sortByPosterPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbSeasonQuerySortThenBy
    on QueryBuilder<TmdbSeason, TmdbSeason, QSortThenBy> {
  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByEpisodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByEpisodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByPosterPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy>
      thenByPosterPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QAfterSortBy> thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbSeasonQueryWhereDistinct
    on QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> {
  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByAirDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'airDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByCreditsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creditsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByEpisodesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByImagesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByLastUpdated(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByOverview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByPosterPathSuffix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPathSuffix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonNumber');
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvId');
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByVideosJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videosJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbSeason, TmdbSeason, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }
}

extension TmdbSeasonQueryProperty
    on QueryBuilder<TmdbSeason, TmdbSeason, QQueryProperty> {
  QueryBuilder<TmdbSeason, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<TmdbSeason, String, QQueryOperations> airDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'airDate');
    });
  }

  QueryBuilder<TmdbSeason, String?, QQueryOperations> creditsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creditsJson');
    });
  }

  QueryBuilder<TmdbSeason, String, QQueryOperations> episodesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodesJson');
    });
  }

  QueryBuilder<TmdbSeason, String?, QQueryOperations> imagesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagesJson');
    });
  }

  QueryBuilder<TmdbSeason, String, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<TmdbSeason, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TmdbSeason, String, QQueryOperations> overviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overview');
    });
  }

  QueryBuilder<TmdbSeason, String?, QQueryOperations>
      posterPathSuffixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPathSuffix');
    });
  }

  QueryBuilder<TmdbSeason, int, QQueryOperations> seasonNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonNumber');
    });
  }

  QueryBuilder<TmdbSeason, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<TmdbSeason, int, QQueryOperations> tvIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvId');
    });
  }

  QueryBuilder<TmdbSeason, String?, QQueryOperations> videosJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videosJson');
    });
  }

  QueryBuilder<TmdbSeason, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }
}
