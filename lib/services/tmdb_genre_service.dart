import 'dart:convert';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_cacheable_service.dart';
import 'package:moviescout/services/update_manager.dart';

const String _tmdbMovieGenres = 'genre/movie/list?language={LOCALE}';
const String _tmdbTvGenres = 'genre/tv/list?language={LOCALE}';

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
    List<String> genreUrls = [_tmdbMovieGenres, _tmdbTvGenres];
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

  String? getName(int id) => _genreMap[id];

  List<TmdbGenre> getGenresFromIds(List<dynamic> ids) {
    return ids
        .map((id) => _genreMap.containsKey(id)
            ? TmdbGenre(genre: {id: _genreMap[id]!})
            : null)
        .whereType<TmdbGenre>()
        .toList();
  }

  List<String> getNamesFromIds(List<dynamic> ids) {
    return ids
        .map((id) => _genreMap.containsKey(id) ? _genreMap[id]! : null)
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
