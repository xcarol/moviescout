import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_cacheable_service.dart';
import 'package:moviescout/services/core/update_manager.dart';
import 'package:moviescout/utils/genre_translator.dart';

class TmdbGenreService extends TmdbCacheableService<Map<int, String>> {
  static final TmdbGenreService _instance = TmdbGenreService._internal();
  factory TmdbGenreService() => _instance;

  TmdbGenreService._internal()
      : super(
          cacheKey: 'genres',
          timeout: UpdateManager.genresTimeout,
        );

  Map<int, String> get _genreMap => data ?? {};

  List<String> get defaultGenresList => _genreMap.values.toList();

  @override
  Future<void> fetchAndCache() async {
    List<String> genreUrls = [
      UrlConstants.tmdbMovieGenresEndpoint,
      UrlConstants.tmdbTvGenresEndpoint
    ];
    final Map<int, String> newGenreMap = {};
    bool reportError = false;
    dynamic lastResponse;

    for (String url in genreUrls) {
      String locale = '${getLanguageCode()}-${getCountryCode()}';
      dynamic response = await get(url.replaceFirst('{LOCALE}', locale));

      if (response.statusCode == 200) {
        List<dynamic> genres =
            (jsonDecode((response.body)) as Map<String, dynamic>)['genres'];

        if (genres.isEmpty ||
            genres[0]['name'] == null ||
            genres[0]['name'].isEmpty) {
          response = await get(
              url.replaceFirst('{LOCALE}', getCountryCode().toLowerCase()));

          if (response.statusCode == 200) {
            genres =
                (jsonDecode((response.body)) as Map<String, dynamic>)['genres'];
            if (genres.isEmpty || genres[0]['name'].isEmpty) {
              response = await get(url.replaceFirst('{LOCALE}', 'en'));

              if (response.statusCode == 200) {
                genres = (jsonDecode((response.body))
                    as Map<String, dynamic>)['genres'];
              } else {
                reportError = true;
                lastResponse = response;
              }
            }
          } else {
            reportError = true;
            lastResponse = response;
          }
        }

        for (var genre in genres) {
          newGenreMap[genre['id']] = genre['name'];
        }
      } else {
        reportError = true;
        lastResponse = response;
      }
    }

    if (reportError && lastResponse != null) {
      ErrorService.log(
        'Failed to load genres: ${lastResponse.statusCode}',
        userMessage: 'Failed to load genres',
      );
    }

    data = newGenreMap;
    saveToCache(newGenreMap.entries
        .map((e) => {'id': e.key, 'name': e.value})
        .toList());
  }

  @override
  Map<int, String> parseData(dynamic json) {
    final Map<int, String> map = {};
    if (json is List) {
      for (var item in json) {
        if (item is Map) {
          map[item['id']] = item['name'];
        }
      }
    }
    return map;
  }

  String? getName(int id) =>
      GenreTranslator.translate(id, getLanguageCode()) ?? _genreMap[id];

  List<TmdbGenre> getGenresFromIds(List<dynamic> ids) {
    return ids
        .map((id) {
          String? name =
              GenreTranslator.translate(id, getLanguageCode()) ?? _genreMap[id];
          return name != null ? TmdbGenre(genre: {id: name}) : null;
        })
        .whereType<TmdbGenre>()
        .toList();
  }

  List<String> getNamesFromIds(List<dynamic> ids) {
    return ids
        .map((id) =>
            GenreTranslator.translate(id, getLanguageCode()) ?? _genreMap[id])
        .whereType<String>()
        .toList();
  }

  List<int> getIdsFromNames(List<String> names) {
    return _genreMap.entries
        .where((entry) => names.contains(entry.value))
        .map((entry) => entry.key)
        .toList();
  }
}
