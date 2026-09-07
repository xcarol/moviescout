import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_following_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;
import 'package:moviescout/services/core/supabase_service.dart';

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
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return;

    await retrieveList(
      accountId,
      forceUpdate: forceUpdate,
      retrieveMovies: () async {
        final response = await SupabaseService()
            .client
            .from('user_list_items')
            .select('tmdb_id, media_type, rate, created_at, date_rated')
            .eq('user_id', userId)
            .eq('list_name', AppConstants.rateslist)
            .eq('media_type', ApiConstants.movie);

        return response
            .map((row) => {
                  TmdbTitleFields.id: row['tmdb_id'],
                  'created_at': row['created_at'],
                  'rate': row['rate'],
                  'date_rated': row['date_rated'],
                })
            .toList();
      },
      retrieveTvshows: () async {
        final response = await SupabaseService()
            .client
            .from('user_list_items')
            .select('tmdb_id, media_type, rate, created_at, date_rated')
            .eq('user_id', userId)
            .eq('list_name', AppConstants.rateslist)
            .eq('media_type', ApiConstants.tv);

        return response
            .map((row) => {
                  TmdbTitleFields.id: row['tmdb_id'],
                  'created_at': row['created_at'],
                  'rate': row['rate'],
                  'date_rated': row['date_rated'],
                })
            .toList();
      },
    );

    await _retrieveRatedEpisodes(accountId, sessionId, locale);

    if (followingService != null) {
      await followingService!.fetchAndApplyFollowingTitles();
    }
  }

  Future<void> _retrieveRatedEpisodes(
      String accountId, String sessionId, Locale locale) async {
    // TODO: re-implement method
    // Left empty for now, assuming episodes will also migrate to Supabase in the future
    // or we fetch them from another table like 'user_episode_rates'
  }

  Future<void> _updateTitleToDatabase(
    int id,
    String mediaType,
    double rate,
    TmdbTitle title,
  ) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('User not logged in');
    }

    if (rate > 0) {
      await SupabaseService().client.from('user_list_items').upsert({
        'user_id': userId,
        'list_name': AppConstants.rateslist,
        'tmdb_id': id,
        'media_type': mediaType,
        'rate': title.rating,
        'created_at': title.addedDate?.toUtc().toIso8601String(),
        'date_rated': title.dateRated.year > 2000
            ? title.dateRated.toUtc().toIso8601String()
            : null,
      }, onConflict: 'user_id, list_name, tmdb_id');
    } else {
      await SupabaseService()
          .client
          .from('user_list_items')
          .delete()
          .eq('user_id', userId)
          .eq('list_name', AppConstants.rateslist)
          .eq('tmdb_id', id);
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
          await followingService!.removeFollowingFromDatabase(title);
          title.notifyNewSeasons = false;
        }
        title.rating = 0.0;
      }
      await updateTitle(accountId, sessionId, title, rating > 0,
          (String accountId, String sessionId) async {
        return _updateTitleToDatabase(
            title.tmdbId, title.mediaType, rating, title);
      });

      final globalTitle =
          await repository.getTitleGlobal(title.tmdbId, title.mediaType);
      if (rating > 0 || globalTitle != null) {
        await repository.updateRating(title);
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

    if (followingService != null) {
      if (title.notifyNewSeasons) {
        await followingService!.addFollowingToDatabase(title);
      } else {
        await followingService!.removeFollowingFromDatabase(title);
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
