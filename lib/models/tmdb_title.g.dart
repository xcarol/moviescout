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
    r'backdropPath': PropertySchema(
      id: 1,
      name: r'backdropPath',
      type: IsarType.string,
    ),
    r'backdropPathSuffix': PropertySchema(
      id: 2,
      name: r'backdropPathSuffix',
      type: IsarType.string,
    ),
    r'budget': PropertySchema(
      id: 3,
      name: r'budget',
      type: IsarType.long,
    ),
    r'creditsJson': PropertySchema(
      id: 4,
      name: r'creditsJson',
      type: IsarType.string,
    ),
    r'dateRated': PropertySchema(
      id: 5,
      name: r'dateRated',
      type: IsarType.dateTime,
    ),
    r'effectiveReleaseDate': PropertySchema(
      id: 6,
      name: r'effectiveReleaseDate',
      type: IsarType.string,
    ),
    r'effectiveRuntime': PropertySchema(
      id: 7,
      name: r'effectiveRuntime',
      type: IsarType.long,
    ),
    r'firstAirDate': PropertySchema(
      id: 8,
      name: r'firstAirDate',
      type: IsarType.string,
    ),
    r'flatrateProviderIds': PropertySchema(
      id: 9,
      name: r'flatrateProviderIds',
      type: IsarType.longList,
    ),
    r'genreIds': PropertySchema(
      id: 10,
      name: r'genreIds',
      type: IsarType.longList,
    ),
    r'hasRating': PropertySchema(
      id: 11,
      name: r'hasRating',
      type: IsarType.bool,
    ),
    r'hashCode': PropertySchema(
      id: 12,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'homepage': PropertySchema(
      id: 13,
      name: r'homepage',
      type: IsarType.string,
    ),
    r'imagesJson': PropertySchema(
      id: 14,
      name: r'imagesJson',
      type: IsarType.string,
    ),
    r'imdbId': PropertySchema(
      id: 15,
      name: r'imdbId',
      type: IsarType.string,
    ),
    r'isMovie': PropertySchema(
      id: 16,
      name: r'isMovie',
      type: IsarType.bool,
    ),
    r'isOnAir': PropertySchema(
      id: 17,
      name: r'isOnAir',
      type: IsarType.bool,
    ),
    r'isPinned': PropertySchema(
      id: 18,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'isRated': PropertySchema(
      id: 19,
      name: r'isRated',
      type: IsarType.bool,
    ),
    r'isSeenOnly': PropertySchema(
      id: 20,
      name: r'isSeenOnly',
      type: IsarType.bool,
    ),
    r'isSerie': PropertySchema(
      id: 21,
      name: r'isSerie',
      type: IsarType.bool,
    ),
    r'lastAirDate': PropertySchema(
      id: 22,
      name: r'lastAirDate',
      type: IsarType.string,
    ),
    r'lastEpisodeToAirJson': PropertySchema(
      id: 23,
      name: r'lastEpisodeToAirJson',
      type: IsarType.string,
    ),
    r'lastNotifiedSeason': PropertySchema(
      id: 24,
      name: r'lastNotifiedSeason',
      type: IsarType.long,
    ),
    r'lastUpdated': PropertySchema(
      id: 25,
      name: r'lastUpdated',
      type: IsarType.string,
    ),
    r'listName': PropertySchema(
      id: 26,
      name: r'listName',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 27,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 28,
      name: r'name',
      type: IsarType.string,
    ),
    r'nextEpisodeToAirJson': PropertySchema(
      id: 29,
      name: r'nextEpisodeToAirJson',
      type: IsarType.string,
    ),
    r'numberOfEpisodes': PropertySchema(
      id: 30,
      name: r'numberOfEpisodes',
      type: IsarType.long,
    ),
    r'numberOfSeasons': PropertySchema(
      id: 31,
      name: r'numberOfSeasons',
      type: IsarType.long,
    ),
    r'originCountry': PropertySchema(
      id: 32,
      name: r'originCountry',
      type: IsarType.stringList,
    ),
    r'originalLanguage': PropertySchema(
      id: 33,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'originalName': PropertySchema(
      id: 34,
      name: r'originalName',
      type: IsarType.string,
    ),
    r'overview': PropertySchema(
      id: 35,
      name: r'overview',
      type: IsarType.string,
    ),
    r'popularity': PropertySchema(
      id: 36,
      name: r'popularity',
      type: IsarType.double,
    ),
    r'posterPath': PropertySchema(
      id: 37,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'posterPathSuffix': PropertySchema(
      id: 38,
      name: r'posterPathSuffix',
      type: IsarType.string,
    ),
    r'providersJson': PropertySchema(
      id: 39,
      name: r'providersJson',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 40,
      name: r'rating',
      type: IsarType.double,
    ),
    r'recommendationsJson': PropertySchema(
      id: 41,
      name: r'recommendationsJson',
      type: IsarType.string,
    ),
    r'releaseDate': PropertySchema(
      id: 42,
      name: r'releaseDate',
      type: IsarType.string,
    ),
    r'revenue': PropertySchema(
      id: 43,
      name: r'revenue',
      type: IsarType.long,
    ),
    r'runtime': PropertySchema(
      id: 44,
      name: r'runtime',
      type: IsarType.long,
    ),
    r'seasonsJson': PropertySchema(
      id: 45,
      name: r'seasonsJson',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 46,
      name: r'status',
      type: IsarType.string,
    ),
    r'tagline': PropertySchema(
      id: 47,
      name: r'tagline',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(
      id: 48,
      name: r'tmdbId',
      type: IsarType.long,
    ),
    r'videosJson': PropertySchema(
      id: 49,
      name: r'videosJson',
      type: IsarType.string,
    ),
    r'voteAverage': PropertySchema(
      id: 50,
      name: r'voteAverage',
      type: IsarType.double,
    ),
    r'voteCount': PropertySchema(
      id: 51,
      name: r'voteCount',
      type: IsarType.long,
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
  version: '3.3.0',
);

int _tmdbTitleEstimateSize(
  TmdbTitle object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backdropPath.length * 3;
  {
    final value = object.backdropPathSuffix;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.creditsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.effectiveReleaseDate.length * 3;
  bytesCount += 3 + object.firstAirDate.length * 3;
  bytesCount += 3 + object.flatrateProviderIds.length * 8;
  bytesCount += 3 + object.genreIds.length * 8;
  bytesCount += 3 + object.homepage.length * 3;
  {
    final value = object.imagesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imdbId.length * 3;
  bytesCount += 3 + object.lastAirDate.length * 3;
  {
    final value = object.lastEpisodeToAirJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lastUpdated.length * 3;
  bytesCount += 3 + object.listName.length * 3;
  bytesCount += 3 + object.mediaType.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.nextEpisodeToAirJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.originCountry.length * 3;
  {
    for (var i = 0; i < object.originCountry.length; i++) {
      final value = object.originCountry[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.originalLanguage.length * 3;
  bytesCount += 3 + object.originalName.length * 3;
  bytesCount += 3 + object.overview.length * 3;
  bytesCount += 3 + object.posterPath.length * 3;
  {
    final value = object.posterPathSuffix;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.providersJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recommendationsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.releaseDate.length * 3;
  {
    final value = object.seasonsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.tagline.length * 3;
  {
    final value = object.videosJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _tmdbTitleSerialize(
  TmdbTitle object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.addedOrder);
  writer.writeString(offsets[1], object.backdropPath);
  writer.writeString(offsets[2], object.backdropPathSuffix);
  writer.writeLong(offsets[3], object.budget);
  writer.writeString(offsets[4], object.creditsJson);
  writer.writeDateTime(offsets[5], object.dateRated);
  writer.writeString(offsets[6], object.effectiveReleaseDate);
  writer.writeLong(offsets[7], object.effectiveRuntime);
  writer.writeString(offsets[8], object.firstAirDate);
  writer.writeLongList(offsets[9], object.flatrateProviderIds);
  writer.writeLongList(offsets[10], object.genreIds);
  writer.writeBool(offsets[11], object.hasRating);
  writer.writeLong(offsets[12], object.hashCode);
  writer.writeString(offsets[13], object.homepage);
  writer.writeString(offsets[14], object.imagesJson);
  writer.writeString(offsets[15], object.imdbId);
  writer.writeBool(offsets[16], object.isMovie);
  writer.writeBool(offsets[17], object.isOnAir);
  writer.writeBool(offsets[18], object.isPinned);
  writer.writeBool(offsets[19], object.isRated);
  writer.writeBool(offsets[20], object.isSeenOnly);
  writer.writeBool(offsets[21], object.isSerie);
  writer.writeString(offsets[22], object.lastAirDate);
  writer.writeString(offsets[23], object.lastEpisodeToAirJson);
  writer.writeLong(offsets[24], object.lastNotifiedSeason);
  writer.writeString(offsets[25], object.lastUpdated);
  writer.writeString(offsets[26], object.listName);
  writer.writeString(offsets[27], object.mediaType);
  writer.writeString(offsets[28], object.name);
  writer.writeString(offsets[29], object.nextEpisodeToAirJson);
  writer.writeLong(offsets[30], object.numberOfEpisodes);
  writer.writeLong(offsets[31], object.numberOfSeasons);
  writer.writeStringList(offsets[32], object.originCountry);
  writer.writeString(offsets[33], object.originalLanguage);
  writer.writeString(offsets[34], object.originalName);
  writer.writeString(offsets[35], object.overview);
  writer.writeDouble(offsets[36], object.popularity);
  writer.writeString(offsets[37], object.posterPath);
  writer.writeString(offsets[38], object.posterPathSuffix);
  writer.writeString(offsets[39], object.providersJson);
  writer.writeDouble(offsets[40], object.rating);
  writer.writeString(offsets[41], object.recommendationsJson);
  writer.writeString(offsets[42], object.releaseDate);
  writer.writeLong(offsets[43], object.revenue);
  writer.writeLong(offsets[44], object.runtime);
  writer.writeString(offsets[45], object.seasonsJson);
  writer.writeString(offsets[46], object.status);
  writer.writeString(offsets[47], object.tagline);
  writer.writeLong(offsets[48], object.tmdbId);
  writer.writeString(offsets[49], object.videosJson);
  writer.writeDouble(offsets[50], object.voteAverage);
  writer.writeLong(offsets[51], object.voteCount);
}

TmdbTitle _tmdbTitleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TmdbTitle(
    addedOrder: reader.readLong(offsets[0]),
    backdropPathSuffix: reader.readStringOrNull(offsets[2]),
    budget: reader.readLongOrNull(offsets[3]) ?? 0,
    creditsJson: reader.readStringOrNull(offsets[4]),
    dateRated: reader.readDateTime(offsets[5]),
    effectiveReleaseDate: reader.readStringOrNull(offsets[6]) ?? '',
    effectiveRuntime: reader.readLongOrNull(offsets[7]) ?? 0,
    firstAirDate: reader.readStringOrNull(offsets[8]) ?? '',
    flatrateProviderIds: reader.readLongList(offsets[9]) ?? const [],
    genreIds: reader.readLongList(offsets[10]) ?? const [],
    homepage: reader.readStringOrNull(offsets[13]) ?? '',
    id: id,
    imagesJson: reader.readStringOrNull(offsets[14]),
    imdbId: reader.readStringOrNull(offsets[15]) ?? '',
    isPinned: reader.readBoolOrNull(offsets[18]) ?? false,
    lastAirDate: reader.readStringOrNull(offsets[22]) ?? '',
    lastEpisodeToAirJson: reader.readStringOrNull(offsets[23]),
    lastNotifiedSeason: reader.readLongOrNull(offsets[24]) ?? 0,
    lastUpdated: reader.readString(offsets[25]),
    listName: reader.readString(offsets[26]),
    mediaType: reader.readStringOrNull(offsets[27]) ?? '',
    name: reader.readString(offsets[28]),
    nextEpisodeToAirJson: reader.readStringOrNull(offsets[29]),
    numberOfEpisodes: reader.readLongOrNull(offsets[30]) ?? 0,
    numberOfSeasons: reader.readLongOrNull(offsets[31]) ?? 0,
    originCountry: reader.readStringList(offsets[32]) ?? const [],
    originalLanguage: reader.readStringOrNull(offsets[33]) ?? '',
    originalName: reader.readStringOrNull(offsets[34]) ?? '',
    overview: reader.readStringOrNull(offsets[35]) ?? '',
    popularity: reader.readDoubleOrNull(offsets[36]) ?? 0.0,
    posterPathSuffix: reader.readStringOrNull(offsets[38]),
    providersJson: reader.readStringOrNull(offsets[39]),
    rating: reader.readDoubleOrNull(offsets[40]) ?? 0.0,
    recommendationsJson: reader.readStringOrNull(offsets[41]),
    releaseDate: reader.readStringOrNull(offsets[42]) ?? '',
    revenue: reader.readLongOrNull(offsets[43]) ?? 0,
    runtime: reader.readLongOrNull(offsets[44]) ?? 0,
    seasonsJson: reader.readStringOrNull(offsets[45]),
    status: reader.readStringOrNull(offsets[46]) ?? '',
    tagline: reader.readStringOrNull(offsets[47]) ?? '',
    tmdbId: reader.readLong(offsets[48]),
    videosJson: reader.readStringOrNull(offsets[49]),
    voteAverage: reader.readDoubleOrNull(offsets[50]) ?? 0.0,
    voteCount: reader.readLongOrNull(offsets[51]) ?? 0,
  );
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
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readLongList(offset) ?? const []) as P;
    case 10:
      return (reader.readLongList(offset) ?? const []) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readBool(offset)) as P;
    case 21:
      return (reader.readBool(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 28:
      return (reader.readString(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 31:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 32:
      return (reader.readStringList(offset) ?? const []) as P;
    case 33:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 34:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 35:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 36:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 37:
      return (reader.readString(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 41:
      return (reader.readStringOrNull(offset)) as P;
    case 42:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 43:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 44:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 45:
      return (reader.readStringOrNull(offset)) as P;
    case 46:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 47:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 48:
      return (reader.readLong(offset)) as P;
    case 49:
      return (reader.readStringOrNull(offset)) as P;
    case 50:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 51:
      return (reader.readLongOrNull(offset) ?? 0) as P;
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> backdropPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> backdropPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backdropPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backdropPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> backdropPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backdropPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'backdropPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backdropPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'backdropPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backdropPathSuffix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backdropPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backdropPathSuffix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backdropPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      backdropPathSuffixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'backdropPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> budgetEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budget',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> budgetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budget',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> budgetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budget',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> budgetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      creditsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'creditsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      creditsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'creditsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creditsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> creditsJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creditsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      creditsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creditsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      creditsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creditsJson',
        value: '',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> firstAirDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> firstAirDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstAirDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firstAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> firstAirDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firstAirDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstAirDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      firstAirDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firstAirDate',
        value: '',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> hasRatingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRating',
        value: value,
      ));
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageStartsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageContains(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> homepageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'homepage',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      homepageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'homepage',
        value: '',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      imagesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagesJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imagesJsonMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      imagesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      imagesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdStartsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdContains(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imdbId',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> imdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imdbId',
        value: '',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isOnAirEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOnAir',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isPinnedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isRatedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRated',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isSeenOnlyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSeenOnly',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> isSerieEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSerie',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastAirDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAirDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastAirDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastAirDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> lastAirDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastAirDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastAirDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAirDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastAirDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastAirDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastEpisodeToAirJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastEpisodeToAirJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEpisodeToAirJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastEpisodeToAirJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEpisodeToAirJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastEpisodeToAirJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastEpisodeToAirJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastNotifiedSeasonEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastNotifiedSeason',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastNotifiedSeasonGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastNotifiedSeason',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastNotifiedSeasonLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastNotifiedSeason',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      lastNotifiedSeasonBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastNotifiedSeason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextEpisodeToAirJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextEpisodeToAirJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextEpisodeToAirJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextEpisodeToAirJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextEpisodeToAirJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextEpisodeToAirJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      nextEpisodeToAirJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextEpisodeToAirJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfEpisodesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfEpisodesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfEpisodesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfEpisodesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfEpisodes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfSeasonsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfSeasons',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfSeasonsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfSeasons',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfSeasonsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfSeasons',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      numberOfSeasonsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfSeasons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originCountry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originCountry',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originCountryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originCountry',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> originalNameEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> originalNameBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> originalNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      originalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewStartsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewContains(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> overviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      overviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overview',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> popularityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      popularityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> popularityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> popularityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'popularity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> posterPathMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'posterPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'posterPathSuffix',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPathSuffix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterPathSuffix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      posterPathSuffixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPathSuffix',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providersJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providersJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providersJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providersJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      providersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providersJson',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recommendationsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recommendationsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendationsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendationsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      recommendationsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendationsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      releaseDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'releaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      releaseDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> releaseDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'releaseDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      releaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      releaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'releaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> revenueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revenue',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> revenueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revenue',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> revenueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revenue',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> revenueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> runtimeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtime',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> runtimeGreaterThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> runtimeLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> runtimeBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seasonsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seasonsJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seasonsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> seasonsJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seasonsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      seasonsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seasonsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> taglineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagline',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      taglineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagline',
        value: '',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      videosJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videosJson',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonEqualTo(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonLessThan(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonBetween(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonEndsWith(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videosJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> videosJsonMatches(
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      videosJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videosJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      videosJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videosJson',
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition>
      voteCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voteCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> voteCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voteCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByBackdropPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByBackdropPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budget', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budget', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByFirstAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByFirstAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHasRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRating', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHasRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRating', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHomepage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByHomepageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsOnAir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnAir', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsOnAirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnAir', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsSeenOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeenOnly', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsSeenOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeenOnly', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSerie', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByIsSerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSerie', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByLastAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAirDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByLastAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAirDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByLastEpisodeToAirJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeToAirJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByLastEpisodeToAirJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeToAirJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByLastNotifiedSeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotifiedSeason', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByLastNotifiedSeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotifiedSeason', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByNextEpisodeToAirJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEpisodeToAirJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByNextEpisodeToAirJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEpisodeToAirJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByNumberOfEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByNumberOfSeasonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByPosterPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByPosterPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByProvidersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providersJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByProvidersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providersJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRecommendationsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      sortByRecommendationsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revenue', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revenue', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortBySeasonsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortBySeasonsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTagline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByTaglineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortByVoteCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByBackdropPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByBackdropPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budget', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budget', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByCreditsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByCreditsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creditsJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByFirstAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByFirstAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHasRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRating', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHasRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRating', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHomepage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByHomepageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'homepage', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByImagesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByImagesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagesJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsOnAir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnAir', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsOnAirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnAir', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRated', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRated', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsSeenOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeenOnly', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsSeenOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeenOnly', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSerie', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByIsSerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSerie', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByLastAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAirDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByLastAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAirDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByLastEpisodeToAirJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeToAirJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByLastEpisodeToAirJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeToAirJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByLastNotifiedSeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotifiedSeason', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByLastNotifiedSeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotifiedSeason', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByNextEpisodeToAirJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEpisodeToAirJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByNextEpisodeToAirJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEpisodeToAirJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByNumberOfEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByNumberOfSeasonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByPosterPathSuffix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByPosterPathSuffixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPathSuffix', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByProvidersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providersJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByProvidersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providersJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRecommendationsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy>
      thenByRecommendationsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revenue', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revenue', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenBySeasonsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonsJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenBySeasonsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonsJson', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTagline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByTaglineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVideosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVideosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosJson', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.asc);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> thenByVoteCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteCount', Sort.desc);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByBackdropPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backdropPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByBackdropPathSuffix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backdropPathSuffix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budget');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByCreditsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creditsJson', caseSensitive: caseSensitive);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByFirstAirDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstAirDate', caseSensitive: caseSensitive);
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

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByHasRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRating');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByHomepage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'homepage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByImagesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByImdbId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMovie');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsOnAir() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnAir');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRated');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsSeenOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSeenOnly');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByIsSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSerie');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByLastAirDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAirDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByLastEpisodeToAirJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEpisodeToAirJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByLastNotifiedSeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastNotifiedSeason');
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

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByNextEpisodeToAirJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextEpisodeToAirJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfEpisodes');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfSeasons');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByOriginCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originCountry');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByOriginalLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByOriginalName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByOverview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'popularity');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByPosterPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByPosterPathSuffix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPathSuffix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByProvidersJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providersJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByRecommendationsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recommendationsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByReleaseDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revenue');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtime');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctBySeasonsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByTagline(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagline', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByVideosJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videosJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QDistinct> distinctByVoteCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteCount');
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

  QueryBuilder<TmdbTitle, String, QQueryOperations> backdropPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backdropPath');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations>
      backdropPathSuffixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backdropPathSuffix');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> budgetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budget');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations> creditsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creditsJson');
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

  QueryBuilder<TmdbTitle, String, QQueryOperations> firstAirDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstAirDate');
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

  QueryBuilder<TmdbTitle, bool, QQueryOperations> hasRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRating');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> homepageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'homepage');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations> imagesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagesJson');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> imdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imdbId');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isMovieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMovie');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isOnAirProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnAir');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isRatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRated');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isSeenOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSeenOnly');
    });
  }

  QueryBuilder<TmdbTitle, bool, QQueryOperations> isSerieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSerie');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> lastAirDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAirDate');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations>
      lastEpisodeToAirJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEpisodeToAirJson');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> lastNotifiedSeasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastNotifiedSeason');
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

  QueryBuilder<TmdbTitle, String?, QQueryOperations>
      nextEpisodeToAirJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextEpisodeToAirJson');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> numberOfEpisodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfEpisodes');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> numberOfSeasonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfSeasons');
    });
  }

  QueryBuilder<TmdbTitle, List<String>, QQueryOperations>
      originCountryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originCountry');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> originalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalName');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> overviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overview');
    });
  }

  QueryBuilder<TmdbTitle, double, QQueryOperations> popularityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'popularity');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations>
      posterPathSuffixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPathSuffix');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations> providersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providersJson');
    });
  }

  QueryBuilder<TmdbTitle, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations>
      recommendationsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recommendationsJson');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> releaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseDate');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> revenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revenue');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> runtimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtime');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations> seasonsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonsJson');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TmdbTitle, String, QQueryOperations> taglineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagline');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<TmdbTitle, String?, QQueryOperations> videosJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videosJson');
    });
  }

  QueryBuilder<TmdbTitle, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }

  QueryBuilder<TmdbTitle, int, QQueryOperations> voteCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteCount');
    });
  }
}
