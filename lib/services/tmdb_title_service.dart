import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbDetails = '/{MEDIA_TYPE}/{ID}?language={LOCALE}';
const String _tmdbProviders = '/{MEDIA_TYPE}/{ID}/watch/providers';

class TmdbTitleService extends TmdbBaseService {
  String _getCountryCode() {
    return PlatformDispatcher.instance.locale.countryCode ?? "US";
  }

  String _getLanguageCode() {
    return PlatformDispatcher.instance.locale.languageCode;
  }

  bool _isUpToDate(TmdbTitle title) {
    return DateTime.now()
            .difference(
              DateTime.parse(title.lastUpdated),
            )
            .inDays <
        DateTime.daysPerWeek;
  }

  _getProviders(int titleId, String mediaType) async {
    final result = await get(
      _tmdbProviders
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', titleId.toString()),
    );
    if (result.statusCode == 200) {
      return body(result)['results'][_getCountryCode()];
    }
    return {};
  }

  Future<dynamic> getTitlesDetails(
    List titles,
  ) async {
    for (int count = 0; count < titles.length; count += 1) {
      final TmdbTitle title = titles[count];
      final TmdbTitle details = await getTitleDetails(title);
      titles[count] = details;
    }
    return titles;
  }

  Future<TmdbTitle> getTitleDetails(TmdbTitle title) async {
    if (_isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? 'movie' : 'tv';
    }

    final result = await get(
      _tmdbDetails
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', title.id.toString())
          .replaceFirst(
              '{LOCALE}', '${_getLanguageCode()}-${_getCountryCode()}'),
    );

    if (result.statusCode == 200) {
      final titleDetails = body(result);

      titleDetails['media_type'] = mediaType;
      titleDetails['providers'] = await _getProviders(title.id, mediaType);
      titleDetails['last_updated'] = DateTime.now().toIso8601String();

      return TmdbTitle(title: titleDetails);
    }

    return TmdbTitle(title: {});
  }
}
