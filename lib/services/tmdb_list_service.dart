import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _listName = '';
  String _lastUpdate = '';
  final List<TmdbTitle> _loadedTitles = List.empty(growable: true);
  String get listName => _listName;
  bool _isDbLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int _page = 0;
  final int _pageSize = 10;
  @protected
  final TmdbTitleRepository repository;
  @protected
  final PreferencesService preferencesService;

  bool _anyFilterApplied = false;
  int _filterRequestId = 0;
  String _filterText = '';
  String _filterMediaType = '';
  List<int> _filterGenres = [];
  List<int> _filterProvidersIds = [];
  bool _filterByProviders = false;
  String _selectedSort = SortOption.alphabetically;
  bool _isSortAsc = true;
  ValueNotifier<int> selectedTitleCount = ValueNotifier(0);
  int get loadedTitleCount => _loadedTitles.length;
  List<String> _listGenres = [];
  ValueNotifier<List<String>> listGenres = ValueNotifier([]);

  static const defaultLastUpdate = 24; // hours
  static const updateTimeout = 10; // hours

  TmdbListService(String listName, this.repository, this.preferencesService,
      {List<TmdbTitle>? titles}) {
    _listName = listName;
    _lastUpdate = preferencesService.prefs
            .getString('$_listName${AppConstants.lastUpdateSuffix}') ??
        DateTime.now()
            .subtract(const Duration(hours: defaultLastUpdate))
            .toIso8601String();
  }

  void _setLastUpdate() {
    _lastUpdate = DateTime.now().toIso8601String();
    preferencesService.prefs
        .setString('$_listName${AppConstants.lastUpdateSuffix}', _lastUpdate);
  }

  bool get userRatingAvailable {
    return _loadedTitles.isNotEmpty && _loadedTitles.first.rating > 0.0;
  }

  bool get userRatedDateAvailable {
    return _loadedTitles.isNotEmpty &&
        _loadedTitles.first.dateRated
            .isAfter(DateTime.fromMillisecondsSinceEpoch(0));
  }

  void _resetServiceStateAfterClear() {
    _clearLoadedTitles(clearGenreCache: true);
    preferencesService.prefs
        .remove('$_listName${AppConstants.lastUpdateSuffix}');
    notifyListeners();
  }

  void clearListSync() {
    repository.clearListSync(_listName);
    _resetServiceStateAfterClear();
  }

  Future<void> _clearLocalList() async {
    await repository.clearList(_listName);
    _resetServiceStateAfterClear();
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
    return repository.countTitlesSync(_listName);
  }

  bool contains(TmdbTitle title) {
    return repository.getTitleByTmdbId(
            _listName, title.tmdbId, title.mediaType) !=
        null;
  }

  void _clearLoadedTitles({bool clearGenreCache = false}) {
    if (clearGenreCache) {
      _listGenres.clear();
    }
    _loadedTitles.clear();
    selectedTitleCount.value = 0;
    _anyFilterApplied = false;
    _hasMore = true;
    _page = 0;
  }

  Future<void> retrieveList(
    String accountId, {
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(_lastUpdate)).inHours <
            updateTimeout;

    if (accountId.isEmpty || (listIsNotEmpty && isUpToDate)) {
      return;
    }

    isLoading.value = true;

    try {
      if (listIsEmpty) {
        await _retrieveFromServer(accountId, retrieveMovies, retrieveTvshows);
      } else {
        await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);
      }

      await _updateListGenres();

      _setLastUpdate();
    } catch (error) {
      SnackMessage.showSnackBar('List $_listName ERROR: $error');
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

    for (int i = 0; i < movies.length; i++) {
      var element = movies[i];
      element[TmdbTitleFields.listName] = _listName;
      element[TmdbTitleFields.mediaType] = ApiConstants.movie;
      element[TmdbTitleFields.addedOrder] = i;
      serverList.add(TmdbTitle.fromMap(title: element));
    }

    for (int i = 0; i < tv.length; i++) {
      var element = tv[i];
      element[TmdbTitleFields.listName] = _listName;
      element[TmdbTitleFields.mediaType] = ApiConstants.tv;
      element[TmdbTitleFields.addedOrder] = i;
      serverList.add(TmdbTitle.fromMap(title: element));
    }

    return serverList;
  }

  Future<void> _retrieveFromServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    await _clearLocalList();

    List<TmdbTitle> titles =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    const batchSize = 10;
    for (var i = 0; i < titles.length; i += batchSize) {
      final batch = titles.skip(i).take(batchSize);

      final updated = await Future.wait(
          batch.map((t) => TmdbTitleService().updateTitleDetails(t)));

      await repository.saveTitles(updated);

      selectedTitleCount.value =
          repository.countTitlesFiltered(listName: _listName);

      await Future.delayed(Duration.zero);
    }

    await _filterTitles();
  }

  Future<void> _syncWithServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);
    final serverIds = serverList.map((t) => t.tmdbId).toSet();

    final localIds = await repository.getAllTmdbIds(_listName);
    final localIdSet = localIds.toSet();

    final idsToAdd = serverIds.difference(localIdSet);
    final titlesToAdd =
        serverList.where((t) => idsToAdd.contains(t.tmdbId)).toList();
    final idsToRemove = localIdSet.difference(serverIds);

    if (titlesToAdd.isNotEmpty) {
      await repository.saveTitles(titlesToAdd);
    }

    if (idsToRemove.isNotEmpty) {
      await repository.deleteTitles(_listName, idsToRemove.toList());
    }

    if (titlesToAdd.isNotEmpty || idsToRemove.isNotEmpty) {
      await _updateListGenres();
      await _filterTitles();
    }
  }

  Future<void> _updateLocalTitle(TmdbTitle title) async {
    if (title.listName.isEmpty) {
      return;
    }

    await repository.saveTitle(title);
  }

  Future<void> _deleteLocalTitle(TmdbTitle title) async {
    await repository.deleteTitle(_listName, title.tmdbId);
  }

  TmdbTitle? getItem(int position) {
    if (position < 0 || position >= _loadedTitles.length) {
      return null;
    }
    try {
      return _loadedTitles[position];
    } catch (e) {
      debugPrint('Error getting item at position $position: $e');
      return null;
    }
  }

  Future<void> _filterTitles() async {
    _clearLoadedTitles(clearGenreCache: false);

    _anyFilterApplied = true;

    selectedTitleCount.value = repository.countTitlesFiltered(
      listName: _listName,
      filterText: _filterText,
      filterMediaType: _filterMediaType,
      filterGenres: _filterGenres,
      filterByProviders: _filterByProviders,
      filterProvidersIds: _filterProvidersIds,
    );
    await loadNextPage();
  }

  Future<void> setFilters(
      {String text = '',
      String type = '',
      List<String> genres = const [],
      bool filterByProviders = false,
      List<int> providerListIds = const []}) async {
    _filterText = text;
    _filterMediaType = type;
    _filterGenres = TmdbGenreService().getIdsFromNames(genres);
    _filterByProviders = filterByProviders;
    _filterProvidersIds = providerListIds;
    await _filterTitles();
  }

  void setTextFilter(String filter) {
    _filterText = filter;
    _filterTitles();
  }

  void setGenresFilter(List<String> genres) {
    _filterGenres = TmdbGenreService().getIdsFromNames(genres);
    _filterTitles();
  }

  void setProvidersFilter(bool filterByProviders, List<int> providerIds) {
    _filterByProviders = filterByProviders;
    _filterProvidersIds = providerIds;
    _filterTitles();
  }

  void setTypeFilter(String type) {
    _filterMediaType = type;
    _filterTitles();
  }

  bool _computeSortDirection(String sort, bool ascending) {
    switch (sort) {
      case SortOption.alphabetically:
        return ascending;
      case SortOption.rating:
      case SortOption.userRating:
      case SortOption.releaseDate:
      case SortOption.dateRated:
      case SortOption.runtime:
        return !ascending;
      default:
        return ascending;
    }
  }

  void setSort(String sort, bool ascending) {
    _selectedSort = sort;
    _isSortAsc = _computeSortDirection(sort, ascending);
    _filterTitles();
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
        await _updateLocalTitle(title);
        await _filterTitles();
      } else {
        await _deleteLocalTitle(title);
        _loadedTitles.removeWhere((element) => element.tmdbId == title.tmdbId);
      }
      _setLastUpdate();
      await _updateListGenres();

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

  Future<void> _updateListGenres() async {
    _listGenres.clear();
    final genreSets = await repository.getAllGenreIds(_listName);

    final uniqueGenres = genreSets.expand((ids) => ids).toSet().toList();
    _listGenres = TmdbGenreService().getNamesFromIds(uniqueGenres);
    _listGenres.sort();
    listGenres.value = [..._listGenres];
  }

  TmdbTitle? getTitleByTmdbId(int tmdbId, String mediaType) {
    return repository.getTitleByTmdbId(_listName, tmdbId, mediaType);
  }

  Future<void> loadNextPage() async {
    if ((_isDbLoading) || !_hasMore) return;

    _isDbLoading = true;

    try {
      if (_anyFilterApplied == false) {
        _isDbLoading = false;
        return _filterTitles();
      }
      final currentRequestId = ++_filterRequestId;

      final titles = await repository.getTitles(
        listName: _listName,
        filterText: _filterText,
        filterMediaType: _filterMediaType,
        filterGenres: _filterGenres,
        filterByProviders: _filterByProviders,
        filterProvidersIds: _filterProvidersIds,
        sortOption: _selectedSort,
        sortAscending: _isSortAsc,
        offset: _page * _pageSize,
        limit: _pageSize,
      );

      if (currentRequestId != _filterRequestId) {
        _isDbLoading = false;
        return;
      }

      _loadedTitles.addAll(titles);
      _page++;
      if (titles.length < _pageSize) {
        _hasMore = false;
      }
    } finally {
      _isDbLoading = false;
      if (_listGenres.isEmpty) {
        await _updateListGenres();
      }
      notifyListeners();
    }
  }
}
