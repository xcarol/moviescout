// ignore_for_file: constant_identifier_names, unused_element

import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_providers.dart';

const _adult = 'adult';
const _backdrop_path = 'backdrop_path';
const _belongs_to_collection = 'belongs_to_collection';
const _budget = 'budget';
const _genres = 'genres';
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
const _last_updated = 'last_updated';
const _media_type = 'media_type';
const _providers = 'providers';

class TmdbTitle {
  final Map _tmdbTitle;
  const TmdbTitle({required Map<dynamic, dynamic> title}) : _tmdbTitle = title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTitle && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map get map {
    return _tmdbTitle;
  }

  bool get isMovie {
    return _tmdbTitle[_title] != null;
  }

  bool get isSerie {
    return _tmdbTitle[_name] != null;
  }

  int get id {
    return _tmdbTitle[_id] ?? 0;
  }

  String get name {
    return _tmdbTitle[_name] ?? _tmdbTitle[_title] ?? '';
  }

  String get lastUpdated {
    return _tmdbTitle[_last_updated] ?? '1970-01-01';
  }

  set lastUpdated(String date) {
    _tmdbTitle[_last_updated] = date;
  }

  String get mediaType {
    return _tmdbTitle[_media_type] ?? '';
  }

  String get posterPath {
    return _tmdbTitle[_poster_path] != null &&
            (_tmdbTitle[_poster_path] as String).isNotEmpty
        ? 'https://image.tmdb.org/t/p/original${_tmdbTitle[_poster_path]}'
        : '';
  }

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

  List get genres {
    List genresList = List.empty(growable: true);

    for (var genre in _tmdbTitle[_genres]) {
      genresList.add(TmdbGenre(genre: genre));
    }

    return genresList;
  }

  String get releaseDate {
    return _tmdbTitle[_release_date] ?? '';
  }

  double get rating {
    return _tmdbTitle[_rating] ?? 0;
  }

  set rating(double rate) {
    _tmdbTitle[_rating] = rate;
  }

  String get firstAirDate {
    return _tmdbTitle[_first_air_date] ?? '';
  }

  String get lastAirDate {
    return _tmdbTitle[_last_air_date] ?? '';
  }

  String get nextEpisodeToAir {
    if (_tmdbTitle[_next_episode_to_air] == null) {
      return '';
    }
    return _tmdbTitle[_next_episode_to_air][_air_date] ?? '';
  }

  String get overview {
    return _tmdbTitle[_overview] ?? '';
  }

  TmdbProviders get providers {
    return TmdbProviders(providers: _tmdbTitle[_providers] ?? {});
  }

  int get runtime {
    return _tmdbTitle[_runtime] ?? 0;
  }

  int get numberOfEpisodes {
    return _tmdbTitle[_number_of_episodes] ?? 0;
  }

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
}
