import 'package:flutter/widgets.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

const String _tmdbPopularlistMovies =
    'movie/popular?page={PAGE}&language={LOCALE}';
const String _tmdbPopularlistTv = 'tv/popular?page={PAGE}&language={LOCALE}';

class TmdbDiscoverlistService extends TmdbListService {
  TmdbDiscoverlistService(super.listName);

  Future<void> retrieveDiscoverlist(
    String accountId,
    String sessionId,
    Locale locale) async {
    retrieveList(accountId.isEmpty ? anonymousAccountId : accountId, retrieveMovies: () async {
      return getTitlesFromServer((int page) async {
        if (page > 2) {
          return (statusCode: 200, body: '{}');
        }

        return get(_tmdbPopularlistMovies
            .replaceFirst('{ACCOUNT_ID}', accountId)
            .replaceFirst('{SESSION_ID}', sessionId)
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'));
      });
    }, retrieveTvshows: () async {
      return getTitlesFromServer((int page) async {
        if (page > 2) {
          return (statusCode: 200, body: '{}');
        }

        return get(_tmdbPopularlistTv
            .replaceFirst('{ACCOUNT_ID}', accountId)
            .replaceFirst('{SESSION_ID}', sessionId)
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'));
      });
    });
  }
}
