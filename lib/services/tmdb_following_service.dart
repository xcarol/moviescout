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
          configListName: 'snoozed', // Keep legacy TMDB list name for migration
          listIdPrefKey: 'followingListId',
          firestoreFieldName: 'followingIds',
        );

  void clearFollowingStatus() {
    clearConfig();
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    setupBase(accountId, sessionId, accessToken);
  }

  Future<void> fetchAndApplyFollowingTitles() async {
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

        final List<String> followingIds = [];
        for (var item in results) {
          final mediaType = item['media_type'];
          final id = item['id'];
          followingIds.add('$mediaType:$id');
        }
        return followingIds;
      }
    } catch (e) {
      // Catch silently for migration
    }
    return <String>[];
  }

  @override
  Future<void> applyData(dynamic data) async {
    if (data is! List) return;
    final List<String> followingIds = List<String>.from(data);

    final currentFollowing = await repository.getTitles(
      listName: AppConstants.rateslist,
      filterRating: RatingFilter.followingOnly,
    );

    final Map<String, TmdbTitle> toUpdate = {};

    // Reset current following
    for (var title in currentFollowing) {
      title.notifyNewSeasons = false;
      toUpdate['${title.tmdbId}_${title.mediaType}'] = title;
    }

    // Set new following
    for (var item in followingIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          var title = await repository.getTitleByTmdbId(
              AppConstants.rateslist, tmdbId, mediaType);
          title ??= TmdbTitle(
              tmdbId: tmdbId,
              name: '',
              mediaType: mediaType,
              dateRated: DateTime.fromMillisecondsSinceEpoch(0),
              lastUpdated: AppConstants.defaultDate)
            ..inLists = [AppConstants.rateslist];
          title.notifyNewSeasons = true;
          toUpdate['${title.tmdbId}_${title.mediaType}'] = title;
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.updateNotifyNewSeasonsList(toUpdate.values.toList());
      notifyListeners();
    }
  }

  Future<bool> addFollowingToServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', true);
  }

  Future<bool> removeFollowingFromServer(TmdbTitle title) async {
    return await updateArrayInFirebase(
        '${title.mediaType}:${title.tmdbId}', false);
  }
}
