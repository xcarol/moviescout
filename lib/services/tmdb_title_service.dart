import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

const String _tmdbDetails =
    '/{MEDIA_TYPE}/{ID}?append_to_response=external_ids%2Cwatch%2Fproviders%2Crecommendations%2Caggregate_credits&language={LOCALE}';

const String _tmdbBrief = '/{MEDIA_TYPE}/{ID}?language={LOCALE}';

class TmdbTitleService extends TmdbBaseService {
  Future<dynamic> _retrieveTitleDetails(
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

  Future<dynamic> _retrieveTitleBrief(
    int id,
    String mediaType,
    String locale,
  ) async {
    return get(
      _tmdbBrief
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
        3;
  }

  Future<TmdbTitle> updateTitleDetails(TmdbTitle title) async {
    if (isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleDetails(
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

    final Map<String, dynamic> details = body(result);

    details[TmdbTitleFields.providers] =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};

    if (details['recommendations'] != null &&
        details['recommendations']['results'] != null) {
      details[TmdbTitleFields.recommendations] =
          details['recommendations']['results'];
    }

    if (mediaType == ApiConstants.tv) {
      final externalIds = details['external_ids'];
      if (externalIds != null && externalIds['imdb_id'] != null) {
        details[TmdbTitleFields.imdbId] = externalIds['imdb_id'];
      }
    }

    if ((details[TmdbTitleFields.overview] ?? '').isEmpty) {
      final fallbackResult = await _retrieveTitleBrief(
        title.tmdbId,
        mediaType,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        _mergeFallback(details, body(fallbackResult), mediaType);
      }
    }

    if ((details[TmdbTitleFields.overview] ?? '').isEmpty) {
      final enResult = await _retrieveTitleBrief(
        title.tmdbId,
        mediaType,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        _mergeFallback(details, body(enResult), mediaType);
      }
    }

    details[TmdbTitleFields.mediaType] = mediaType;
    details[TmdbTitleFields.lastUpdated] = DateTime.now().toIso8601String();

    title.fillFromMap(details);

    return title;
  }

  void _mergeFallback(Map<String, dynamic> target,
      Map<String, dynamic> fallback, String mediaType) {
    final String fallbackOverview = fallback[TmdbTitleFields.overview] ?? '';

    if (fallbackOverview.isNotEmpty) {
      target[TmdbTitleFields.overview] = fallbackOverview;

      if (mediaType == ApiConstants.movie) {
        if (fallback[TmdbTitleFields.title] != null) {
          target[TmdbTitleFields.title] = fallback[TmdbTitleFields.title];
        }
        if (fallback[TmdbTitleFields.originalTitle] != null) {
          target[TmdbTitleFields.originalTitle] =
              fallback[TmdbTitleFields.originalTitle];
        }
      } else {
        if (fallback[TmdbTitleFields.name] != null) {
          target[TmdbTitleFields.name] = fallback[TmdbTitleFields.name];
        }
        if (fallback[TmdbTitleFields.originalName] != null) {
          target[TmdbTitleFields.originalName] =
              fallback[TmdbTitleFields.originalName];
        }
      }
    }
  }
}
