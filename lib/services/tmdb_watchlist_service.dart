import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List userWatchlist = List.empty(growable: true);

  void clearWatchList() {
    userWatchlist = List.empty(growable: true);
    notifyListeners();
  }

  Future<void> retrieveUserWatchlist(int accountId) async {
    if (accountId <= 0) {
      return;
    }

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

    movies['results'].forEach((element) {
      element['last_updated'] = DateTime.now().toIso8601String();
      element['media_type'] = 'movie';
    });

    tv['results'].forEach((element) {
      element['last_updated'] = DateTime.now().toIso8601String();
      element['media_type'] = 'tv';
    });

    userWatchlist = movies['results'] + tv['results'];
    notifyListeners();
  }

  Future<dynamic> _updateTitleInWatchlistToTmdb(
      int accountId, int id, bool add) async {
    return post('account/$accountId/watchlist',
        {'media_type': 'movie', 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(int accountId, Map title, bool add) async {
    if (add) {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title['id'], true);
      if (result.statusCode == 201) {
        userWatchlist.add(title);
      } else {
        throw Exception('Failed to add title to watchlist. Response code: ${result.statusCode}');
      }
    } else {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title['id'], false);
      if (result.statusCode == 200) {
        userWatchlist.removeWhere((element) => element['id'] == title['id']);
      } else {
        throw Exception(
            'Failed to remove title to watchlist. Response code: ${result.statusCode}');
      }
    }
    notifyListeners();
  }
}
