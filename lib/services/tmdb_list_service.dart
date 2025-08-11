import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _listName = '';
  String _lastUpdate = '';
  String get listName => _listName;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final _isar = IsarService.instance;

  TmdbListService(String listName, {List<TmdbTitle>? titles}) {
    _listName = listName;
    _lastUpdate =
        PreferencesService().prefs.getString('${_listName}_last_update') ??
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();

    if (titles != null) {
      addTitles(_listName, titles);
      _lastUpdate = DateTime.now().toIso8601String();
    }
  }

  Future<void> addTitles(String listName, List<TmdbTitle> titles) async {
    if (listName.isNotEmpty && titles.first.listName.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.tmdbTitles.filter().listNameEqualTo(listName).deleteAll();
        await _isar.tmdbTitles.putAll(titles);
      });
    }
  }

  void _setLastUpdate() {
    _lastUpdate = DateTime.now().toIso8601String();
    PreferencesService()
        .prefs
        .setString('${_listName}_last_update', _lastUpdate);
  }

  bool get userRatingAvailable {
    List<TmdbTitle> titles = List.empty(growable: true);

    titles = _isar.txnSync(() {
      return _isar.tmdbTitles
          .filter()
          .listNameEqualTo(_listName)
          .ratingGreaterThan(0.0)
          .findAllSync()
          .toList();
    });

    return titles.isNotEmpty;
  }

  Future<void> clearList() async {
    await _clearLocalList();
    notifyListeners();
  }

  bool contains(TmdbTitle title) {
    return _isar.tmdbTitles.getSync(title.id) != null;
  }

  Future<void> _clearLocalList() async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(_listName).deleteAll();
    });
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

    bool listIsNotEmpty =
        _isar.tmdbTitles.filter().listNameEqualTo(_listName).countSync() > 0;

    if (accountId.isEmpty || (listIsNotEmpty && isUpToDate)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (listIsNotEmpty) {
        await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);
      } else {
        List<TmdbTitle> titles = await _retrieveServerList(
            accountId, retrieveMovies, retrieveTvshows);

        for (var title in titles) {
          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(title);
          await _updateLocalTitle(updatedTitle);
          notifyListeners();
        }

        _setLastUpdate();
      }

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

  Future<void> _syncWithServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    List<TmdbTitle> titlesToAdd = serverList
        .where((remote) => _isar.tmdbTitles
            .filter()
            .listNameEqualTo(_listName)
            .tmdbIdEqualTo(remote.tmdbId)
            .isEmptySync())
        .toList();

    for (TmdbTitle title in titlesToAdd) {
      title.listName = _listName;
      await _updateLocalTitle(
        await TmdbTitleService().updateTitleDetails(title),
      );
      notifyListeners();
    }

    List<TmdbTitle> titlesToRemove = _isar.tmdbTitles
        .filter()
        .listNameEqualTo(_listName)
        .findAllSync()
        // .toList()
        // .cast<TmdbTitle>()
        .where((local) =>
            !serverList.any((remote) => remote.tmdbId == local.tmdbId))
        .toList();

    for (TmdbTitle title in titlesToRemove) {
      await _deleteLocalTitle(title);
      notifyListeners();
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
      } else {
        await _deleteLocalTitle(title);
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
}
