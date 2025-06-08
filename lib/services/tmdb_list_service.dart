import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _prefsListName = '';
  String _lastUpdated =
      DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();
  List<TmdbTitle> _titles = List.empty(growable: true);
  List<TmdbTitle> get titles => _titles;
  String get listName => _prefsListName;

  TmdbListService(String listName, {List<TmdbTitle>? titles}) {
    if (titles != null) {
      _titles = titles;
      _lastUpdated = DateTime.now().toIso8601String();
    }
    _prefsListName = listName;
  }

  void clearList() {
    _titles = List.empty(growable: true);
    _updateLocalList();
    notifyListeners();
  }

  bool contains(TmdbTitle title) {
    return titles.contains(title);
  }

  Future<void> retrieveList(
    String accountId, {
    required bool notify,
    required bool updateTitles,
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
  }) async {
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(_lastUpdated)).inHours < 10;

    if (accountId.isEmpty || (_titles.isNotEmpty && isUpToDate)) {
      return;
    }

    _titles = _retrieveLocalList();
    if (_titles.isNotEmpty) {
      _titles =
          await _syncWithServer(accountId, retrieveMovies, retrieveTvshows);
    } else {
      _titles =
          await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);
    }

    _updateLocalList();

    if (updateTitles) {
      TmdbTitleService().updateTitles(_titles).then((_) {
        if (notify) {
          notifyListeners();
        }
        return null;
      });
    } else if (notify) {
      notifyListeners();
    }
  }

  void retreiveListFromLocal({bool notify = true}) {
    _titles = _retrieveLocalList();
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
      element['media_type'] = 'movie';
      serverList.add(TmdbTitle(title: element));
    }

    for (var element in tv) {
      element['media_type'] = 'tv';
      serverList.add(TmdbTitle(title: element));
    }

    return serverList;
  }

  List<TmdbTitle> _retrieveLocalList() {
    final List<String>? listJson =
        PreferencesService().prefs.getStringList(_prefsListName);

    if (listJson == null || listJson.isEmpty) {
      return List.empty(growable: true);
    }

    return listJson.map((json) => TmdbTitle(title: jsonDecode(json))).toList();
  }

  Future<List<TmdbTitle>> _syncWithServer(
    String accountId,
    Future<List> Function() retrieveMovies,
    Future<List> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> localList = _retrieveLocalList();
    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    List<TmdbTitle> titlesToAdd =
        serverList.where((title) => !localList.contains(title)).toList();

    List<TmdbTitle> titlesToRemove =
        localList.where((title) => !serverList.contains(title)).toList();

    List<TmdbTitle> listUpdated = _titles;
    listUpdated.addAll(titlesToAdd);
    for (TmdbTitle title in titlesToRemove) {
      listUpdated.removeWhere((element) => element.id == title.id);
    }

    return listUpdated;
  }

  Future<void> _updateLocalList() async {
    List<String> listJson =
        _titles.map((title) => jsonEncode(title.map)).toList();

    PreferencesService().prefs.setStringList(_prefsListName, listJson);

    _lastUpdated = DateTime.now().toIso8601String();
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
      _titles.removeWhere((element) => element.id == title.id);

      if (add) {
        title.lastUpdated = DateTime.now().toString();
        _titles.add(title);
      }

      _updateLocalList();
      notifyListeners();
    } else {
      throw Exception(
          'Failed to update titleId: ${title.id}. Status code: ${result.statusCode} - ${result.body}');
    }
  }

  Future<TmdbTitle> updateTitleDetails(
      String accountId, TmdbTitle title) async {
    if (_titles.isEmpty) {
      return title;
    }

    TmdbTitle titleFromList =
        _titles.firstWhere((element) => element.id == title.id);

    if (TmdbTitleService.isUpToDate(titleFromList) == false) {
      TmdbTitle updatedTitle =
          await TmdbTitleService().getTitleDetails(titleFromList);
      _titles.removeWhere((element) => element.id == title.id);
      _titles.add(updatedTitle);
      return updatedTitle;
    }

    return titleFromList;
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
}
