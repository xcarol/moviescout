import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/update_manager.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

enum RatingFilter { all, rated, seenOnly }

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  @protected
  String listNameVal = '';
  @protected
  final List<TmdbTitle> loadedTitlesVal = List.empty(growable: true);
  @protected
  final List<TmdbTitle> pinnedTitlesVal = List.empty(growable: true);
  String get listName => listNameVal;
  @protected
  bool isDbLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  @protected
  bool hasMoreVal = true;
  bool get hasMore => hasMoreVal;
  @protected
  int pageVal = 0;
  @protected
  final int pageSizeVal = 10;
  @protected
  final TmdbTitleRepository repository;
  @protected
  final PreferencesService preferencesService;

  @protected
  bool anyFilterApplied = false;
  @protected
  int filterRequestId = 0;
  @protected
  String filterText = '';
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
  ValueNotifier<int> selectedTitleCount = ValueNotifier(0);
  int get loadedTitleCount => loadedTitlesVal.length;
  List<TmdbTitle> get pinnedTitles => pinnedTitlesVal;
  @protected
  List<String> listGenresVal = [];
  ValueNotifier<List<String>> listGenres = ValueNotifier([]);

  TmdbListService(String listName, this.repository, this.preferencesService,
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
    return listNameVal == AppConstants.rateslist ||
        (loadedTitlesVal.isNotEmpty && loadedTitlesVal.first.rating > 0.0);
  }

  bool get userRatedDateAvailable {
    return listNameVal == AppConstants.rateslist ||
        (loadedTitlesVal.isNotEmpty &&
            loadedTitlesVal.first.dateRated
                .isAfter(DateTime.fromMillisecondsSinceEpoch(0)));
  }

  @protected
  void resetServiceStateAfterClear() {
    clearLoadedTitles(clearGenreCache: true);
    UpdateManager().removeLastUpdate(listNameVal);
    notifyListeners();
  }

  void clearListSync() {
    repository.clearListSync(listNameVal);
    resetServiceStateAfterClear();
  }

  @protected
  Future<void> clearLocalList() async {
    await repository.clearList(listNameVal);
    resetServiceStateAfterClear();
  }

  Future<void> clearList() async {
    await clearLocalList();
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

  bool contains(TmdbTitle title) {
    return repository.getTitleByTmdbId(
            listNameVal, title.tmdbId, title.mediaType) !=
        null;
  }

  @protected
  void clearLoadedTitles({bool clearGenreCache = false}) {
    if (clearGenreCache) {
      listGenresVal.clear();
    }
    loadedTitlesVal.clear();
    pinnedTitlesVal.clear();
    selectedTitleCount.value = 0;
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

    if (accountId.isEmpty || (listIsNotEmpty && isUpToDate && !forceUpdate)) {
      return;
    }

    isLoading.value = true;

    try {
      await _syncWithServer(
        accountId,
        retrieveMovies,
        retrieveTvshows,
        forceUpdate: forceUpdate,
      );

      await updateListGenres();

      setLastUpdate();
    } catch (error) {
      SnackMessage.showSnackBar('List $listNameVal ERROR: $error');
    } finally {
      isLoading.value = false;
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

    int movieIdx = 0;
    int tvIdx = 0;
    int globalIdx = 0;

    while (movieIdx < movies.length || tvIdx < tv.length) {
      if (movieIdx < movies.length) {
        var element = movies[movieIdx++];
        element[TmdbTitleFields.listName] = listNameVal;
        element[TmdbTitleFields.mediaType] = ApiConstants.movie;
        element[TmdbTitleFields.addedOrder] = globalIdx++;
        serverList.add(TmdbTitle.fromMap(title: element));
      }
      if (tvIdx < tv.length) {
        var element = tv[tvIdx++];
        element[TmdbTitleFields.listName] = listNameVal;
        element[TmdbTitleFields.mediaType] = ApiConstants.tv;
        element[TmdbTitleFields.addedOrder] = globalIdx++;
        serverList.add(TmdbTitle.fromMap(title: element));
      }
    }

    return serverList;
  }

  @protected
  Future<void> _syncWithServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows, {
    bool forceUpdate = false,
  }) async {
    final bool isInitialLoad = listIsEmpty;

    if (isInitialLoad) {
      await clearLocalList();
    }

    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    if (isInitialLoad) {
      await repository.saveTitles(serverList);
    } else {
      final serverIds = serverList.map((t) => t.tmdbId).toSet();
      final localIds = await repository.getAllTmdbIds(listNameVal);
      final localIdSet = localIds.toSet();

      final idsToAdd = serverIds.difference(localIdSet);
      final titlesToAdd =
          serverList.where((t) => idsToAdd.contains(t.tmdbId)).toList();
      final idsToRemove = localIdSet.difference(serverIds);

      if (titlesToAdd.isNotEmpty) {
        int currentMax = repository.getMaxAddedOrderSync(listNameVal);
        for (var title in titlesToAdd) {
          title.addedOrder = ++currentMax;
        }

        final updated = await Future.wait(
            titlesToAdd.map((t) => TmdbTitleService().updateTitleDetails(t)));
        await repository.saveTitles(updated.cast<TmdbTitle>());
      }

      if (idsToRemove.isNotEmpty) {
        await repository.deleteTitles(listNameVal, idsToRemove.toList());
      }
    }

    if (forceUpdate || isInitialLoad) {
      final totalCount = listTitleCount;
      const batchSize = 10;

      for (var i = 0; i < totalCount; i += batchSize) {
        final batch = await repository.getTitles(
          listName: listNameVal,
          offset: i,
          limit: batchSize,
        );

        final updated = await Future.wait(batch.map((t) =>
            TmdbTitleService().updateTitleDetails(t, force: forceUpdate)));

        await repository.saveTitles(updated.cast<TmdbTitle>());
        await Future.delayed(Duration.zero);
      }
    }

    await filterTitles();
  }

  @protected
  Future<void> updateLocalTitle(TmdbTitle title) async {
    if (title.listName.isEmpty) {
      return;
    }

    await repository.saveTitle(title);
  }

  @protected
  Future<void> deleteLocalTitle(TmdbTitle title) async {
    await repository.deleteTitle(listNameVal, title.tmdbId);
  }

  TmdbTitle? getItem(int position) {
    if (position < 0 || position >= loadedTitlesVal.length) {
      return null;
    }
    try {
      return loadedTitlesVal[position];
    } catch (e) {
      debugPrint('Error getting item at position $position: $e');
      return null;
    }
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

  @protected
  Future<void> filterTitles() async {
    while (isDbLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final currentRequestId = ++filterRequestId;

    clearLoadedTitles(clearGenreCache: false);

    anyFilterApplied = true;

    if (listNameVal == AppConstants.watchlist) {
      final pinnedTitles = await _fetchTitles(limit: 10, pinned: true);

      if (currentRequestId != filterRequestId) {
        return;
      }

      pinnedTitlesVal.clear();
      pinnedTitlesVal.addAll(pinnedTitles);
    }

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

    if (currentRequestId != filterRequestId) {
      return;
    }

    selectedTitleCount.value = count +
        (listNameVal == AppConstants.watchlist ? pinnedTitlesVal.length : 0);

    await loadNextPage();
  }

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
    await filterTitles();
  }

  void setTextFilter(String filter) {
    filterText = filter;
    filterTitles();
  }

  void setGenresFilter(List<String> genres) {
    filterGenres = TmdbGenreService().getIdsFromNames(genres);
    filterTitles();
  }

  void setProvidersFilter(bool filterByProviders, List<int> providerIds) {
    this.filterByProviders = filterByProviders;
    filterProvidersIds = providerIds;
    filterTitles();
  }

  void setTypeFilter(String type) {
    filterMediaType = type;
    filterTitles();
  }

  void setRatingFilter(RatingFilter filter) {
    filterRating = filter;
    filterTitles();
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
    filterTitles();
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
        loadedTitlesVal
            .removeWhere((element) => element.tmdbId == title.tmdbId);
      }
      await filterTitles();
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

  TmdbTitle? getTitleByTmdbId(int tmdbId, String mediaType) {
    final memoryTitle = loadedTitlesVal.firstWhereOrNull(
        (t) => t.tmdbId == tmdbId && t.mediaType == mediaType);
    if (memoryTitle != null) return memoryTitle;

    return repository.getTitleByTmdbId(listNameVal, tmdbId, mediaType);
  }

  Future<void> loadNextPage() async {
    if ((isDbLoading) || !hasMoreVal) return;

    isDbLoading = true;

    try {
      if (anyFilterApplied == false) {
        return filterTitles();
      }
      final currentRequestId = ++filterRequestId;

      final titles = await _fetchTitles(
        pinned: listNameVal == AppConstants.watchlist ? false : null,
        offset: pageVal * pageSizeVal,
      );

      if (currentRequestId != filterRequestId) {
        return;
      }

      loadedTitlesVal.addAll(titles);
      pageVal++;
      if (titles.length < pageSizeVal && !isLoading.value) {
        hasMoreVal = false;
      }
    } finally {
      isDbLoading = false;
      if (listGenresVal.isEmpty) {
        await updateListGenres();
      }
      notifyListeners();
    }
  }
}
