import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbTitleRepository {
  final _isar = IsarService.instance;

  Future<void> saveTitle(
      TmdbTitle title, String listName, int addedOrder) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.put(title);
      await _isar.userListEntrys.put(UserListEntry(
        listName: listName,
        tmdbId: title.tmdbId,
        addedOrder: addedOrder,
      ));
    });
  }

  Future<void> saveTitles(List<TmdbTitle> titles, String listName,
      {List<int>? addedOrders}) async {
    if (titles.isEmpty) return;

    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.putAll(titles);
      final entries = <UserListEntry>[];
      for (var i = 0; i < titles.length; i++) {
        entries.add(UserListEntry(
          listName: listName,
          tmdbId: titles[i].tmdbId,
          addedOrder: addedOrders != null ? addedOrders[i] : i,
        ));
      }
      await _isar.userListEntrys.putAll(entries);
    });
  }

  Future<void> updateTitleMetadata(TmdbTitle title) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.put(title);
    });
  }

  Future<void> updateTitlesMetadata(List<TmdbTitle> titles) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.putAll(titles);
    });
  }

  Future<void> deleteTitle(String listName, int tmdbId) async {
    await _isar.writeTxn(() async {
      await _isar.userListEntrys
          .filter()
          .listNameEqualTo(listName)
          .tmdbIdEqualTo(tmdbId)
          .deleteAll();

      final remainsInAnyList =
          await _isar.userListEntrys.filter().tmdbIdEqualTo(tmdbId).count() > 0;

      if (!remainsInAnyList) {
        await _isar.tmdbTitles.filter().tmdbIdEqualTo(tmdbId).deleteAll();
      }
    });
  }

  Future<void> deleteTitles(String listName, List<int> tmdbIds) async {
    await _isar.writeTxn(() async {
      for (final id in tmdbIds) {
        await _isar.userListEntrys
            .filter()
            .listNameEqualTo(listName)
            .tmdbIdEqualTo(id)
            .deleteAll();

        final remainsInAnyList =
            await _isar.userListEntrys.filter().tmdbIdEqualTo(id).count() > 0;

        if (!remainsInAnyList) {
          await _isar.tmdbTitles.filter().tmdbIdEqualTo(id).deleteAll();
        }
      }
    });
  }

  Future<void> clearList(String listName) async {
    await _isar.writeTxn(() async {
      final idsToRemove = await _isar.userListEntrys
          .filter()
          .listNameEqualTo(listName)
          .tmdbIdProperty()
          .findAll();

      await _isar.userListEntrys.filter().listNameEqualTo(listName).deleteAll();

      for (final id in idsToRemove) {
        final remainsInAnyList =
            await _isar.userListEntrys.filter().tmdbIdEqualTo(id).count() > 0;
        if (!remainsInAnyList) {
          await _isar.tmdbTitles.filter().tmdbIdEqualTo(id).deleteAll();
        }
      }
    });
  }

  void clearListSync(String listName) {
    _isar.writeTxnSync(() {
      final idsToRemove = _isar.userListEntrys
          .filter()
          .listNameEqualTo(listName)
          .tmdbIdProperty()
          .findAllSync();

      _isar.userListEntrys.filter().listNameEqualTo(listName).deleteAllSync();

      for (final id in idsToRemove) {
        final remainsInAnyList =
            _isar.userListEntrys.filter().tmdbIdEqualTo(id).countSync() > 0;
        if (!remainsInAnyList) {
          _isar.tmdbTitles.filter().tmdbIdEqualTo(id).deleteAllSync();
        }
      }
    });
  }

  Future<bool> hasRatedTitles(String listName) async {
    final idsInList = await getAllTmdbIds(listName);

    if (idsInList.isEmpty) return false;

    final count = await _isar.tmdbTitles
            .where()
            .anyOf(idsInList, (q, id) => q.tmdbIdEqualTo(id))
            .filter()
            .ratingGreaterThan(AppConstants.seenRating)
            .count();
    return count > 0;
  }

  int countTitlesSync(String listName) {
    return _isar.userListEntrys.filter().listNameEqualTo(listName).countSync();
  }

  int getMaxAddedOrderSync(String listName) {
    final entry = _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .sortByAddedOrderDesc()
        .findFirstSync();
    return entry?.addedOrder ?? -1;
  }

  TmdbTitle? getTitleByTmdbId(String listName, int tmdbId, String mediaType) {
    final inList = _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .tmdbIdEqualTo(tmdbId)
        .findFirstSync();

    if (inList == null) return null;

    return _isar.tmdbTitles
        .filter()
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirstSync();
  }

  Future<TmdbTitle?> getTitleGlobal(int tmdbId) async {
    return _isar.tmdbTitles.filter().tmdbIdEqualTo(tmdbId).findFirst();
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    return _isar.tmdbTitles
        .filter()
        .anyOf(tmdbIds, (q, id) => q.tmdbIdEqualTo(id))
        .findAll();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    return _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .tmdbIdProperty()
        .findAll();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    final ids = await getAllTmdbIds(listName);
    if (ids.isEmpty) return [];
    return _isar.tmdbTitles
        .filter()
        .anyOf(ids, (q, id) => q.tmdbIdEqualTo(id))
        .genreIdsProperty()
        .findAll();
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> _buildQuery(
    List<int> idsInList, {
    bool? pinned,
    String filterText = '',
    List<int> filterGenres = const [],
    String filterMediaType = '',
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
  }) {
    var query = _isar.tmdbTitles
        .filter()
        .anyOf(idsInList, (q, id) => q.tmdbIdEqualTo(id));

    if (pinned != null) {
      query = query.isPinnedEqualTo(pinned);
    }

    if (filterText.isNotEmpty) {
      query = query.group((q) => q
          .nameContains(filterText, caseSensitive: false)
          .or()
          .originalNameContains(filterText, caseSensitive: false)
          .or()
          .overviewContains(filterText, caseSensitive: false)
          .or()
          .taglineContains(filterText, caseSensitive: false));
    }

    if (filterGenres.isNotEmpty) {
      query =
          query.anyOf(filterGenres, (q, id) => q.genreIdsElementEqualTo(id));
    }

    if (filterMediaType.isNotEmpty) {
      query = query.mediaTypeEqualTo(filterMediaType);
    }

    if (filterByProviders && filterProvidersIds.isNotEmpty) {
      query = query.anyOf(filterProvidersIds,
          (q, id) => q.flatrateProviderIdsElementEqualTo(id));
    }

    if (filterRating == RatingFilter.rated) {
      query = query.ratingGreaterThan(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.seenOnly) {
      query = query.ratingEqualTo(AppConstants.seenRating);
    }

    return query;
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> _applySort(
    QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> query,
    String sortOption,
    bool sortAscending,
  ) {
    switch (sortOption) {
      case SortOption.rating:
        return sortAscending
            ? query.sortByVoteAverage()
            : query.sortByVoteAverageDesc();
      case SortOption.userRating:
        return sortAscending ? query.sortByRating() : query.sortByRatingDesc();
      case SortOption.dateRated:
        return sortAscending
            ? query.sortByDateRated()
            : query.sortByDateRatedDesc();
      case SortOption.releaseDate:
        return sortAscending
            ? query.sortByEffectiveReleaseDate()
            : query.sortByEffectiveReleaseDateDesc();
      case SortOption.runtime:
        return sortAscending
            ? query.sortByIsMovieDesc().thenByEffectiveRuntime()
            : query.sortByIsMovieDesc().thenByEffectiveRuntimeDesc();
      case SortOption.alphabetically:
      default:
        return sortAscending ? query.sortByName() : query.sortByNameDesc();
    }
  }

  Future<List<TmdbTitle>> _getTitlesSortedByAddedOrder({
    required String listName,
    required List<int> idsInList,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
    bool sortAscending = true,
    int offset = 0,
    int limit = 10,
  }) async {
    final eligibleIds = await _buildQuery(
      idsInList,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).tmdbIdProperty().findAll();

    if (eligibleIds.isEmpty) return [];

    final entryQuery = _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .anyOf(eligibleIds, (q, id) => q.tmdbIdEqualTo(id));

    final sortedEntries = sortAscending
        ? await entryQuery
            .sortByAddedOrder()
            .offset(offset)
            .limit(limit)
            .findAll()
        : await entryQuery
            .sortByAddedOrderDesc()
            .offset(offset)
            .limit(limit)
            .findAll();

    final pagedIds = sortedEntries.map((e) => e.tmdbId).toList();
    if (pagedIds.isEmpty) return [];

    final pagedTitles = await _isar.tmdbTitles
        .filter()
        .anyOf(pagedIds, (q, id) => q.tmdbIdEqualTo(id))
        .findAll();

    final titlesMap = {for (var t in pagedTitles) t.tmdbId: t};
    return pagedIds.map((id) => titlesMap[id]!).toList();
  }

  Future<List<TmdbTitle>> getTitles({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    String sortOption = SortOption.alphabetically,
    bool sortAscending = true,
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
    int offset = 0,
    int limit = 10,
  }) async {
    final idsInList = await getAllTmdbIds(listName);
    if (idsInList.isEmpty) return [];

    if (sortOption == SortOption.addedOrder) {
      return _getTitlesSortedByAddedOrder(
        listName: listName,
        idsInList: idsInList,
        filterText: filterText,
        filterMediaType: filterMediaType,
        filterGenres: filterGenres,
        filterByProviders: filterByProviders,
        filterProvidersIds: filterProvidersIds,
        filterRating: filterRating,
        pinned: pinned,
        sortAscending: sortAscending,
        offset: offset,
        limit: limit,
      );
    }

    var query = _buildQuery(
      idsInList,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    );

    final sortedQuery = _applySort(query, sortOption, sortAscending);
    return sortedQuery.offset(offset).limit(limit).findAll();
  }

  Future<int> countTitlesFiltered({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
  }) async {
    final idsInList = await getAllTmdbIds(listName);
    if (idsInList.isEmpty) return 0;

    return _buildQuery(
      idsInList,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).count();
  }
}
