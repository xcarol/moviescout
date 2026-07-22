import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

const int maxSearchMovies = 20;
const int maxSearchTvShows = 20;
const int maxSearchPersons = 20;

const String _tmdbSearchMovies =
    '/search/movie?query={SEARCH}&page={PAGE}&language={LOCALE}';

const String _tmdbSearchTvShows =
    '/search/tv?query={SEARCH}&page={PAGE}&language={LOCALE}';

const String _tmdbSearchPersons =
    '/search/person?query={SEARCH}&page={PAGE}&language={LOCALE}';

const String _tmdbFindByID =
    '/find/{ID}?language={LOCALE}&external_source=imdb_id';

class TmdbSearchService extends TmdbBaseListService<TmdbItem> {
  final TmdbTitleRepository titleRepository;
  final List<TmdbPerson> _memoryPersons = [];

  TmdbSearchService(String listName, this.titleRepository) {
    listNameVal = listName;
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
      _tmdbFindByID.replaceFirst('{ID}', imdbId).replaceFirst(
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

    if (_localFilterText.isNotEmpty) {
      final localQuery = _localFilterText.toLowerCase().trim();
      allItems = allItems.where((item) {
        String name =
            (item is TmdbTitle ? item.name : (item as TmdbPerson).name)
                .toLowerCase();
        return name.contains(localQuery);
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

    allItems.sort((a, b) {
      String nameA =
          (a is TmdbTitle ? a.name : (a as TmdbPerson).name).toLowerCase();
      String nameB =
          (b is TmdbTitle ? b.name : (b as TmdbPerson).name).toLowerCase();

      if (query.isNotEmpty) {
        bool exactA = nameA == query;
        bool exactB = nameB == query;
        if (exactA && !exactB) return -1;
        if (!exactA && exactB) return 1;

        bool startsA = nameA.startsWith(query);
        bool startsB = nameB.startsWith(query);
        if (startsA && !startsB) return -1;
        if (!startsA && startsB) return 1;
      }

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
        } else {
          compareResult = nameA.compareTo(nameB);
        }
      } else {
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

  Future<void> clearList() async {
    await titleRepository.clearList(listNameVal);
    _memoryPersons.clear();
    clearLoadedItems(resetCount: true);
    notifyListeners();
  }

  Future<void> retrieveSearchlist(
      String accountId, String searchTerm, Locale locale) async {
    isLoading.value = true;
    filterText = searchTerm;
    notifyListeners();

    try {
      await titleRepository.clearList(listNameVal);
      _memoryPersons.clear();

      await Future.wait([
        _fetchAndSaveMovies(searchTerm, locale),
        _fetchAndSaveTvShows(searchTerm, locale),
        _fetchAndSavePersons(searchTerm, locale),
      ]);

      await filterItems();
    } catch (e) {
      // Ignore or log error
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndSaveMovies(String searchTerm, Locale locale) async {
    int page = 1;
    int totalPages = 1;
    List<dynamic> rawItems = [];

    do {
      dynamic response = await get(
        _tmdbSearchMovies
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{SEARCH}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages = _totalPagesFromResponse(response, maxSearchMovies);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            item[TmdbTitleFields.mediaType] = ApiConstants.movie;
            rawItems.add(item);
          }
        }
      }
    } while (page++ < totalPages);

    if (rawItems.isNotEmpty) {
      final mergedTitles =
          await _mergeRawItemsWithExisting(rawItems, ApiConstants.movie);
      final updated = await Future.wait(mergedTitles.map((t) =>
          TmdbTitleService().updateTitleDetails(t,
              force: t.lastProvidersUpdate == AppConstants.defaultDate)));
      await titleRepository.saveTitles(updated.cast<TmdbTitle>(), listNameVal);
    }
  }

  Future<void> _fetchAndSaveTvShows(String searchTerm, Locale locale) async {
    int page = 1;
    int totalPages = 1;
    List<dynamic> rawItems = [];

    do {
      dynamic response = await get(
        _tmdbSearchTvShows
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{SEARCH}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages = _totalPagesFromResponse(response, maxSearchTvShows);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            item[TmdbTitleFields.mediaType] = ApiConstants.tv;
            rawItems.add(item);
          }
        }
      }
    } while (page++ < totalPages);

    if (rawItems.isNotEmpty) {
      final mergedTitles =
          await _mergeRawItemsWithExisting(rawItems, ApiConstants.tv);
      final updated = await Future.wait(mergedTitles.map((t) =>
          TmdbTitleService().updateTitleDetails(t,
              force: t.lastProvidersUpdate == AppConstants.defaultDate)));
      await titleRepository.saveTitles(updated.cast<TmdbTitle>(), listNameVal);
    }
  }

  Future<void> _fetchAndSavePersons(String searchTerm, Locale locale) async {
    int page = 1;
    int totalPages = 1;
    List<TmdbPerson> persons = [];

    do {
      dynamic response = await get(
        _tmdbSearchPersons
            .replaceFirst('{PAGE}', page.toString())
            .replaceFirst('{SEARCH}', searchTerm)
            .replaceFirst(
                '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      if (response.statusCode == 200) {
        final Map responseBody = body(response);
        if (responseBody['total_pages'] != null) {
          totalPages = _totalPagesFromResponse(response, maxSearchPersons);
        }
        if (responseBody['results'] != null) {
          for (var item in responseBody['results']) {
            final person = TmdbPerson.fromMap(person: item);
            persons.add(person);
          }
        }
      }
    } while (page++ < totalPages);

    if (persons.isNotEmpty) {
      _memoryPersons.addAll(persons);
    }
  }

  Future<List<TmdbTitle>> _mergeRawItemsWithExisting(
      List<dynamic> rawItems, String mediaType) async {
    final allTmdbIds =
        rawItems.map((item) => item[TmdbTitleFields.id] as int).toList();
    final existingTitles = await titleRepository.getTitlesByTmdbIds(allTmdbIds);
    final existingMap = {
      for (var t in existingTitles) '${t.tmdbId}_${t.mediaType}': t
    };

    List<TmdbTitle> mergedTitles = [];
    for (var item in rawItems) {
      final tmdbId = item[TmdbTitleFields.id] as int;
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
