import 'package:flutter/services.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:http/http.dart' as http;

class HomeScreenShortcutService {
  static const MethodChannel _channel =
      MethodChannel('com.xicra.moviescout/shortcut');

  static Future<Uint8List?> _getIconBytes(String path) async {
    if (path.isEmpty) return null;
    try {
      final imageUrl = UrlConstants.tmdbImageW185Template
          .replaceFirst('{PATH}', path);
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  static Future<bool> _invokePinShortcut({
    required String id,
    required String shortLabel,
    required String url,
    required Uint8List? iconBytes,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('pinShortcut', {
        'id': id,
        'shortLabel': shortLabel,
        'url': url,
        'iconBytes': iconBytes,
      });
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    } on MissingPluginException catch (_) {
      return false;
    }
  }

  static Future<bool> pinTitleShortcut(TmdbTitle title) async {
    final String url = UrlConstants.moviescoutTitleWebTemplate
        .replaceFirst('{MEDIA_TYPE}', title.mediaType)
        .replaceFirst('{ID}', title.tmdbId.toString());

    final iconBytes = await _getIconBytes(title.posterPath);

    return _invokePinShortcut(
      id: 'title_${title.mediaType}_${title.tmdbId}',
      shortLabel: title.name,
      url: url,
      iconBytes: iconBytes,
    );
  }

  static Future<bool> pinPersonShortcut(TmdbPerson person) async {
    final String url = UrlConstants.moviescoutPersonWebTemplate
        .replaceFirst('{ID}', person.tmdbId.toString());

    final iconBytes = await _getIconBytes(person.profilePath);

    return _invokePinShortcut(
      id: 'person_${person.tmdbId}',
      shortLabel: person.name,
      url: url,
      iconBytes: iconBytes,
    );
  }

  static Future<bool> pinSeasonShortcut(TmdbTitle title, int seasonNumber,
      String seasonName, String posterPath) async {
    final String url = UrlConstants.moviescoutTvSeasonWebTemplate
        .replaceFirst('{ID}', title.tmdbId.toString())
        .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString());

    Uint8List? iconBytes = await _getIconBytes(posterPath);
    iconBytes ??= await _getIconBytes(title.posterPath);

    return _invokePinShortcut(
      id: 'season_${title.tmdbId}_$seasonNumber',
      shortLabel:
          seasonName.isNotEmpty ? seasonName : '${title.name} S$seasonNumber',
      url: url,
      iconBytes: iconBytes,
    );
  }
}
