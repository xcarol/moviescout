import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

const String _tmdbPopularlistMovies =
    'movie/popular?page={PAGE}&language={LOCALE}';
const String _tmdbPopularlistTv = 'tv/popular?page={PAGE}&language={LOCALE}';

class TmdbDiscoverlistService extends TmdbListService {
  TmdbDiscoverlistService(super.listName);

  Future<void> retrieveDiscoverlist(
      String accountId, String sessionId, Locale locale) async {
    final lastUpdate =
        PreferencesService().prefs.getString('${listName}_last_update') ??
            DateTime.now().subtract(const Duration(days: 8)).toIso8601String();

    final isUpToDate =
        DateTime.now().difference(DateTime.parse(lastUpdate)).inDays < 7;

    if (listIsNotEmpty && isUpToDate) {
      return;
    }

    retrieveList(accountId.isEmpty ? anonymousAccountId : accountId,
        retrieveMovies: () async {
      return _getDiscoveryTitles(
          accountId, sessionId, locale, 'movie', _tmdbPopularlistMovies);
    }, retrieveTvshows: () async {
      return _getDiscoveryTitles(
          accountId, sessionId, locale, 'tv', _tmdbPopularlistTv);
    });
  }

  Future<List> _getDiscoveryTitles(String accountId, String sessionId,
      Locale locale, String mediaType, String popularEndpoint) async {
    final isar = IsarService.instance;
    final ratedTitles = await isar.tmdbTitles
        .filter()
        .ratingGreaterThan(0)
        .and()
        .mediaTypeEqualTo(mediaType)
        .sortByRatingDesc()
        .findAll();

    final watchlistTitles = await isar.tmdbTitles
        .filter()
        .listNameEqualTo('watchlist')
        .and()
        .mediaTypeEqualTo(mediaType)
        .findAll();

    final Set<int> ratedIds = ratedTitles.map((t) => t.tmdbId).toSet();
    final Set<int> watchlistIds = watchlistTitles.map((t) => t.tmdbId).toSet();
    final List<dynamic> recommendations = [];
    final Set<int> addedIds = {};

    // Exclude titles already in watchlist
    addedIds.addAll(watchlistIds);

    for (final title in ratedTitles) {
      if (recommendations.length >= 40) break;
      for (final rec in title.recommendations) {
        if (recommendations.length >= 40) break;
        final recId = rec['id'];
        if (!ratedIds.contains(recId) && !addedIds.contains(recId)) {
          recommendations.add(rec);
          addedIds.add(recId);
        }
      }
    }

    if (recommendations.length < 40) {
      final popularTitles = await getTitlesFromServer((int page) async {
        if (page > 2) {
          return (statusCode: 200, body: '{}');
        }

        return get(popularEndpoint
            .replaceFirst('{ACCOUNT_ID}', accountId)
            .replaceFirst('{SESSION_ID}', sessionId)
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'));
      });

      for (final title in popularTitles) {
        if (recommendations.length >= 40) break;
        final id = title['id'];
        if (!ratedIds.contains(id) && !addedIds.contains(id)) {
          recommendations.add(title);
          addedIds.add(id);
        }
      }
    }

    return recommendations;
  }
}
