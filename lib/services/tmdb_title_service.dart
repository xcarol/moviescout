import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    return result['results'][getCountryCode()];
  }

  Future<dynamic> getTitlesDetails(
    List titles,
    Locale locale,
  ) async {
    for (int count = 0; count < titles.length; count += 1) {
      final title = titles[count];
      final details = await getTitleDetails(title, locale);
      titles[count] = details;
    }
    return titles;
  }

  Future<dynamic> getTitleDetails(
    Map title,
    Locale locale,
  ) async {
    if (title['last_updated'] != null &&
        DateTime.now()
                .difference(DateTime.parse(title['last_updated']))
                .inDays <
            DateTime.daysPerWeek) {
      return title;
    }

    String mediaType = title['media_type'] ?? '';
    if (mediaType == '') {
      mediaType = title['title'] != null ? 'movie' : 'tv';
    }

    final result = await get(
      _tmdbDetails
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', title['id'].toString())
          .replaceFirst(
              '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );
    final titleDetails = result;

    titleDetails['providers'] = await getTitleProviders(title['id'], mediaType);
    titleDetails['last_updated'] = DateTime.now().toIso8601String();

    return titleDetails;
  }
}
