import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
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
    final currentListId = await getOrFetchListId();
    if (currentListId == null || currentListId.isEmpty) return;

    try {
      final response = await get('/list/$currentListId?page=1',
          version: ApiVersion.v4, accessToken: accessToken);

      if (response.statusCode == 200) {
        final data = body(response);
        final results = data['results'] as List<dynamic>? ?? [];

        final List<String> pinnedIds = [];
        for (var item in results) {
          final mediaType = item['media_type'];
          final id = item['id'];
          pinnedIds.add('$mediaType:$id');
        }

        await _applyPinnedIds(pinnedIds);
        notifyListeners();
      } else if (response.statusCode == 404) {
        listId = ''; // Reset if not found
        await _applyPinnedIds([]);
        notifyListeners();
      }
    } catch (e) {
      // ignore errors quietly for custom lists fetching
    }
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
          final title = await repository.getTitleByTmdbId(
              AppConstants.watchlist, tmdbId, mediaType);
          if (title != null) {
            title.isPinned = true;
            toUpdate[title.id] = title;
          }
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.updateTitlesMetadata(toUpdate.values.toList());
    }
  }

  Future<bool> addPinnedToServer(TmdbTitle title) async {
    String? currentListId = await getOrFetchListId();
    // ensure list exists
    currentListId ??= await createServerList(forced: true);

    if (currentListId == null) return false;

    final requestBody = {
      'items': [
        {
          'media_type': title.mediaType,
          'media_id': title.tmdbId,
        }
      ]
    };

    try {
      final response = await post('list/$currentListId/items', requestBody,
          version: ApiVersion.v4, accessToken: accessToken);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePinnedFromServer(TmdbTitle title) async {
    final currentListId = await getOrFetchListId();
    if (currentListId == null || currentListId.isEmpty) return false;

    final requestBody = {
      'items': [
        {
          'media_type': title.mediaType,
          'media_id': title.tmdbId,
        }
      ]
    };

    try {
      final response = await delete('list/$currentListId/items',
          body: requestBody, version: ApiVersion.v4, accessToken: accessToken);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
