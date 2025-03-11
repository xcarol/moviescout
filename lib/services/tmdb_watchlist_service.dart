import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List userWatchlist = List.empty(growable: true);

  Future<dynamic> _updateTitleInWatchlistToTmdb(
      int accountId, int id, bool add) async {
    return post('account/$accountId/watchlist',
        {'media_type': 'movie', 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(int accountId, Map title, bool add) async {
    if (add) {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title['id'], true);
      if (result['success'] == true) {
        userWatchlist.add(title);
      } else {
        throw Exception('Failed to add title to watchlist. Response: $result');
      }
    } else {
      final result =
          await _updateTitleInWatchlistToTmdb(accountId, title['id'], false);
      if (result['success'] == true) {
        userWatchlist.removeWhere((element) => element['id'] == title['id']);
      } else {
        throw Exception('Failed to remove title to watchlist. Response: $result');
      }
    }
    notifyListeners();
  }
}
