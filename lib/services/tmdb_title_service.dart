import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbDetails = '/{MEDIA_TYPE}/{ID}?language={LOCALE}';
const String _tmdbProviders = '/{MEDIA_TYPE}/{ID}/watch/providers';

class TmdbTitleService extends TmdbBaseService {
  String getCountryCode() {
    return PlatformDispatcher.instance.locale.countryCode ?? "US";
  }

  getTitleProviders(int titleId, String mediaType) async {
    final result = await get(
      _tmdbProviders
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', titleId.toString()),
    );
    if (result.statusCode == 200) {
      return body(result)['results'][getCountryCode()];
    }
    return {};
  }

  Future<dynamic> getTitlesDetails(
    List titles,
    Locale locale,
  ) async {
    for (int count = 0; count < titles.length; count += 1) {
      final TmdbTitle title = titles[count];
      final TmdbTitle details = await getTitleDetails(title, locale);
      titles[count] = details;
    }
    return titles;
  }

  Future<TmdbTitle> getTitleDetails(
    TmdbTitle title,
    Locale locale,
  ) async {
    if (DateTime.now()
            .difference(
              DateTime.parse(title.lastUpdated),
            )
            .inDays <
        DateTime.daysPerWeek) {
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
              '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );

    if (result.statusCode == 200) {
      final titleDetails = body(result);

      titleDetails['media_type'] = mediaType;
      titleDetails['providers'] =
          await getTitleProviders(title.id, mediaType);
      titleDetails['last_updated'] = DateTime.now().toIso8601String();

      return TmdbTitle(title: titleDetails);
    }
    
    return TmdbTitle(title: {});
  }
}
