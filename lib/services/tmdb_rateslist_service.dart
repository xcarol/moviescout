import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

String _prefsRateslistName = 'rateslist';

class TmdbRateslistService extends TmdbBaseService with ChangeNotifier {
  List<TmdbTitle> rateslist = List.empty(growable: true);

  void clearRatesList() {
    rateslist = List.empty(growable: true);
    _updateRateslistInCache();
    notifyListeners();
  }

  int getRating(int id) {
    if (rateslist.isEmpty) {
      // retrieveRateslist may not have been called yet
      rateslist = _retrieveRateslistFromCache();
    }
    TmdbTitle? title = rateslist.firstWhere(
      (element) => element.id == id,
      orElse: () => TmdbTitle(title: {}),
    );
    return title.rating.toInt();
  }

  Future<void> retrieveRateslist(String accountId) async {
    if (accountId.isEmpty) {
      return;
    }

    rateslist = _retrieveRateslistFromCache();
    if (rateslist.isNotEmpty) {
      await _syncCacheRatesListWithServer(accountId);
    } else {
      rateslist = await _retrieveRateslistFromServer(accountId);
      _updateRateslistInCache();
    }

    notifyListeners();
  }

  Future<dynamic> _retrieveRateslistFromServer(String accountId) async {
    late Map<String, dynamic> movies = {};
    List<TmdbTitle> serverRateslist = List.empty(growable: true);
    dynamic response = await get('account/$accountId/rated/movies');
    if (response.statusCode == 200) {
      movies = body(response);
    }

    late Map<String, dynamic> tv = {};
    response = await get('account/$accountId/rated/tv');
    if (response.statusCode == 200) {
      tv = body(response);
    }

    if (movies['results'] != null) {
      movies['results'].forEach((element) {
        element['media_type'] = 'movie';
        serverRateslist.add(TmdbTitle(title: element));
      });
    }

    if (tv['results'] != null) {
      tv['results'].forEach((element) {
        element['media_type'] = 'tv';
        serverRateslist.add(TmdbTitle(title: element));
      });
    }

    return serverRateslist;
  }

  List<TmdbTitle> _retrieveRateslistFromCache() {
    final List<String>? rateslistJson =
        PreferencesService().prefs.getStringList(_prefsRateslistName);

    if (rateslistJson == null || rateslistJson.isEmpty) {
      return List.empty(growable: true);
    }

    return rateslistJson
        .map((json) => TmdbTitle(title: jsonDecode(json)))
        .toList();
  }

  Future<void> _syncCacheRatesListWithServer(String accountId) async {
    List<TmdbTitle> cacheRateslist = _retrieveRateslistFromCache();
    List<TmdbTitle> serverRateslist =
        await _retrieveRateslistFromServer(accountId);

    List<TmdbTitle> titlesToAdd = serverRateslist
        .where((title) => !cacheRateslist.contains(title))
        .toList();

    List<TmdbTitle> titlesToRemove = cacheRateslist
        .where((title) => !serverRateslist.contains(title))
        .toList();

    for (TmdbTitle title in titlesToAdd) {
      rateslist.add(title);
    }
    for (TmdbTitle title in titlesToRemove) {
      rateslist.removeWhere((element) => element.id == title.id);
    }
    _updateRateslistInCache();
  }

  Future<void> _updateRateslistInCache() async {
    List<String> rateslistJson =
        rateslist.map((title) => jsonEncode(title.map)).toList();

    PreferencesService()
        .prefs
        .setStringList(_prefsRateslistName, rateslistJson);
  }

  Future<dynamic> _updateTitleInRateslistToTmdb(
      String accountId, int id, String mediaType, int rate) async {
    if (rate > 0) {
      if (mediaType == 'movie') {
        return post('movie/$id/rating', {'value': rate});
      } else if (mediaType == 'tv') {
        return post('tv/$id/rating', {'value': rate});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    } else {
      if (mediaType == 'movie') {
        return delete('movie/$id/rating', {});
      } else if (mediaType == 'tv') {
        return delete('tv/$id/rating', {});
      }
      HttpException(
          'Invalid media type: $mediaType. Expected "movie" or "tv".');
    }
  }

  Future<void> updateRateslistTitle(
      String accountId, TmdbTitle title, int rating) async {
    if (rating > 0) {
      final result = await _updateTitleInRateslistToTmdb(
          accountId, title.id, title.mediaType, rating);
      if (result.statusCode == 201) {
        title.rating = rating.toDouble();
        title.lastUpdated = DateTime.now().toString();

        if (!rateslist.contains(title)) {
          rateslist.add(title);
        } else {
          rateslist.removeWhere((element) => element.id == title.id);
          rateslist.add(title);
        }
      } else {
        throw Exception(
            'Failed to add rating to title. Response code: ${result.statusCode}');
      }
    } else {
      final result = await _updateTitleInRateslistToTmdb(
          accountId, title.id, title.mediaType, rating);
      if (result.statusCode == 200) {
        rateslist.removeWhere((element) => element.id == title.id);
      } else {
        throw Exception(
            'Failed to remove rating from title. Response code: ${result.statusCode}');
      }
    }

    _updateRateslistInCache();
    notifyListeners();
  }
}
