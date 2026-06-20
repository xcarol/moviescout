import 'dart:convert';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:isar_community/isar.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

// ignore_for_file: constant_identifier_names, unused_element

import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_providers.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';

part 'tmdb_title.g.dart';

class TmdbTitleFields {
  static const String adult = 'adult';
  static const String backdropPath = 'backdrop_path';
  static const String belongsToCollection = 'belongs_to_collection';
  static const String budget = 'budget';
  static const String genres = 'genres';
  static const String genreIds = 'genre_ids';
  static const String homepage = 'homepage';
  static const String id = 'id';
  static const String imdbId = 'imdb_id';
  static const String originCountry = 'origin_country';
  static const String originalLanguage = 'original_language';
  static const String originalTitle = 'original_title';
  static const String overview = 'overview';
  static const String popularity = 'popularity';
  static const String posterPath = 'poster_path';
  static const String productionCompanies = 'production_companies';
  static const String productionCountries = 'production_countries';
  static const String releaseDate = 'release_date';
  static const String rating = 'rating';
  static const String recommendations = 'recommendations';
  static const String accountRating = 'account_rating';
  static const String accountRatingDate = 'created_at';
  static const String accountRatingValue = 'value';
  static const String revenue = 'revenue';
  static const String runtime = 'runtime';
  static const String spokenLanguages = 'spoken_languages';
  static const String status = 'status';
  static const String tagline = 'tagline';
  static const String title = 'title';
  static const String video = 'video';
  static const String voteAverage = 'vote_average';
  static const String voteCount = 'vote_count';

  // Only in tv series
  static const String createdBy = 'created_by';
  static const String episodeRunTime = 'episode_run_time';
  static const String firstAirDate = 'first_air_date';
  static const String inProduction = 'in_production';
  static const String languages = 'languages';
  static const String lastAirDate = 'last_air_date';
  static const String lastEpisodeToAir = 'last_episode_to_air';
  static const String name = 'name';
  static const String nextEpisodeToAir = 'next_episode_to_air';
  static const String airDate = 'air_date';
  static const String networks = 'networks';
  static const String numberOfEpisodes = 'number_of_episodes';
  static const String numberOfSeasons = 'number_of_seasons';
  static const String originalName = 'original_name';
  static const String seasons = 'seasons';
  static const String type = 'type';

  // People
  static const String credits = 'credits';
  static const String aggregateCredits = 'aggregate_credits';
  static const String cast = 'cast';
  static const String character = 'character';
  static const String job = 'job';
  static const String department = 'department';

  // Custom
  static const String listName = 'list_name';
  static const String lastUpdated = 'last_updated';
  static const String mediaType = 'media_type';
  static const String providers = 'providers';
  static const String isPinned = 'is_pinned';
  static const String notifyNewSeasons = 'notify_new_seasons';
  static const String images = 'images';
  static const String videos = 'videos';
  static const String key = 'key';
  static const String site = 'site';
  static const String isSearchResult = 'is_search_result';
  static const String iso6391 = 'iso_639_1';
  static const String lastNotifiedSeason = 'last_notified_season';
  static const String lastProvidersUpdate = 'last_providers_update';
  static const String omdbRatings = 'omdb_ratings';
}

class TvShowStatus {
  static const String ended = 'Ended';
  static const String returning = 'Returning Series';
  static const String canceled = 'Canceled';
  static const String inProduction = 'In Production';
  static const String planned = 'Planned';
}

class SortOption {
  static const alphabetically = 'alphabetically';
  static const rating = 'rating';
  static const userRating = 'userRating';
  static const releaseDate = 'releaseDate';
  static const runtime = 'runtime';
  static const dateRated = 'dateRated';
  static const addedOrder = 'addedOrder';
}

@collection
class TmdbTitle implements TmdbItem {
  @Index(unique: true)
  Id id = Isar.autoIncrement;

  @override
  @Index(unique: true, replace: true, composite: [CompositeIndex('mediaType')])
  late int tmdbId;

  List<String> inLists = [];

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
  @override
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
  @ignore
  int addedOrder = 0;
  late bool isPinned;
  late bool notifyNewSeasons;

  // Lists (Simple)
  late List<int> genreIds;
  late List<int> flatrateProviderIds;
  late List<String> originCountry;

  // Complex objects stored as JSON strings
  late String? creditsJson;
  late String? providersJson;
  late String? seasonsJson;
  late String? recommendationsJson;
  late String? nextEpisodeToAirJson;
  late String? lastEpisodeToAirJson;
  late String? imagesJson;
  late String? videosJson;
  late String? omdbRatingsJson;

  late int lastNotifiedSeason; // New field for notification tracking
  late String lastProvidersUpdate;

  @ignore
  String character = '';
  @ignore
  String job = '';
  @ignore
  String department = '';

  TmdbTitle({
    required this.id,
    required this.tmdbId,
    required this.name,
    this.originalName = '',
    this.originalLanguage = '',
    this.overview = '',
    this.tagline = '',
    this.status = '',
    this.mediaType = '',
    this.imdbId = '',
    this.posterPathSuffix,
    this.backdropPathSuffix,
    this.releaseDate = '',
    this.firstAirDate = '',
    this.lastAirDate = '',
    required this.lastUpdated,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.rating = 0.0,
    required this.dateRated,
    this.runtime = 0,
    this.numberOfEpisodes = 0,
    this.numberOfSeasons = 0,
    this.popularity = 0.0,
    this.budget = 0,
    this.revenue = 0,
    this.effectiveRuntime = 0,
    this.effectiveReleaseDate = '',
    this.genreIds = const [],
    this.flatrateProviderIds = const [],
    this.originCountry = const [],
    this.creditsJson,
    this.providersJson,
    this.seasonsJson,
    this.recommendationsJson,
    this.nextEpisodeToAirJson,
    this.lastEpisodeToAirJson,
    this.imagesJson,
    this.videosJson,
    this.omdbRatingsJson,
    this.homepage = '',
    this.isPinned = false,
    this.notifyNewSeasons = false,
    this.lastNotifiedSeason = 0,
    this.lastProvidersUpdate = '',
  }) {
    if (effectiveReleaseDate.isEmpty) {
      effectiveReleaseDate =
          mediaType == ApiConstants.movie ? releaseDate : firstAirDate;
    }
    if (effectiveRuntime == 0) {
      effectiveRuntime =
          mediaType == ApiConstants.movie ? runtime : numberOfEpisodes;
    }
  }

  factory TmdbTitle.fromMap({required Map<dynamic, dynamic> title}) {
    return TmdbTitle(
      id: Isar.autoIncrement,
      tmdbId: title[TmdbTitleFields.id] ?? 0,
      name: '',
      lastUpdated: AppConstants.defaultDate,
      dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      isPinned: title[TmdbTitleFields.isPinned] ?? false,
      notifyNewSeasons: title[TmdbTitleFields.notifyNewSeasons] ?? false,
      lastNotifiedSeason: title[TmdbTitleFields.lastNotifiedSeason] ?? 0,
      lastProvidersUpdate: title[TmdbTitleFields.lastProvidersUpdate] ??
          AppConstants.defaultDate,
    )..fillFromMap(title);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTitle && tmdbId == other.tmdbId;

  @override
  int get hashCode => tmdbId.hashCode;

  void fillFromMap(Map<dynamic, dynamic> title) {
    if (title[TmdbTitleFields.id] != null) {
      tmdbId = title[TmdbTitleFields.id];
    }

    final mediaTypeVal = title[TmdbTitleFields.mediaType] ?? mediaType;
    mediaType = mediaTypeVal;

    if (title[TmdbTitleFields.name] != null ||
        title[TmdbTitleFields.title] != null) {
      name = title[TmdbTitleFields.name] ?? title[TmdbTitleFields.title] ?? '';
    }

    if (title[TmdbTitleFields.originalName] != null ||
        title[TmdbTitleFields.originalTitle] != null) {
      originalName = title[TmdbTitleFields.originalName] ??
          title[TmdbTitleFields.originalTitle] ??
          '';
    }

    originalLanguage =
        title[TmdbTitleFields.originalLanguage] ?? originalLanguage;
    overview = title[TmdbTitleFields.overview] ?? overview;
    tagline = title[TmdbTitleFields.tagline] ?? tagline;
    status = title[TmdbTitleFields.status] ?? status;
    imdbId = title[TmdbTitleFields.imdbId] ?? imdbId;
    homepage = title[TmdbTitleFields.homepage] ?? homepage;

    if (title.containsKey(TmdbTitleFields.posterPath)) {
      posterPathSuffix = title[TmdbTitleFields.posterPath];
    }
    if (title.containsKey(TmdbTitleFields.backdropPath)) {
      backdropPathSuffix = title[TmdbTitleFields.backdropPath];
    }

    releaseDate = title[TmdbTitleFields.releaseDate] ?? releaseDate;
    firstAirDate = title[TmdbTitleFields.firstAirDate] ?? firstAirDate;
    lastAirDate = title[TmdbTitleFields.lastAirDate] ?? lastAirDate;
    lastUpdated = title[TmdbTitleFields.lastUpdated] ?? lastUpdated;

    voteAverage =
        (title[TmdbTitleFields.voteAverage] ?? voteAverage).toDouble();
    voteCount = title[TmdbTitleFields.voteCount] ?? voteCount;

    if (title[TmdbTitleFields.accountRating] is Map) {
      rating = (title[TmdbTitleFields.accountRating]
                  [TmdbTitleFields.accountRatingValue] ??
              rating)
          .toDouble();
      if (title[TmdbTitleFields.accountRating]
              [TmdbTitleFields.accountRatingDate] !=
          null) {
        dateRated = DateTime.parse(title[TmdbTitleFields.accountRating]
            [TmdbTitleFields.accountRatingDate]);
      }
    } else if (title[TmdbTitleFields.accountRating] is num) {
      rating = title[TmdbTitleFields.accountRating].toDouble();
      if (dateRated.year < 2000) dateRated = DateTime.now();
    } else if (title[TmdbTitleFields.rating] != null) {
      rating = title[TmdbTitleFields.rating].toDouble();
      if (dateRated.year < 2000) dateRated = DateTime.now();
    }

    runtime = title[TmdbTitleFields.runtime] ?? runtime;
    numberOfEpisodes =
        title[TmdbTitleFields.numberOfEpisodes] ?? numberOfEpisodes;
    numberOfSeasons = title[TmdbTitleFields.numberOfSeasons] ?? numberOfSeasons;
    popularity = (title[TmdbTitleFields.popularity] ?? popularity).toDouble();
    budget = title[TmdbTitleFields.budget] ?? budget;
    revenue = title[TmdbTitleFields.revenue] ?? revenue;
    isPinned = title[TmdbTitleFields.isPinned] ?? isPinned;
    notifyNewSeasons =
        title[TmdbTitleFields.notifyNewSeasons] ?? notifyNewSeasons;
    lastNotifiedSeason =
        title[TmdbTitleFields.lastNotifiedSeason] ?? lastNotifiedSeason;
    lastProvidersUpdate =
        title[TmdbTitleFields.lastProvidersUpdate] ?? lastProvidersUpdate;

    effectiveReleaseDate =
        mediaType == ApiConstants.movie ? releaseDate : firstAirDate;
    effectiveRuntime =
        mediaType == ApiConstants.movie ? runtime : numberOfEpisodes;

    if (title[TmdbTitleFields.originCountry] is List) {
      originCountry = List<String>.from(title[TmdbTitleFields.originCountry]);
    }

    if (title[TmdbTitleFields.credits] != null ||
        title[TmdbTitleFields.aggregateCredits] != null) {
      creditsJson = jsonEncode(title[TmdbTitleFields.credits] ??
          title[TmdbTitleFields.aggregateCredits]);
    }
    if (title[TmdbTitleFields.providers] != null) {
      providersJson = jsonEncode(title[TmdbTitleFields.providers]);
    }
    if (title[TmdbTitleFields.seasons] != null) {
      seasonsJson = jsonEncode(title[TmdbTitleFields.seasons]);
    }
    if (title[TmdbTitleFields.recommendations] != null) {
      recommendationsJson = jsonEncode(title[TmdbTitleFields.recommendations]);
    }
    if (title.containsKey(TmdbTitleFields.nextEpisodeToAir)) {
      nextEpisodeToAirJson = title[TmdbTitleFields.nextEpisodeToAir] != null
          ? jsonEncode(title[TmdbTitleFields.nextEpisodeToAir])
          : null;
    }
    if (title.containsKey(TmdbTitleFields.lastEpisodeToAir)) {
      lastEpisodeToAirJson = title[TmdbTitleFields.lastEpisodeToAir] != null
          ? jsonEncode(title[TmdbTitleFields.lastEpisodeToAir])
          : null;
    }
    if (title[TmdbTitleFields.images] != null) {
      imagesJson = jsonEncode(title[TmdbTitleFields.images]);
    }
    if (title[TmdbTitleFields.videos] != null) {
      videosJson = jsonEncode(title[TmdbTitleFields.videos]);
    }
    if (title[TmdbTitleFields.omdbRatings] != null) {
      omdbRatingsJson = jsonEncode(title[TmdbTitleFields.omdbRatings]);
    }

    character = title[TmdbTitleFields.character] ?? character;
    job = title[TmdbTitleFields.job] ?? job;
    department = title[TmdbTitleFields.department] ?? department;

    updateGenreIds(
        this, title[TmdbTitleFields.genres], title[TmdbTitleFields.genreIds]);
    updateProviderIds(this, title[TmdbTitleFields.providers]);
  }

  Map<String, dynamic> toMap() {
    return {
      TmdbTitleFields.id: tmdbId,
      TmdbTitleFields.name: name,
      TmdbTitleFields.title: name,
      TmdbTitleFields.originalName: originalName,
      TmdbTitleFields.originalTitle: originalName,
      TmdbTitleFields.originalLanguage: originalLanguage,
      TmdbTitleFields.overview: overview,
      TmdbTitleFields.tagline: tagline,
      TmdbTitleFields.status: status,
      TmdbTitleFields.mediaType: mediaType,
      TmdbTitleFields.imdbId: imdbId,
      TmdbTitleFields.homepage: homepage,
      TmdbTitleFields.posterPath: posterPathSuffix,
      TmdbTitleFields.backdropPath: backdropPathSuffix,
      TmdbTitleFields.releaseDate: releaseDate,
      TmdbTitleFields.firstAirDate: firstAirDate,
      TmdbTitleFields.lastAirDate: lastAirDate,
      TmdbTitleFields.lastUpdated: lastUpdated,
      TmdbTitleFields.voteAverage: voteAverage,
      TmdbTitleFields.voteCount: voteCount,
      TmdbTitleFields.accountRating: {
        TmdbTitleFields.accountRatingValue: rating,
        TmdbTitleFields.accountRatingDate: dateRated.toIso8601String(),
      },
      TmdbTitleFields.runtime: runtime,
      TmdbTitleFields.numberOfEpisodes: numberOfEpisodes,
      TmdbTitleFields.numberOfSeasons: numberOfSeasons,
      TmdbTitleFields.popularity: popularity,
      TmdbTitleFields.budget: budget,
      TmdbTitleFields.revenue: revenue,
      TmdbTitleFields.isPinned: isPinned,
      TmdbTitleFields.notifyNewSeasons: notifyNewSeasons,
      TmdbTitleFields.lastNotifiedSeason: lastNotifiedSeason,
      TmdbTitleFields.lastProvidersUpdate: lastProvidersUpdate,
      TmdbTitleFields.genreIds: genreIds,
      TmdbTitleFields.originCountry: originCountry,
      TmdbTitleFields.credits:
          creditsJson != null ? jsonDecode(creditsJson!) : null,
      TmdbTitleFields.providers:
          providersJson != null ? jsonDecode(providersJson!) : null,
      TmdbTitleFields.seasons:
          seasonsJson != null ? jsonDecode(seasonsJson!) : null,
      TmdbTitleFields.recommendations:
          recommendationsJson != null ? jsonDecode(recommendationsJson!) : null,
      TmdbTitleFields.nextEpisodeToAir: nextEpisodeToAirJson != null
          ? jsonDecode(nextEpisodeToAirJson!)
          : null,
      TmdbTitleFields.lastEpisodeToAir: lastEpisodeToAirJson != null
          ? jsonDecode(lastEpisodeToAirJson!)
          : null,
      TmdbTitleFields.images:
          imagesJson != null ? jsonDecode(imagesJson!) : null,
      TmdbTitleFields.videos:
          videosJson != null ? jsonDecode(videosJson!) : null,
      TmdbTitleFields.omdbRatings:
          omdbRatingsJson != null ? jsonDecode(omdbRatingsJson!) : null,
      TmdbTitleFields.character: character,
      TmdbTitleFields.job: job,
      TmdbTitleFields.department: department,
    };
  }

  bool get isMovie => name.isEmpty
      ? (mediaType == ApiConstants.movie)
      : (mediaType == ApiConstants.movie ||
          (mediaType.isEmpty && name.isNotEmpty && originalName.isNotEmpty));

  bool get isSerie => mediaType == ApiConstants.tv;

  bool get isSeenOnly => rating == AppConstants.seenRating;
  bool get isRated => rating > AppConstants.seenRating;
  bool get hasRating => rating > 0.0;

  bool get isOnAir =>
      status == TvShowStatus.returning ||
      status == TvShowStatus.inProduction ||
      status == TvShowStatus.planned;

  bool get isMiniSerie =>
      firstAirDate.isNotEmpty &&
      lastAirDate.isNotEmpty &&
      firstAirDate.substring(0, 4) == lastAirDate.substring(0, 4);

  String get posterPath =>
      posterPathSuffix != null && posterPathSuffix!.isNotEmpty
          ? 'https://image.tmdb.org/t/p/original$posterPathSuffix'
          : '';

  String get backdropPath =>
      backdropPathSuffix != null && backdropPathSuffix!.isNotEmpty
          ? 'https://image.tmdb.org/t/p/original$backdropPathSuffix'
          : '';

  @ignore
  List<TmdbGenre> get genres => TmdbGenreService().getGenresFromIds(genreIds);

  void updateRating(double value) {
    rating = value;
    dateRated = DateTime.now();
  }

  @ignore
  List? _recommendationsCache;

  @ignore
  List get recommendations {
    if (_recommendationsCache != null) return _recommendationsCache!;
    if (_recommendationsCache == null) return [];
    _recommendationsCache = jsonDecode(recommendationsJson!) as List;
    return _recommendationsCache!;
  }

  @ignore
  Map<String, dynamic>? _nextEpisodeToAirCache;

  @ignore
  Map<String, dynamic>? get nextEpisodeToAir {
    if (_nextEpisodeToAirCache != null) return _nextEpisodeToAirCache;
    if (nextEpisodeToAirJson == null) return null;
    _nextEpisodeToAirCache =
        jsonDecode(nextEpisodeToAirJson!) as Map<String, dynamic>;
    return _nextEpisodeToAirCache;
  }

  @ignore
  Map<String, dynamic>? _lastEpisodeToAirCache;

  @ignore
  Map<String, dynamic>? get lastEpisodeToAir {
    if (_lastEpisodeToAirCache != null) return _lastEpisodeToAirCache;
    if (lastEpisodeToAirJson == null) return null;
    _lastEpisodeToAirCache =
        jsonDecode(lastEpisodeToAirJson!) as Map<String, dynamic>;
    return _lastEpisodeToAirCache;
  }

  @ignore
  String get nextEpisodeAirDate {
    return nextEpisodeToAir?[TmdbTitleFields.airDate] ?? '';
  }

  @ignore
  String get lastEpisodeAirDate {
    return lastEpisodeToAir?[TmdbTitleFields.airDate] ?? '';
  }

  @ignore
  TmdbProviders? _providersCache;

  @ignore
  TmdbProviders get providers {
    if (_providersCache != null) return _providersCache!;
    if (providersJson == null) return TmdbProviders(providers: {});
    _providersCache = TmdbProviders(providers: jsonDecode(providersJson!));
    return _providersCache!;
  }

  @ignore
  Map<String, dynamic>? _creditsMapCache;

  @ignore
  List<TmdbPerson>? _castCache;

  @ignore
  List<TmdbPerson> get cast {
    if (_castCache != null) return _castCache!;
    if (creditsJson == null) return [];
    _creditsMapCache ??= jsonDecode(creditsJson!);
    _castCache = TmdbPerson.parsePersonList(
        _creditsMapCache![PersonAttributes.cast] is List
            ? _creditsMapCache![PersonAttributes.cast]
            : null,
        PersonAttributes.cast);
    return _castCache!;
  }

  @ignore
  List<TmdbPerson>? _crewCache;

  @ignore
  List<TmdbPerson> get crew {
    if (_crewCache != null) return _crewCache!;
    if (creditsJson == null) return [];
    _creditsMapCache ??= jsonDecode(creditsJson!);
    _crewCache = TmdbPerson.parsePersonList(
        _creditsMapCache![PersonAttributes.crew] is List
            ? _creditsMapCache![PersonAttributes.crew]
            : null,
        PersonAttributes.crew);
    return _crewCache!;
  }

  @ignore
  String get duration {
    String duration = '';

    if (effectiveRuntime > 0) {
      if (mediaType == ApiConstants.movie) {
        int hours = (effectiveRuntime / 60).floor().toInt();
        int minutes = effectiveRuntime - hours * 60;
        if (hours > 0) duration = '${hours}h ';
        duration += '${minutes}m';
      } else {
        duration = '${effectiveRuntime}eps';
      }
    }
    return duration;
  }

  @ignore
  String get titleLink {
    if (mediaType == ApiConstants.movie) {
      return 'https://www.themoviedb.org/movie/$tmdbId';
    } else {
      return 'https://www.themoviedb.org/tv/$tmdbId';
    }
  }

  @ignore
  List<String>? _imagesCache;

  @ignore
  List<String> get images {
    if (_imagesCache != null) return _imagesCache!;
    if (imagesJson == null) return [];
    try {
      final decoded = jsonDecode(imagesJson!);
      if (decoded is List) {
        _imagesCache = decoded.map((e) => e.toString()).toList();
        return _imagesCache!;
      }
    } catch (_) {}
    return [];
  }

  @ignore
  List<Map<String, dynamic>>? _videosCache;

  @ignore
  List<Map<String, dynamic>> get videos {
    if (_videosCache != null) return _videosCache!;
    if (videosJson == null) return [];
    try {
      final decoded = jsonDecode(videosJson!);
      if (decoded is List) {
        _videosCache = decoded.map((e) => e as Map<String, dynamic>).toList();
        return _videosCache!;
      }
    } catch (_) {}
    return [];
  }

  set videos(List<Map<String, dynamic>> value) {
    videosJson = jsonEncode(value);
  }

  static void updateGenreIds(
      TmdbTitle title, dynamic genres, dynamic genreIdsList) {
    final ids = <int>[];
    if (genreIdsList is List) {
      ids.addAll(List<int>.from(genreIdsList));
    } else if (genres is List) {
      for (var genre in genres) {
        if (genre is Map && genre[TmdbTitleFields.id] != null) {
          ids.add(genre[TmdbTitleFields.id]);
        }
      }
    }
    if (ids.isNotEmpty) {
      title.genreIds = ids;
    }
  }

  static void updateProviderIds(TmdbTitle title, dynamic providers) {
    if (providers is Map) {
      final provs = TmdbProviders(providers: providers);
      title.flatrateProviderIds = provs.flatrate.map((p) => p.id).toList();
    }
  }
}
