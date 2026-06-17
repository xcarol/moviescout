import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/update_manager.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

enum RatingFilter { all, rated, seenOnly, followingOnly }

class TmdbTitleListService extends TmdbBaseListService<TmdbTitle> {
  @protected
  final List<TmdbTitle> pinnedTitlesVal = List.empty(growable: true);
  @protected
  final TmdbTitleRepository repository;

  @protected
  String filterMediaType = '';
  @protected
  List<int> filterGenres = [];
  @protected
  List<int> filterProvidersIds = [];
  @protected
  bool filterByProviders = false;
  @protected
  String selectedSort = SortOption.alphabetically;
  @protected
  bool isSortAsc = true;
  @protected
  RatingFilter filterRating = RatingFilter.all;
  int get loadedTitleCount => loadedItemsVal.length;
  List<TmdbTitle> get pinnedTitles => pinnedTitlesVal;
  String get defaultSort => selectedSort;
  bool get defaultSortAsc => isSortAsc;
  @protected
  List<String> listGenresVal = [];
  ValueNotifier<List<String>> listGenres = ValueNotifier([]);
  bool _userRatingAvailableVal = false;

  static Future<void> _syncQueue = Future.value();

  TmdbTitleListService(String listName, this.repository,
      {List<TmdbTitle>? titles}) {
    listNameVal = listName;
  }

  @protected
  Duration get cacheTimeout {
    if (listNameVal == AppConstants.watchlist) {
      return UpdateManager.watchlistTimeout;
    }
    if (listNameVal == AppConstants.rateslist) {
      return UpdateManager.rateslistTimeout;
    }
    if (listNameVal == AppConstants.discoverlist) {
      return UpdateManager.discoverlistTimeout;
    }
    return const Duration(days: 1);
  }

  @protected
  void setLastUpdate() {
    UpdateManager().updateLastUpdate(listNameVal);
  }

  bool get userRatingAvailable {
    return listNameVal == AppConstants.rateslist || _userRatingAvailableVal;
  }

  @protected
  Future<void> updateUserRatingAvailable() async {
    _userRatingAvailableVal = await repository.hasRatedTitles(listNameVal);
    notifyListeners();
  }

  @protected
  void resetServiceStateAfterClear() {
    clearLoadedItems(clearGenreCache: true, resetCount: true);
    UpdateManager().removeLastUpdate(listNameVal);
    notifyListeners();
  }

  @protected
  Future<void> _clearLocalList() async {
    await repository.clearList(listNameVal);
    resetServiceStateAfterClear();
  }

  Future<void> clearList() async {
    await _clearLocalList();
  }

  bool get listIsEmpty {
    return listTitleCount == 0;
  }

  bool get listIsNotEmpty {
    return !listIsEmpty;
  }

  int get listTitleCount {
    return repository.countTitlesSync(listNameVal);
  }

  Future<bool> contains(TmdbTitle title) async {
    return await repository.getTitleByTmdbId(
            listNameVal, title.tmdbId, title.mediaType) !=
        null;
  }

  Future<void> debugUpdateTitleLastUpdate(TmdbTitle title) async {
    await repository.updateTitleMetadata(title);
    notifyListeners();
  }

  @override
  @protected
  void clearLoadedItems(
      {bool clearGenreCache = false, bool resetCount = false}) {
    if (clearGenreCache) {
      listGenresVal.clear();
    }
    loadedItemsVal.clear();
    pinnedTitlesVal.clear();
    if (resetCount) {
      selectedItemCount.value = 0;
    }
    anyFilterApplied = false;
    hasMoreVal = true;
    pageVal = 0;
  }

  Future<void> retrieveList(
    String accountId, {
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
    bool forceUpdate = false,
  }) async {
    bool isUpToDate = UpdateManager().isUpToDate(listNameVal, cacheTimeout);
    bool hasLocalData = listIsNotEmpty;
    if (!hasLocalData) {
      hasLocalData = await repository.hasTitlesFiltered(listName: listNameVal);
    }

    if (accountId.isEmpty ||
        (hasLocalData && isUpToDate && !forceUpdate) ||
        isLoading.value) {
      if (hasLocalData && loadedItemsVal.isEmpty) {
        await filterItems();
      }
      return;
    }

    isLoading.value = true;

    final predecessor = _syncQueue;
    final completer = Completer<void>();
    _syncQueue = completer.future;

    await predecessor.catchError((_) {});

    try {
      bool isUpToDateNow =
          UpdateManager().isUpToDate(listNameVal, cacheTimeout);
      bool hasLocalDataNow = listIsNotEmpty;
      if (!hasLocalDataNow) {
        hasLocalDataNow =
            await repository.hasTitlesFiltered(listName: listNameVal);
      }

      if (hasLocalDataNow && isUpToDateNow && !forceUpdate) {
        return;
      }

      await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);

      await updateListGenres();

      setLastUpdate();
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating list $listNameVal',
      );
    } finally {
      isLoading.value = false;
      completer.complete();
    }
  }

  Future<dynamic> _retrieveServerList(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList = List.empty(growable: true);

    final results = await Future.wait([
      retrieveMovies(),
      retrieveTvshows(),
    ]);

    final movies = results[0];
    final tv = results[1];

    final allTmdbIds = [
      ...movies.map((m) => m[TmdbTitleFields.id] as int),
      ...tv.map((t) => t[TmdbTitleFields.id] as int),
    ];
    final existingTitles = await repository.getTitlesByTmdbIds(allTmdbIds);
    final existingMap = {
      for (var t in existingTitles) '${t.tmdbId}_${t.mediaType}': t
    };

    int movieIdx = 0;
    int tvIdx = 0;

    while (movieIdx < movies.length || tvIdx < tv.length) {
      if (movieIdx < movies.length) {
        var element = movies[movieIdx++];
        element[TmdbTitleFields.mediaType] = ApiConstants.movie;
        final tmdbId = element[TmdbTitleFields.id] as int;
        final existing = existingMap['${tmdbId}_${ApiConstants.movie}'];
        if (existing != null) {
          existing.fillFromMap(element);
          serverList.add(existing);
        } else {
          serverList.add(TmdbTitle.fromMap(title: element));
        }
      }
      if (tvIdx < tv.length) {
        var element = tv[tvIdx++];
        element[TmdbTitleFields.mediaType] = ApiConstants.tv;
        final tmdbId = element[TmdbTitleFields.id] as int;
        final existing = existingMap['${tmdbId}_${ApiConstants.tv}'];
        if (existing != null) {
          existing.fillFromMap(element);
          serverList.add(existing);
        } else {
          serverList.add(TmdbTitle.fromMap(title: element));
        }
      }
    }

    return serverList;
  }

  @protected
  Future<void> _syncWithServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    final dbCount = await repository.countTitlesFiltered(listName: listNameVal);
    final bool isInitialLoad = dbCount == 0;

    if (isInitialLoad) {
      await _clearLocalList();
    }

    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    if (isInitialLoad) {
      await repository.saveTitles(serverList, listNameVal);
      await filterItems();
    } else {
      final serverKeys =
          serverList.map((t) => '${t.tmdbId}_${t.mediaType}').toSet();
      final localEntries = await repository.getAllEntries(listNameVal);
      final localKeys =
          localEntries.map((e) => '${e.tmdbId}_${e.mediaType}').toSet();

      final keysToAdd = serverKeys.difference(localKeys);
      final titlesToAdd = serverList
          .where((t) => keysToAdd.contains('${t.tmdbId}_${t.mediaType}'))
          .toList();
      final keysToRemove = localKeys.difference(serverKeys);

      if (titlesToAdd.isNotEmpty) {
        int currentMax = await repository.getMaxAddedOrder(listNameVal);
        final updated = await Future.wait(
            titlesToAdd.map((t) => TmdbTitleService().updateTitleDetails(t)));
        await repository.saveTitles(updated.cast<TmdbTitle>(), listNameVal,
            addedOrders: titlesToAdd.map((t) => ++currentMax).toList());
        await filterItems();
      }

      if (keysToRemove.isNotEmpty) {
        final entriesToRemove = localEntries
            .where((e) => keysToRemove.contains('${e.tmdbId}_${e.mediaType}'))
            .toList();
        final idsToRemove = entriesToRemove.map((e) => e.tmdbId).toList();
        final mediaTypes = entriesToRemove.map((e) => e.mediaType).toList();
        await repository.deleteTitles(listNameVal, idsToRemove, mediaTypes);
        await filterItems();
      }
    }

    if (isInitialLoad) {
      final totalCount = listTitleCount;
      const batchSize = AppConstants.tinyBatchSize;

      for (var i = 0; i < totalCount; i += batchSize) {
        final batch = await repository.getTitles(
          listName: listNameVal,
          offset: i,
          limit: batchSize,
          sortOption: SortOption.addedOrder,
          sortAscending: true,
        );

        final updated = await Future.wait(
            batch.map((t) => TmdbTitleService().updateTitleDetails(t)));

        int startOrder = i;
        await repository.saveTitles(updated.cast<TmdbTitle>(), listNameVal,
            addedOrders: batch.map((t) => startOrder++).toList());

        await Future.delayed(Duration.zero);
      }
    }

    await filterItems();
  }

  Future<void> updateProviders() async {
    isLoading.value = true;
    try {
      final totalCount = listTitleCount;
      const batchSize = AppConstants.tinyBatchSize;

      for (var i = 0; i < totalCount; i += batchSize) {
        final batch = await repository.getTitles(
          listName: listNameVal,
          offset: i,
          limit: batchSize,
        );

        final updated = await Future.wait(
            batch.map((t) => TmdbTitleService().updateTitleProviders(t)));

        await repository.updateTitlesMetadata(updated.cast<TmdbTitle>());
        await Future.delayed(Duration.zero);
      }

      await filterItems();
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating platform availability',
      );
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  @protected
  Future<void> updateLocalTitle(TmdbTitle title) async {
    int currentMax = await repository.getMaxAddedOrder(listNameVal);
    await repository.saveTitle(title, listNameVal, ++currentMax);
  }

  @protected
  Future<void> deleteLocalTitle(TmdbTitle title) async {
    await repository.deleteTitle(listNameVal, title.tmdbId, title.mediaType);
  }

  @protected
  Future<List<TmdbTitle>> _fetchTitles({
    int offset = 0,
    int? limit,
    bool? pinned,
  }) {
    return repository.getTitles(
      listName: listNameVal,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      sortOption: selectedSort,
      sortAscending: isSortAsc,
      filterRating: filterRating,
      pinned: pinned,
      offset: offset,
      limit: limit ?? pageSizeVal,
    );
  }

  @override
  @protected
  Future<void> preFilterItems(int requestId) async {
    if (listNameVal == AppConstants.watchlist) {
      final pinnedTitles = await _fetchTitles(limit: 10, pinned: true);

      if (requestId != filterRequestId) {
        return;
      }

      pinnedTitlesVal.clear();
      pinnedTitlesVal.addAll(pinnedTitles);
    }
  }

  @override
  @protected
  Future<void> postFilterItems() async {
    await updateUserRatingAvailable();
    if (listGenresVal.isEmpty) {
      await updateListGenres();
    }
  }

  @override
  @protected
  Future<int> countFilteredItems() async {
    final count = await repository.countTitlesFiltered(
      listName: listNameVal,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: listNameVal == AppConstants.watchlist ? false : null,
    );
    return count +
        (listNameVal == AppConstants.watchlist ? pinnedTitlesVal.length : 0);
  }

  @override
  @protected
  Future<List<TmdbTitle>> fetchItems(
      {required int offset, required int limit}) async {
    return await _fetchTitles(
      pinned: listNameVal == AppConstants.watchlist ? false : null,
      offset: offset,
      limit: limit,
    );
  }

  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {}

  Future<void> setFilters(
      {String text = '',
      String type = '',
      List<String> genres = const [],
      bool filterByProviders = false,
      List<int> providerListIds = const [],
      RatingFilter ratingFilter = RatingFilter.all,
      String sort = SortOption.alphabetically,
      bool ascending = true}) async {
    filterText = text;
    filterMediaType = type;
    filterGenres = TmdbGenreService().getIdsFromNames(genres);
    this.filterByProviders = filterByProviders;
    filterProvidersIds = providerListIds;
    filterRating = ratingFilter;
    selectedSort = sort;
    isSortAsc = computeSortDirection(sort, ascending);
    await filterItems();
  }

  void setGenresFilter(List<String> genres) {
    filterGenres = TmdbGenreService().getIdsFromNames(genres);
    filterItems();
  }

  void setProvidersFilter(bool filterByProviders, List<int> providerIds) {
    this.filterByProviders = filterByProviders;
    filterProvidersIds = providerIds;
    filterItems();
  }

  void setTypeFilter(String type) {
    filterMediaType = type;
    filterItems();
  }

  void setRatingFilter(RatingFilter filter) {
    filterRating = filter;
    filterItems();
  }

  @protected
  bool computeSortDirection(String sort, bool ascending) {
    switch (sort) {
      case SortOption.alphabetically:
        return ascending;
      case SortOption.rating:
      case SortOption.userRating:
      case SortOption.releaseDate:
      case SortOption.dateRated:
      case SortOption.runtime:
      case SortOption.addedOrder:
        return !ascending;
      default:
        return ascending;
    }
  }

  void setSort(String sort, bool ascending) {
    selectedSort = sort;
    isSortAsc = computeSortDirection(sort, ascending);
    filterItems();
  }

  Future<void> updateTitle(
    String accountId,
    String sessionId,
    TmdbTitle title,
    bool add,
    Future<dynamic> Function(
      String accountId,
      String sessionId,
    ) updateTitleToServer,
  ) async {
    final result = await updateTitleToServer(accountId, sessionId);
    if (result.statusCode == 200 || result.statusCode == 201) {
      if (add) {
        await updateLocalTitle(title);
      } else {
        await deleteLocalTitle(title);
        loadedItemsVal.removeWhere((element) => element.tmdbId == title.tmdbId);
      }
      await filterItems(retainPagination: true);
      setLastUpdate();
      await updateListGenres();

      notifyListeners();
    } else {
      throw Exception(
          'Failed to update titleId: ${title.tmdbId}. Status code: ${result.statusCode} - ${result.body}');
    }
  }

  Future<List> getTitlesFromServer(
      Future<dynamic> Function(int) getTitles) async {
    int page = 1, pages = 1;
    List titles = List.empty(growable: true);
    do {
      dynamic response = await getTitles(page);
      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          pages = responseBody['total_pages'];
        }
        if (responseBody['results'] != null) {
          titles.addAll(responseBody['results']);
        }
      }
    } while (page++ < pages);

    return titles;
  }

  @protected
  Future<void> updateListGenres() async {
    listGenresVal.clear();
    final genreSets = await repository.getAllGenreIds(listNameVal);

    final uniqueGenres = genreSets.expand((ids) => ids).toSet().toList();
    listGenresVal = TmdbGenreService().getNamesFromIds(uniqueGenres);
    listGenresVal.sort();
    listGenres.value = [...listGenresVal];
  }

  Future<TmdbTitle?> getTitleByTmdbId(int tmdbId, String mediaType) async {
    final memoryTitle = loadedItemsVal.firstWhereOrNull(
        (t) => t.tmdbId == tmdbId && t.mediaType == mediaType);
    if (memoryTitle != null) return memoryTitle;

    return repository.getTitleByTmdbId(listNameVal, tmdbId, mediaType);
  }

  TmdbTitle? getTitleByTmdbIdSync(int tmdbId, String mediaType) {
    final memoryTitle = loadedItemsVal.firstWhereOrNull(
        (t) => t.tmdbId == tmdbId && t.mediaType == mediaType);
    if (memoryTitle != null) return memoryTitle;

    return repository.getTitleByTmdbIdSync(listNameVal, tmdbId, mediaType);
  }
}
