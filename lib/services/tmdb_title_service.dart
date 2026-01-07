import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

const String _tmdbDetails =
    '/{MEDIA_TYPE}/{ID}?append_to_response=external_ids%2Cwatch%2Fproviders%2Crecommendations%2Ccredits&language={LOCALE}';

class TmdbTitleService extends TmdbBaseService {
  Future<dynamic> _retrieveTitleDetailsByLocale(
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

  Future<TmdbTitle> updateTitleDetails(TmdbTitle title) async {
    if (isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleDetailsByLocale(
      title.tmdbId,
      mediaType,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        FirebaseCrashlytics.instance.recordError(
          Exception(
            'Failed to retrieve title details for ${title.tmdbId} - ${result.statusCode} - ${result.body}',
          ),
          null,
          reason: 'TmdbTitleService.updateTitleDetails',
        );
      } else {
        SnackMessage.showSnackBar(
          'Failed to retrieve title details for ${title.tmdbId} - ${result.statusCode} - ${result.body}',
        );
      }
      return title;
    }

    final Map<String, dynamic> titleMap = title.toMap();
    final Map<String, dynamic> details = body(result);

    titleMap.addAll(details);

    final providersMap =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};
    titleMap[TmdbTitleFields.providers] = providersMap;

    if (details['recommendations'] != null &&
        details['recommendations']['results'] != null) {
      titleMap[TmdbTitleFields.recommendations] =
          details['recommendations']['results'];
    }

    if (details['credits'] != null) {
      titleMap[TmdbTitleFields.credits] = details['credits'];
    }

    if (mediaType == ApiConstants.tv) {
      final externalIds = details['external_ids'];
      if (externalIds != null && externalIds['imdb_id'] != null) {
        titleMap[TmdbTitleFields.imdbId] = externalIds['imdb_id'];
      }
    }

    if ((titleMap[TmdbTitleFields.overview] ?? '').isEmpty) {
      final fallbackResult = await _retrieveTitleDetailsByLocale(
        title.tmdbId,
        mediaType,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        _applyLocaleFallback(titleMap, body(fallbackResult), mediaType);
      }
    }

    if ((titleMap[TmdbTitleFields.overview] ?? '').isEmpty) {
      final enResult = await _retrieveTitleDetailsByLocale(
        title.tmdbId,
        mediaType,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        _applyLocaleFallback(titleMap, body(enResult), mediaType);
      }
    }

    titleMap[TmdbTitleFields.mediaType] = mediaType;
    titleMap[TmdbTitleFields.lastUpdated] = DateTime.now().toIso8601String();

    return TmdbTitle.fromMap(title: titleMap);
  }

  void _applyLocaleFallback(Map<String, dynamic> titleMap,
      Map<String, dynamic> fallback, String mediaType) {
    final String fallbackOverview = fallback[TmdbTitleFields.overview] ?? '';

    if (fallbackOverview.isNotEmpty) {
      titleMap[TmdbTitleFields.overview] = fallbackOverview;

      if (mediaType == ApiConstants.movie) {
        if (fallback[TmdbTitleFields.title] != null) {
          titleMap[TmdbTitleFields.title] = fallback[TmdbTitleFields.title];
        }
        if (fallback[TmdbTitleFields.originalTitle] != null) {
          titleMap[TmdbTitleFields.originalTitle] =
              fallback[TmdbTitleFields.originalTitle];
        }
      } else {
        if (fallback[TmdbTitleFields.name] != null) {
          titleMap[TmdbTitleFields.name] = fallback[TmdbTitleFields.name];
        }
        if (fallback[TmdbTitleFields.originalName] != null) {
          titleMap[TmdbTitleFields.originalName] =
              fallback[TmdbTitleFields.originalName];
        }
      }
    }
  }
}
