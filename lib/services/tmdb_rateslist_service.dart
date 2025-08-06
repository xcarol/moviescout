import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

const String _tmdbRateslistMovies =
    'account/{ACCOUNT_ID}/movie/rated?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';
const String _tmdbRateslistTv =
    'account/{ACCOUNT_ID}/tv/rated?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';
const String _rateMovie = 'movie/{ID}/rating?session_id={SESSION_ID}';
const String _rateTv = 'tv/{ID}/rating?session_id={SESSION_ID}';

class TmdbRateslistService extends TmdbListService {
  TmdbRateslistService(super.listName);

  int getRating(int titleId) {
    if (titles.isEmpty) {
      // retrieveRateslist may not have been called yet
      retrieveListFromLocal(notify: false);
    }
    TmdbTitle? title = titles.firstWhere(
      (element) => element.tmdbId == titleId,
      orElse: () => TmdbTitle.fromMap(title: {}),
    );
    return title.rating.toInt();
  }

  Future<void> retrieveRateslist(
    String accountId,
    String sessionId,
    Locale locale, {
    bool notify = false,
  }) async {
    retrieveList(accountId, notify: notify,
        retrieveMovies: () async {
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
    int rate,
  ) async {
    if (rate > 0) {
      if (mediaType == 'movie') {
        return post(
            _rateMovie
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      } else if (mediaType == 'tv') {
        return post(
            _rateTv
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    } else {
      if (mediaType == 'movie') {
        return delete(
            _rateMovie
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {});
      } else if (mediaType == 'tv') {
        return delete(
            _rateTv
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    }
  }

  Future<void> updateTitleRate(
    String accountId,
    String sessionId,
    TmdbTitle title,
    int rating,
  ) async {
    try {
      if (rating > 0) {
        title.updateRating(rating.toDouble());
      }
      await updateTitle(accountId, sessionId, title, rating > 0,
          (String accountId, String sessionId) async {
        return _updateTitleRateToTmdb(
            accountId, sessionId, title.tmdbId, title.mediaType, rating);
      });
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error updating rate for ${title.name}: $error',
      );
    }
  }
}
