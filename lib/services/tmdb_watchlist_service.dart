import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

String _prefsWatchlistName = 'watchlist';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List<TmdbTitle> watchlist = List.empty(growable: true);

  void clearWatchList() {
    watchlist = List.empty(growable: true);
    _updateWatchlistInCache();
    notifyListeners();
  }

  Future<void> retrieveWatchlist(int accountId) async {
    if (accountId <= 0) {
      return;
    }

    watchlist = _retrieveWatchlistFromCache();
    if (watchlist.isNotEmpty) {
      await _syncCacheWatchListWithServer(accountId);
    } else {
      watchlist = await _retrieveWatchlistFromServer(accountId);
      _updateWatchlistInCache();
    }

    notifyListeners();
  }

  Future<dynamic> _retrieveWatchlistFromServer(int accountId) async {
    late Map<String, dynamic> movies;
    dynamic response = await get('account/$accountId/watchlist/movies');
    if (response.statusCode == 200) {
      movies = body(response);
    }

    late Map<String, dynamic> tv;
    response = await get('account/$accountId/watchlist/tv');
    if (response.statusCode == 200) {
      tv = body(response);
    }

    List<TmdbTitle> watchlist = List.empty(growable: true);

    movies['results'].forEach((element) {
      element['media_type'] = 'movie';
      watchlist.add(TmdbTitle(title: element));
    });

    tv['results'].forEach((element) {
      element['media_type'] = 'tv';
      watchlist.add(TmdbTitle(title: element));
    });

    return watchlist;
  }

  List<TmdbTitle> _retrieveWatchlistFromCache() {
    final List<String>? watchlistJson =
        PreferencesService().prefs.getStringList(_prefsWatchlistName);

    if (watchlistJson == null || watchlistJson.isEmpty) {
      return List.empty(growable: true);
    }

    return watchlistJson
        .map((json) => TmdbTitle(title: jsonDecode(json)))
        .toList();
  }

  Future<void> _syncCacheWatchListWithServer(int accountId) async {
    List<TmdbTitle> cacheWatchlist = _retrieveWatchlistFromCache();
    List<TmdbTitle> serverWatchlist =
        await _retrieveWatchlistFromServer(accountId);

    List<TmdbTitle> titlesToAdd = serverWatchlist
        .where((title) => !cacheWatchlist.contains(title))
        .toList();

    List<TmdbTitle> titlesToRemove = cacheWatchlist
        .where((title) => !serverWatchlist.contains(title))
        .toList();

    for (TmdbTitle title in titlesToAdd) {
      watchlist.add(title);
    }
    for (TmdbTitle title in titlesToRemove) {
      watchlist.removeWhere((element) => element.id == title.id);
    }
    _updateWatchlistInCache();
  }

  Future<void> _updateWatchlistInCache() async {
    List<String> watchlistJson =
        watchlist.map((title) => jsonEncode(title.map)).toList();

    PreferencesService().prefs.setStringList(_prefsWatchlistName, watchlistJson);
  }

  Future<dynamic> _updateTitleInWatchlistToTmdb(
      int accountId, int id, String mediaType, bool add) async {
    return post('account/$accountId/watchlist',
        {'media_type': mediaType, 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(
      int accountId, TmdbTitle title, bool add) async {
    if (add) {
      final result = await _updateTitleInWatchlistToTmdb(
          accountId, title.id, title.mediaType, true);
      if (result.statusCode == 201) {
        watchlist.add(title);
      } else {
        throw Exception(
            'Failed to add title to watchlist. Response code: ${result.statusCode}');
      }
    } else {
      final result = await _updateTitleInWatchlistToTmdb(
          accountId, title.id, title.mediaType, false);
      if (result.statusCode == 200) {
        watchlist.removeWhere((element) => element.id == title.id);
      } else {
        throw Exception(
            'Failed to remove title to watchlist. Response code: ${result.statusCode}');
      }
    }
    _updateWatchlistInCache();
    notifyListeners();
  }
}
