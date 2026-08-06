import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/api/ai_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

class TmdbSearchService extends TmdbBaseListService<TmdbItem> {
  final TmdbTitleRepository titleRepository;
  final List<TmdbPerson> _memoryPersons = [];
  final List<TmdbCollection> _memoryCollections = [];

  TmdbSearchService(String listName, this.titleRepository) {
    listNameVal = listName;
    selectedSort = SortOption.relevance;
  }

  @override
  bool get isRefreshable => false;

  bool _userRatingAvailableVal = false;

  @override
  bool get userRatingAvailable => _userRatingAvailableVal;

  @override
  Future<void> postFilterItems() async {
    _userRatingAvailableVal = await titleRepository.hasRatedTitles(listNameVal);
    notifyListeners();
  }

  Future<dynamic> searchImdbTitle(
    String imdbId,
    Locale locale,
  ) async {
    return get(
      UrlConstants.tmdbFindByIdEndpoint
          .replaceFirst('{ID}', imdbId)
          .replaceFirst(
              '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );
  }

  List<TmdbTitle> fromImdbIdToTitle(Map response) {
    List<TmdbTitle> titles = [];
    for (var key in response.keys) {
      if (key == ApiConstants.movieResults) {
        for (var movie in response[key]) {
          titles.add(TmdbTitle.fromMap(title: movie));
        }
      }
      if (key == ApiConstants.tvResults) {
        for (var tv in response[key]) {
          titles.add(TmdbTitle.fromMap(title: tv));
        }
      }
    }
    return titles;
  }

  int _totalPagesFromResponse(dynamic response, int maxOfType) {
    final Map responseBody = body(response);
    if (responseBody['results'] != null) {
      final resultsPerPage = (responseBody['results'] as List).length;
      if (resultsPerPage > 0) {
        return max((maxOfType / resultsPerPage).toInt(), 1);
      }
    }
    return 0;
  }

  String get currentFilterText => filterText;

  String get selectedType => filterMediaType;

  String _localFilterText = '';

  void updateLocalFilterText(String text) {
    _localFilterText = text;
    filterItems();
    notifyListeners();
  }

  Future<List<TmdbItem>> _getAllSortedAndFiltered() async {
    List<TmdbItem> allItems = [];
    if (filterMediaType == '' ||
        filterMediaType == ApiConstants.movie ||
        filterMediaType == ApiConstants.tv) {
      final titles = await titleRepository.getTitles(
        listName: listNameVal,
        filterText: '',
        limit: 1000,
        sortOption: selectedSort == SortOption.relevance
            ? SortOption.addedOrder
            : SortOption.alphabetically,
      );
      if (filterMediaType == '') {
        allItems.addAll(titles);
      } else {
        allItems.addAll(titles.where((t) => t.mediaType == filterMediaType));
      }
    }

    if (filterMediaType == '' || filterMediaType == ApiConstants.person) {
      if (filterText.isEmpty) {
        allItems.addAll(_memoryPersons);
      } else {
        final query = filterText.toLowerCase().trim();
        allItems.addAll(_memoryPersons.where((p) {
          return p.name.toLowerCase().contains(query) ||
              p.character.toLowerCase().contains(query) ||
              p.job.toLowerCase().contains(query);
        }));
      }
    }

    if (filterMediaType == '' || filterMediaType == ApiConstants.collection) {
      if (filterText.isEmpty) {
        allItems.addAll(_memoryCollections);
      } else {
        final query = filterText.toLowerCase().trim();
        allItems.addAll(_memoryCollections.where((c) {
          return c.name.toLowerCase().contains(query);
        }));
      }
    }

    if (_localFilterText.isNotEmpty) {
      final localQuery = _localFilterText.toLowerCase().trim();
      allItems = allItems.where((item) {
        return item.name.toLowerCase().contains(localQuery);
      }).toList();
    }

    if (filterGenres.isNotEmpty) {
      allItems = allItems.where((item) {
        if (item is! TmdbTitle) return false;

        bool hasAny = item.genreIds.any((id) => filterGenres.contains(id));
        if (filterExcludeGenres) {
          if (hasAny) return false;
        } else {
          if (!hasAny) return false;
        }
        return true;
      }).toList();
    }

    if (filterByProviders) {
      allItems = allItems.where((item) {
        if (item is! TmdbTitle) return false;

        if (filterProvidersIds.isNotEmpty) {
          if (!item.flatrateProviderIds
              .any((id) => filterProvidersIds.contains(id))) {
            return false;
          }
        } else {
          return false;
        }
        return true;
      }).toList();
    }

    final String query = filterText.toLowerCase().trim();

    if (selectedSort == SortOption.relevance) {
      return isSortAsc ? allItems : allItems.reversed.toList();
    }

    allItems.sort((a, b) {
      String nameA = a.name.toLowerCase();
      String nameB = b.name.toLowerCase();

      int compareResult = 0;
      if (selectedSort.isNotEmpty &&
          selectedSort != SortOption.alphabetically) {
        if (selectedSort == SortOption.rating) {
          double valA = a is TmdbTitle ? a.voteAverage : 0.0;
          double valB = b is TmdbTitle ? b.voteAverage : 0.0;
          compareResult = valA.compareTo(valB);
        } else if (selectedSort == SortOption.releaseDate) {
          String valA = a is TmdbTitle ? a.effectiveReleaseDate : '';
          String valB = b is TmdbTitle ? b.effectiveReleaseDate : '';
          compareResult = valA.compareTo(valB);
        } else if (selectedSort == SortOption.runtime) {
          int valA = a is TmdbTitle ? a.runtime : 0;
          int valB = b is TmdbTitle ? b.runtime : 0;
          compareResult = valA.compareTo(valB);
        } else if (selectedSort == SortOption.userRating) {
          double valA = a is TmdbTitle ? a.rating : 0.0;
          double valB = b is TmdbTitle ? b.rating : 0.0;
          compareResult = valA.compareTo(valB);
        } else if (selectedSort == SortOption.dateRated) {
          DateTime valA = a is TmdbTitle
              ? a.dateRated
              : DateTime.fromMillisecondsSinceEpoch(0);
          DateTime valB = b is TmdbTitle
              ? b.dateRated
              : DateTime.fromMillisecondsSinceEpoch(0);
          compareResult = valA.compareTo(valB);
        }
      }

      if (compareResult == 0) {
        if (selectedSort != SortOption.alphabetically && query.isNotEmpty) {
          bool exactA = nameA == query;
          bool exactB = nameB == query;
          if (exactA && !exactB) return isSortAsc ? -1 : 1;
          if (!exactA && exactB) return isSortAsc ? 1 : -1;

          bool startsA = nameA.startsWith(query);
          bool startsB = nameB.startsWith(query);
          if (startsA && !startsB) return isSortAsc ? -1 : 1;
          if (!startsA && startsB) return isSortAsc ? 1 : -1;
        }
        compareResult = nameA.compareTo(nameB);
      }

      return isSortAsc ? compareResult : -compareResult;
    });
    return allItems;
  }

  @override
  Future<int> countFilteredItems() async {
    final allItems = await _getAllSortedAndFiltered();
    return allItems.length;
  }

  @override
  Future<List<TmdbItem>> fetchItems(
      {required int offset, required int limit}) async {
    final allItems = await _getAllSortedAndFiltered();

    int end = offset + limit;
    if (end > allItems.length) end = allItems.length;
    if (offset >= allItems.length) return [];

    return allItems.sublist(offset, end);
  }

  int _activeSearchId = 0;

  bool _activeSearchChanged([int? searchId]) =>
      searchId != null && searchId != _activeSearchId;

  Future<void> clearList() async {
    _activeSearchId++;
    await titleRepository.clearList(listNameVal);
    _memoryPersons.clear();
    _memoryCollections.clear();
    clearLoadedItems(resetCount: true);
    notifyListeners();
  }

  Future<void> retrieveSearchlist(
      String accountId, String searchTerm, Locale locale) async {
    final searchId = ++_activeSearchId;
    isLoading.value = true;
    filterText = searchTerm;
    notifyListeners();

    try {
      await titleRepository.clearList(listNameVal);
      if (_activeSearchChanged(searchId)) return;

      _memoryPersons.clear();
      _memoryCollections.clear();

      await Future.wait([
        _fetchAndSaveMovies(searchTerm, locale, searchId),
        _fetchAndSaveTvShows(searchTerm, locale, searchId),
        _fetchAndSavePersons(searchTerm, locale, searchId),
        _fetchAndSaveCollections(searchTerm, locale, searchId),
      ]);

      if (_activeSearchChanged(searchId)) return;

      await filterItems();
    } catch (e) {
      // Ignore or log error
    } finally {
      if (searchId == _activeSearchId) {
        isLoading.value = false;
        notifyListeners();
      }
    }
  }

  Future<void> retrieveAiSearchlist(String searchTerm, Locale locale) async {
    isLoading.value = true;
    filterText = searchTerm;
    notifyListeners();

    try {
      await titleRepository.clearList(listNameVal);
      _memoryPersons.clear();
      _memoryCollections.clear();

      await _fetchAndSaveAiSuggestions(searchTerm, locale);

      await filterItems();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndSaveAiSuggestions(
      String searchTerm, Locale locale) async {
    final suggestions = await AiService().suggestTitles(searchTerm);
    if (suggestions.isEmpty) return;

    final List<Map<String, dynamic>> rawItems = [];
    final Set<String> seenKeys = {};

    for (final suggestion in suggestions) {
      final item = await _searchTmdbBySuggestion(suggestion, locale);
      if (item != null) {
        final id = item[TmdbTitleFields.id] as int;
        final mediaType = item[TmdbTitleFields.mediaType] as String;
        final key = '${id}_$mediaType';
        if (seenKeys.add(key)) {
          rawItems.add(item);
        }
      }
    }

    if (rawItems.isNotEmpty) {
      final mergedTitles = await _mergeRawItemsWithExisting(rawItems);
      await _saveTitlesWithDetails(mergedTitles);
    }
  }

  Future<Map<String, dynamic>?> _searchTmdbBySuggestion(
    AiTitleSuggestion suggestion,
    Locale locale,
  ) async {
    final query = Uri.encodeComponent(suggestion.title);
    final localeStr = '${locale.languageCode}-${locale.countryCode}';
    final year = suggestion.year;
    final isTv = suggestion.mediaType == ApiConstants.tv;

    final endpoint = _buildSuggestionEndpoint(query, year, isTv, localeStr);
    dynamic response = await get(endpoint);

    if (response.statusCode == 200 && year != null) {
      final Map responseBody = body(response);
      final results = responseBody['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        final fallbackEndpoint = _buildSuggestionEndpoint(
          query,
          year,
          isTv,
          localeStr,
          includeYear: false,
        );
        response = await get(fallbackEndpoint);
      }
    }

    if (response.statusCode == 200) {
      final Map responseBody = body(response);
      final results = responseBody['results'] as List<dynamic>?;
      if (results != null && results.isNotEmpty) {
        final item = Map<String, dynamic>.from(results.first);
        item[TmdbTitleFields.mediaType] =
            isTv ? ApiConstants.tv : ApiConstants.movie;
        return item;
      }
    }
    return null;
  }

  String _buildSuggestionEndpoint(
    String query,
    int? year,
    bool isTv,
    String localeStr, {
    bool includeYear = true,
  }) {
    if (isTv) {
      if (includeYear && year != null) {
        return UrlConstants.tmdbSearchTvShowsWithYearEndpoint
            .replaceFirst('{QUERY}', query)
            .replaceFirst('{YEAR}', year.toString())
            .replaceFirst('{PAGE}', '1')
            .replaceFirst('{LOCALE}', localeStr);
      }
      return UrlConstants.tmdbSearchTvShowsEndpoint
          .replaceFirst('{QUERY}', query)
          .replaceFirst('{PAGE}', '1')
          .replaceFirst('{LOCALE}', localeStr);
    }

    if (includeYear && year != null) {
      return UrlConstants.tmdbSearchMoviesWithYearEndpoint
          .replaceFirst('{QUERY}', query)
          .replaceFirst('{YEAR}', year.toString())
          .replaceFirst('{PAGE}', '1')
          .replaceFirst('{LOCALE}', localeStr);
    }
    return UrlConstants.tmdbSearchMoviesEndpoint
        .replaceFirst('{QUERY}', query)
        .replaceFirst('{PAGE}', '1')
        .replaceFirst('{LOCALE}', localeStr);
  }

  Future<void> _fetchAndSaveMovies(String searchTerm, Locale locale,
      [int? searchId]) async {
    int page = 1;
    int totalPages = 1;
    List<dynamic> rawItems = [];

    do {
      if (_activeSearchChanged(searchId)) return;
      dynamic response = await get(
        UrlConstants.tmdbSearchMoviesEndpoint
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{QUERY}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (_activeSearchChanged(searchId)) return;

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages =
              _totalPagesFromResponse(response, AppConstants.maxSearchMovies);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            item[TmdbTitleFields.mediaType] = ApiConstants.movie;
            rawItems.add(item);
          }
        }
      }
    } while (page++ < totalPages);

    if (_activeSearchChanged(searchId)) return;

    if (rawItems.isNotEmpty) {
      final mergedTitles =
          await _mergeRawItemsWithExisting(rawItems, ApiConstants.movie);
      if (_activeSearchChanged(searchId)) return;
      await _saveTitlesWithDetails(mergedTitles, searchId);
    }
  }

  Future<void> _fetchAndSaveTvShows(String searchTerm, Locale locale,
      [int? searchId]) async {
    int page = 1;
    int totalPages = 1;
    List<dynamic> rawItems = [];

    do {
      if (_activeSearchChanged(searchId)) return;
      dynamic response = await get(
        UrlConstants.tmdbSearchTvShowsEndpoint
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{QUERY}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (_activeSearchChanged(searchId)) return;

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages =
              _totalPagesFromResponse(response, AppConstants.maxSearchTvShows);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            item[TmdbTitleFields.mediaType] = ApiConstants.tv;
            rawItems.add(item);
          }
        }
      }
    } while (page++ < totalPages);

    if (_activeSearchChanged(searchId)) return;

    if (rawItems.isNotEmpty) {
      final mergedTitles =
          await _mergeRawItemsWithExisting(rawItems, ApiConstants.tv);
      if (_activeSearchChanged(searchId)) return;
      await _saveTitlesWithDetails(mergedTitles, searchId);
    }
  }

  Future<void> _fetchAndSavePersons(String searchTerm, Locale locale,
      [int? searchId]) async {
    int page = 1;
    int totalPages = 1;
    List<TmdbPerson> persons = [];

    do {
      if (_activeSearchChanged(searchId)) return;
      dynamic response = await get(
        UrlConstants.tmdbSearchPersonsEndpoint
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{QUERY}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (_activeSearchChanged(searchId)) return;

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages =
              _totalPagesFromResponse(response, AppConstants.maxSearchPersons);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            final person = TmdbPerson.fromMap(person: item);
            persons.add(person);
          }
        }
      }
    } while (page++ < totalPages);

    if (_activeSearchChanged(searchId)) return;

    if (persons.isNotEmpty) {
      _memoryPersons.addAll(persons);
    }
  }

  Future<void> _fetchAndSaveCollections(String searchTerm, Locale locale,
      [int? searchId]) async {
    int page = 1;
    int totalPages = 1;
    List<TmdbCollection> collections = [];

    do {
      if (_activeSearchChanged(searchId)) return;
      dynamic response = await get(
        UrlConstants.tmdbSearchCollectionsEndpoint
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{QUERY}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (_activeSearchChanged(searchId)) return;

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages = _totalPagesFromResponse(
              response, AppConstants.maxSearchCollections);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            final collection = TmdbCollection.fromMap(collection: item);
            collections.add(collection);
          }
        }
      }
    } while (page++ < totalPages);

    if (_activeSearchChanged(searchId)) return;

    if (collections.isNotEmpty) {
      _memoryCollections.addAll(collections);
    }
  }

  Future<void> _saveTitlesWithDetails(List<TmdbTitle> titles,
      [int? searchId]) async {
    final updated = await Future.wait(titles.map((t) => TmdbTitleService()
        .updateTitleDetails(t,
            force: t.lastUpdated == AppConstants.defaultDate)));
    if (_activeSearchChanged(searchId)) return;
    await titleRepository.saveTitles(updated.cast<TmdbTitle>(), listNameVal);
  }

  Future<List<TmdbTitle>> _mergeRawItemsWithExisting(List<dynamic> rawItems,
      [String? defaultMediaType]) async {
    final allTmdbIds =
        rawItems.map((item) => item[TmdbTitleFields.id] as int).toList();
    final existingTitles = await titleRepository.getTitlesByTmdbIds(allTmdbIds);
    final existingMap = {
      for (var t in existingTitles) '${t.tmdbId}_${t.mediaType}': t
    };

    List<TmdbTitle> mergedTitles = [];
    for (var item in rawItems) {
      final tmdbId = item[TmdbTitleFields.id] as int;
      final mediaType =
          item[TmdbTitleFields.mediaType] as String? ?? defaultMediaType ?? '';
      final existing = existingMap['${tmdbId}_$mediaType'];
      if (existing != null) {
        mergedTitles.add(existing);
      } else {
        mergedTitles.add(TmdbTitle.fromMap(title: item));
      }
    }
    return mergedTitles;
  }
}
