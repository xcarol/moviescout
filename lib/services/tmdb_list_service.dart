import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _listName = '';
  String _lastUpdate = '';
  final List<TmdbTitle> _loadedTitles = List.empty(growable: true);
  String get listName => _listName;
  bool _isDbLoading = false;
  bool _isServerLoading = false;
  bool get isLoading => _isServerLoading;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int _page = 0;
  final int _pageSize = 10;
  final _isar = IsarService.instance;
  late QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> _query;
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

  TmdbListService(String listName, {List<TmdbTitle>? titles}) {
    _listName = listName;
    _lastUpdate =
        PreferencesService().prefs.getString('${_listName}_last_update') ??
            DateTime.now()
                .subtract(const Duration(hours: defaultLastUpdate))
                .toIso8601String();
    _query = _isar.tmdbTitles.filter().listNameEqualTo(_listName);
  }

  Future<void> setLocalTitles(List<TmdbTitle> titles) async {
    await _clearLocalList();

    if (titles.isEmpty) {
      return;
    }

    for (var title in titles) {
      title.listName = _listName;
    }

    await _updateLocalTitles(titles);
    await _filterTitles();
    _setLastUpdate();
    _updateListGenres();
  }

  Future<void> _updateLocalTitles(List<TmdbTitle> titles) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
      for (var title in titles) {
        await _isar.tmdbTitles.put(title);
      }
    });
  }

  void _setLastUpdate() {
    _lastUpdate = DateTime.now().toIso8601String();
    PreferencesService()
        .prefs
        .setString('${_listName}_last_update', _lastUpdate);
  }

  bool get userRatingAvailable {
    return _loadedTitles.isNotEmpty && _loadedTitles.first.rating > 0.0;
  }

  void clearListSync() {
    _isar.writeTxnSync(() {
      _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAllSync();
    });
    _clearLoadedTitles(clearGenreCache: true);
    PreferencesService().prefs.remove('${_listName}_last_update');
  }

  Future<void> clearList() async {
    await _clearLocalList();
    notifyListeners();
  }

  bool get listIsEmpty {
    return listTitleCount == 0;
  }

  bool get listIsNotEmpty {
    return !listIsEmpty;
  }

  int get listTitleCount {
    return _isar.tmdbTitles.filter().listNameEqualTo(_listName).countSync();
  }

  bool contains(TmdbTitle title) {
    if (_isar.tmdbTitles
            .filter()
            .listNameEqualTo(_listName)
            .tmdbIdEqualTo(title.tmdbId)
            .findFirstSync() ==
        null) {
      return false;
    }
    return true;
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

  Future<void> _clearLocalList() async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
    });
    _clearLoadedTitles(clearGenreCache: true);
    PreferencesService().prefs.remove('${_listName}_last_update');
  }

  Future<void> retrieveList(
    String accountId, {
    required bool notify,
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(_lastUpdate)).inHours <
            updateTimeout;

    if (accountId.isEmpty || (listIsNotEmpty && isUpToDate)) {
      return;
    }

    _isServerLoading = true;

    try {
      if (listIsEmpty) {
        await _retrieveFromServer(accountId, retrieveMovies, retrieveTvshows);
      } else {
        await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);
      }

      _setLastUpdate();
    } catch (error) {
      SnackMessage.showSnackBar('List $_listName ERROR: $error');
    } finally {
      _isServerLoading = false;
    }
  }

  Future<dynamic> _retrieveServerList(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList = List.empty(growable: true);
    List movies = await retrieveMovies();
    List tv = await retrieveTvshows();

    for (var element in movies) {
      element['list_name'] = _listName;
      element['media_type'] = 'movie';
      serverList.add(TmdbTitle.fromMap(title: element));
    }

    for (var element in tv) {
      element['list_name'] = _listName;
      element['media_type'] = 'tv';
      serverList.add(TmdbTitle.fromMap(title: element));
    }

    return serverList;
  }

  Future<void> _retrieveFromServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> titles =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    _updateListGenres();
    await _filterTitles();
    for (var title in titles) {
      TmdbTitle updatedTitle =
          await TmdbTitleService().updateTitleDetails(title);
      await _updateLocalTitle(updatedTitle);
      selectedTitleCount.value = _query.countSync();
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

    final localIds = await _isar.tmdbTitles
        .where()
        .listNameEqualTo(_listName)
        .tmdbIdProperty()
        .findAll();
    final localIdSet = localIds.toSet();

    final idsToAdd = serverIds.difference(localIdSet);
    final titlesToAdd =
        serverList.where((t) => idsToAdd.contains(t.tmdbId)).toList();
    final idsToRemove = localIdSet.difference(serverIds);

    await _isar.writeTxn(() async {
      if (titlesToAdd.isNotEmpty) {
        await _isar.tmdbTitles.putAll(titlesToAdd);
      }

      if (idsToRemove.isNotEmpty) {
        for (final id in idsToRemove) {
          await _isar.tmdbTitles.filter().tmdbIdEqualTo(id).deleteAll();
        }
      }
    });

    if (titlesToAdd.isNotEmpty || idsToRemove.isNotEmpty) {
      _updateListGenres();
      await _filterTitles();
    }
  }

  Future<void> _updateLocalTitle(TmdbTitle title) async {
    if (title.listName.isEmpty) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.put(title);
    });
  }

  Future<void> _deleteLocalTitle(TmdbTitle title) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles
          .filter()
          .listNameEqualTo(_listName)
          .tmdbIdEqualTo(title.tmdbId)
          .deleteAll();
    });
  }

  Future<List<TmdbTitle>> _getPage({required int offset, required int limit}) {
    return _sortTitles(_query).offset(offset).limit(limit).findAll();
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> _sortTitles(
      QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> query) {
    QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> sortedQuery;

    switch (_selectedSort) {
      case SortOption.rating:
        sortedQuery = _isSortAsc
            ? query.sortByVoteAverage()
            : query.sortByVoteAverageDesc();
        break;
      case SortOption.userRating:
        sortedQuery =
            _isSortAsc ? query.sortByRating() : query.sortByRatingDesc();
        break;
      case SortOption.releaseDate:
        sortedQuery = _isSortAsc
            ? query.sortByEffectiveReleaseDate()
            : query.sortByEffectiveReleaseDateDesc();
        break;
      case SortOption.runtime:
        sortedQuery = _isSortAsc
            ? query.sortByIsMovieDesc().thenByEffectiveRuntime()
            : query.sortByIsMovieDesc().thenByEffectiveRuntimeDesc();
        break;
      case SortOption.alphabetically:
      default:
        sortedQuery = _isSortAsc ? query.sortByName() : query.sortByNameDesc();
        break;
    }

    return sortedQuery;
  }

  Future<void> _filterTitles() async {
    _query = _isar.tmdbTitles.filter().listNameEqualTo(_listName);

    if (_filterText.isNotEmpty) {
      _query = _query.nameContains(_filterText, caseSensitive: false);
    }

    if (_filterGenres.isNotEmpty) {
      _query =
          _query.anyOf(_filterGenres, (q, id) => q.genreIdsElementEqualTo(id));
    }

    if (_filterMediaType.isNotEmpty) {
      _query = _query.mediaTypeEqualTo(_filterMediaType);
    }

    if (_filterByProviders && _filterProvidersIds.isNotEmpty) {
      _query = _query.anyOf(_filterProvidersIds,
          (q, id) => q.flatrateProviderIdsElementEqualTo(id));
    }

    _clearLoadedTitles(clearGenreCache: false);
    _anyFilterApplied = true;
    selectedTitleCount.value = _query.countSync();
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

  void setSort(String sort, bool ascending) {
    _selectedSort = sort;
    _isSortAsc = ascending;
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
      _updateListGenres();
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

  void _updateListGenres() {
    _listGenres.clear();
    final genreSets = _isar.tmdbTitles
        .filter()
        .listNameEqualTo(_listName)
        .genreIdsProperty()
        .findAllSync();

    final uniqueGenres = genreSets.expand((ids) => ids).toSet().toList();
    _listGenres = TmdbGenreService().getNamesFromIds(uniqueGenres);
    _listGenres.sort();
    listGenres.value = [..._listGenres];
  }

  TmdbTitle? getTitleByTmdbId(int tmdbId) {
    return _isar.tmdbTitles
        .filter()
        .listNameEqualTo(_listName)
        .tmdbIdEqualTo(tmdbId)
        .findFirstSync();
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
      final titles =
          await _getPage(offset: _page * _pageSize, limit: _pageSize);

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
        _updateListGenres();
      }
      notifyListeners();
    }
  }
}
