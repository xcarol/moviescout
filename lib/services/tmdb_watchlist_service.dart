import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

const String _tmdbWatchlistMovies =
    'account/{ACCOUNT_ID}/movie/watchlist?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';
const String _tmdbWatchlistTv =
    'account/{ACCOUNT_ID}/tv/watchlist?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}';

class TmdbWatchlistService extends TmdbListService {
  TmdbWatchlistService(super.listName);

  Future<void> retrieveWatchlist(
    String accountId,
    String sessionId,
    Locale locale, {
    bool notify = false,
  }) async {
    retrieveList(accountId, notify: notify, retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        return get(
            _tmdbWatchlistMovies
                .replaceFirst('{ACCOUNT_ID}', accountId)
                .replaceFirst('{SESSION_ID}', sessionId)
                .replaceFirst('{PAGE}', page.toString())
                .replaceFirst(
                    '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
            version: ApiVersion.v4);
      });
    }, retrieveTvshows: () async {
      return getTitlesFromServer((int page) async {
        return get(
            _tmdbWatchlistTv
                .replaceFirst('{ACCOUNT_ID}', accountId)
                .replaceFirst('{SESSION_ID}', sessionId)
                .replaceFirst('{PAGE}', page.toString())
                .replaceFirst(
                    '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
            version: ApiVersion.v4);
      });
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
