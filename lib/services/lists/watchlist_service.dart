import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/workers/uninitialized_titles_worker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/repositories/title_repository.dart';

class WatchlistService extends TmdbTitleListService {
  final SupabaseClient _supabase = Supabase.instance.client;
  TmdbPinnedService? pinnedService;

  WatchlistService(TitleRepository repository)
      : super(AppConstants.watchlist, repository);

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('user_titles')
          .select('tmdb_id, media_type, is_pinned, created_at')
          .eq('list_name', AppConstants.watchlist)
          .order('created_at', ascending: true);

      final localTmdbIds =
          await repository.getAllTmdbIds(AppConstants.watchlist);

      final remoteTmdbIds = <int>[];
      final newTitles = <TmdbTitle>[];
      final addedOrders = <int>[];
      int currentMaxOrder =
          await repository.getMaxAddedOrder(AppConstants.watchlist);

      for (var row in response) {
        final tmdbId = row['tmdb_id'] as int;
        final mediaType = row['media_type'] as String;
        final isPinned = row['is_pinned'] as bool? ?? false;

        remoteTmdbIds.add(tmdbId);

        if (!localTmdbIds.contains(tmdbId)) {
          final newTitle = TmdbTitle(
            tmdbId: tmdbId,
            mediaType: mediaType,
            name: '',
            lastUpdated: DateTime.now().toIso8601String(),
            dateRated: DateTime.now(),
          )..isPinned = isPinned;

          newTitles.add(newTitle);
          currentMaxOrder++;
          addedOrders.add(currentMaxOrder);
        } else {
          final localTitle = repository.getTitleByTmdbIdSync(
              AppConstants.watchlist, tmdbId, mediaType);
          if (localTitle != null && localTitle.isPinned != isPinned) {
            localTitle.isPinned = isPinned;
            await repository.updateIsPinnedList([localTitle]);
          }
        }
      }

      if (newTitles.isNotEmpty) {
        await repository.saveTitles(newTitles, AppConstants.watchlist,
            addedOrders: addedOrders);
        UninitializedTitlesWorker.dispatch();
      }

      final toRemove =
          localTmdbIds.where((id) => !remoteTmdbIds.contains(id)).toList();
      if (toRemove.isNotEmpty) {
        // We fetch the full local title because repository.deleteTitles requires the mediaType array,
        // which isn't provided by getAllTmdbIds.
        final localTitles =
            await repository.getAllTitlesInList(AppConstants.watchlist);
        final titlesToRemove =
            localTitles.where((t) => toRemove.contains(t.tmdbId));
        for (var t in titlesToRemove) {
          await repository
              .deleteTitles(AppConstants.watchlist, [t.tmdbId], [t.mediaType]);
        }
      }

      await filterItems();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error syncing watchlist from Supabase',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> updateWatchlistTitle(
      String accountId, String sessionId, TmdbTitle title, bool add) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      if (add) {
        title.isPinned = false;

        await _supabase.from('user_titles').upsert({
          'user_id': user.id,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'list_name': AppConstants.watchlist,
          'is_pinned': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });

        await updateLocalTitle(title);

        final globalTitle =
            await repository.getTitleGlobal(title.tmdbId, title.mediaType);
        if (globalTitle != null) {
          await repository.updateIsPinnedList([title]);
        }
      } else {
        if (title.isPinned && pinnedService != null) {
          title.isPinned = false;
        }

        await _supabase
            .from('user_titles')
            .delete()
            .eq('user_id', user.id)
            .eq('tmdb_id', title.tmdbId)
            .eq('media_type', title.mediaType)
            .eq('list_name', AppConstants.watchlist);

        await repository.deleteTitles(
            AppConstants.watchlist, [title.tmdbId], [title.mediaType]);
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating watchlist for ${title.name}',
      );
    }
  }

  Future<void> togglePin(TmdbTitle title, {String? limitReachedMessage}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      if (!title.isPinned) {
        final pinnedCount = await repository.countTitlesFiltered(
          listName: listNameVal,
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

      await _supabase
          .from('user_titles')
          .update({
            'is_pinned': title.isPinned,
          })
          .eq('user_id', user.id)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.watchlist);

      await repository.updateIsPinnedList([title]);

      await filterItems(retainPagination: true);
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error toggling pin for ${title.name}',
      );
      title.isPinned = !title.isPinned;
    }
  }
}
