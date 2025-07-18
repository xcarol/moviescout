import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbDetails =
    '/{MEDIA_TYPE}/{ID}?append_to_response=external_ids%2Cwatch%2Fproviders%2Crecommendations&language={LOCALE}';

class TmdbTitleService extends TmdbBaseService {
  _retrieveTitleDetailsByLocale(
    int id,
    String mediaType,
    String locale,
  ) async {
    return get(
      _tmdbDetails
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  static bool isUpToDate(TmdbTitle title) {
    return DateTime.now()
            .difference(
              DateTime.parse(title.lastUpdated),
            )
            .inDays <
        DateTime.daysPerWeek;
  }

  Future<void> updateTitles(List<TmdbTitle> titles) async {
    await Future.wait(
      titles.map((title) async => await updateTitleDetails(title)),
    );
  }

  Future<TmdbTitle> updateTitleDetails(TmdbTitle title) async {
    if (isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? 'movie' : 'tv';
    }

    final result = await _retrieveTitleDetailsByLocale(
      title.id,
      mediaType,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      FirebaseCrashlytics.instance.recordError(
        Exception(
          'Failed to retrieve title details for ${title.id} - ${result.statusCode} - ${result.body}',
        ),
        null,
        reason: 'TmdbTitleService.updateTitleDetails',
      );
      return title;
    }

    final Map titleMap = title.map;

    titleMap.addAll(body(result));

    if (titleMap['overview'].isEmpty) {
      final result = await _retrieveTitleDetailsByLocale(
        title.id,
        mediaType,
        getCountryCode().toLowerCase(),
      );

      if (result.statusCode == 200) {
        final details = body(result);
        if (details['overview'].isNotEmpty) {
          titleMap['title'] = details['title'];
          titleMap['overview'] = details['overview'];
        }
      }
    }

    if (titleMap['overview'].isEmpty) {
      final result = await _retrieveTitleDetailsByLocale(
        title.id,
        mediaType,
        'en-US',
      );

      if (result.statusCode == 200) {
        final details = body(result);
        if (details['overview'].isNotEmpty) {
          titleMap['title'] = details['title'];
          titleMap['overview'] = details['overview'];
        }
      }
    }

    if (mediaType == 'tv') {
      titleMap['imdb_id'] = titleMap['external_ids']?['imdb_id'] ?? '';
    }

    titleMap['media_type'] = mediaType;
    titleMap['providers'] =
        titleMap['watch/providers']?['results']?[getCountryCode()] ?? {};
    titleMap['recommendations'] = titleMap['recommendations']?['results'] ?? {};
    titleMap['last_updated'] = DateTime.now().toIso8601String();

    return title;
  }
}
