import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbWatchlistService extends TmdbBaseService with ChangeNotifier {
  List userWatchlist = List.empty();

  void updateWatchlist(Map title, bool add) {
    notifyListeners();
  }
}
