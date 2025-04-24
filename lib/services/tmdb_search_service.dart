import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbSearch =
    '/search/multi?query={SEARCH}&page=1&language={LOCALE}';

const String _tmdbFindByID =
    '/find/{ID}?language={LOCALE}&external_source=imdb_id';

class TmdbSearchService extends TmdbBaseService {
  List<TmdbTitle> fromImdbIdToTitle(Map response) {
    List<TmdbTitle> titles = [];
    for (var key in response.keys) {
      if (key == 'movie_results') {
        for (var movie in response[key]) {
          titles.add(TmdbTitle(title: movie));
        }
      }
      if (key == 'tv_results') {
        for (var tv in response[key]) {
          titles.add(TmdbTitle(title: tv));
        }
      }
    }
    return titles;
  }

  Future<List<TmdbTitle>> _titlesList(Map response, Locale locale) async {
    List<TmdbTitle> titles = [];
    final totalResults = response['total_results'] ?? 0;

    for (int count = 0; count < totalResults && count < 10; count += 1) {
      Map title = response['results'][count];
      if (title['media_type'] != 'movie' && title['media_type'] != 'tv') {
        continue;
      }
      titles.add(TmdbTitle(title: response['results'][count]));
    }

    return titles;
  }

  Future<List<TmdbTitle>> searchTitle(
    String search,
    Locale locale,
  ) async {
    if (search.trim().isEmpty || search.trim().length < 3) {
      return [];
    }

    final result = await get(
      _tmdbSearch.replaceFirst('{SEARCH}', search).replaceFirst(
          '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );
    if (result.statusCode == 200) {
      return _titlesList(body(result), locale);
    }
    throw Exception(
        'Failed to search title. Response code: ${result.statusCode}');
  }

  Future<dynamic> searchImdbTitle(
    String imdbId,
    Locale locale,
  ) async {
    return get(
      _tmdbFindByID.replaceFirst('{ID}', imdbId).replaceFirst(
          '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );
  }
}
