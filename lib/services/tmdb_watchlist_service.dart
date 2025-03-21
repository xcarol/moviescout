import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List<TmdbTitle> userWatchlist = List.empty(growable: true);

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

    userWatchlist.clear();

    movies['results'].forEach((element) {
      element['media_type'] = 'movie';
      userWatchlist.add(TmdbTitle(title: element));
    });

    tv['results'].forEach((element) {
      element['media_type'] = 'tv';
      userWatchlist.add(TmdbTitle(title: element));
    });

    notifyListeners();
  }

  Future<dynamic> _updateTitleInWatchlistToTmdb(
      int accountId, int id, String mediaType, bool add) async {
    return post('account/$accountId/watchlist',
        {'media_type': mediaType, 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(int accountId, TmdbTitle title, bool add) async {
    if (add) {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title.id, title.mediaType, true);
      if (result.statusCode == 201) {
        userWatchlist.add(title);
      } else {
        throw Exception('Failed to add title to watchlist. Response code: ${result.statusCode}');
      }
    } else {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title.id, title.mediaType, false);
      if (result.statusCode == 200) {
        userWatchlist.removeWhere((element) => element.id == title.id);
      } else {
        throw Exception(
            'Failed to remove title to watchlist. Response code: ${result.statusCode}');
      }
    }
    notifyListeners();
  }
}
