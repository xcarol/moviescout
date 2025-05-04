import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

const String _tmdbRateslistMovies =
    'account/{ACCOUNT_ID}/rated/movies?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';
const String _tmdbRateslistTv =
    'account/{ACCOUNT_ID}/tv/watchlist?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';

class TmdbRateslistService extends TmdbListService {
  TmdbRateslistService(super.listName);

  int getRating(int titleId) {
    if (titles.isEmpty) {
      // retrieveRateslist may not have been called yet
      retreiveListFromLocal(notify: false);
    }
    TmdbTitle? title = titles.firstWhere(
      (element) => element.id == titleId,
      orElse: () => TmdbTitle(title: {}),
    );
    return title.rating.toInt();
  }

  Future<void> retrieveRateslist(
    String accountId,
    String sessionId,
    Locale locale, {
    bool notify = false,
  }) async {
    retrieveList(accountId, notify: notify, retrieveMovies: () async {
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
      String accountId, int id, String mediaType, int rate) async {
    if (rate > 0) {
      if (mediaType == 'movie') {
        return post('movie/$id/rating', {'value': rate});
      } else if (mediaType == 'tv') {
        return post('tv/$id/rating', {'value': rate});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    } else {
      if (mediaType == 'movie') {
        return delete('movie/$id/rating', {});
      } else if (mediaType == 'tv') {
        return delete('tv/$id/rating', {});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    }
  }

  Future<void> updateTitleRate(
    String accountId,
    TmdbTitle title,
    int rating,
  ) async {
    try {
      if (rating > 0) {
        title.rating = rating.toDouble();
      }
      await updateTitle(accountId, title, rating > 0, (String accountId) async {
        return _updateTitleRateToTmdb(
            accountId, title.id, title.mediaType, rating);
      });
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error updating rate for ${title.name}: $error',
      );
    }
  }
}
