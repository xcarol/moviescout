import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _listName = '';
  String _lastUpdate = '';
  final List<TmdbTitle> _loadedTitles = List.empty(growable: true);
  String get listName => _listName;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
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
  List<int> _filterProviders = [];
  bool _filterByProviders = false;
  String _selectedSort = SortOption.alphabetically;
  bool _isSortAsc = true;
  int _selectedTitleCount = 0;
  int get selectedTitleCount => _selectedTitleCount;

  TmdbListService(String listName, {List<TmdbTitle>? titles}) {
    _listName = listName;
    _lastUpdate =
        PreferencesService().prefs.getString('${_listName}_last_update') ??
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();

    if (titles != null) {
      for (var title in titles) {
        title.listName = _listName;
      }
      _loadedTitles.addAll(titles);
      _updateLocalTitles(titles);
      _selectedTitleCount = titles.length;
      _lastUpdate = DateTime.now().toIso8601String();
    }
  }

  Future<void> _updateLocalTitles(List<TmdbTitle> titles) async {
    _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
      for (var title in titles) {
        await _isar.tmdbTitles.put(title);
      }
    });
    await _filterTitles(force: true);
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

  int get loadedTitleCount {
    return _loadedTitles.length;
  }

  void _clearLoadedTitles() {
    _loadedTitles.clear();
    _hasMore = true;
    _page = 0;
  }

  Future<void> _clearLocalList() async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
    });
    _clearLoadedTitles();
    PreferencesService().prefs.remove('${_listName}_last_update');
  }

  Future<void> retrieveList(
    String accountId, {
    required bool notify,
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(_lastUpdate)).inHours < 10;

    if (accountId.isEmpty || (listIsNotEmpty && isUpToDate)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (listIsEmpty) {
        await _retrieveFromServer(accountId, retrieveMovies, retrieveTvshows);
      } else {
        await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);
      }

      _setLastUpdate();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error retrieving $_listName: $error',
      );
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

    for (var title in titles) {
      TmdbTitle updatedTitle =
          await TmdbTitleService().updateTitleDetails(title);
      await _updateLocalTitle(updatedTitle);
      notifyListeners();
    }

    // await _filterTitles(force: true);
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
      await _filterTitles(force: true);
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
      await _isar.tmdbTitles.delete(title.id);
    });
  }

  Future<List<TmdbTitle>> _getPage({required int offset, required int limit}) {
    return _sortTitles(_query).offset(offset).limit(limit).findAll();
  }

  TmdbTitle? getItem(int position) {
    if (position < 0 || position >= listTitleCount) {
      return null;
    }
    return _isar.tmdbTitles
        .filter()
        .listNameEqualTo(_listName)
        .offset(position)
        .findFirstSync();
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

  Future<void> _filterTitles({bool force = false}) async {
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

    if (_filterByProviders && _filterProviders.isNotEmpty) {
      _query = _query.anyOf(
          _filterProviders, (q, id) => q.flatrateProviderIdsElementEqualTo(id));
    }

    _anyFilterApplied = true;
    _selectedTitleCount = _query.countSync();
    _clearLoadedTitles();
    if (force) {
      await loadNextPage(force: force);
    }
  }

  void setTextFilter(String filter) {
    _filterText = filter;
    if (_filterText.isEmpty) {
      _filterTitles(force: true);
    }
  }

  void setGenresFilter(List<String> genres) {
    _filterGenres = TmdbGenreService().getIdsFromNames(genres);
    _filterTitles();
  }

  void setProvidersFilter(bool filterByProviders, List<String> providerList) {
    _filterByProviders = filterByProviders;
    _filterProviders = TmdbProviderService().getIdsFromNames(providerList);
    _filterTitles();
  }

  void setTypeFilter(String type) {
    _filterMediaType = type;
    _filterTitles();
  }

  void setSort(String sort, bool ascending) {
    _selectedSort = sort;
    _isSortAsc = ascending;
    _filterTitles(force: true);
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
        await _filterTitles(force: true);
      } else {
        await _deleteLocalTitle(title);
        _loadedTitles.removeWhere((element) => element.tmdbId == title.tmdbId);
      }
      _setLastUpdate();
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

    notifyListeners();
    return titles;
  }

  List<String> getListGenres() {
    final titles =
        _isar.tmdbTitles.filter().listNameEqualTo(_listName).findAllSync();
    final List<String> genres = titles
        .expand((t) => t.genres)
        .map((genre) => genre.name)
        .toSet()
        .toList();
    genres.sort();
    return genres;
  }

  TmdbTitle? getTitleByTmdbId(int tmdbId) {
    return _isar.tmdbTitles
        .filter()
        .listNameEqualTo(_listName)
        .tmdbIdEqualTo(tmdbId)
        .findFirstSync();
  }

  Future<void> loadNextPage({bool force = false}) async {
    if ((_isLoading && !force) || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (_anyFilterApplied == false) {
        await _filterTitles();
      }
      final currentRequestId = ++_filterRequestId;
      final titles =
          await _getPage(offset: _page * _pageSize, limit: _pageSize);

      if (currentRequestId != _filterRequestId) {
        _isLoading = false;
        return;
      }

      _loadedTitles.addAll(titles);
      _page++;
      if (titles.length < _pageSize) {
        _hasMore = false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
