import 'package:flutter/widgets.dart';
import 'package:moviescout/models/discovery_options.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class UserPreferences {
  final Map<int, double> genreWeights;
  final List<int> preferredGenres;
  final List<int> dislikedGenres;
  final bool hasRatings;

  UserPreferences({
    required this.genreWeights,
    required this.preferredGenres,
    required this.dislikedGenres,
    required this.hasRatings,
  });
}

class TmdbDiscoverlistService extends TmdbTitleListService {
  static const Set<int> _validTvGenres = {
    10759,
    16,
    35,
    80,
    99,
    18,
    10751,
    10762,
    9648,
    10763,
    10764,
    10765,
    10766,
    10767,
    10768,
    37
  };

  static const Set<int> _validMovieGenres = {
    28,
    12,
    16,
    35,
    80,
    99,
    18,
    10751,
    14,
    36,
    27,
    10402,
    9648,
    10749,
    878,
    10770,
    53,
    10752,
    37
  };

  static const Map<int, int> _movieToTvGenreMap = {
    28: 10759,
    12: 10759,
    878: 10765,
    14: 10765,
    10752: 10768,
    36: 10768,
    27: 9648,
    53: 80,
  };

  bool _isRefreshPaused = false;
  bool _refreshPending = false;
  bool _retrievePending = false;

  bool get retrievePending => _retrievePending;
  bool get refreshPending => _refreshPending;

  final ValueNotifier<bool> isRefreshing = ValueNotifier(false);

  DiscoveryOptions _options = const DiscoveryOptions();
  DiscoveryOptions get options => _options;

  List<int> _enabledProviderIds = [];
  List<int> get enabledProviderIds => _enabledProviderIds;

  bool get anyFilterActive {
    final hasNonDefaultOptions = !_options.isDefault;
    final hasToggledProviders =
        _enabledProviderIds.isNotEmpty && !_options.filterByProviders;
    return hasNonDefaultOptions || hasToggledProviders;
  }

  TmdbDiscoverlistService(super.listName, super.repository) {
    _loadSavedOptions();
  }

  void _loadSavedOptions() {
    try {
      final prefs = PreferencesService().prefs;
      _options = DiscoveryOptions.loadFromPrefs(prefs);
    } catch (_) {}
  }

  void setEnabledProviderIds(List<int> ids) {
    _enabledProviderIds = ids;
  }

  Future<void> updateDiscoveryOptions(
    DiscoveryOptions newOptions,
    Locale locale,
  ) async {
    _options = newOptions;
    try {
      final prefs = PreferencesService().prefs;
      await _options.saveToPrefs(prefs);
    } catch (_) {}
    notifyListeners();
    await retrieveDiscoverlist(locale, forceUpdate: true);
  }

  void clearPendingFlags() {
    _retrievePending = false;
    _refreshPending = false;
  }

  Future<void> retrieveDiscoverlist(
    Locale locale, {
    bool forceUpdate = false,
  }) async {
    if (((_isRefreshPaused && hasLoadedItems) || isLoading.value) &&
        !forceUpdate) {
      _retrievePending = true;
      return;
    }

    isRefreshing.value = true;
    try {
      await retrieveList(
        forceUpdate: forceUpdate,
        fetchRemoteData: () async {
          final titles = await fetchAndMergeTmdbLists(
            retrieveMovies: () =>
                _getDiscoveryTitles(locale, ApiConstants.movie),
            retrieveTvshows: () => _getDiscoveryTitles(locale, ApiConstants.tv),
          );
          if (forceUpdate) {
            await clearList();
          }
          return titles;
        },
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  double _getWeightForRating(double rating) {
    if (rating >= 4.5) return 1.0;
    if (rating >= 3.5) return 0.7;
    if (rating >= 2.5) return 0.2;
    if (rating > 0) return -0.6;
    return 0.0;
  }

  int? _toTvGenre(int id) {
    if (_validTvGenres.contains(id)) return id;
    return _movieToTvGenreMap[id];
  }

  int? _toMovieGenre(int id) {
    if (_validMovieGenres.contains(id)) return id;
    if (id == 10759) return 28;
    if (id == 10765) return 878;
    if (id == 10768) return 10752;
    return null;
  }

  Future<UserPreferences> _calculatePreferences(String mediaType) async {
    final titleRepo = repository;
    final Map<int, double> genreWeights = {};
    final Map<int, int> genreCounts = {};
    final isMovie = mediaType == ApiConstants.movie;

    final ratedTitles =
        await titleRepo.getAllTitlesInList(AppConstants.rateslist);
    final watchlistTitles =
        await titleRepo.getAllTitlesInList(AppConstants.watchlist);

    final matchingRated =
        ratedTitles.where((t) => t.mediaType == mediaType).toList();
    final matchingWatchlist =
        watchlistTitles.where((t) => t.mediaType == mediaType).toList();

    final titlesToUseForRated =
        matchingRated.isNotEmpty ? matchingRated : ratedTitles;
    final titlesToUseForWatchlist =
        matchingWatchlist.isNotEmpty ? matchingWatchlist : watchlistTitles;

    final totalTitles =
        titlesToUseForRated.length + titlesToUseForWatchlist.length;
    if (totalTitles == 0) {
      return UserPreferences(
        genreWeights: {},
        preferredGenres: [],
        dislikedGenres: [],
        hasRatings: false,
      );
    }

    for (final title in titlesToUseForRated) {
      final weight = _getWeightForRating(title.rating);
      for (final id in title.genreIds) {
        final mappedId = isMovie ? _toMovieGenre(id) : _toTvGenre(id);
        if (mappedId != null) {
          genreWeights[mappedId] = (genreWeights[mappedId] ?? 0.0) + weight;
          genreCounts[mappedId] = (genreCounts[mappedId] ?? 0) + 1;
        }
      }
    }

    for (final title in titlesToUseForWatchlist) {
      for (final id in title.genreIds) {
        final mappedId = isMovie ? _toMovieGenre(id) : _toTvGenre(id);
        if (mappedId != null) {
          genreWeights[mappedId] = (genreWeights[mappedId] ?? 0.0) + 0.3;
          genreCounts[mappedId] = (genreCounts[mappedId] ?? 0) + 1;
        }
      }
    }

    final Map<int, double> normalizedWeights = {};
    genreWeights.forEach((id, totalWeight) {
      final count = genreCounts[id] ?? 1;
      final avgWeight = totalWeight / count;
      final frequency = count / totalTitles;
      final specificityPenalty = 1.0 / (1.0 + (frequency * 1.5));
      normalizedWeights[id] = (avgWeight * specificityPenalty).clamp(-0.5, 0.7);
    });

    final preferred = normalizedWeights.entries
        .where((e) => e.value > 0.1)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final disliked = normalizedWeights.entries
        .where((e) => e.value < -0.2)
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return UserPreferences(
      genreWeights: normalizedWeights,
      preferredGenres: preferred.map((e) => e.key).toList(),
      dislikedGenres: disliked.map((e) => e.key).toList(),
      hasRatings: ratedTitles.isNotEmpty,
    );
  }

  String _buildDiscoverQuery(
    Locale locale,
    String mediaType,
    int page,
    UserPreferences prefs,
  ) {
    final isMovie = mediaType == ApiConstants.movie;
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'language': '${locale.languageCode}-${locale.countryCode ?? "US"}',
      'include_adult': 'false',
    };

    if (!isMovie) {
      queryParams['include_null_first_air_dates'] = 'false';
    }

    final region = getCountryCode();
    if (region.isNotEmpty) {
      queryParams['watch_region'] = region;
      queryParams['with_watch_monetization_types'] = 'flatrate|free|ads';
    }

    if (_options.filterByProviders && _enabledProviderIds.isNotEmpty) {
      queryParams['with_watch_providers'] = _enabledProviderIds.join('|');
    }

    if (_options.theme != DiscoveryTheme.any) {
      final def = DiscoveryOptions.themes[_options.theme]!;
      final genres = isMovie ? def.movieGenreIds : def.tvGenreIds;
      if (genres.isNotEmpty) {
        queryParams['with_genres'] = genres.join('|');
      }
      if (def.keywordIds.isNotEmpty) {
        queryParams['with_keywords'] = def.keywordIds.join('|');
      }
    } else {
      if (prefs.preferredGenres.isNotEmpty) {
        queryParams['with_genres'] = prefs.preferredGenres.take(3).join('|');
      }
      if (prefs.dislikedGenres.isNotEmpty) {
        queryParams['without_genres'] = prefs.dislikedGenres.take(5).join(',');
      }
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final oneYearAgo = DateTime.now()
        .subtract(const Duration(days: 365))
        .toIso8601String()
        .split('T')
        .first;

    switch (_options.mode) {
      case DiscoveryMode.forYou:
        queryParams['sort_by'] = 'popularity.desc';
        if (isMovie) {
          if (prefs.hasRatings) {
            queryParams['vote_count.gte'] = '100';
            queryParams['vote_average.gte'] = '6.0';
          } else {
            queryParams['vote_count.gte'] = '250';
            queryParams['vote_average.gte'] = '6.5';
          }
        } else {
          if (prefs.hasRatings) {
            queryParams['vote_count.gte'] = '30';
            queryParams['vote_average.gte'] = '6.0';
          } else {
            queryParams['vote_count.gte'] = '50';
            queryParams['vote_average.gte'] = '6.5';
          }
        }
        break;
      case DiscoveryMode.hiddenGems:
        queryParams['sort_by'] = 'vote_average.desc';
        if (isMovie) {
          queryParams['vote_count.gte'] = '80';
          queryParams['vote_count.lte'] = '2500';
          queryParams['vote_average.gte'] = '7.0';
        } else {
          queryParams['vote_count.gte'] = '25';
          queryParams['vote_count.lte'] = '800';
          queryParams['vote_average.gte'] = '7.0';
        }
        break;
      case DiscoveryMode.topRated:
        queryParams['sort_by'] = 'vote_average.desc';
        if (isMovie) {
          queryParams['vote_count.gte'] = '1500';
          queryParams['vote_average.gte'] = '7.5';
        } else {
          queryParams['vote_count.gte'] = '300';
          queryParams['vote_average.gte'] = '7.5';
        }
        break;
      case DiscoveryMode.newReleases:
        if (isMovie) {
          queryParams['sort_by'] = 'primary_release_date.desc';
          queryParams['primary_release_date.lte'] = today;
          queryParams['primary_release_date.gte'] = oneYearAgo;
          queryParams['vote_count.gte'] = '30';
        } else {
          queryParams['sort_by'] = 'first_air_date.desc';
          queryParams['first_air_date.lte'] = today;
          queryParams['first_air_date.gte'] = oneYearAgo;
          queryParams['vote_count.gte'] = '15';
        }
        break;
    }

    final dateKeyGte =
        isMovie ? 'primary_release_date.gte' : 'first_air_date.gte';
    final dateKeyLte =
        isMovie ? 'primary_release_date.lte' : 'first_air_date.lte';

    switch (_options.epoch) {
      case DiscoveryEpoch.all:
        break;
      case DiscoveryEpoch.e2020s:
        queryParams[dateKeyGte] = '2020-01-01';
        break;
      case DiscoveryEpoch.e2010s:
        queryParams[dateKeyGte] = '2010-01-01';
        queryParams[dateKeyLte] = '2019-12-31';
        break;
      case DiscoveryEpoch.e2000s:
        queryParams[dateKeyGte] = '2000-01-01';
        queryParams[dateKeyLte] = '2009-12-31';
        break;
      case DiscoveryEpoch.e80s90s:
        queryParams[dateKeyGte] = '1980-01-01';
        queryParams[dateKeyLte] = '1999-12-31';
        break;
      case DiscoveryEpoch.classics:
        queryParams[dateKeyLte] = '1979-12-31';
        break;
    }

    if (isMovie) {
      switch (_options.duration) {
        case DiscoveryDuration.any:
          break;
        case DiscoveryDuration.short:
          queryParams['with_runtime.lte'] = '95';
          break;
        case DiscoveryDuration.standard:
          queryParams['with_runtime.gte'] = '90';
          queryParams['with_runtime.lte'] = '125';
          break;
        case DiscoveryDuration.epic:
          queryParams['with_runtime.gte'] = '120';
          break;
      }
    }

    final queryString = queryParams.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final baseEndpoint = isMovie ? 'discover/movie' : 'discover/tv';
    return '$baseEndpoint?$queryString';
  }

  void _scoreAndSortRecommendations(
    List<dynamic> recommendations,
    UserPreferences preferences,
  ) {
    if (_options.mode == DiscoveryMode.newReleases) {
      recommendations.sort((a, b) {
        final dateA = (a[TmdbTitleFields.releaseDate] ??
            a[TmdbTitleFields.firstAirDate] ??
            '') as String;
        final dateB = (b[TmdbTitleFields.releaseDate] ??
            b[TmdbTitleFields.firstAirDate] ??
            '') as String;
        return dateB.compareTo(dateA);
      });
      return;
    }

    if (_options.mode == DiscoveryMode.hiddenGems ||
        _options.mode == DiscoveryMode.topRated) {
      recommendations.sort((a, b) {
        final scoreA =
            (a[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        final scoreB =
            (b[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        return scoreB.compareTo(scoreA);
      });
      return;
    }

    recommendations.sort((a, b) {
      final scoreA =
          (a[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
      final scoreB =
          (b[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;

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

  Future<List<dynamic>> _getDiscoveryTitles(
    Locale locale,
    String mediaType,
  ) async {
    final List<dynamic> recommendations = [];
    final Set<int> excludedTmdbIds = {};

    final titleRepo = repository;
    final preferences = await _calculatePreferences(mediaType);

    final ratedTitles =
        await titleRepo.getAllTitlesInList(AppConstants.rateslist);
    final watchlistTitles =
        await titleRepo.getAllTitlesInList(AppConstants.watchlist);

    excludedTmdbIds.addAll(ratedTitles
        .where((t) => t.mediaType == mediaType)
        .map((t) => t.tmdbId));
    excludedTmdbIds.addAll(watchlistTitles
        .where((t) => t.mediaType == mediaType)
        .map((t) => t.tmdbId));

    int page = 1;
    int totalPages = 1;
    const int maxPagesToQuery = 5;
    const int targetCount = 40;

    while (recommendations.length < targetCount &&
        page <= totalPages &&
        page <= maxPagesToQuery) {
      final query = _buildDiscoverQuery(locale, mediaType, page, preferences);
      try {
        final response = await get(query);
        if (response.statusCode == 200) {
          final data = body(response);
          if (data['total_pages'] != null) {
            totalPages = (data['total_pages'] as num).toInt();
          }
          final List<dynamic>? results = data['results'];
          if (results != null) {
            for (final title in results) {
              if (recommendations.length >= targetCount) break;
              final id = title[TmdbTitleFields.id];
              if (id != null && !excludedTmdbIds.contains(id)) {
                recommendations.add(title);
                excludedTmdbIds.add(id);
              }
            }
          }
        } else {
          break;
        }
      } catch (_) {
        break;
      }
      page++;
    }

    _scoreAndSortRecommendations(recommendations, preferences);
    return recommendations;
  }

  void setRefreshPaused(bool paused) {
    _isRefreshPaused = paused;
  }

  @override
  bool get isDataLoading => super.isDataLoading || isRefreshing.value;

  @override
  bool get filterByProviders => false;

  @override
  void setProvidersFilter(bool filterByProviders, List<int> providerIds) {
    this.filterByProviders = false;
    filterProvidersIds = providerIds;
  }

  @override
  Future<void> setFilters({
    String text = '',
    String type = '',
    List<String> genres = const [],
    bool excludeGenres = false,
    bool filterByProviders = false,
    List<int> providerListIds = const [],
    RatingFilter ratingFilter = RatingFilter.all,
    String sort = SortOption.alphabetically,
    bool ascending = true,
  }) async {
    await super.setFilters(
      text: text,
      type: type,
      genres: genres,
      excludeGenres: excludeGenres,
      filterByProviders: false,
      providerListIds: providerListIds,
      ratingFilter: ratingFilter,
      sort: sort,
      ascending: ascending,
    );
  }

  @override
  @protected
  Future<List<TmdbTitle>> fetchItems({
    required int offset,
    required int limit,
  }) {
    return repository.getTitles(
      listName: listNameVal,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: false,
      filterProvidersIds: const [],
      sortOption: selectedSort,
      sortAscending: isSortAsc,
      filterRating: filterRating,
      offset: offset,
      limit: limit,
    );
  }

  @override
  @protected
  Future<int> countFilteredItems() async {
    return await repository.countTitlesFiltered(
      listName: listNameVal,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: false,
      filterProvidersIds: const [],
      filterRating: filterRating,
    );
  }

  @override
  void refresh() {
    if (_isRefreshPaused && hasLoadedItems) {
      _refreshPending = true;
      return;
    }
    filterItems();
  }

  @override
  Future<void> syncFromServer({
    Locale? locale,
    bool forceUpdate = false,
  }) async {
    await retrieveDiscoverlist(locale ?? const Locale('en', 'US'),
        forceUpdate: forceUpdate);
  }
}
