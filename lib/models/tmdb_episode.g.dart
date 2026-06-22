// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_episode.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTmdbEpisodeCollection on Isar {
  IsarCollection<TmdbEpisode> get tmdbEpisodes => this.collection();
}

const TmdbEpisodeSchema = CollectionSchema(
  name: r'TmdbEpisode',
  id: 4747751130577010369,
  properties: {
    r'airDate': PropertySchema(
      id: 0,
      name: r'airDate',
      type: IsarType.string,
    ),
    r'crewJson': PropertySchema(
      id: 1,
      name: r'crewJson',
      type: IsarType.string,
    ),
    r'episodeNumber': PropertySchema(
      id: 2,
      name: r'episodeNumber',
      type: IsarType.long,
    ),
    r'guestStarsJson': PropertySchema(
      id: 3,
      name: r'guestStarsJson',
      type: IsarType.string,
    ),
    r'imagesJson': PropertySchema(
      id: 4,
      name: r'imagesJson',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 5,
      name: r'lastUpdated',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'overview': PropertySchema(
      id: 7,
      name: r'overview',
      type: IsarType.string,
    ),
    r'runtime': PropertySchema(
      id: 8,
      name: r'runtime',
      type: IsarType.long,
    ),
    r'seasonNumber': PropertySchema(
      id: 9,
      name: r'seasonNumber',
      type: IsarType.long,
    ),
    r'stillPathSuffix': PropertySchema(
      id: 10,
      name: r'stillPathSuffix',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(
      id: 11,
      name: r'tmdbId',
      type: IsarType.long,
    ),
    r'tvId': PropertySchema(
      id: 12,
      name: r'tvId',
      type: IsarType.long,
    ),
    r'videosJson': PropertySchema(
      id: 13,
      name: r'videosJson',
      type: IsarType.string,
    ),
    r'voteAverage': PropertySchema(
      id: 14,
      name: r'voteAverage',
      type: IsarType.double,
    )
  },
  estimateSize: _tmdbEpisodeEstimateSize,
  serialize: _tmdbEpisodeSerialize,
  deserialize: _tmdbEpisodeDeserialize,
  deserializeProp: _tmdbEpisodeDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'tvId_seasonNumber_episodeNumber': IndexSchema(
      id: 1829837763494901221,
      name: r'tvId_seasonNumber_episodeNumber',
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
        ),
        IndexPropertySchema(
          name: r'episodeNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tmdbEpisodeGetId,
  getLinks: _tmdbEpisodeGetLinks,
  attach: _tmdbEpisodeAttach,
  version: '3.3.2',
);

int _tmdbEpisodeEstimateSize(
  TmdbEpisode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.airDate.length * 3;
  {
    final value = object.crewJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.guestStarsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
    final value = object.stillPathSuffix;
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

void _tmdbEpisodeSerialize(
  TmdbEpisode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.airDate);
  writer.writeString(offsets[1], object.crewJson);
  writer.writeLong(offsets[2], object.episodeNumber);
  writer.writeString(offsets[3], object.guestStarsJson);
  writer.writeString(offsets[4], object.imagesJson);
  writer.writeString(offsets[5], object.lastUpdated);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.overview);
  writer.writeLong(offsets[8], object.runtime);
  writer.writeLong(offsets[9], object.seasonNumber);
  writer.writeString(offsets[10], object.stillPathSuffix);
  writer.writeLong(offsets[11], object.tmdbId);
  writer.writeLong(offsets[12], object.tvId);
  writer.writeString(offsets[13], object.videosJson);
  writer.writeDouble(offsets[14], object.voteAverage);
}

TmdbEpisode _tmdbEpisodeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TmdbEpisode(
    airDate: reader.readString(offsets[0]),
    crewJson: reader.readStringOrNull(offsets[1]),
    episodeNumber: reader.readLong(offsets[2]),
    guestStarsJson: reader.readStringOrNull(offsets[3]),
    imagesJson: reader.readStringOrNull(offsets[4]),
    lastUpdated: reader.readString(offsets[5]),
    name: reader.readString(offsets[6]),
    overview: reader.readString(offsets[7]),
    runtime: reader.readLong(offsets[8]),
    seasonNumber: reader.readLong(offsets[9]),
    stillPathSuffix: reader.readStringOrNull(offsets[10]),
    tmdbId: reader.readLong(offsets[11]),
    tvId: reader.readLong(offsets[12]),
    videosJson: reader.readStringOrNull(offsets[13]),
    voteAverage: reader.readDouble(offsets[14]),
  );
  object.isarId = id;
  return object;
}

P _tmdbEpisodeDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tmdbEpisodeGetId(TmdbEpisode object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _tmdbEpisodeGetLinks(TmdbEpisode object) {
  return [];
}

void _tmdbEpisodeAttach(
    IsarCollection<dynamic> col, Id id, TmdbEpisode object) {
  object.isarId = id;
}

extension TmdbEpisodeQueryWhereSort
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QWhere> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhere>
      anyTvIdSeasonNumberEpisodeNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(
            indexName: r'tvId_seasonNumber_episodeNumber'),
      );
    });
  }
}

extension TmdbEpisodeQueryWhere
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QWhereClause> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdEqualToAnySeasonNumberEpisodeNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tvId_seasonNumber_episodeNumber',
        value: [tvId],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdNotEqualToAnySeasonNumberEpisodeNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [],
              upper: [tvId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [],
              upper: [tvId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdGreaterThanAnySeasonNumberEpisodeNumber(
    int tvId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdLessThanAnySeasonNumberEpisodeNumber(
    int tvId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [],
        upper: [tvId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdBetweenAnySeasonNumberEpisodeNumber(
    int lowerTvId,
    int upperTvId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [lowerTvId],
        includeLower: includeLower,
        upper: [upperTvId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEqualToAnyEpisodeNumber(int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tvId_seasonNumber_episodeNumber',
        value: [tvId, seasonNumber],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdEqualToSeasonNumberNotEqualToAnyEpisodeNumber(
          int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId],
              upper: [tvId, seasonNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber],
              includeLower: false,
              upper: [tvId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber],
              includeLower: false,
              upper: [tvId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId],
              upper: [tvId, seasonNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdEqualToSeasonNumberGreaterThanAnyEpisodeNumber(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId, seasonNumber],
        includeLower: include,
        upper: [tvId],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdEqualToSeasonNumberLessThanAnyEpisodeNumber(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId],
        upper: [tvId, seasonNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdEqualToSeasonNumberBetweenAnyEpisodeNumber(
    int tvId,
    int lowerSeasonNumber,
    int upperSeasonNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId, lowerSeasonNumber],
        includeLower: includeLower,
        upper: [tvId, upperSeasonNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEpisodeNumberEqualTo(
          int tvId, int seasonNumber, int episodeNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tvId_seasonNumber_episodeNumber',
        value: [tvId, seasonNumber, episodeNumber],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEqualToEpisodeNumberNotEqualTo(
          int tvId, int seasonNumber, int episodeNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber],
              upper: [tvId, seasonNumber, episodeNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber, episodeNumber],
              includeLower: false,
              upper: [tvId, seasonNumber],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber, episodeNumber],
              includeLower: false,
              upper: [tvId, seasonNumber],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tvId_seasonNumber_episodeNumber',
              lower: [tvId, seasonNumber],
              upper: [tvId, seasonNumber, episodeNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEqualToEpisodeNumberGreaterThan(
    int tvId,
    int seasonNumber,
    int episodeNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId, seasonNumber, episodeNumber],
        includeLower: include,
        upper: [tvId, seasonNumber],
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEqualToEpisodeNumberLessThan(
    int tvId,
    int seasonNumber,
    int episodeNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId, seasonNumber],
        upper: [tvId, seasonNumber, episodeNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterWhereClause>
      tvIdSeasonNumberEqualToEpisodeNumberBetween(
    int tvId,
    int seasonNumber,
    int lowerEpisodeNumber,
    int upperEpisodeNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tvId_seasonNumber_episodeNumber',
        lower: [tvId, seasonNumber, lowerEpisodeNumber],
        includeLower: includeLower,
        upper: [tvId, seasonNumber, upperEpisodeNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TmdbEpisodeQueryFilter
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QFilterCondition> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      airDateStartsWith(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateEndsWith(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateContains(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> airDateMatches(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      airDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'airDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      airDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'airDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'crewJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'crewJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> crewJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> crewJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'crewJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'crewJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> crewJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'crewJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crewJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      crewJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'crewJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      episodeNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      episodeNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      episodeNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      episodeNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'guestStarsJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'guestStarsJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guestStarsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'guestStarsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'guestStarsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guestStarsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      guestStarsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'guestStarsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      imagesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      lastUpdatedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastUpdated',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      lastUpdatedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastUpdated',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      lastUpdatedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      lastUpdatedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastUpdated',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameContains(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> overviewEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      overviewLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> overviewBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      overviewEndsWith(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      overviewContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'overview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> overviewMatches(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      overviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      overviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> runtimeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      runtimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> runtimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> runtimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      seasonNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stillPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stillPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stillPathSuffix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stillPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stillPathSuffix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stillPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      stillPathSuffixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stillPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tmdbIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      tmdbIdGreaterThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tmdbIdLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tmdbIdBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tvIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tvId',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tvIdGreaterThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tvIdLessThan(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition> tvIdBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonEqualTo(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonBetween(
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videosJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
      videosJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videosJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterFilterCondition>
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

extension TmdbEpisodeQueryObject
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QFilterCondition> {}

extension TmdbEpisodeQueryLinks
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QFilterCondition> {}

extension TmdbEpisodeQuerySortBy
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QSortBy> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByCrewJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crewJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByCrewJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crewJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByEpisodeNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      sortByEpisodeNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByGuestStarsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestStarsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      sortByGuestStarsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestStarsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      sortBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByStillPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stillPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      sortByStillPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stillPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbEpisodeQuerySortThenBy
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QSortThenBy> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByCrewJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crewJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByCrewJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crewJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByEpisodeNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      thenByEpisodeNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByGuestStarsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestStarsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      thenByGuestStarsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestStarsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      thenBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByStillPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stillPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy>
      thenByStillPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stillPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QAfterSortBy> thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension TmdbEpisodeQueryWhereDistinct
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> {
  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByAirDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'airDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByCrewJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'crewJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByEpisodeNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeNumber');
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByGuestStarsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guestStarsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByImagesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByLastUpdated(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByOverview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtime');
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonNumber');
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByStillPathSuffix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stillPathSuffix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvId');
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByVideosJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videosJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbEpisode, TmdbEpisode, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }
}

extension TmdbEpisodeQueryProperty
    on QueryBuilder<TmdbEpisode, TmdbEpisode, QQueryProperty> {
  QueryBuilder<TmdbEpisode, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<TmdbEpisode, String, QQueryOperations> airDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'airDate');
    });
  }

  QueryBuilder<TmdbEpisode, String?, QQueryOperations> crewJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'crewJson');
    });
  }

  QueryBuilder<TmdbEpisode, int, QQueryOperations> episodeNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeNumber');
    });
  }

  QueryBuilder<TmdbEpisode, String?, QQueryOperations>
      guestStarsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guestStarsJson');
    });
  }

  QueryBuilder<TmdbEpisode, String?, QQueryOperations> imagesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagesJson');
    });
  }

  QueryBuilder<TmdbEpisode, String, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<TmdbEpisode, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TmdbEpisode, String, QQueryOperations> overviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overview');
    });
  }

  QueryBuilder<TmdbEpisode, int, QQueryOperations> runtimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtime');
    });
  }

  QueryBuilder<TmdbEpisode, int, QQueryOperations> seasonNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonNumber');
    });
  }

  QueryBuilder<TmdbEpisode, String?, QQueryOperations>
      stillPathSuffixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stillPathSuffix');
    });
  }

  QueryBuilder<TmdbEpisode, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<TmdbEpisode, int, QQueryOperations> tvIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvId');
    });
  }

  QueryBuilder<TmdbEpisode, String?, QQueryOperations> videosJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videosJson');
    });
  }

  QueryBuilder<TmdbEpisode, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }
}
