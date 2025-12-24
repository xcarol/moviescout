import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:moviescout/utils/api_constants.dart';

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
  static const String cast = 'cast';

  // Custom
  static const String listName = 'list_name';
  static const String lastUpdated = 'last_updated';
  static const String mediaType = 'media_type';
  static const String providers = 'providers';
  static const String addedOrder = 'added_order';
}

const statusEnded = 'Ended';
const statusReturning = 'Returning Series';
const statusCanceled = 'Canceled';
const statusInProduction = 'In Production';
const statusPlanned = 'Planned';

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
class TmdbTitle {
  @Index(unique: true)
  Id id = Isar.autoIncrement;

  @Index()
  late int tmdbId;

  @Index()
  late String listName;

  late String name;
  late String originalName;
  late String originalLanguage;
  late String overview;
  late String tagline;
  late String status;
  late String mediaType;
  late String imdbId;

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

  TmdbTitle({
    required this.id,
    required this.tmdbId,
    required this.listName,
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
    required this.addedOrder,
    this.genreIds = const [],
    this.flatrateProviderIds = const [],
    this.originCountry = const [],
    this.creditsJson,
    this.providersJson,
    this.seasonsJson,
    this.recommendationsJson,
    this.nextEpisodeToAirJson,
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
    final mediaType = title[TmdbTitleFields.mediaType] ?? ApiConstants.movie;

    final releaseDate = title[TmdbTitleFields.releaseDate] ?? '';
    final firstAirDate = title[TmdbTitleFields.firstAirDate] ?? '';
    final runtime = title[TmdbTitleFields.runtime] ?? 0;
    final numberOfEpisodes = title[TmdbTitleFields.numberOfEpisodes] ?? 0;

    final effectiveReleaseDate =
        mediaType == ApiConstants.movie ? releaseDate : firstAirDate;
    final effectiveRuntime =
        mediaType == ApiConstants.movie ? runtime : numberOfEpisodes;

    final titleObj = TmdbTitle(
      id: Isar.autoIncrement,
      tmdbId: title[TmdbTitleFields.id] ?? 0,
      listName: title[TmdbTitleFields.listName] ?? '',
      name: title[TmdbTitleFields.name] ?? title[TmdbTitleFields.title] ?? '',
      originalName: title[TmdbTitleFields.originalName] ??
          title[TmdbTitleFields.originalTitle] ??
          '',
      originalLanguage: title[TmdbTitleFields.originalLanguage] ?? '',
      overview: title[TmdbTitleFields.overview] ?? '',
      tagline: title[TmdbTitleFields.tagline] ?? '',
      status: title[TmdbTitleFields.status] ?? '',
      mediaType: mediaType,
      imdbId: title[TmdbTitleFields.imdbId] ?? '',
      posterPathSuffix: title[TmdbTitleFields.posterPath],
      backdropPathSuffix: title[TmdbTitleFields.backdropPath],
      releaseDate: releaseDate,
      firstAirDate: firstAirDate,
      lastAirDate: title[TmdbTitleFields.lastAirDate] ?? '',
      lastUpdated: title[TmdbTitleFields.lastUpdated] ?? '1970-01-01',
      voteAverage: (title[TmdbTitleFields.voteAverage] ?? 0).toDouble(),
      voteCount: title[TmdbTitleFields.voteCount] ?? 0,
      rating: title[TmdbTitleFields.accountRating] is Map
          ? (title[TmdbTitleFields.accountRating]
                      [TmdbTitleFields.accountRatingValue] ??
                  0.0)
              .toDouble()
          : 0.0,
      dateRated: title[TmdbTitleFields.accountRating] is Map &&
              title[TmdbTitleFields.accountRating]
                      [TmdbTitleFields.accountRatingDate] !=
                  null
          ? DateTime.parse(title[TmdbTitleFields.accountRating]
              [TmdbTitleFields.accountRatingDate])
          : DateTime.fromMillisecondsSinceEpoch(0),
      runtime: runtime,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: title[TmdbTitleFields.numberOfSeasons] ?? 0,
      popularity: (title[TmdbTitleFields.popularity] ?? 0).toDouble(),
      budget: title[TmdbTitleFields.budget] ?? 0,
      revenue: title[TmdbTitleFields.revenue] ?? 0,
      effectiveRuntime: effectiveRuntime,
      effectiveReleaseDate: effectiveReleaseDate,
      addedOrder: title[TmdbTitleFields.addedOrder] ?? 0,
      genreIds: [],
      flatrateProviderIds: [],
      originCountry: title[TmdbTitleFields.originCountry] is List
          ? List<String>.from(title[TmdbTitleFields.originCountry])
          : [],
      creditsJson: title[TmdbTitleFields.credits] != null
          ? jsonEncode(title[TmdbTitleFields.credits])
          : null,
      providersJson: title[TmdbTitleFields.providers] != null
          ? jsonEncode(title[TmdbTitleFields.providers])
          : null,
      seasonsJson: title[TmdbTitleFields.seasons] != null
          ? jsonEncode(title[TmdbTitleFields.seasons])
          : null,
      recommendationsJson: title[TmdbTitleFields.recommendations] != null
          ? jsonEncode(title[TmdbTitleFields.recommendations])
          : null,
      nextEpisodeToAirJson: title[TmdbTitleFields.nextEpisodeToAir] != null
          ? jsonEncode(title[TmdbTitleFields.nextEpisodeToAir])
          : null,
    );

    updateGenreIds(titleObj, title[TmdbTitleFields.genres],
        title[TmdbTitleFields.genreIds]);
    updateProviderIds(titleObj, title[TmdbTitleFields.providers]);

    return titleObj;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTitle && tmdbId == other.tmdbId;

  @override
  int get hashCode => tmdbId.hashCode;

  void copyFrom(TmdbTitle other) {
    name = other.name;
    originalName = other.originalName;
    overview = other.overview;
    rating = other.rating;
    voteAverage = other.voteAverage;
    posterPathSuffix = other.posterPathSuffix;
    backdropPathSuffix = other.backdropPathSuffix;
    lastUpdated = other.lastUpdated;
    genreIds = List<int>.from(other.genreIds);
    flatrateProviderIds = List<int>.from(other.flatrateProviderIds);
    creditsJson = other.creditsJson;
    providersJson = other.providersJson;
    seasonsJson = other.seasonsJson;
    recommendationsJson = other.recommendationsJson;
  }

  bool get isMovie => name.isEmpty
      ? (mediaType == ApiConstants.movie)
      : (mediaType == ApiConstants.movie ||
          (mediaType.isEmpty && name.isNotEmpty && originalName.isNotEmpty));

  bool get isSerie => mediaType == ApiConstants.tv;

  bool get isOnAir => status == statusInProduction || status == statusPlanned;

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
  List get recommendations {
    if (recommendationsJson != null) {
      return jsonDecode(recommendationsJson!) as List;
    }
    return [];
  }

  @ignore
  String get nextEpisodeToAir {
    if (nextEpisodeToAirJson == null) return '';
    final map = jsonDecode(nextEpisodeToAirJson!);
    return map[TmdbTitleFields.airDate] ?? '';
  }

  @ignore
  TmdbProviders get providers {
    if (providersJson == null) return TmdbProviders(providers: {});
    return TmdbProviders(providers: jsonDecode(providersJson!));
  }

  @ignore
  List<TmdbPerson> get cast {
    if (creditsJson == null) return [];

    final creditsMap = jsonDecode(creditsJson!);
    if (creditsMap[TmdbTitleFields.cast] is! List) return [];

    List<TmdbPerson> castPeople = [];
    for (dynamic person in creditsMap[TmdbTitleFields.cast]) {
      castPeople.add(TmdbPerson(
        tmdbJson: jsonEncode(person), // legacy TmdbPerson still uses json
        tmdbId: person[PersonAttributes.id],
        name: person[PersonAttributes.name],
        lastUpdated: '1970-01-01',
        knownForDepartment: person[PersonAttributes.known_for_department],
        gender: person[PersonAttributes.gender],
        originalName: person[PersonAttributes.original_name],
        profilePath: person[PersonAttributes.profile_path] ?? '',
        character: person[PersonAttributes.character],
        biography: person[PersonAttributes.biography] ?? '',
        birthday: person[PersonAttributes.birthday] ?? '',
        deathday: person[PersonAttributes.deathday] ?? '',
        imdbId: person[PersonAttributes.imdb_id] ?? '',
        placeOfBirth: person[PersonAttributes.place_of_birth] ?? '',
        combinedCredits: CombinedCredits.fromMap(
            person[PersonAttributes.combined_credits] ?? {}),
        homepage: person[PersonAttributes.homepage] ?? '',
      ));
    }
    return castPeople;
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

  void mergeFromMap(Map<String, dynamic> data) {
    if (data[TmdbTitleFields.posterPath] != null) {
      posterPathSuffix = data[TmdbTitleFields.posterPath];
    }
    if (data[TmdbTitleFields.backdropPath] != null) {
      backdropPathSuffix = data[TmdbTitleFields.backdropPath];
    }

    if (data[TmdbTitleFields.name] != null) {
      name = data[TmdbTitleFields.name];
    } else if (data[TmdbTitleFields.title] != null) {
      name = data[TmdbTitleFields.title];
    }

    if (data[TmdbTitleFields.originalName] != null) {
      originalName = data[TmdbTitleFields.originalName];
    } else if (data[TmdbTitleFields.originalTitle] != null) {
      originalName = data[TmdbTitleFields.originalTitle];
    }

    if (data[TmdbTitleFields.runtime] != null) {
      runtime = data[TmdbTitleFields.runtime];
    }
    if (data[TmdbTitleFields.overview] != null &&
        (data[TmdbTitleFields.overview] as String).isNotEmpty) {
      overview = data[TmdbTitleFields.overview];
    }
    if (data[TmdbTitleFields.tagline] != null) {
      tagline = data[TmdbTitleFields.tagline];
    }
    if (data[TmdbTitleFields.status] != null) {
      status = data[TmdbTitleFields.status];
    }
    if (data[TmdbTitleFields.imdbId] != null) {
      imdbId = data[TmdbTitleFields.imdbId];
    }

    if (data[TmdbTitleFields.releaseDate] != null) {
      releaseDate = data[TmdbTitleFields.releaseDate];
    }
    if (data[TmdbTitleFields.firstAirDate] != null) {
      firstAirDate = data[TmdbTitleFields.firstAirDate];
    }
    if (data[TmdbTitleFields.lastAirDate] != null) {
      lastAirDate = data[TmdbTitleFields.lastAirDate];
    }

    if (data[TmdbTitleFields.voteAverage] != null) {
      voteAverage = (data[TmdbTitleFields.voteAverage] as num).toDouble();
    }
    if (data[TmdbTitleFields.voteCount] != null) {
      voteCount = data[TmdbTitleFields.voteCount];
    }
    if (data[TmdbTitleFields.popularity] != null) {
      popularity = (data[TmdbTitleFields.popularity] as num).toDouble();
    }
    if (data[TmdbTitleFields.budget] != null) {
      budget = data[TmdbTitleFields.budget];
    }
    if (data[TmdbTitleFields.revenue] != null) {
      revenue = data[TmdbTitleFields.revenue];
    }
    if (data[TmdbTitleFields.numberOfEpisodes] != null) {
      numberOfEpisodes = data[TmdbTitleFields.numberOfEpisodes];
    }
    if (data[TmdbTitleFields.numberOfSeasons] != null) {
      numberOfSeasons = data[TmdbTitleFields.numberOfSeasons];
    }

    if (data[TmdbTitleFields.mediaType] != null) {
      mediaType = data[TmdbTitleFields.mediaType];
    }
    if (data[TmdbTitleFields.originCountry] is List) {
      originCountry = List<String>.from(data[TmdbTitleFields.originCountry]);
    }

    if (effectiveReleaseDate.isEmpty) {
      effectiveReleaseDate =
          mediaType == ApiConstants.movie ? releaseDate : firstAirDate;
    }
    if (effectiveRuntime == 0) {
      effectiveRuntime =
          mediaType == ApiConstants.movie ? runtime : numberOfEpisodes;
    }

    if (data[TmdbTitleFields.credits] != null) {
      creditsJson = jsonEncode(data[TmdbTitleFields.credits]);
    }

    if (data['providers'] != null) {
      providersJson = jsonEncode(data['providers']);
    } else if (data[TmdbTitleFields.providers] != null) {
      providersJson = jsonEncode(data[TmdbTitleFields.providers]);
    }

    if (data[TmdbTitleFields.seasons] != null) {
      seasonsJson = jsonEncode(data[TmdbTitleFields.seasons]);
    }
    if (data[TmdbTitleFields.recommendations] != null) {
      recommendationsJson = jsonEncode(data[TmdbTitleFields.recommendations]);
    }
    if (data[TmdbTitleFields.nextEpisodeToAir] != null) {
      nextEpisodeToAirJson = jsonEncode(data[TmdbTitleFields.nextEpisodeToAir]);
    }

    updateGenreIds(
        this, data[TmdbTitleFields.genres], data[TmdbTitleFields.genreIds]);
    updateProviderIds(
        this, data['providers'] ?? data[TmdbTitleFields.providers]);

    lastUpdated = DateTime.now().toIso8601String();
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

  Map<String, dynamic> toMap() {
    return {
      TmdbTitleFields.id: tmdbId,
      TmdbTitleFields.listName: listName,
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
      TmdbTitleFields.addedOrder: addedOrder,
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
    };
  }
}
