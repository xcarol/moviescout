import 'dart:convert';

import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbMovieGenres = 'genre/movie/list?language={LOCALE}';
const String _tmdbTvGenres = 'genre/tv/list?language={LOCALE}';

class TmdbGenreService extends TmdbBaseService {
  static final TmdbGenreService _instance = TmdbGenreService._internal();
  factory TmdbGenreService() => _instance;
  TmdbGenreService._internal();

  final Map<int, String> _genreMap = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  Future<void> init() async {
    if (_isLoaded) return;

    List<String> genreUrls = [_tmdbMovieGenres, _tmdbTvGenres];

    _genreMap.clear();
    for (String url in genreUrls) {
      dynamic response = await get(url.replaceFirst(
          '{LOCALE}', '${getLanguageCode()}-${getCountryCode()}'));

      if (response.statusCode == 200) {
        List<dynamic> genres =
            (jsonDecode((response.body)) as Map<String, dynamic>)['genres'];

        if (genres.isEmpty ||
            genres[0]['name'] == null ||
            genres[0]['name'].isEmpty) {
          response = await await get(
              url.replaceFirst('{LOCALE}', getCountryCode().toLowerCase()));

          if (response.statusCode == 200) {
            genres =
                (jsonDecode((response.body)) as Map<String, dynamic>)['genres'];
            if (genres[0]['name'].isEmpty) {
              response = await await get(url.replaceFirst('{LOCALE}', 'en'));

              if (response.statusCode == 200) {
                genres = (jsonDecode((response.body))
                    as Map<String, dynamic>)['genres'];
              } else {
                throw Exception('Failed to load genres');
              }
            }
          } else {
            throw Exception('Failed to load genres');
          }
        }

        for (var genre in genres) {
          _genreMap[genre['id']] = genre['name'];
        }
      } else {
        throw Exception('Failed to load genres');
      }
      _isLoaded = true;
    }
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
}
