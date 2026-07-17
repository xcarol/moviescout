import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/database/realm_models.dart';

class RealmMapper {
  static TmdbTitle toDomainTitle(TmdbTitleRealm realmObj) {
    return TmdbTitle(
      tmdbId: realmObj.tmdbId,
      name: realmObj.name,
      originalName: realmObj.originalName,
      originalLanguage: realmObj.originalLanguage,
      overview: realmObj.overview,
      tagline: realmObj.tagline,
      status: realmObj.status,
      mediaType: realmObj.mediaType,
      imdbId: realmObj.imdbId,
      homepage: realmObj.homepage,
      certification: realmObj.certification,
      posterPathSuffix: realmObj.posterPathSuffix,
      backdropPathSuffix: realmObj.backdropPathSuffix,
      releaseDate: realmObj.releaseDate,
      firstAirDate: realmObj.firstAirDate,
      lastAirDate: realmObj.lastAirDate,
      lastUpdated: realmObj.lastUpdated,
      voteAverage: realmObj.voteAverage,
      voteCount: realmObj.voteCount,
      rating: realmObj.rating,
      dateRated: realmObj.dateRated,
      runtime: realmObj.runtime,
      numberOfEpisodes: realmObj.numberOfEpisodes,
      numberOfSeasons: realmObj.numberOfSeasons,
      popularity: realmObj.popularity,
      budget: realmObj.budget,
      revenue: realmObj.revenue,
    )
      ..inLists = realmObj.inLists.toList()
      ..effectiveRuntime = realmObj.effectiveRuntime
      ..effectiveReleaseDate = realmObj.effectiveReleaseDate
      ..addedOrder = realmObj.addedOrder
      ..isPinned = realmObj.isPinned
      ..notifyNewSeasons = realmObj.notifyNewSeasons
      ..imagesJson = realmObj.imagesJson
      ..videosJson = realmObj.videosJson
      ..recommendationsJson = realmObj.recommendationsJson
      ..nextEpisodeToAirJson = realmObj.nextEpisodeToAirJson
      ..lastEpisodeToAirJson = realmObj.lastEpisodeToAirJson
      ..externalIdsJson = realmObj.externalIdsJson
      ..providersJson = realmObj.providersJson
      ..creditsJson = realmObj.creditsJson
      ..seasonsJson = realmObj.seasonsJson
      ..genreIds = realmObj.genreIds.toList()
      ..keywordIds = realmObj.keywordIds.toList()
      ..flatrateProviderIds = realmObj.flatrateProviderIds.toList()
      ..lastNotifiedSeason = realmObj.lastNotifiedSeason
      ..lastProvidersUpdate = realmObj.lastProvidersUpdate
      ..character = realmObj.character
      ..job = realmObj.job
      ..department = realmObj.department;
  }

  static TmdbTitleRealm toRealmTitle(TmdbTitle domainObj) {
    return TmdbTitleRealm(
      '${domainObj.tmdbId}_${domainObj.mediaType}',
      domainObj.tmdbId,
      domainObj.name,
      domainObj.originalName,
      domainObj.originalLanguage,
      domainObj.overview,
      domainObj.tagline,
      domainObj.status,
      domainObj.mediaType,
      domainObj.imdbId,
      domainObj.homepage,
      domainObj.certification,
      domainObj.releaseDate,
      domainObj.firstAirDate,
      domainObj.lastAirDate,
      domainObj.lastUpdated,
      domainObj.voteAverage,
      domainObj.voteCount,
      domainObj.rating,
      domainObj.dateRated,
      domainObj.runtime,
      domainObj.numberOfEpisodes,
      domainObj.numberOfSeasons,
      domainObj.popularity,
      domainObj.budget,
      domainObj.revenue,
      domainObj.effectiveRuntime,
      domainObj.effectiveReleaseDate,
      domainObj.addedOrder,
      domainObj.isPinned,
      domainObj.notifyNewSeasons,
      domainObj.lastNotifiedSeason,
      domainObj.lastProvidersUpdate,
      domainObj.character,
      domainObj.job,
      domainObj.department,
      inLists: domainObj.inLists,
      posterPathSuffix: domainObj.posterPathSuffix,
      backdropPathSuffix: domainObj.backdropPathSuffix,
      imagesJson: domainObj.imagesJson,
      videosJson: domainObj.videosJson,
      recommendationsJson: domainObj.recommendationsJson,
      nextEpisodeToAirJson: domainObj.nextEpisodeToAirJson,
      lastEpisodeToAirJson: domainObj.lastEpisodeToAirJson,
      externalIdsJson: domainObj.externalIdsJson,
      providersJson: domainObj.providersJson,
      creditsJson: domainObj.creditsJson,
      seasonsJson: domainObj.seasonsJson,
      genreIds: domainObj.genreIds,
      keywordIds: domainObj.keywordIds,
      flatrateProviderIds: domainObj.flatrateProviderIds,
    );
  }

  static UserListEntry toDomainUserListEntry(UserListEntryRealm realmObj) {
    return UserListEntry(
      listName: realmObj.listName,
      tmdbId: realmObj.tmdbId,
      mediaType: realmObj.mediaType,
      addedOrder: realmObj.addedOrder,
    );
  }

  static UserListEntryRealm toRealmUserListEntry(UserListEntry domainObj) {
    return UserListEntryRealm(
      '${domainObj.listName}_${domainObj.tmdbId}_${domainObj.mediaType}',
      domainObj.listName,
      domainObj.tmdbId,
      domainObj.mediaType,
      domainObj.addedOrder,
    );
  }

  static TmdbSeason toDomainSeason(TmdbSeasonRealm realmObj) {
    return TmdbSeason(
      tvId: realmObj.tvId,
      tmdbId: realmObj.tmdbId,
      seasonNumber: realmObj.seasonNumber,
      name: realmObj.name,
      overview: realmObj.overview,
      airDate: realmObj.airDate,
      posterPathSuffix: realmObj.posterPathSuffix,
      lastUpdated: realmObj.lastUpdated,
      voteAverage: 0.0, // Add missing default if any
    )
      ..creditsJson = realmObj.creditsJson
      ..episodesJson = realmObj.episodesJson ?? '[]';
  }

  static TmdbSeasonRealm toRealmSeason(TmdbSeason domainObj) {
    return TmdbSeasonRealm(
      '${domainObj.tvId}_${domainObj.seasonNumber}',
      domainObj.tvId,
      domainObj.tmdbId,
      domainObj.seasonNumber,
      domainObj.name,
      domainObj.overview,
      domainObj.airDate,
      domainObj.lastUpdated,
      posterPathSuffix: domainObj.posterPathSuffix,
      creditsJson: domainObj.creditsJson,
      episodesJson: domainObj.episodesJson,
    );
  }

  static TmdbEpisode toDomainEpisode(TmdbEpisodeRealm realmObj) {
    return TmdbEpisode(
      tmdbId: realmObj.tmdbId,
      tvId: realmObj.tvId,
      seasonNumber: realmObj.seasonNumber,
      name: realmObj.name,
      overview: realmObj.overview,
      airDate: realmObj.airDate,
      runtime: realmObj.runtime,
      episodeNumber: realmObj.episodeNumber,
      lastUpdated: realmObj.lastUpdated,
      voteAverage: realmObj.voteAverage,
    )
      ..stillPathSuffix = realmObj.stillPathSuffix
      ..guestStarsJson = realmObj.guestStarsJson
      ..crewJson = realmObj.crewJson
      ..imagesJson = realmObj.imagesJson
      ..videosJson = realmObj.videosJson;
  }

  static TmdbEpisodeRealm toRealmEpisode(TmdbEpisode domainObj) {
    return TmdbEpisodeRealm(
      '${domainObj.tvId}_${domainObj.seasonNumber}_${domainObj.episodeNumber}',
      domainObj.tmdbId,
      domainObj.tvId,
      domainObj.seasonNumber,
      domainObj.name,
      domainObj.overview,
      domainObj.airDate,
      domainObj.runtime,
      domainObj.episodeNumber,
      domainObj.lastUpdated,
      domainObj.voteAverage,
      stillPathSuffix: domainObj.stillPathSuffix,
      guestStarsJson: domainObj.guestStarsJson,
      crewJson: domainObj.crewJson,
      imagesJson: domainObj.imagesJson,
      videosJson: domainObj.videosJson,
    );
  }
}
