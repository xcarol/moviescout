import 'dart:convert';
import 'package:isar/isar.dart';

// ignore_for_file: constant_identifier_names, unused_element

import 'package:moviescout/models/tmdb_genre.dart';
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

// Custom
const _listName = 'list_name';
const _last_updated = 'last_updated';
const _media_type = 'media_type';
const _providers = 'providers';

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
}

@collection
class TmdbTitle {
  @Index(unique: true)
  Id id = Isar.autoIncrement;

  @ignore
  Map<String, dynamic>? _tmdbMapCache;

  @Index()
  late int tmdbId;

  @Index()
  late String listName;

  late String tmdbJson;
  late String name;
  late String lastUpdated;
  late double rating;
  late int effectiveRuntime;
  late String effectiveReleaseDate;
  late List<int> genreIds;
  late List<int> flatrateProviderIds;

  TmdbTitle({
    required this.id,
    required this.tmdbJson,
    required this.tmdbId,
    required this.listName,
    required this.name,
    required this.rating,
    required this.lastUpdated,
  })  : genreIds = <int>[],
        flatrateProviderIds = <int>[] {
    effectiveReleaseDate = mediaType == 'movie' ? releaseDate : firstAirDate;
    effectiveRuntime = mediaType == 'movie' ? runtime : numberOfEpisodes;
    _populateGenreIds();
    _populateFlatrateProviderIds();
  }

  factory TmdbTitle.fromMap({required Map<dynamic, dynamic> title}) {
    return TmdbTitle(
      id: Isar.autoIncrement,
      tmdbJson: jsonEncode(title),
      tmdbId: title[_id] ?? 0,
      listName: title[_listName] ?? '',
      name: title[_name] ?? title[_title] ?? '',
      rating: title[_account_rating] is Map
          ? title[_account_rating][_account_rating_value] ?? 0.0
          : 0.0,
      lastUpdated: title[_last_updated] ?? '1970-01-01',
    );
  }

  void _populateGenreIds() {
    genreIds = <int>[];

    if (_tmdbTitle[_genres] is List) {
      for (var genre in _tmdbTitle[_genres]) {
        if (genre[_id] != null &&
            !(_tmdbTitle[_genre_ids] as List).contains(genre[_id])) {
          (_tmdbTitle[_genre_ids] as List).add(genre[_id]);
        }
      }
    }

    genreIds = List.from(_tmdbTitle[_genre_ids] ?? []);
  }

  void _populateFlatrateProviderIds() {
    flatrateProviderIds = <int>[];

    for (var provider
        in TmdbProviders(providers: _tmdbTitle[_providers] ?? {}).flatrate) {
      if (!flatrateProviderIds.contains(provider.id)) {
        flatrateProviderIds.add(provider.id);
      }
    }
  }

  Map<String, dynamic> get _tmdbTitle {
    return _tmdbMapCache ??= jsonDecode(tmdbJson);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTitle && tmdbId == other.tmdbId;

  @override
  int get hashCode => tmdbId.hashCode;

  void copyFrom(TmdbTitle other) {
    tmdbJson = other.tmdbJson;
  }

  @ignore
  Map get map {
    return _tmdbTitle;
  }

  bool get isMovie {
    return _tmdbTitle[_title] != null;
  }

  @ignore
  bool get isSerie {
    return _tmdbTitle[_name] != null;
  }

  @ignore
  String get status {
    return _tmdbTitle[_status] ?? '';
  }

  @ignore
  String get tagline {
    return _tmdbTitle[_tagline] ?? '';
  }

  String get mediaType {
    return _tmdbTitle[_media_type] ?? '';
  }

  @ignore
  String get originalName {
    return _tmdbTitle[_original_name] ?? _tmdbTitle[_original_title] ?? '';
  }

  @ignore
  String get originalLanguage {
    return _tmdbTitle[_original_language] ?? '';
  }

  @ignore
  String get originCountry {
    return _tmdbTitle[_origin_country] != null &&
            _tmdbTitle[_origin_country] is List &&
            (_tmdbTitle[_origin_country] as List).isNotEmpty
        ? _tmdbTitle[_origin_country][0]
        : '';
  }

  @ignore
  String get posterPath {
    return _tmdbTitle[_poster_path] != null &&
            (_tmdbTitle[_poster_path] as String).isNotEmpty
        ? 'https://image.tmdb.org/t/p/original${_tmdbTitle[_poster_path]}'
        : '';
  }

  @ignore
  String get backdropPath {
    if (_tmdbTitle[_backdrop_path] != null) {
      return (_tmdbTitle[_backdrop_path] as String).isNotEmpty
          ? 'https://image.tmdb.org/t/p/original${_tmdbTitle[_backdrop_path]}'
          : '';
    }

    return '';
  }

  double get voteAverage {
    return _tmdbTitle[_vote_average] ?? 0.0;
  }

  @ignore
  List<TmdbGenre> get genres {
    return TmdbGenreService().getGenresFromIds(genreIds);
  }

  @ignore
  String get releaseDate {
    return _tmdbTitle[_release_date] ?? '';
  }

  void updateRating(double value) {
    final map = _tmdbTitle;

    map[_account_rating] = {
      _account_rating_date: DateTime.now().toIso8601String(),
      _account_rating_value: value
    };

    rating = value;

    tmdbJson = jsonEncode(map);
    _tmdbMapCache = map;
  }

  @ignore
  List get recommendations {
    if (_tmdbTitle[_recommendations] is List) {
      return _tmdbTitle[_recommendations];
    }
    return [];
  }

  @ignore
  bool get isOnAir {
    if (_tmdbTitle[_status] == null) {
      return false;
    }
    return _tmdbTitle[_status] == statusInProduction ||
        _tmdbTitle[_status] == statusPlanned;
  }

  @ignore
  String get firstAirDate {
    return _tmdbTitle[_first_air_date] ?? '';
  }

  @ignore
  String get lastAirDate {
    return _tmdbTitle[_last_air_date] ?? '';
  }

  @ignore
  String get nextEpisodeToAir {
    if (_tmdbTitle[_next_episode_to_air] == null) {
      return '';
    }
    return _tmdbTitle[_next_episode_to_air][_air_date] ?? '';
  }

  @ignore
  String get overview {
    return _tmdbTitle[_overview] ?? '';
  }

  @ignore
  TmdbProviders get providers {
    return TmdbProviders(providers: _tmdbTitle[_providers] ?? {});
  }

  @ignore
  int get runtime {
    return _tmdbTitle[_runtime] ?? 0;
  }

  @ignore
  int get numberOfEpisodes {
    return _tmdbTitle[_number_of_episodes] ?? 0;
  }

  @ignore
  String get duration {
    String duration = '';

    if (isMovie && runtime > 0) {
      int hours = (runtime / 60).floor().toInt();
      int minutes = runtime - hours * 60;
      if (hours > 0) {
        duration = '${hours}h ';
      }
      duration += '${minutes}m';
    } else if (isSerie && numberOfEpisodes > 0) {
      duration = '${numberOfEpisodes}eps';
    }

    return duration;
  }

  @ignore
  String get imdbId {
    return _tmdbTitle[_imdb_id] ?? '';
  }
}
