import re

with open('/home/xcarol/workspace/moviescout/lib/services/discoverlist_service.dart', 'r') as f:
    content = f.read()

new_content = """import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class UserPreferences {
  final Map<int, double> genreWeights;
  final Map<int, double> keywordWeights;

  UserPreferences(this.genreWeights, this.keywordWeights);
}

class TmdbDiscoverlistService extends TmdbTitleListService {
  bool _isRefreshPaused = false;
  bool _refreshPending = false;
  bool _retrievePending = false;

  bool get retrievePending => _retrievePending;
  bool get refreshPending => _refreshPending;

  final ValueNotifier<bool> isRefreshing = ValueNotifier(false);

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

    isRefreshing.value = true;
    await clearList();

    retrieveList(
        accountId.isEmpty ? AppConstants.anonymousAccountId : accountId,
        forceUpdate: forceUpdate, retrieveMovies: () async {
      return _getDiscoveryTitles(accountId, sessionId, locale,
          ApiConstants.movie, UrlConstants.tmdbPopularMoviesEndpoint);
    }, retrieveTvshows: () async {
      return _getDiscoveryTitles(accountId, sessionId, locale, ApiConstants.tv,
          UrlConstants.tmdbPopularTvEndpoint);
    }).whenComplete(() {
      isRefreshing.value = false;
    });
  }

  Map<int, double> _normalizeWeights(Map<int, double> weights, Map<int, int> counts, int totalTitles) {
    final Map<int, double> normalizedWeights = {};
    weights.forEach((id, totalWeight) {
      final count = counts[id] ?? 1;
      final avgWeight = totalWeight / count;

      // Specificity Factor (IDF-like):
      // If a genre/keyword appears in almost all titles, its "importance" is reduced.
      // specificity = log(Total / Count)
      // Since this is a mobile app with few titles, we use a smoothed version:
      final frequency = count / totalTitles;
      final specificityPenalty = 1.0 / (1.0 + (frequency * 2.0));

      normalizedWeights[id] = (avgWeight * specificityPenalty).clamp(-0.4, 0.6);
    });
    return normalizedWeights;
  }

  Future<UserPreferences> _calculatePreferences() async {
    final titleRepo = TmdbTitleRepository();
    final Map<int, double> genreWeights = {};
    final Map<int, int> genreCounts = {};
    final Map<int, double> keywordWeights = {};
    final Map<int, int> keywordCounts = {};

    final ratedTitles = await titleRepo.getAllTitlesInList(AppConstants.rateslist);
    final watchlistTitles = await titleRepo.getAllTitlesInList(AppConstants.watchlist);

    final allTitles = {...ratedTitles, ...watchlistTitles}.toList();
    final totalTitles = allTitles.length;

    if (totalTitles == 0) return UserPreferences({}, {});

    void addWeights(List<int> genres, List<int> keywords, double weight) {
      for (final id in genres) {
        genreWeights[id] = (genreWeights[id] ?? 0.0) + weight;
        genreCounts[id] = (genreCounts[id] ?? 0) + 1;
      }
      for (final id in keywords) {
        keywordWeights[id] = (keywordWeights[id] ?? 0.0) + weight;
        keywordCounts[id] = (keywordCounts[id] ?? 0) + 1;
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
      addWeights(title.genreIds, title.keywordIds, weight);
    }

    for (final title in watchlistTitles) {
      addWeights(title.genreIds, title.keywordIds, 0.4);
    }

    return UserPreferences(
      _normalizeWeights(genreWeights, genreCounts, totalTitles),
      _normalizeWeights(keywordWeights, keywordCounts, totalTitles),
    );
  }

  Future<List<dynamic>> _fetchDiscoverTitles(String discoverEndpoint, Locale locale, UserPreferences preferences) async {
    final topGenres = preferences.genreWeights.entries.where((e) => e.value > 0).toList()..sort((a, b) => b.value.compareTo(a.value));
    final topKeywords = preferences.keywordWeights.entries.where((e) => e.value > 0).toList()..sort((a, b) => b.value.compareTo(a.value));

    final genresQuery = topGenres.take(3).map((e) => e.key).join('|');
    final keywordsQuery = topKeywords.take(3).map((e) => e.key).join('|');

    if (genresQuery.isEmpty && keywordsQuery.isEmpty) return [];

    try {
      return await getTitlesFromServer((int page) async {
        if (page > 1) return http.Response('{"page":$page,"total_pages":$page}', 200);
        return get(discoverEndpoint
            .replaceFirst('{PAGE}', '1')
            .replaceFirst('{LOCALE}', '${locale.languageCode}-${locale.countryCode}')
            .replaceFirst('{GENRES}', genresQuery)
            .replaceFirst('{KEYWORDS}', keywordsQuery));
      });
    } catch (_) {
      return [];
    }
  }

  List<dynamic> _extractRecommendationsFromSeeds(List<TmdbTitle> seedTitles) {
    final List<dynamic> allRecommendations = [];
    final selectedSeeds = seedTitles.take(20).toList();
    for (final title in selectedSeeds) {
      final jsonStr = title.recommendationsJson;
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          allRecommendations.addAll(jsonDecode(jsonStr));
        } catch (_) {}
      }
    }
    return allRecommendations;
  }

  void _scoreAndSortRecommendations(List<dynamic> recommendations, UserPreferences preferences) {
    recommendations.sort((a, b) {
      double scoreA = (a[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
      double scoreB = (b[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;

      double boostA = 0.0;
      final List<dynamic>? genresA = a[TmdbTitleFields.genreIds];
      if (genresA != null) {
        for (final genreId in genresA) {
          boostA += preferences.genreWeights[genreId] ?? 0.0;
        }
      }

      double boostB = 0.0;
      final List<dynamic>? genresB = b[TmdbTitleFields.genreIds];
      if (genresB != null) {
        for (final genreId in genresB) {
          boostB += preferences.genreWeights[genreId] ?? 0.0;
        }
      }

      final finalScoreA = scoreA * (1.0 + boostA);
      final finalScoreB = scoreB * (1.0 + boostB);

      return finalScoreB.compareTo(finalScoreA);
    });
  }

  Future<List> _getDiscoveryTitles(String accountId, String sessionId, Locale locale, String mediaType, String popularEndpoint) async {
    final String discoverEndpoint = mediaType == ApiConstants.movie 
        ? UrlConstants.tmdbDiscoverMoviesEndpoint 
        : UrlConstants.tmdbDiscoverTvEndpoint;
    final List<dynamic> recommendations = [];
    final Set<int> excludedTmdbIds = {};

    if (accountId.isNotEmpty) {
      final titleRepo = TmdbTitleRepository();
      final preferences = await _calculatePreferences();

      final ratedTitles = await titleRepo.getAllTitlesInList(AppConstants.rateslist);
      final watchlistTitles = await titleRepo.getAllTitlesInList(AppConstants.watchlist);

      final positiveSignalTitles = [
        ...ratedTitles.where((t) => t.rating > 2.5 && t.mediaType == mediaType),
        ...watchlistTitles.where((t) => t.mediaType == mediaType)
      ];

      excludedTmdbIds.addAll(ratedTitles.where((t) => t.mediaType == mediaType).map((t) => t.tmdbId));
      excludedTmdbIds.addAll(watchlistTitles.where((t) => t.mediaType == mediaType).map((t) => t.tmdbId));

      final List<dynamic> allRecommendations = [];
      allRecommendations.addAll(await _fetchDiscoverTitles(discoverEndpoint, locale, preferences));
      allRecommendations.addAll(_extractRecommendationsFromSeeds([...positiveSignalTitles]..shuffle()));

      _scoreAndSortRecommendations(allRecommendations, preferences);

      for (final rec in allRecommendations) {
        if (recommendations.length >= 40) break;
        final recId = rec[TmdbTitleFields.id];
        if (!excludedTmdbIds.contains(recId)) {
          recommendations.add(rec);
          excludedTmdbIds.add(recId);
        }
      }
    }

    if (recommendations.length < 40) {
      final popularTitles = await getTitlesFromServer((int page) async {
        if (page > 2) return http.Response('{"page":$page,"total_pages":$page}', 200);
        return get(popularEndpoint
            .replaceFirst('{ACCOUNT_ID}', accountId)
            .replaceFirst('{SESSION_ID}', sessionId)
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{LOCALE}', '${locale.languageCode}-${locale.countryCode}'));
      });

      for (final title in popularTitles) {
        if (recommendations.length >= 40) break;
        final id = title[TmdbTitleFields.id];
        if (!excludedTmdbIds.contains(id)) {
          recommendations.add(title);
          excludedTmdbIds.add(id);
        }
      }
    }

    return recommendations;
  }

  void setRefreshPaused(bool paused) {
    _isRefreshPaused = paused;
  }

  @override
  void refresh() {
    if (_isRefreshPaused && listIsNotEmpty) {
      _refreshPending = true;
      return;
    }
    filterItems();
  }

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    await retrieveDiscoverlist(accountId, sessionId, locale, forceUpdate: true);
  }
}
"""

with open('/home/xcarol/workspace/moviescout/lib/services/discoverlist_service.dart', 'w') as f:
    f.write(new_content)
