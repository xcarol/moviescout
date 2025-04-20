import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbListService extends TmdbBaseService with ChangeNotifier {
  String _prefsListName = '';
  String _lastUpdated =
      DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();
  List<TmdbTitle> _titles = List.empty(growable: true);
  List<TmdbTitle> get titles => _titles;
  String get listName => _prefsListName;

  TmdbListService(String listName) {
    _prefsListName = listName;
  }

  void clearList() {
    _titles = List.empty(growable: true);
    _updateLocalList();
    notifyListeners();
  }

  Future<void> retrieveList(
    String accountId, {
    required Future<Map<String, dynamic>> Function() retrieveMovies,
    required Future<Map<String, dynamic>> Function() retrieveTvshows,
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
    notifyListeners();
  }

  void retreiveListFromLocal({bool notify = true}) {
    _titles = _retrieveLocalList();
    if (notify) {
      notifyListeners();
    }
  }

  Future<dynamic> _retrieveServerList(
    String accountId,
    Future<Map<String, dynamic>> Function() retrieveMovies,
    Future<Map<String, dynamic>> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> serverList = List.empty(growable: true);
    Map<String, dynamic> movies = await retrieveMovies();
    Map<String, dynamic> tv = await retrieveTvshows();

    if (movies['results'] != null) {
      movies['results'].forEach((element) {
        element['media_type'] = 'movie';
        element['last_updated'] = DateTime.now().toString();
        serverList.add(TmdbTitle(title: element));
      });
    }

    if (tv['results'] != null) {
      tv['results'].forEach((element) {
        element['media_type'] = 'tv';
        element['last_updated'] = DateTime.now().toString();
        serverList.add(TmdbTitle(title: element));
      });
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
    Future<Map<String, dynamic>> Function() retrieveMovies,
    Future<Map<String, dynamic>> Function() retrieveTvshows,
  ) async {
    List<TmdbTitle> localList = _retrieveLocalList();
    List<TmdbTitle> serverList =
        await _retrieveServerList(accountId, retrieveMovies, retrieveTvshows);

    List<TmdbTitle> titlesToAdd =
        serverList.where((title) => !localList.contains(title)).toList();

    List<TmdbTitle> titlesToRemove =
        localList.where((title) => !serverList.contains(title)).toList();

    List<TmdbTitle> listUpdated = _titles;
    for (TmdbTitle title in titlesToAdd) {
      listUpdated.add(title);
    }
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

  Future<void> updateTitle(String accountId, TmdbTitle title, bool add,
      Future<dynamic> Function(String accountId) updateTitleToServer) async {
    final result = await updateTitleToServer(accountId);
    if (result.statusCode == 200 || result.statusCode == 201) {
      _titles.removeWhere((element) => element.id == title.id);

      if (add) {
        title.lastUpdated = DateTime.now().toString();
        _titles.add(title);
      }

      _updateLocalList();
      notifyListeners();
    } else {
      throw Exception('Failed to update titleId: ${title.id}. Status code: ${result.statusCode} - ${result.message}');
    }
  }
}
