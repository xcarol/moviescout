import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbSearch =
    '/search/multi?query={SEARCH}&page=1&language={LOCALE}';

const String _tmdbFindByID =
    '/find/{ID}?language={LOCALE}&external_source=imdb_id';

class TmdbSearchService extends TmdbBaseService {
  List<TmdbTitle> _fromImdbIdToTitle(Map response) {
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

  Future<dynamic> searchImdbTitles(
    List imdbIds,
    Locale locale,
  ) async {
    List titles = [];
    List notFound = [];

    if (imdbIds.isEmpty) {
      return [];
    }

    for (int count = 0; count < imdbIds.length; count += 1) {
      final id = imdbIds[count];

      if (id.trim().isEmpty) {
        continue;
      }

      final result = await get(
        _tmdbFindByID.replaceFirst('{ID}', id).replaceFirst(
            '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );
      if (result.statusCode == 200) {
        List titlesFromId = _fromImdbIdToTitle(body(result));
        if (titlesFromId.isEmpty) {
          notFound.add(id);
        }
        titles.addAll(titlesFromId);
      } else {
        throw Exception(
            'Failed to search IMDB title. Response code: ${result.statusCode}');
      }
    }

    return {}
      ..['titles'] = titles
      ..['notFound'] = notFound;
  }
}
