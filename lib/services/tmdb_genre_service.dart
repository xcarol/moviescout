import 'dart:convert';

import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/update_manager.dart';

const String _tmdbMovieGenres = 'genre/movie/list?language={LOCALE}';
const String _tmdbTvGenres = 'genre/tv/list?language={LOCALE}';

class TmdbGenreService extends TmdbBaseService {
  static final TmdbGenreService _instance = TmdbGenreService._internal();
  factory TmdbGenreService() => _instance;
  TmdbGenreService._internal();

  final Map<int, String> _genreMap = {};
  List<String> get defaultGenresList => _genreMap.values.toList();
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  Future<void> init() async {
    bool reportError = false;
    if (_isLoaded) return;

    List<String> genreUrls = [_tmdbMovieGenres, _tmdbTvGenres];

    _genreMap.clear();

    if (_getLocalGenres()) {
      _isLoaded = true;
      return;
    }

    for (String url in genreUrls) {
      dynamic response = await get(url.replaceFirst(
          '{LOCALE}', '${getLanguageCode()}-${getCountryCode()}'));

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
            if (genres[0]['name'].isEmpty) {
              response = await get(url.replaceFirst('{LOCALE}', 'en'));

              if (response.statusCode == 200) {
                genres = (jsonDecode((response.body))
                    as Map<String, dynamic>)['genres'];
              } else {
                reportError = true;
              }
            }
          } else {
            reportError = true;
          }
        }

        for (var genre in genres) {
          _genreMap[genre['id']] = genre['name'];
        }
      } else {
        reportError = true;
      }

      if (reportError == true) {
        ErrorService.log(
          'Failed to load genres: ${response.statusCode}',
          userMessage: 'Failed to load genres',
        );
      }
    }

    _isLoaded = true;
    _setLocalGenres(_genreMap);
  }

  Future<void> reload() async {
    _isLoaded = false;
    await PreferencesService().prefs.remove('genres');
    await UpdateManager().removeLastUpdate('genres');
    await init();
  }

  bool _getLocalGenres() {
    final genres = PreferencesService().prefs.getStringList('genres') ?? [];
    bool isUpToDate = UpdateManager().isGenresUpToDate();

    if (genres.isEmpty || !isUpToDate) return false;

    genres
        .map((genre) => jsonDecode(genre) as Map<String, dynamic>)
        .forEach((genre) {
      _genreMap[genre['id']] = genre['name'];
    });

    return true;
  }

  void _setLocalGenres(Map<int, String> genres) {
    final genreList = genres.entries
        .map((entry) => jsonEncode({'id': entry.key, 'name': entry.value}))
        .toList();
    PreferencesService().prefs.setStringList('genres', genreList);
    UpdateManager().updateGenresLastUpdate();
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
