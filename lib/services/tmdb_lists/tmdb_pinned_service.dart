import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_config_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbPinnedService extends TmdbConfigListService {
  final TmdbTitleRepository repository;

  TmdbPinnedService(this.repository)
      : super(
          configListName: 'pinned',
          listIdPrefKey: 'pinnedListId',
          firestoreFieldName: 'pinnedIds',
        );

  void clearPinnedStatus() {
    clearConfig();
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    setupBase(accountId, sessionId, accessToken);
  }

  // Renamed to act as the trigger for the watchlist
  Future<void> fetchAndApplyPinnedTitles() async {
    await fetchAndListen();
  }

  @override
  Future<dynamic> migrateDataFromTmdb() async {
    final currentListId = await getOrFetchListId();
    if (currentListId == null || currentListId.isEmpty) return <String>[];

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
        return pinnedIds;
      }
    } catch (e) {
      // Catch silently for migration
    }
    return <String>[];
  }

  @override
  Future<void> applyData(dynamic data) async {
    if (data is! List) return;
    final List<String> pinnedIds = List<String>.from(data);

    final currentPinned = await repository.getTitles(
      listName: AppConstants.watchlist,
      pinned: true,
    );

    final Map<String, TmdbTitle> toUpdate = {};

    // Reset current pins
    for (var title in currentPinned) {
      title.isPinned = false;
      toUpdate['${title.tmdbId}_${title.mediaType}'] = title;
    }

    // Set new pins
    for (var item in pinnedIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          var title = await repository.getTitleByTmdbId(
              AppConstants.watchlist, tmdbId, mediaType);
          title ??= TmdbTitle(
              tmdbId: tmdbId,
              name: '',
              mediaType: mediaType,
              dateRated: DateTime.fromMillisecondsSinceEpoch(0),
              lastUpdated: AppConstants.defaultDate);
          title.isPinned = true;
          toUpdate['${title.tmdbId}_${title.mediaType}'] = title;
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.updateIsPinnedList(toUpdate.values.toList());
      notifyListeners();
    }
  }

  Future<bool> addPinnedToServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', true);
  }

  Future<bool> removePinnedFromServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', false);
  }
}
