import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _listName = '';
  // TODO: Save the last update in shared preferences
  String _lastUpdated =
      DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();
  List<TmdbTitle> _titles = List.empty(growable: true);
  List<TmdbTitle> get titles => _titles;
  String get listName => _listName;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TmdbListService(String listName, {List<TmdbTitle>? titles}) {
    if (titles != null) {
      _titles = titles;
      _lastUpdated = DateTime.now().toIso8601String();
    }
    _listName = listName;
  }

  bool get userRatingAvailable {
    return _titles.isNotEmpty && _titles[0].rating > 0.0;
  }

  Future<void> clearList() async {
    _titles = List.empty(growable: true);
    await _clearLocalList();
    notifyListeners();
  }

  bool contains(TmdbTitle title) {
    return titles.contains(title);
  }

  Future<void> _clearLocalList() async {
    final isar = IsarService.instance;
    await isar.writeTxn(() async {
      await isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
    });
    _lastUpdated = DateTime.now().toIso8601String();
  }

  Future<void> retrieveList(
    String accountId, {
    required bool notify,
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(_lastUpdated)).inHours < 10;

    if (accountId.isEmpty || (_titles.isNotEmpty && isUpToDate)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _titles = await _retrieveLocalList();
      if (_titles.isNotEmpty) {
        await _syncWithServer(
            accountId, _titles, retrieveMovies, retrieveTvshows);
      } else {
        List<TmdbTitle> titles = await _retrieveServerList(
            accountId, retrieveMovies, retrieveTvshows);

        for (var title in titles) {
          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(title);
          await _updateLocalTitle(updatedTitle);
          _titles.add(updatedTitle);
          notifyListeners();
        }

        _lastUpdated = DateTime.now().toIso8601String();
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error retrieving $_listName: $error',
      );
    }
  }

  void retrieveListFromLocal({bool notify = true}) async {
    _titles = await _retrieveLocalList();
    if (notify) {
      notifyListeners();
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

  Future<List<TmdbTitle>> _retrieveLocalList() async {
    try {
      final isar = IsarService.instance;
      final titles =
          await isar.tmdbTitles.filter().listNameEqualTo(_listName).findAll();
      return titles.toList();
    } catch (e) {
      SnackMessage.showSnackBar(
        'Error retrieving local list: $e',
      );
      return List.empty(growable: true);
    }
  }

  Future<void> _syncWithServer(
    String accountId,
    List<TmdbTitle> localList,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    List<TmdbTitle> titlesToAdd = serverList
        .where((remote) =>
            !localList.any((local) => local.tmdbId == remote.tmdbId))
        .toList();

    for (TmdbTitle title in titlesToAdd) {
      title.listName = _listName;
      await _updateLocalTitle(
        await TmdbTitleService().updateTitleDetails(title),
      );
      _titles.add(title);
      notifyListeners();
    }

    List<TmdbTitle> titlesToRemove = localList
        .where((local) =>
            !serverList.any((remote) => remote.tmdbId == local.tmdbId))
        .toList();

    for (TmdbTitle title in titlesToRemove) {
      await _deleteLocalTitle(title);
      _titles.removeWhere((element) => element.tmdbId == title.tmdbId);
      notifyListeners();
    }
  }

  Future<void> _updateLocalTitle(TmdbTitle title) async {
    final isar = IsarService.instance;

    if (title.listName.isEmpty) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.tmdbTitles.put(title);
    });
  }

  Future<void> _deleteLocalTitle(TmdbTitle title) async {
    final isar = IsarService.instance;

    await isar.writeTxn(() async {
      await isar.tmdbTitles.delete(title.id);
    });
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
        _titles.add(title);
      } else {
        await _deleteLocalTitle(title);
        _titles.removeWhere((element) => element.tmdbId == title.tmdbId);
      }
      _lastUpdated = DateTime.now().toIso8601String();
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
}
