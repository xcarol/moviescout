import 'dart:async';
import 'dart:io';

import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class TmdbRateslistService extends TmdbListService {
  TmdbRateslistService(super.listName);

  int getRating(int titleId) {
    if (titles.isEmpty) {
      // retrieveRateslist may not have been called yet
      retreiveListFromLocal(notify: false);
    }
    TmdbTitle? title = titles.firstWhere(
      (element) => element.id == titleId,
      orElse: () => TmdbTitle(title: {}),
    );
    return title.rating.toInt();
  }

  Future<void> retrieveRates(String accountId) async {
    retrieveList(accountId, retrieveMovies: () async {
      late Map<String, dynamic> movies = {};
      dynamic response = await get('account/$accountId/rated/movies');
      if (response.statusCode == 200) {
        movies = body(response);
      }
      return movies;
    }, retrieveTvshows: () async {
      late Map<String, dynamic> tv = {};
      dynamic response = await get('account/$accountId/rated/tv');
      if (response.statusCode == 200) {
        tv = body(response);
      }
      return tv;
    });
  }

  Future<dynamic> _updateTitleRateToTmdb(
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

  Future<void> updateTitleRate(
    String accountId,
    TmdbTitle title,
    int rating,
  ) async {
    try {
      if (rating > 0) {
        title.rating = rating.toDouble();
      }
      await updateTitle(accountId, title, rating > 0, (String accountId) async {
        return _updateTitleRateToTmdb(
            accountId, title.id, title.mediaType, rating);
      });
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error updating rate for ${title.name}: $error',
      );
    }
  }
}
