import 'package:moviescout/utils/url_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';

class TmdbWatchlistService extends TmdbTitleListService {
  TmdbPinnedService? pinnedService;

  TmdbWatchlistService(super.listName, super.repository);

  Future<void> retrieveWatchlist(
      String accountId, String sessionId, Locale locale,
      {bool forceUpdate = false}) async {
    await retrieveList(accountId, forceUpdate: forceUpdate,
        retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        return get(
          UrlConstants.tmdbWatchlistMoviesEndpoint
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
          UrlConstants.tmdbWatchlistTvEndpoint
              .replaceFirst('{ACCOUNT_ID}', accountId)
              .replaceFirst('{SESSION_ID}', sessionId)
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );
      });
    });

    if (pinnedService != null) {
      await pinnedService!.fetchAndApplyPinnedTitles();
      await filterItems();
    }
  }

  Future<dynamic> _updateTitleInWatchlistToTmdb(
    String accountId,
    String sessionId,
    int id,
    String mediaType,
    bool add,
  ) async {
    return post(
        UrlConstants.tmdbUpdateWatchlistEndpoint
            .replaceFirst('{ACCOUNT_ID}', accountId)
            .replaceFirst('{SESSION_ID}', sessionId),
        {'media_type': mediaType, 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(
      String accountId, String sessionId, TmdbTitle title, bool add) async {
    try {
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
        return _updateTitleInWatchlistToTmdb(
            accountId, sessionId, title.tmdbId, title.mediaType, add);
      });

      final globalTitle =
          await repository.getTitleGlobal(title.tmdbId, title.mediaType);
      if (add || globalTitle != null) {
        await repository.updateIsPinned(title);
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
    await repository.updateIsPinned(title);

    if (pinnedService != null) {
      if (title.isPinned) {
        await pinnedService!.addPinnedToServer(title);
      } else {
        await pinnedService!.removePinnedFromServer(title);
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
