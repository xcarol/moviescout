import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_config_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbPinnedService extends TmdbConfigListService {
  final TmdbTitleRepository repository;

  TmdbPinnedService(this.repository)
      : super(
          configListName: 'pinned',
          listIdPrefKey: 'pinnedListId',
        );

  void clearPinnedStatus() {
    clearConfig();
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    setupBase(accountId, sessionId, accessToken);
  }

  Future<void> fetchAndApplyPinnedTitles() async {
    final pinnedString = await fetchConfigFromServer();

    if (pinnedString == null) {
      return;
    }

    if (pinnedString.isEmpty) {
      await _applyPinnedIds([]);
      return;
    }

    final pinnedIds =
        pinnedString.split(',').where((s) => s.isNotEmpty).toList();

    await _applyPinnedIds(pinnedIds);
    notifyListeners();
  }

  Future<void> _applyPinnedIds(List<String> pinnedIds) async {
    final currentPinned = await repository.getTitles(
      listName: AppConstants.watchlist,
      pinned: true,
    );

    final Map<int, TmdbTitle> toUpdate = {};

    // Reset current pins
    for (var title in currentPinned) {
      title.isPinned = false;
      toUpdate[title.id] = title;
    }

    // Set new pins
    for (var item in pinnedIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          final title = repository.getTitleByTmdbId(
              AppConstants.watchlist, tmdbId, mediaType);
          if (title != null) {
            title.isPinned = true;
            toUpdate[title.id] = title;
          }
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.saveTitles(toUpdate.values.toList());
    }
  }

  Future<String> _pinnedToString() async {
    final pinnedTitles = await repository.getTitles(
      listName: AppConstants.watchlist,
      pinned: true,
    );
    return pinnedTitles.map((t) => '${t.mediaType}:${t.tmdbId}').join(',');
  }

  Future<bool> updatePinnedToServer() async {
    final description = await _pinnedToString();
    return updateConfigToServer(
      description,
      userErrorMessage: 'Error updating pinned to server',
    );
  }
}
