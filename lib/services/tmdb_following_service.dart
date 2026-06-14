import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_config_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;

class TmdbFollowingService extends TmdbConfigListService {
  final TmdbTitleRepository repository;

  TmdbFollowingService(this.repository)
      : super(
          configListName: 'snoozed',
          listIdPrefKey: 'snoozedListId',
          firestoreFieldName: 'snoozedIds',
        );

  void clearSnoozedStatus() {
    clearConfig();
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    setupBase(accountId, sessionId, accessToken);
  }

  // Renamed to act as the trigger for the rateslist
  Future<void> fetchAndApplySnoozedTitles() async {
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

        final List<String> snoozedIds = [];
        for (var item in results) {
          final mediaType = item['media_type'];
          final id = item['id'];
          snoozedIds.add('$mediaType:$id');
        }
        return snoozedIds;
      }
    } catch (e) {
      // Catch silently for migration
    }
    return <String>[];
  }

  @override
  Future<void> applyData(dynamic data) async {
    if (data is! List) return;
    final List<String> snoozedIds = List<String>.from(data);

    final currentSnoozed = await repository.getTitles(
      listName: AppConstants.rateslist,
      filterRating: RatingFilter.followingOnly,
    );

    final Map<int, TmdbTitle> toUpdate = {};

    // Reset current snoozes
    for (var title in currentSnoozed) {
      title.notifyNewSeasons = false;
      toUpdate[title.id] = title;
    }

    // Set new snoozes
    for (var item in snoozedIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          final title = await repository.getTitleByTmdbId(
              AppConstants.rateslist, tmdbId, mediaType);
          if (title != null) {
            title.notifyNewSeasons = true;
            toUpdate[title.id] = title;
          }
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.updateTitlesMetadata(toUpdate.values.toList());
      notifyListeners();
    }
  }

  Future<bool> addSnoozedToServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', true);
  }

  Future<bool> removeSnoozedFromServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', false);
  }
}
