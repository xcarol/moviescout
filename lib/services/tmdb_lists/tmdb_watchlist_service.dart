import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbWatchlistService extends TmdbTitleListService {
  TmdbPinnedService? pinnedService;

  TmdbWatchlistService(super.listName, super.repository);

  Future<void> retrieveWatchlist(
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
            .select('tmdb_id, media_type, created_at')
            .eq('user_id', userId)
            .eq('list_name', AppConstants.watchlist)
            .eq('media_type', ApiConstants.movie);

        return response
            .map((row) => {
                  TmdbTitleFields.id: row['tmdb_id'],
                  'created_at': row['created_at'],
                })
            .toList();
      },
      retrieveTvshows: () async {
        final response = await SupabaseService()
            .client
            .from('user_list_items')
            .select('tmdb_id, media_type, created_at')
            .eq('user_id', userId)
            .eq('list_name', AppConstants.watchlist)
            .eq('media_type', ApiConstants.tv);

        return response
            .map((row) => {
                  TmdbTitleFields.id: row['tmdb_id'],
                  'created_at': row['created_at'],
                })
            .toList();
      },
    );

    if (pinnedService != null) {
      await pinnedService!.fetchAndApplyPinnedTitles();
      await filterItems();
    }
  }

  Future<void> _updateTitleToDatabase(
    int id,
    String mediaType,
    bool add,
    TmdbTitle title,
  ) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('User not logged in');
    }

    if (add) {
      await SupabaseService().client.from('user_list_items').upsert({
        'user_id': userId,
        'list_name': AppConstants.watchlist,
        'tmdb_id': id,
        'media_type': mediaType,
        'created_at': title.addedDate?.toUtc().toIso8601String(),
      }, onConflict: 'user_id, list_name, tmdb_id');
    } else {
      await SupabaseService()
          .client
          .from('user_list_items')
          .delete()
          .eq('user_id', userId)
          .eq('list_name', AppConstants.watchlist)
          .eq('tmdb_id', id);
    }
  }

  Future<void> updateWatchlistTitle(
      String accountId, String sessionId, TmdbTitle title, bool add) async {
    try {
      if (add) {
        title.isPinned = false;
      } else {
        if (title.isPinned && pinnedService != null) {
          await pinnedService!.removePinnedFromDatabase(title);
          title.isPinned = false;
        }
      }

      await updateTitle(accountId, sessionId, title, add,
          (String accountId, String sessionId) async {
        return _updateTitleToDatabase(
            title.tmdbId, title.mediaType, add, title);
      });
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating watchlist for ${title.name}',
      );
    }
  }

  Future<void> togglePin(TmdbTitle title, {String? limitReachedMessage}) async {
    if (!title.isPinned) {
      final pinnedCount = await repository.countTitlesFiltered(
        listName: listName,
        pinned: true,
      );
      if (pinnedCount >= 5) {
        if (limitReachedMessage != null) {
          ErrorService.log(
            'Pin limit reached',
            userMessage: limitReachedMessage,
          );
        }
        return;
      }
    }

    title.isPinned = !title.isPinned;

    if (pinnedService != null) {
      if (title.isPinned) {
        await pinnedService!.addPinnedToDatabase(title);
      } else {
        await pinnedService!.removePinnedFromDatabase(title);
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
    await retrieveWatchlist(accountId, sessionId, locale, forceUpdate: true);
  }
}
