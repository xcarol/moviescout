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
    if (((_isRefreshPaused && listIsNotEmpty) || isLoading.value) &&
        !forceUpdate) {
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

  Future<Map<int, double>> _calculateGenrePreferences() async {
    final isar = IsarService.instance;
    final Map<int, double> genreWeights = {};
    final Map<int, int> genreCounts = {};

    final ratedTitles = await isar.tmdbTitles
        .filter()
        .listNameEqualTo(AppConstants.rateslist)
        .findAll();

    final watchlistTitles = await isar.tmdbTitles
        .filter()
        .listNameEqualTo(AppConstants.watchlist)
        .findAll();

    final allTitles = {...ratedTitles, ...watchlistTitles}.toList();
    final totalTitles = allTitles.length;

    if (totalTitles == 0) return {};

    void addWeight(List<int> genres, double weight) {
      for (final id in genres) {
        genreWeights[id] = (genreWeights[id] ?? 0.0) + weight;
        genreCounts[id] = (genreCounts[id] ?? 0) + 1;
      }
    }

    for (final title in ratedTitles) {
      double weight = 0.0;
      if (title.rating >= 4.5) {
        weight = 1.0;
      } else if (title.rating >= 3.5) {
        weight = 0.7;
      } else if (title.rating >= 2.5) {
        weight = 0.3;
      } else if (title.rating > 0) {
        weight = -0.5;
      }
      addWeight(title.genreIds, weight);
    }

    for (final title in watchlistTitles) {
      addWeight(title.genreIds, 0.4);
    }

    final Map<int, double> normalizedWeights = {};
    genreWeights.forEach((id, totalWeight) {
      final count = genreCounts[id] ?? 1;
      final avgWeight = totalWeight / count;

      // Specificity Factor (IDF-like):
      // If a genre appears in almost all titles (e.g., Drama), its "importance" is reduced.
      // specificity = log(Total / Count)
      // Since this is a mobile app with few titles, we use a smoothed version:
      final genreFrequency = count / totalTitles;
      final specificityPenalty = 1.0 /
          (1.0 +
              (genreFrequency *
                  2.0)); // If frequency is 1.0, penalty is 0.33. If 0.1, penalty is 0.83.

      normalizedWeights[id] = (avgWeight * specificityPenalty).clamp(-0.4, 0.6);
    });

    return normalizedWeights;
  }

  Future<List> _getDiscoveryTitles(String accountId, String sessionId,
      Locale locale, String mediaType, String popularEndpoint) async {
    final List<dynamic> recommendations = [];
    final Set<int> addedIds = {};

    if (accountId.isNotEmpty) {
      final isar = IsarService.instance;

      // 1. Get genre preferences
      final genrePreferences = await _calculateGenrePreferences();

      // 2. Get all positive signal titles
      final positiveSignalTitles = await isar.tmdbTitles
          .filter()
          .group((q) => q
              .listNameEqualTo(AppConstants.rateslist)
              .and()
              .ratingGreaterThan(2.5)
              .or()
              .listNameEqualTo(AppConstants.watchlist))
          .and()
          .mediaTypeEqualTo(mediaType)
          .findAll();

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

      // 3. Randomize seeds to ensure variety on refresh
      final seedTitles = [...positiveSignalTitles]..shuffle();
      final selectedSeeds = seedTitles.take(20).toList();

      final List<dynamic> allRecommendations = [];
      for (final title in selectedSeeds) {
        final jsonStr = title.recommendationsJson;
        if (jsonStr != null && jsonStr.isNotEmpty) {
          try {
            allRecommendations.addAll(jsonDecode(jsonStr));
          } catch (_) {}
        }
      }

      // 4. Sort with genre weighting
      allRecommendations.sort((a, b) {
        double scoreA =
            (a[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        double scoreB =
            (b[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;

        // Apply genre weights
        double boostA = 0.0;
        final List<dynamic>? genresA = a[TmdbTitleFields.genreIds];
        if (genresA != null) {
          for (final genreId in genresA) {
            boostA += genrePreferences[genreId] ?? 0.0;
          }
        }

        double boostB = 0.0;
        final List<dynamic>? genresB = b[TmdbTitleFields.genreIds];
        if (genresB != null) {
          for (final genreId in genresB) {
            boostB += genrePreferences[genreId] ?? 0.0;
          }
        }

        final finalScoreA = scoreA * (1.0 + boostA);
        final finalScoreB = scoreB * (1.0 + boostB);

        return finalScoreB.compareTo(finalScoreA);
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
