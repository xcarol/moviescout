import 'dart:convert';
import 'package:isar/isar.dart';

// ignore_for_file: constant_identifier_names, unused_element

import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_providers.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';

part 'tmdb_title.g.dart';

const _adult = 'adult';
const _backdrop_path = 'backdrop_path';
const _belongs_to_collection = 'belongs_to_collection';
const _budget = 'budget';
const _genres = 'genres';
const _genre_ids = 'genre_ids';
const _homepage = 'homepage';
const _id = 'id';
const _imdb_id = 'imdb_id';
const _origin_country = 'origin_country';
const _original_language = 'original_language';
const _original_title = 'original_title';
const _overview = 'overview';
const _popularity = 'popularity';
const _poster_path = 'poster_path';
const _production_companies = 'production_companies';
const _production_countries = 'production_countries';
const _release_date = 'release_date';
const _rating = 'rating';
const _recommendations = 'recommendations';
const _account_rating = 'account_rating';
const _account_rating_date = 'created_at';
const _account_rating_value = 'value';
const _revenue = 'revenue';
const _runtime = 'runtime';
const _spoken_languages = 'spoken_languages';
const _status = 'status';
const _tagline = 'tagline';
const _title = 'title';
const _video = 'video';
const _vote_average = 'vote_average';
const _vote_count = 'vote_count';

// Only in tv series
const _created_by = 'created_by';
const _episode_run_time = 'episode_run_time';
const _first_air_date = 'first_air_date';
const _in_production = 'in_production';
const _languages = 'languages';
const _last_air_date = 'last_air_date';
const _last_episode_to_air = 'last_episode_to_air';
const _name = 'name';
const _next_episode_to_air = 'next_episode_to_air';
const _air_date = 'air_date';
const _networks = 'networks';
const _number_of_episodes = 'number_of_episodes';
const _number_of_seasons = 'number_of_seasons';
const _original_name = 'original_name';
const _seasons = 'seasons';
const _type = 'type';

// People
const _credits = 'credits';
const _cast = 'cast';

// Custom
const _listName = 'list_name';
const _last_updated = 'last_updated';
const _media_type = 'media_type';
const _providers = 'providers';
const _added_order = 'added_order';

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

  // Complex objects stored as JSON strings for now to preserve structure without full embedded migration
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
    // Fallback logic if not set during init (though fromMap should handle it)
    if (effectiveReleaseDate.isEmpty) {
      effectiveReleaseDate = mediaType == 'movie' ? releaseDate : firstAirDate;
    }
    if (effectiveRuntime == 0) {
      effectiveRuntime = mediaType == 'movie' ? runtime : numberOfEpisodes;
    }
  }

  factory TmdbTitle.fromMap({required Map<dynamic, dynamic> title}) {
    final mediaType = title[_media_type] ??
        'movie'; // Default to movie if unknown? Or check structure

    final releaseDate = title[_release_date] ?? '';
    final firstAirDate = title[_first_air_date] ?? '';
    final runtime = title[_runtime] ?? 0;
    final numberOfEpisodes = title[_number_of_episodes] ?? 0;

    final effectiveReleaseDate =
        mediaType == 'movie' ? releaseDate : firstAirDate;
    final effectiveRuntime = mediaType == 'movie' ? runtime : numberOfEpisodes;

    final genreIds = <int>[];
    if (title[_genres] is List) {
      for (var genre in title[_genres]) {
        if (genre[_id] != null) {
          // We could also populate a secondary list if we don't trust genre_ids key
        }
      }
    }
    // Prefer the explicit genre_ids list if available
    if (title[_genre_ids] != null) {
      genreIds.addAll(List<int>.from(title[_genre_ids]));
    } else if (title[_genres] is List) {
      // Extract from object list
      for (var genre in title[_genres]) {
        if (genre is Map && genre[_id] != null) genreIds.add(genre[_id]);
      }
    }

    // Providers logic
    final providersJson =
        title[_providers] != null ? jsonEncode(title[_providers]) : null;
    final flatrateProviderIds = <int>[];
    if (title[_providers] != null) {
      final provs = TmdbProviders(providers: title[_providers]);
      for (var p in provs.flatrate) {
        flatrateProviderIds.add(p.id);
      }
    }

    return TmdbTitle(
      id: Isar.autoIncrement,
      tmdbId: title[_id] ?? 0,
      listName: title[_listName] ?? '',
      name: title[_name] ?? title[_title] ?? '',
      originalName: title[_original_name] ?? title[_original_title] ?? '',
      originalLanguage: title[_original_language] ?? '',
      overview: title[_overview] ?? '',
      tagline: title[_tagline] ?? '',
      status: title[_status] ?? '',
      mediaType: mediaType,
      imdbId: title[_imdb_id] ?? '',
      posterPathSuffix: title[_poster_path],
      backdropPathSuffix: title[_backdrop_path],
      releaseDate: releaseDate,
      firstAirDate: firstAirDate,
      lastAirDate: title[_last_air_date] ?? '',
      lastUpdated: title[_last_updated] ?? '1970-01-01',
      voteAverage: (title[_vote_average] ?? 0).toDouble(),
      voteCount: title[_vote_count] ?? 0,
      rating: title[_account_rating] is Map
          ? (title[_account_rating][_account_rating_value] ?? 0.0).toDouble()
          : 0.0,
      dateRated: title[_account_rating] is Map &&
              title[_account_rating][_account_rating_date] != null
          ? DateTime.parse(title[_account_rating][_account_rating_date])
          : DateTime.fromMillisecondsSinceEpoch(0),
      runtime: runtime,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: title[_number_of_seasons] ?? 0,
      popularity: (title[_popularity] ?? 0).toDouble(),
      budget: title[_budget] ?? 0,
      revenue: title[_revenue] ?? 0,
      effectiveRuntime: effectiveRuntime,
      effectiveReleaseDate: effectiveReleaseDate,
      addedOrder: title[_added_order] ?? 0,
      genreIds: genreIds,
      flatrateProviderIds: flatrateProviderIds,
      originCountry: title[_origin_country] is List
          ? List<String>.from(title[_origin_country])
          : [],
      creditsJson: title[_credits] != null ? jsonEncode(title[_credits]) : null,
      providersJson: providersJson,
      seasonsJson: title[_seasons] != null ? jsonEncode(title[_seasons]) : null,
      recommendationsJson: title[_recommendations] != null
          ? jsonEncode(title[_recommendations])
          : null,
      nextEpisodeToAirJson: title[_next_episode_to_air] != null
          ? jsonEncode(title[_next_episode_to_air])
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTitle && tmdbId == other.tmdbId;

  @override
  int get hashCode => tmdbId.hashCode;

  void copyFrom(TmdbTitle other) {
    // Manually updating fields from another instance
    name = other.name;
    originalName = other.originalName;
    overview = other.overview;
    rating = other.rating;
    voteAverage = other.voteAverage;
    posterPathSuffix = other.posterPathSuffix;
    backdropPathSuffix = other.backdropPathSuffix;
    // ... complete copy logic if needed for mutable updates in place
    // But ideally we replace the object in Isar.
    // For now, minimal set:
    lastUpdated = other.lastUpdated;
    creditsJson = other.creditsJson;
    providersJson = other.providersJson;
    seasonsJson = other.seasonsJson;
    recommendationsJson = other.recommendationsJson;
  }

  // Getters that format or retrieve from internal fields

  bool get isMovie => name.isEmpty
      ? (mediaType == 'movie')
      : (mediaType == 'movie' ||
          (mediaType.isEmpty &&
              name.isNotEmpty &&
              originalName.isNotEmpty)); // Fallback logic might be simpler
  // Simplified:
  // bool get isMovie => mediaType == 'movie'; // Assuming mediaType is always correctly set by fromMap

  bool get isSerie => mediaType == 'tv';

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
    // No longer updating tmdbJson
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
    return map[_air_date] ?? '';
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
    if (creditsMap[_cast] is! List) return [];

    List<TmdbPerson> castPeople = [];
    for (dynamic person in creditsMap[_cast]) {
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
      // Using pre-calculated
      if (mediaType == 'movie') {
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

  void mergeFromMap(Map<String, dynamic> data) {
    if (data[_poster_path] != null) {
      posterPathSuffix = data[_poster_path];
    }
    if (data[_backdrop_path] != null) {
      backdropPathSuffix = data[_backdrop_path];
    }

    if (data[_name] != null) {
      name = data[_name];
    } else if (data[_title] != null) {
      name = data[_title];
    }

    if (data[_original_name] != null) {
      originalName = data[_original_name];
    } else if (data[_original_title] != null) {
      originalName = data[_original_title];
    }

    if (data[_runtime] != null) {
      runtime = data[_runtime];
    }
    if (data[_overview] != null && (data[_overview] as String).isNotEmpty) {
      overview = data[_overview];
    }
    if (data[_tagline] != null) {
      tagline = data[_tagline];
    }
    if (data[_status] != null) {
      status = data[_status];
    }
    if (data[_imdb_id] != null) {
      imdbId = data[_imdb_id];
    }

    if (data[_release_date] != null) {
      releaseDate = data[_release_date];
    }
    if (data[_first_air_date] != null) {
      firstAirDate = data[_first_air_date];
    }
    if (data[_last_air_date] != null) {
      lastAirDate = data[_last_air_date];
    }

    if (data[_vote_average] != null) {
      voteAverage = (data[_vote_average] as num).toDouble();
    }
    if (data[_vote_count] != null) {
      voteCount = data[_vote_count];
    }
    if (data[_popularity] != null) {
      popularity = (data[_popularity] as num).toDouble();
    }
    if (data[_budget] != null) {
      budget = data[_budget];
    }
    if (data[_revenue] != null) {
      revenue = data[_revenue];
    }
    if (data[_number_of_episodes] != null) {
      numberOfEpisodes = data[_number_of_episodes];
    }
    if (data[_number_of_seasons] != null) {
      numberOfSeasons = data[_number_of_seasons];
    }

    if (data[_media_type] != null) {
      mediaType = data[_media_type];
    }
    if (data[_origin_country] is List) {
      originCountry = List<String>.from(data[_origin_country]);
    }

    if (effectiveReleaseDate.isEmpty) {
      effectiveReleaseDate = mediaType == 'movie' ? releaseDate : firstAirDate;
    }
    if (effectiveRuntime == 0) {
      effectiveRuntime = mediaType == 'movie' ? runtime : numberOfEpisodes;
    }

    if (data[_credits] != null) {
      creditsJson = jsonEncode(data[_credits]);
    }

    // Handle pre-processed providers key
    if (data['providers'] != null) {
      providersJson = jsonEncode(data['providers']);
    } else if (data[_providers] != null) {
      providersJson = jsonEncode(data[_providers]);
    }

    if (data[_seasons] != null) {
      seasonsJson = jsonEncode(data[_seasons]);
    }
    if (data[_recommendations] != null) {
      recommendationsJson = jsonEncode(data[_recommendations]);
    }
    if (data[_next_episode_to_air] != null) {
      nextEpisodeToAirJson = jsonEncode(data[_next_episode_to_air]);
    }

    lastUpdated = DateTime.now().toIso8601String();
  }

  @ignore
  // Map<String, dynamic> get map => toMap();

  Map<String, dynamic> toMap() {
    return {
      _id: tmdbId,
      _listName: listName,
      _name: name,
      _title: name,
      _original_name: originalName,
      _original_title: originalName,
      _original_language: originalLanguage,
      _overview: overview,
      _tagline: tagline,
      _status: status,
      _media_type: mediaType,
      _imdb_id: imdbId,
      _poster_path: posterPathSuffix,
      _backdrop_path: backdropPathSuffix,
      _release_date: releaseDate,
      _first_air_date: firstAirDate,
      _last_air_date: lastAirDate,
      _last_updated: lastUpdated,
      _vote_average: voteAverage,
      _vote_count: voteCount,
      _account_rating: {
        _account_rating_value: rating,
        _account_rating_date: dateRated.toIso8601String(),
      },
      _runtime: runtime,
      _number_of_episodes: numberOfEpisodes,
      _number_of_seasons: numberOfSeasons,
      _popularity: popularity,
      _budget: budget,
      _revenue: revenue,
      _added_order: addedOrder,
      _genre_ids: genreIds,
      _origin_country: originCountry,
      _credits: creditsJson != null ? jsonDecode(creditsJson!) : null,
      _providers: providersJson != null ? jsonDecode(providersJson!) : null,
      _seasons: seasonsJson != null ? jsonDecode(seasonsJson!) : null,
      _recommendations:
          recommendationsJson != null ? jsonDecode(recommendationsJson!) : null,
      _next_episode_to_air: nextEpisodeToAirJson != null
          ? jsonDecode(nextEpisodeToAirJson!)
          : null,
    };
  }
}
