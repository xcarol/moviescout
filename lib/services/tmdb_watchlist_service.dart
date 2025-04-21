import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class TmdbWatchlistService extends TmdbListService {
  TmdbWatchlistService(super.listName);

  Future<void> retrieveWatchlist(String accountId) async {
    retrieveList(accountId, retrieveMovies: () async {
      late Map<String, dynamic> movies = {};
      dynamic response = await get('account/$accountId/watchlist/movies');
      if (response.statusCode == 200) {
        movies = body(response);
      }
      return movies;
    }, retrieveTvshows: () async {
      Map<String, dynamic> tv = {};
      dynamic response = await get('account/$accountId/watchlist/tv');
      if (response.statusCode == 200) {
        tv = body(response);
      }
      return tv;
    });
  }

  Future<dynamic> _updateTitleInWatchlistToTmdb(
      String accountId, int id, String mediaType, bool add) async {
    return post('account/$accountId/watchlist',
        {'media_type': mediaType, 'media_id': id, 'watchlist': add});
  }

  Future<void> updateWatchlistTitle(
      String accountId, TmdbTitle title, bool add) async {
    try {
      await updateTitle(accountId, title, add, (String accountId) async {
        return _updateTitleInWatchlistToTmdb(
            accountId, title.id, title.mediaType, add);
      });
    } catch (error) {
      SnackMessage.showSnackBar(
        'Error updating watchlist for ${title.name}: $error',
      );
    }
  }
}
