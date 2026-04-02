import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

const String _tmdbRateslistMovies =
    'account/{ACCOUNT_ID}/movie/rated?session_id={SESSION_ID}&page={PAGE}&sort_by=created_at.asc&language={LOCALE}';
const String _tmdbRateslistTv =
    'account/{ACCOUNT_ID}/tv/rated?session_id={SESSION_ID}&page={PAGE}&sort_by=created_at.asc&language={LOCALE}';
const String _rateMovie = 'movie/{ID}/rating?session_id={SESSION_ID}';
const String _rateTv = 'tv/{ID}/rating?session_id={SESSION_ID}';

class TmdbRateslistService extends TmdbListService {
  TmdbRateslistService(super.listName, super.repository) {
    filterRating = RatingFilter.rated;
  }

  double getRating(int titleId, String mediaType) {
    TmdbTitle? title = getTitleByTmdbIdSync(titleId, mediaType);
    if (title == null) {
      return 0.0;
    }
    return title.rating;
  }

  Future<DateTime> getRatingDate(int titleId, String mediaType) async {
    TmdbTitle? title = await getTitleByTmdbId(titleId, mediaType);
    if (title == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return title.dateRated;
  }

  Future<void> retrieveRateslist(
      String accountId, String sessionId, Locale locale,
      {bool forceUpdate = false}) async {
    retrieveList(accountId, forceUpdate: forceUpdate, retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        return get(
            _tmdbRateslistMovies
                .replaceFirst('{ACCOUNT_ID}', accountId)
                .replaceFirst('{SESSION_ID}', sessionId)
                .replaceFirst('{PAGE}', page.toString())
                .replaceFirst(
                    '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
            version: ApiVersion.v4);
      });
    }, retrieveTvshows: () async {
      return getTitlesFromServer((int page) async {
        return get(
            _tmdbRateslistTv
                .replaceFirst('{ACCOUNT_ID}', accountId)
                .replaceFirst('{SESSION_ID}', sessionId)
                .replaceFirst('{PAGE}', page.toString())
                .replaceFirst(
                    '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
            version: ApiVersion.v4);
      });
    });
  }

  Future<dynamic> _updateTitleRateToTmdb(
    String accountId,
    String sessionId,
    int id,
    String mediaType,
    double rate,
  ) async {
    if (rate > 0) {
      if (mediaType == ApiConstants.movie) {
        return post(
            _rateMovie
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      } else if (mediaType == ApiConstants.tv) {
        return post(
            _rateTv
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "${ApiConstants.movie}" or "${ApiConstants.tv}".');
    } else {
      if (mediaType == ApiConstants.movie) {
        return delete(_rateMovie
            .replaceFirst('{ID}', id.toString())
            .replaceFirst('{SESSION_ID}', sessionId));
      } else if (mediaType == ApiConstants.tv) {
        return delete(_rateTv
            .replaceFirst('{ID}', id.toString())
            .replaceFirst('{SESSION_ID}', sessionId));
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "${ApiConstants.movie}" or "${ApiConstants.tv}".');
    }
  }

  Future<void> updateTitleRate(
    String accountId,
    String sessionId,
    TmdbTitle title,
    double rating,
  ) async {
    try {
      if (rating > 0) {
        title.updateRating(rating.toDouble());
        title.isPinned = false;

        final watchlistTitle = await repository.getTitleByTmdbId(
            AppConstants.watchlist, title.tmdbId, title.mediaType);
        if (watchlistTitle != null) {
          await repository.deleteTitle(
              AppConstants.watchlist, title.tmdbId, title.mediaType);
        }
      }
      await updateTitle(accountId, sessionId, title, rating > 0,
          (String accountId, String sessionId) async {
        return _updateTitleRateToTmdb(
            accountId, sessionId, title.tmdbId, title.mediaType, rating);
      });
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating rate for ${title.name}',
      );
    }
  }

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    await retrieveRateslist(accountId, sessionId, locale, forceUpdate: true);
  }
}
