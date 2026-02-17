import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';

const int maxSearchMovies = 20;
const int maxSearchTvShows = 20;

const String _tmdbSearchMovies =
    '/search/movie?query={SEARCH}&page={PAGE}&language={LOCALE}';

const String _tmdbSearchTvShows =
    '/search/tv?query={SEARCH}&page={PAGE}&language={LOCALE}';

const String _tmdbFindByID =
    '/find/{ID}?language={LOCALE}&external_source=imdb_id';

class TmdbSearchService extends TmdbListService {
  TmdbSearchService(super.listName, super.repository);

  Future<dynamic> searchImdbTitle(
    String imdbId,
    Locale locale,
  ) async {
    return get(
      _tmdbFindByID.replaceFirst('{ID}', imdbId).replaceFirst(
          '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );
  }

  List<TmdbTitle> fromImdbIdToTitle(Map response) {
    List<TmdbTitle> titles = [];
    for (var key in response.keys) {
      if (key == ApiConstants.movieResults) {
        for (var movie in response[key]) {
          titles.add(TmdbTitle.fromMap(title: movie));
        }
      }
      if (key == ApiConstants.tvResults) {
        for (var tv in response[key]) {
          titles.add(TmdbTitle.fromMap(title: tv));
        }
      }
    }
    return titles;
  }

  dynamic _lastPage(int page) {
    return http.Response(
      '{"page":%d,"total_pages":%d}'.replaceAll('%d', page.toString()),
      200,
    );
  }

  int _totalPagesFromResponse(dynamic response, int maxOfType) {
    final Map responseBody = body(response);
    if (responseBody['results'] != null) {
      final resultsPerPage = (responseBody['results'] as List).length;
      if (resultsPerPage > 0) {
        return max((maxOfType / resultsPerPage).toInt(), 1);
      }
    }
    return 0;
  }

  Future<void> retrieveSearchlist(
      String accountId, String searchTerm, Locale locale) async {
    int totalMoviePages = 0;
    int totalTvShowPages = 0;

    retrieveList(accountId, retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        if (totalMoviePages > 0 && page > totalMoviePages) {
          return _lastPage(page);
        }
        dynamic response = await get(
          _tmdbSearchMovies
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst('{SEARCH}', searchTerm)
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );

        if (totalMoviePages > 0) {
          return response;
        }

        if (response.statusCode == 200) {
          totalMoviePages = _totalPagesFromResponse(response, maxSearchMovies);
        }

        return response;
      });
    }, retrieveTvshows: () async {
      return getTitlesFromServer((int page) async {
        if (totalTvShowPages > 0 && page > totalTvShowPages) {
          return _lastPage(page);
        }

        dynamic response = await get(
          _tmdbSearchTvShows
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst('{SEARCH}', searchTerm)
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );

        if (totalTvShowPages > 0) {
          return response;
        }

        if (response.statusCode == 200) {
          totalTvShowPages =
              _totalPagesFromResponse(response, maxSearchTvShows);
        }

        return response;
      });
    });
  }
}
