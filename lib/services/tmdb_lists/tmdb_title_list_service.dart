import "package:moviescout/utils/api_constants.dart";
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_genre_service.dart';
import 'package:moviescout/services/workers/uninitialized_titles_worker.dart';
import 'package:moviescout/services/core/update_manager.dart';
import 'package:moviescout/services/workers/update_providers_worker.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbTitleListService extends TmdbBaseListService<TmdbTitle> {
  @protected
  final List<TmdbTitle> pinnedTitlesVal = List.empty(growable: true);
  @protected
  final TitleRepository repository;

  int get loadedTitleCount => loadedItemsVal.length;
  List<TmdbTitle> get pinnedTitles => pinnedTitlesVal;

  bool _userRatingAvailableVal = false;

  static Future<void> _syncQueue = Future.value();

  TmdbTitleListService(String listName, this.repository,
      {List<TmdbTitle>? titles}) {
    listNameVal = listName;
    UninitializedTitlesWorker.onFinished.stream.listen((_) {
      filterItems();
    });
    UpdateProvidersWorker.onFinished.stream.listen((_) {
      filterItems();
    });
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

  @override
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
    await repository.updateTitlesMetadata([title]);
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
    required Future<List<TmdbTitle>> Function() fetchRemoteData,
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

      await _syncWithServer(accountId, fetchRemoteData);

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

  Future<List<TmdbTitle>> _retrieveServerList(
    String accountId,
    Future<List<TmdbTitle>> Function() fetchRemoteData,
  ) async {
    List<TmdbTitle> serverList = List.empty(growable: true);

    final remoteTitles = await fetchRemoteData();

    final allTmdbIds = remoteTitles.map((t) => t.tmdbId).toList();
    final existingTitles = await repository.getTitlesByTmdbIds(allTmdbIds);
    final existingMap = {
      for (var t in existingTitles) '${t.tmdbId}_${t.mediaType}': t
    };

    for (var element in remoteTitles) {
      final existing = existingMap['${element.tmdbId}_${element.mediaType}'];
      if (existing != null) {
        existing.isPinned = element.isPinned;
        existing.rating = element.rating;
        existing.notifyNewSeasons = element.notifyNewSeasons;
        serverList.add(existing);
      } else {
        serverList.add(element);
      }
    }

    return serverList;
  }

  @protected
  Future<void> _syncWithServer(
    String accountId,
    Future<List<TmdbTitle>> Function() fetchRemoteData,
  ) async {
    final dbCount = await repository.countTitlesFiltered(listName: listNameVal);
    final bool isInitialLoad = dbCount == 0;

    if (isInitialLoad) {
      await _clearLocalList();
    }

    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, fetchRemoteData);

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
      final keysToRemove = localKeys.difference(serverKeys);
      final keysToUpdate = serverKeys.intersection(localKeys);

      final titlesToAdd = serverList
          .where((t) => keysToAdd.contains('${t.tmdbId}_${t.mediaType}'))
          .toList();

      if (titlesToAdd.isNotEmpty) {
        int currentMax = await repository.getMaxAddedOrder(listNameVal);
        final addedOrders =
            List.generate(titlesToAdd.length, (i) => currentMax + 1 + i);
        await repository.saveTitles(titlesToAdd, listNameVal,
            addedOrders: addedOrders);
      }

      final titlesToUpdate = serverList
          .where((t) => keysToUpdate.contains('${t.tmdbId}_${t.mediaType}'))
          .toList();

      if (titlesToUpdate.isNotEmpty) {
        if (listNameVal == AppConstants.watchlist) {
          await repository.updateIsPinnedList(titlesToUpdate);
        } else if (listNameVal == AppConstants.rateslist) {
          await repository.updateRatingList(titlesToUpdate);
          await repository.updateNotifyNewSeasonsList(titlesToUpdate);
        }
      }

      if (keysToRemove.isNotEmpty) {
        final entriesToRemove = localEntries
            .where((e) => keysToRemove.contains('${e.tmdbId}_${e.mediaType}'))
            .toList();
        final idsToRemove = entriesToRemove.map((e) => e.tmdbId).toList();
        final mediaTypes = entriesToRemove.map((e) => e.mediaType).toList();
        await repository.deleteTitles(listNameVal, idsToRemove, mediaTypes);
      }

      await filterItems();
    }

    UninitializedTitlesWorker.dispatch();

    await filterItems();
  }

  Future<void> updateProviders() async {
    UpdateProvidersWorker.dispatch(listNameVal);
  }

  @protected
  Future<void> updateLocalTitle(TmdbTitle title) async {
    if (!title.inLists.contains(listNameVal)) {
      title.inLists = title.inLists.toList()..add(listNameVal);
    }
    int currentMax = await repository.getMaxAddedOrder(listNameVal);
    await repository.saveTitles([title], listNameVal,
        addedOrders: [++currentMax]);
  }

  @protected
  Future<void> deleteLocalTitle(TmdbTitle title) async {
    title.inLists = title.inLists.toList()..remove(listNameVal);
    await repository
        .deleteTitles(listNameVal, [title.tmdbId], [title.mediaType]);
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
      filterExcludeGenres: filterExcludeGenres,
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
      filterExcludeGenres: filterExcludeGenres,
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

  @protected
  Future<List<TmdbTitle>> fetchAndMergeTmdbLists({
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    final results = await Future.wait([retrieveMovies(), retrieveTvshows()]);
    final List<TmdbTitle> mapped = [];
    for (var element in results[0]) {
      element[TmdbTitleFields.mediaType] = ApiConstants.movie;
      mapped.add(TmdbTitle.fromMap(title: element));
    }
    for (var element in results[1]) {
      element[TmdbTitleFields.mediaType] = ApiConstants.tv;
      mapped.add(TmdbTitle.fromMap(title: element));
    }
    return mapped;
  }
}
