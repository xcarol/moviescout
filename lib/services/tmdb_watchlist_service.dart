import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List<TmdbTitle> userWatchlist = List.empty(growable: true);

  void clearWatchList() {
    userWatchlist = List.empty(growable: true);
    _updateUserWatchlistCache();
    notifyListeners();
  }

  Future<void> retrieveUserWatchlist(int accountId) async {
    if (accountId <= 0) {
      return;
    }

    userWatchlist = _retrieveUserWatchlistFromCache();
    if (userWatchlist.isNotEmpty) {
      await _syncUserWatchListWithServer(accountId);
    } else {
      userWatchlist = await _retrieveUserWatchlistFromServer(accountId);
      _updateUserWatchlistCache();
    }

    notifyListeners();
  }

  Future<dynamic> _retrieveUserWatchlistFromServer(int accountId) async {
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

  dynamic _retrieveUserWatchlistFromCache() {
    final List<String>? watchlistJson =
        PreferencesService().prefs.getStringList('user_watchlist');

    if (watchlistJson == null || watchlistJson.isEmpty) {
      return null;
    }

    return watchlistJson
        .map((json) => TmdbTitle(title: jsonDecode(json)))
        .toList();
  }

  Future<void> _syncUserWatchListWithServer(int accountId) async {
    List<TmdbTitle> cacheWatchlist = _retrieveUserWatchlistFromCache();
    List<TmdbTitle> serverWatchlist =
        await _retrieveUserWatchlistFromServer(accountId);

    List<TmdbTitle> titlesToAdd = serverWatchlist
        .where((title) => !cacheWatchlist.contains(title))
        .toList();

    List<TmdbTitle> titlesToRemove = cacheWatchlist
        .where((title) => !serverWatchlist.contains(title))
        .toList();

    for (TmdbTitle title in titlesToAdd) {
      userWatchlist.add(title);
    }
    for (TmdbTitle title in titlesToRemove) {
      userWatchlist.removeWhere((element) => element.id == title.id);
    }
    _updateUserWatchlistCache();
  }

  Future<void> _updateUserWatchlistCache() async {
    List<String> watchlistJson =
        userWatchlist.map((title) => jsonEncode(title.map)).toList();

    PreferencesService().prefs.setStringList('user_watchlist', watchlistJson);
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
        userWatchlist.add(title);
      } else {
        throw Exception(
            'Failed to add title to watchlist. Response code: ${result.statusCode}');
      }
    } else {
      final result = await _updateTitleInWatchlistToTmdb(
          accountId, title.id, title.mediaType, false);
      if (result.statusCode == 200) {
        userWatchlist.removeWhere((element) => element.id == title.id);
      } else {
        throw Exception(
            'Failed to remove title to watchlist. Response code: ${result.statusCode}');
      }
    }
    _updateUserWatchlistCache();
    notifyListeners();
  }
}
