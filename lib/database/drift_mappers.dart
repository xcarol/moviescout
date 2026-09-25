import 'package:drift/drift.dart';
import 'package:moviescout/database/app_database.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';

class DriftMapper {
  static TmdbTitle toDomainTitle(TmdbTitleData data) {
    return TmdbTitle(
      tmdbId: data.tmdbId,
      name: data.name,
      originalName: data.originalName,
      originalLanguage: data.originalLanguage,
      overview: data.overview,
      tagline: data.tagline,
      status: data.status,
      mediaType: data.mediaType,
      imdbId: data.imdbId,
      homepage: data.homepage,
      certification: data.certification,
      type: data.type,
      posterPathSuffix: data.posterPathSuffix,
      backdropPathSuffix: data.backdropPathSuffix,
      releaseDate: data.releaseDate,
      firstAirDate: data.firstAirDate,
      lastAirDate: data.lastAirDate,
      lastUpdated: data.lastUpdated,
      voteAverage: data.voteAverage,
      voteCount: data.voteCount,
      rating: data.rating,
      dateRated: data.dateRated,
      runtime: data.runtime,
      numberOfEpisodes: data.numberOfEpisodes,
      numberOfSeasons: data.numberOfSeasons,
      popularity: data.popularity,
      budget: data.budget,
      revenue: data.revenue,
    )
      ..inLists = data.inLists.toList()
      ..effectiveRuntime = data.effectiveRuntime
      ..effectiveReleaseDate = data.effectiveReleaseDate
      ..addedOrder = data.addedOrder
      ..isPinned = data.isPinned
      ..notifyNewSeasons = data.notifyNewSeasons
      ..imagesJson = data.imagesJson
      ..videosJson = data.videosJson
      ..recommendationsJson = data.recommendationsJson
      ..nextEpisodeToAirJson = data.nextEpisodeToAirJson
      ..lastEpisodeToAirJson = data.lastEpisodeToAirJson
      ..externalIdsJson = data.externalIdsJson
      ..providersJson = data.providersJson
      ..creditsJson = data.creditsJson
      ..seasonsJson = data.seasonsJson
      ..genreIds = data.genreIds.toList()
      ..keywordIds = data.keywordIds.toList()
      ..flatrateProviderIds = data.flatrateProviderIds.toList()
      ..lastNotifiedSeason = data.lastNotifiedSeason
      ..character = data.character
      ..job = data.job
      ..department = data.department;
  }

  static TmdbTitlesCompanion toCompanionTitle(TmdbTitle domainObj) {
    return TmdbTitlesCompanion(
      id: Value('${domainObj.tmdbId}_${domainObj.mediaType}'),
      tmdbId: Value(domainObj.tmdbId),
      name: Value(domainObj.name),
      originalName: Value(domainObj.originalName),
      originalLanguage: Value(domainObj.originalLanguage),
      overview: Value(domainObj.overview),
      tagline: Value(domainObj.tagline),
      status: Value(domainObj.status),
      mediaType: Value(domainObj.mediaType),
      imdbId: Value(domainObj.imdbId),
      homepage: Value(domainObj.homepage),
      certification: Value(domainObj.certification),
      type: Value(domainObj.type),
      posterPathSuffix: Value(domainObj.posterPathSuffix),
      backdropPathSuffix: Value(domainObj.backdropPathSuffix),
      releaseDate: Value(domainObj.releaseDate),
      firstAirDate: Value(domainObj.firstAirDate),
      lastAirDate: Value(domainObj.lastAirDate),
      lastUpdated: Value(domainObj.lastUpdated),
      externalIdsJson: Value(domainObj.externalIdsJson),
      voteAverage: Value(domainObj.voteAverage),
      voteCount: Value(domainObj.voteCount),
      rating: Value(domainObj.rating),
      dateRated: Value(domainObj.dateRated),
      runtime: Value(domainObj.runtime),
      numberOfEpisodes: Value(domainObj.numberOfEpisodes),
      numberOfSeasons: Value(domainObj.numberOfSeasons),
      popularity: Value(domainObj.popularity),
      budget: Value(domainObj.budget),
      revenue: Value(domainObj.revenue),
      effectiveRuntime: Value(domainObj.effectiveRuntime),
      effectiveReleaseDate: Value(domainObj.effectiveReleaseDate),
      addedOrder: Value(domainObj.addedOrder),
      isPinned: Value(domainObj.isPinned),
      notifyNewSeasons: Value(domainObj.notifyNewSeasons),
      imagesJson: Value(domainObj.imagesJson),
      videosJson: Value(domainObj.videosJson),
      recommendationsJson: Value(domainObj.recommendationsJson),
      nextEpisodeToAirJson: Value(domainObj.nextEpisodeToAirJson),
      lastEpisodeToAirJson: Value(domainObj.lastEpisodeToAirJson),
      providersJson: Value(domainObj.providersJson),
      creditsJson: Value(domainObj.creditsJson),
      seasonsJson: Value(domainObj.seasonsJson),
      inLists: Value(domainObj.inLists),
      genreIds: Value(domainObj.genreIds),
      keywordIds: Value(domainObj.keywordIds),
      flatrateProviderIds: Value(domainObj.flatrateProviderIds),
      lastNotifiedSeason: Value(domainObj.lastNotifiedSeason),
      character: Value(domainObj.character),
      job: Value(domainObj.job),
      department: Value(domainObj.department),
    );
  }

  static UserListEntry toDomainUserListEntry(UserListEntryData data) {
    return UserListEntry(
      listName: data.listName,
      tmdbId: data.tmdbId,
      mediaType: data.mediaType,
      addedOrder: data.addedOrder,
    );
  }

  static UserListEntriesCompanion toCompanionUserListEntry(
      UserListEntry domainObj) {
    return UserListEntriesCompanion(
      id: Value(
          '${domainObj.listName}_${domainObj.tmdbId}_${domainObj.mediaType}'),
      listName: Value(domainObj.listName),
      tmdbId: Value(domainObj.tmdbId),
      mediaType: Value(domainObj.mediaType),
      addedOrder: Value(domainObj.addedOrder),
    );
  }

  static TmdbSeason toDomainSeason(TmdbSeasonData data) {
    return TmdbSeason(
      tvId: data.tvId,
      tmdbId: data.tmdbId,
      seasonNumber: data.seasonNumber,
      name: data.name,
      overview: data.overview,
      airDate: data.airDate,
      posterPathSuffix: data.posterPathSuffix,
      lastUpdated: data.lastUpdated,
      voteAverage: data.voteAverage,
    )
      ..creditsJson = data.creditsJson
      ..imagesJson = data.imagesJson
      ..videosJson = data.videosJson
      ..episodesJson = data.episodesJson ?? '[]';
  }

  static TmdbSeasonsCompanion toCompanionSeason(TmdbSeason domainObj) {
    return TmdbSeasonsCompanion(
      id: Value('${domainObj.tvId}_${domainObj.seasonNumber}'),
      tvId: Value(domainObj.tvId),
      tmdbId: Value(domainObj.tmdbId),
      seasonNumber: Value(domainObj.seasonNumber),
      name: Value(domainObj.name),
      overview: Value(domainObj.overview),
      airDate: Value(domainObj.airDate),
      posterPathSuffix: Value(domainObj.posterPathSuffix),
      lastUpdated: Value(domainObj.lastUpdated),
      voteAverage: Value(domainObj.voteAverage),
      creditsJson: Value(domainObj.creditsJson),
      imagesJson: Value(domainObj.imagesJson),
      videosJson: Value(domainObj.videosJson),
      episodesJson: Value(domainObj.episodesJson),
    );
  }

  static TmdbEpisode toDomainEpisode(TmdbEpisodeData data) {
    return TmdbEpisode(
      tmdbId: data.tmdbId,
      tvId: data.tvId,
      seasonNumber: data.seasonNumber,
      name: data.name,
      overview: data.overview,
      airDate: data.airDate,
      runtime: data.runtime,
      episodeNumber: data.episodeNumber,
      lastUpdated: data.lastUpdated,
      voteAverage: data.voteAverage,
      rating: data.rating,
      dateRated: data.dateRated,
    )
      ..stillPathSuffix = data.stillPathSuffix
      ..guestStarsJson = data.guestStarsJson
      ..crewJson = data.crewJson
      ..imagesJson = data.imagesJson
      ..videosJson = data.videosJson;
  }

  static TmdbEpisodesCompanion toCompanionEpisode(TmdbEpisode domainObj) {
    return TmdbEpisodesCompanion(
      id: Value(
          '${domainObj.tvId}_${domainObj.seasonNumber}_${domainObj.episodeNumber}'),
      tmdbId: Value(domainObj.tmdbId),
      tvId: Value(domainObj.tvId),
      seasonNumber: Value(domainObj.seasonNumber),
      episodeNumber: Value(domainObj.episodeNumber),
      name: Value(domainObj.name),
      overview: Value(domainObj.overview),
      airDate: Value(domainObj.airDate),
      runtime: Value(domainObj.runtime),
      lastUpdated: Value(domainObj.lastUpdated),
      voteAverage: Value(domainObj.voteAverage),
      rating: Value(domainObj.rating),
      dateRated: Value(domainObj.dateRated),
      stillPathSuffix: Value(domainObj.stillPathSuffix),
      guestStarsJson: Value(domainObj.guestStarsJson),
      crewJson: Value(domainObj.crewJson),
      imagesJson: Value(domainObj.imagesJson),
      videosJson: Value(domainObj.videosJson),
    );
  }
}
