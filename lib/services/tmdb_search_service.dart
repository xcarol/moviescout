import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbSearch =
    '/search/multi?query={SEARCH}&page=1&language={LOCALE}';

const String _tmdbFindByID =
    '/find/{ID}?language={LOCALE}&external_source=imdb_id';

const String _tmdbImages = '/{MEDIA_TYPE}/{ID}/images';

class TmdbSearchService extends TmdbBaseService {
  _getPoster(Map details) {
    if (details['posters'] != null && details['posters'].length > 0) {
      return details['posters'][0]['file_path'];
    } else if (details['logos'] != null && details['logos'].length > 0) {
      return details['logos'][0]['file_path'];
    } else if (details['backdrops'] != null &&
        details['backdrops'].length > 0) {
      return details['backdrops'][0]['file_path'];
    } else {
      return '';
    }
  }

  _getImages(int titleId, String mediaType) async {
    final result = await get(
      _tmdbImages
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', titleId.toString()),
    );
    if (result.statusCode == 200) {
      return body(result);
    }
  }

  List _fromImdbIdToTitle(Map response) {
    List titles = [];
    for (var key in response.keys) {
      if (key == 'movie_results') {
        for (var movie in response[key]) {
          titles.add(movie);
        }
      }
      if (key == 'tv_results') {
        for (var tv in response[key]) {
          titles.add(tv);
        }
      }
    }
    return titles;
  }

  Future<List> _titlesList(Map response, Locale locale) async {
    List titles = [];
    final totalResults = response['total_results'] ?? 0;
    for (int count = 0; count < totalResults && count < 10; count += 1) {
      final title = response['results'][count];
      final details = await _getImages(title['id'], title['media_type']);
      final poster = _getPoster(details);
      titles.add({
        'id': title['id'],
        'title': title['title'] ?? title['name'],
        'poster_path': poster,
        'overview': title['overview'],
        'release_date': title['release_date'],
        'media_type': title['media_type'],
        'genre_ids': title['genre_ids'],
        'vote_average': title['vote_average'],
      });
    }
    return titles;
  }

  Future<dynamic> searchTitle(
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
