import 'package:moviescout/utils/url_constants.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_following_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbRateslistService extends TmdbTitleListService {
  TmdbFollowingService? followingService;

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

  Future<double> getRatingAsync(int titleId, String mediaType) async {
    TmdbTitle? title = await getTitleByTmdbId(titleId, mediaType);
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
    await retrieveList(accountId, forceUpdate: forceUpdate,
        retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        return get(
          UrlConstants.tmdbRateslistMoviesEndpoint
              .replaceFirst('{ACCOUNT_ID}', accountId)
              .replaceFirst('{SESSION_ID}', sessionId)
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );
      });
    }, retrieveTvshows: () async {
      return getTitlesFromServer((int page) async {
        return get(
          UrlConstants.tmdbRateslistTvEndpoint
              .replaceFirst('{ACCOUNT_ID}', accountId)
              .replaceFirst('{SESSION_ID}', sessionId)
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );
      });
    });

    if (followingService != null) {
      await followingService!.fetchAndApplyFollowingTitles();
    }
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
            UrlConstants.tmdbRateMovieEndpoint
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      } else if (mediaType == ApiConstants.tv) {
        return post(
            UrlConstants.tmdbRateTvEndpoint
                .replaceFirst('{ID}', id.toString())
                .replaceFirst('{SESSION_ID}', sessionId),
            {'value': rate});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "${ApiConstants.movie}" or "${ApiConstants.tv}".');
    } else {
      if (mediaType == ApiConstants.movie) {
        return delete(UrlConstants.tmdbRateMovieEndpoint
            .replaceFirst('{ID}', id.toString())
            .replaceFirst('{SESSION_ID}', sessionId));
      } else if (mediaType == ApiConstants.tv) {
        return delete(UrlConstants.tmdbRateTvEndpoint
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
          title.inLists = title.inLists.toList()
            ..remove(AppConstants.watchlist);
        }
      } else {
        if (title.notifyNewSeasons && followingService != null) {
          await followingService!.removeFollowingFromServer(title);
          title.notifyNewSeasons = false;
        }
        title.rating = 0.0;
      }
      await updateTitle(accountId, sessionId, title, rating > 0,
          (String accountId, String sessionId) async {
        return _updateTitleRateToTmdb(
            accountId, sessionId, title.tmdbId, title.mediaType, rating);
      });

      final globalTitle = await repository.getTitleGlobal(title.tmdbId, title.mediaType);
      if (rating > 0 || globalTitle != null) {
        await repository.updateRating(title);
        await repository.updateIsPinned(title);
        await repository.updateNotifyNewSeasons(title);
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating rate for ${title.name}',
      );
    }
  }

  Future<void> toggleNotify(TmdbTitle title) async {
    title.notifyNewSeasons = !title.notifyNewSeasons;
    await repository.updateNotifyNewSeasons(title);

    if (followingService != null) {
      if (title.notifyNewSeasons) {
        await followingService!.addFollowingToServer(title);
      } else {
        await followingService!.removeFollowingFromServer(title);
      }
    }

    return filterItems(retainPagination: true);
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
