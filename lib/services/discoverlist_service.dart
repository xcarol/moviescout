import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

const String _tmdbPopularlistMovies =
    'movie/popular?page={PAGE}&language={LOCALE}';
const String _tmdbPopularlistTv = 'tv/popular?page={PAGE}&language={LOCALE}';

class TmdbDiscoverlistService extends TmdbListService {
  bool _isRefreshPaused = false;
  bool _refreshPending = false;
  bool _retrievePending = false;

  bool get retrievePending => _retrievePending;
  bool get refreshPending => _refreshPending;

  TmdbDiscoverlistService(super.listName, super.repository);

  void clearPendingFlags() {
    _retrievePending = false;
    _refreshPending = false;
  }

  Future<void> retrieveDiscoverlist(
    String accountId,
    String sessionId,
    Locale locale, {
    bool forceUpdate = false,
  }) async {
    if (_isRefreshPaused && listIsNotEmpty) {
      _retrievePending = true;
      return;
    }

    await clearList();

    retrieveList(
        accountId.isEmpty ? AppConstants.anonymousAccountId : accountId,
        forceUpdate: forceUpdate, retrieveMovies: () async {
      return _getDiscoveryTitles(accountId, sessionId, locale,
          ApiConstants.movie, _tmdbPopularlistMovies);
    }, retrieveTvshows: () async {
      return _getDiscoveryTitles(
          accountId, sessionId, locale, ApiConstants.tv, _tmdbPopularlistTv);
    });
  }

  Future<List> _getDiscoveryTitles(String accountId, String sessionId,
      Locale locale, String mediaType, String popularEndpoint) async {
    final List<dynamic> recommendations = [];
    final Set<int> addedIds = {};

    if (accountId.isNotEmpty) {
      final isar = IsarService.instance;

      final ratedIds = await isar.tmdbTitles
          .filter()
          .listNameEqualTo(AppConstants.rateslist)
          .and()
          .mediaTypeEqualTo(mediaType)
          .tmdbIdProperty()
          .findAll();

      final watchlistIds = await isar.tmdbTitles
          .filter()
          .listNameEqualTo(AppConstants.watchlist)
          .and()
          .mediaTypeEqualTo(mediaType)
          .tmdbIdProperty()
          .findAll();

      addedIds.addAll(ratedIds);
      addedIds.addAll(watchlistIds);

      final recommendationJsons = await isar.tmdbTitles
          .filter()
          .group((q) => q
              .listNameEqualTo(AppConstants.rateslist)
              .or()
              .listNameEqualTo(AppConstants.watchlist))
          .and()
          .mediaTypeEqualTo(mediaType)
          .sortByRatingDesc()
          .limit(50)
          .recommendationsJsonProperty()
          .findAll();

      final List<dynamic> allRecommendations = [];
      for (final jsonStr in recommendationJsons) {
        if (jsonStr != null && jsonStr.isNotEmpty) {
          try {
            allRecommendations.addAll(jsonDecode(jsonStr));
          } catch (_) {}
        }
      }

      allRecommendations.sort((a, b) {
        final double voteA =
            (a[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        final double voteB =
            (b[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        return voteB.compareTo(voteA);
      });

      for (final rec in allRecommendations) {
        if (recommendations.length >= 40) break;
        final recId = rec[TmdbTitleFields.id];
        if (!addedIds.contains(recId)) {
          recommendations.add(rec);
          addedIds.add(recId);
        }
      }
    }

    if (recommendations.length < 40) {
      final popularTitles = await getTitlesFromServer((int page) async {
        if (page > 2) {
          return http.Response(
            '{"page":%d,"total_pages":%d}'.replaceAll('%d', page.toString()),
            200,
          );
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
        final id = title[TmdbTitleFields.id];
        if (!addedIds.contains(id)) {
          recommendations.add(title);
          addedIds.add(id);
        }
      }
    }

    return recommendations;
  }

  void setRefreshPaused(bool paused) {
    _isRefreshPaused = paused;
  }

  void refresh() {
    if (_isRefreshPaused && listIsNotEmpty) {
      _refreshPending = true;
      return;
    }
    filterTitles();
  }
}
