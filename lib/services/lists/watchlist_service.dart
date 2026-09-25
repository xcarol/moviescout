import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/repositories/title_repository.dart';

import 'package:moviescout/services/legacy/legacy_watchlist_service.dart';

class WatchlistService extends TmdbTitleListService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LegacyWatchlistService _legacyService;

  TmdbPinnedService? pinnedService;
  String? _lastUserId;

  WatchlistService(TitleRepository repository, this._legacyService)
      : super(AppConstants.watchlist, repository);

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      if (accountId.isEmpty || sessionId.isEmpty) return;
      return await _legacyService.syncFromServer(
        accountId: accountId,
        sessionId: sessionId,
        locale: locale,
      );
    }

    await retrieveList(accountId, forceUpdate: true, fetchRemoteData: () async {
      final List<TmdbTitle> parsed = [];
      int start = 0;
      const int limit = 1000;
      bool hasMore = true;

      while (hasMore) {
        final response = await _supabase
            .from('user_titles')
            .select(
                'tmdb_id, media_type, is_pinned, created_at, name, poster_path, vote_average')
            .eq('list_name', AppConstants.watchlist)
            .order('created_at', ascending: true)
            .range(start, start + limit - 1);

        for (var row in response) {
          final newTitle = TmdbTitle(
            tmdbId: row['tmdb_id'] as int,
            mediaType: row['media_type'] as String,
            name: row['name'] as String? ?? '',
            posterPathSuffix: row['poster_path'] as String?,
            voteAverage: (row['vote_average'] as num?)?.toDouble() ?? 0.0,
            lastUpdated: AppConstants.defaultDate,
            dateRated: DateTime.parse(AppConstants.defaultDate),
          )..isPinned = row['is_pinned'] as bool? ?? false;
          parsed.add(newTitle);
        }

        if (response.length < limit) {
          hasMore = false;
        } else {
          start += limit;
        }
      }
      return parsed;
    });

    if (pinnedService != null) {
      await pinnedService!.fetchAndApplyPinnedTitles();
      await filterItems();
    }
  }

  Future<void> _updateTitleInWatchlistToSupabase(
      String userId, TmdbTitle title, bool add) async {
    if (add) {
      await _supabase.from('user_titles').upsert({
        'user_id': userId,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'list_name': AppConstants.watchlist,
        'is_pinned': false,
        'name': title.name,
        'poster_path': title.posterPathSuffix,
        'vote_average': title.voteAverage,
      }, onConflict: 'user_id, tmdb_id, media_type, list_name');
    } else {
      await _supabase
          .from('user_titles')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.watchlist);
    }
  }

  Future<void> updateWatchlistTitle(
      String accountId, String sessionId, TmdbTitle title, bool add) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (accountId.isEmpty || sessionId.isEmpty) return;
        return await _legacyService.updateWatchlistTitle(
            accountId, sessionId, title, add);
      }

      if (add) {
        title.isPinned = false;
      } else {
        if (title.isPinned && pinnedService != null) {
          await pinnedService!.removePinnedFromServer(title);
          title.isPinned = false;
        }
      }

      await updateTitle(accountId, sessionId, title, add,
          (String accountId, String sessionId) async {
        await _updateTitleInWatchlistToSupabase(user.id, title, add);

        final globalTitle =
            await repository.getTitleGlobal(title.tmdbId, title.mediaType);
        if (add || globalTitle != null) {
          await repository.updateIsPinnedList([title]);
        }

        return http.Response('', 200);
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
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return await _legacyService.togglePin(title,
            limitReachedMessage: limitReachedMessage);
      }

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
      await repository.updateIsPinnedList([title]);

      if (title.isPinned) {
        await pinnedService?.addPinnedToServer(title);
      } else {
        await pinnedService?.removePinnedFromServer(title);
      }

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
}
