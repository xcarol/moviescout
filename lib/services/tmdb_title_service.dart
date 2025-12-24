import 'dart:convert';

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

  //TODO: Delete
  Future<List<TmdbTitle>> updateTitles(List<TmdbTitle> titles) async {
    List<TmdbTitle> updatedTitles = [];

    for (TmdbTitle title in titles) {
      final updatedTitle = await updateTitleDetails(title);
      updatedTitles.add(updatedTitle);
    }

    return updatedTitles;
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

    final details = body(result);
    title.mergeFromMap(details);

    if (title.overview.isEmpty) {
      final fallbackResult = await _retrieveTitleDetailsByLocale(
        title.tmdbId,
        mediaType,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        title.mergeFromMap(body(fallbackResult));
      }
    }

    if (title.overview.isEmpty) {
      final enResult = await _retrieveTitleDetailsByLocale(
        title.tmdbId,
        mediaType,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        title.mergeFromMap(body(enResult));
      }
    }

    if (mediaType == ApiConstants.tv) {
      final externalIds = details['external_ids'];
      if (externalIds != null && externalIds['imdb_id'] != null) {
        title.imdbId = externalIds['imdb_id'];
      }
    }

    final providersMap =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};
    TmdbTitle.updateProviderIds(title, providersMap);
    title.providersJson = jsonEncode(providersMap);

    if (details['recommendations'] != null &&
        details['recommendations']['results'] != null) {
      title.recommendationsJson =
          jsonEncode(details['recommendations']['results']);
    }

    title.mediaType = mediaType;
    title.lastUpdated = DateTime.now().toIso8601String();

    return title;
  }
}
