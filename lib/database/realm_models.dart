import 'package:realm/realm.dart';

part 'realm_models.realm.dart';

@RealmModel()
class _UserListEntryRealm {
  @PrimaryKey()
  late String id; // format: listName_tmdbId_mediaType

  late String listName;
  late int tmdbId;
  late String mediaType;

  @Indexed()
  late int addedOrder;
}

@RealmModel()
class _TmdbTitleRealm {
  @PrimaryKey()
  late String id; // format: tmdbId_mediaType

  late int tmdbId;
  late List<String> inLists;

  late String name;
  late String originalName;
  late String originalLanguage;
  late String overview;
  late String tagline;
  late String status;
  late String mediaType;
  late String imdbId;
  late String homepage;

  late String? posterPathSuffix;
  late String? backdropPathSuffix;

  // Dates
  late String releaseDate;
  late String firstAirDate;
  late String lastAirDate;
  late String lastUpdated;

  // Numbers
  late double voteAverage;
  late int voteCount;
  late double rating; // User rating
  late DateTime dateRated;
  late int runtime;
  late int numberOfEpisodes;
  late int numberOfSeasons;
  late double popularity;
  late int budget;
  late int revenue;

  // Calculated/Logic fields
  late int effectiveRuntime;
  late String effectiveReleaseDate;
  late int addedOrder;
  late bool isPinned;
  late bool notifyNewSeasons;

  // JSON strings for complex objects
  late String? imagesJson;
  late String? videosJson;
  late String? recommendationsJson;
  late String? nextEpisodeToAirJson;
  late String? lastEpisodeToAirJson;
  late String? providersJson;
  late String? creditsJson;
  late String? seasonsJson;

  late List<int> genreIds;
  late List<int> flatrateProviderIds;
  late int lastNotifiedSeason;
  late String lastProvidersUpdate;

  late String character;
  late String job;
  late String department;
}

@RealmModel()
class _TmdbSeasonRealm {
  @PrimaryKey()
  late String id; // format: tvId_seasonNumber

  late int tvId;
  late int tmdbId;
  late int seasonNumber;
  late String name;
  late String overview;
  late String airDate;
  late String? posterPathSuffix;
  late String lastUpdated;

  late String? creditsJson;
  late String? episodesJson;
}

@RealmModel()
class _TmdbEpisodeRealm {
  @PrimaryKey()
  late String id; // format: tvId_seasonNumber_episodeNumber

  late int tmdbId;
  late int tvId;
  late int seasonNumber;
  late String name;
  late String overview;
  late String airDate;
  late int runtime;
  late int episodeNumber;
  late String lastUpdated;

  late double voteAverage;

  late String? stillPathSuffix;
  late String? guestStarsJson;
  late String? crewJson;
  late String? imagesJson;
  late String? videosJson;
}

class TmdbTitleRealmFields {
  static const String dateRated = 'dateRated';
  static const String effectiveReleaseDate = 'effectiveReleaseDate';
  static const String effectiveRuntime = 'effectiveRuntime';
  static const String genreIds = 'genreIds';
  static const String inLists = 'inLists';
  static const String isPinned = 'isPinned';
  static const String mediaType = 'mediaType';
  static const String name = 'name';
  static const String notifyNewSeasons = 'notifyNewSeasons';
  static const String numberOfSeasons = 'numberOfSeasons';
  static const String originalName = 'originalName';
  static const String overview = 'overview';
  static const String providersJson = 'providersJson';
  static const String rating = 'rating';
  static const String status = 'status';
  static const String tagline = 'tagline';
  static const String tmdbId = 'tmdbId';
  static const String voteAverage = 'voteAverage';
  static const String flatrateProviderIds = 'flatrateProviderIds';
  static const String lastUpdated = 'lastUpdated';
}

class UserListEntryRealmFields {
  static const String addedOrder = 'addedOrder';
  static const String listName = 'listName';
  static const String mediaType = 'mediaType';
  static const String tmdbId = 'tmdbId';
}

class TmdbSeasonRealmFields {
  static const String seasonNumber = 'seasonNumber';
  static const String tvId = 'tvId';
}

class TmdbEpisodeRealmFields {
  static const String tvId = 'tvId';
}
