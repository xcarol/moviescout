import "package:moviescout/services/auth/supabase_auth_service.dart";
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
  String? _lastUserId;

  WatchlistService(TitleRepository repository)
      : super(AppConstants.watchlist, repository);

  void updateAuth(SupabaseAuthService authService) {
    final user = authService.currentUser;
    if (user != null && _lastUserId != user.id) {
      _lastUserId = user.id;
      syncFromServer(
          accountId: user.id, sessionId: '', locale: const Locale('en'));
    } else if (user == null) {
      _lastUserId = null;
    }
  }

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await retrieveList(accountId, forceUpdate: true, fetchRemoteData: () async {
      final response = await _supabase
          .from('user_titles')
          .select('tmdb_id, media_type, is_pinned, created_at')
          .eq('list_name', AppConstants.watchlist)
          .order('created_at', ascending: true);

      final List<TmdbTitle> parsed = [];
      for (var row in response) {
        final newTitle = TmdbTitle(
          tmdbId: row['tmdb_id'] as int,
          mediaType: row['media_type'] as String,
          name: '',
          lastUpdated: AppConstants.defaultDate,
          dateRated: DateTime.parse(AppConstants.defaultDate),
        )..isPinned = row['is_pinned'] as bool? ?? false;
        parsed.add(newTitle);
      }
      return parsed;
    });
    UninitializedTitlesWorker.dispatch();
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
