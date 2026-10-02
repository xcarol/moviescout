import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/lists/pinned_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class WatchlistService extends TmdbTitleListService {
  final CloudTitleRepository _cloudRepository;

  PinnedService? pinnedService;
  String? _lastUserId;

  WatchlistService(
    LocalTitleRepository repository, {
    CloudTitleRepository? cloudRepository,
  })  : _cloudRepository = cloudRepository ?? CloudTitleRepository(),
        super(AppConstants.watchlist, repository);

  @override
  Future<void> syncFromServer({
    Locale? locale,
  }) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) return;

    await retrieveList(
        forceUpdate: true,
        fetchRemoteData: () async {
          final List<TmdbTitle> parsed = [];
          int start = 0;
          const int limit = 1000;
          bool hasMore = true;

          while (hasMore) {
            final titles = await _cloudRepository.fetchUserTitles(
              userId: user.id,
              listName: AppConstants.watchlist,
              start: start,
              limit: limit,
            );

            parsed.addAll(titles);

            if (titles.length < limit) {
              hasMore = false;
            } else {
              start += limit;
            }
          }
          return parsed;
        });
  }

  Future<void> _updateTitleInWatchlistToSupabase(
      String userId, TmdbTitle title, bool add) async {
    if (add) {
      await _cloudRepository.upsertWatchlistTitle(
        userId: userId,
        title: title,
      );
    } else {
      await _cloudRepository.deleteWatchlistTitle(
        userId: userId,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
      );
    }
  }

  Future<void> updateWatchlistTitle(TmdbTitle title, bool add) async {
    try {
      final user = CloudDatabaseService.currentUser;
      if (user == null) return;

      if (add) {
        title.isPinned = false;
      } else {
        if (title.isPinned && pinnedService != null) {
          await pinnedService!.removePinnedFromServer(title);
          title.isPinned = false;
        }
      }

      await updateTitle(title, add, () async {
        await _updateTitleInWatchlistToSupabase(user.id, title, add);

        final globalTitle =
            await repository.getTitleGlobal(title.tmdbId, title.mediaType);
        if (add || globalTitle != null) {
          await repository.updateIsPinnedList([title]);
        }

        return true;
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
      final user = CloudDatabaseService.currentUser;
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
              showSnackBar: true,
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
      syncFromServer();
    } else if (user == null) {
      _lastUserId = null;
    }
  }
}
