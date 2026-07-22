import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_genre_service.dart';

enum RatingFilter { all, rated, seenOnly, followingOnly }

abstract class TmdbBaseListService<T> extends TmdbBaseService
    with ChangeNotifier {
  @protected
  String listNameVal = '';
  String get listName => listNameVal;

  @protected
  final List<T> loadedItemsVal = List.empty(growable: true);
  int get loadedItemCount => loadedItemsVal.length;

  bool get userRatingAvailable => false;

  @protected
  bool isDbLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @protected
  bool hasMoreVal = true;
  bool get hasMore => hasMoreVal;

  @protected
  int pageVal = 0;
  @protected
  final int pageSizeVal = 10;

  @protected
  bool anyFilterApplied = false;
  @protected
  int filterRequestId = 0;

  @protected
  String filterText = '';

  ValueNotifier<int> selectedItemCount = ValueNotifier(0);

  @protected
  String filterMediaType = '';
  @protected
  List<int> filterGenres = [];
  @protected
  bool filterExcludeGenres = false;
  @protected
  List<int> filterProvidersIds = [];
  @protected
  bool filterByProviders = false;
  @protected
  String selectedSort = SortOption.alphabetically;
  @protected
  bool isSortAsc = true;
  @protected
  RatingFilter filterRating = RatingFilter.all;

  String get defaultSort => selectedSort;
  bool get defaultSortAsc => isSortAsc;

  @protected
  List<String> listGenresVal = [];
  ValueNotifier<List<String>> listGenres = ValueNotifier([]);

  bool get isRefreshable => true;

  T? getItem(int position) {
    if (position < 0 || position >= loadedItemsVal.length) {
      return null;
    }
    try {
      return loadedItemsVal[position];
    } catch (error, stackTrace) {
      ErrorService.log(
        'Error getting item at position $position: $error',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @protected
  void clearLoadedItems({bool resetCount = false}) {
    loadedItemsVal.clear();
    if (resetCount) {
      selectedItemCount.value = 0;
    }
    anyFilterApplied = false;
    hasMoreVal = true;
    pageVal = 0;
  }

  void setTextFilter(String filter) {
    filterText = filter;
    filterItems();
  }

  void refresh() {
    filterItems(retainPagination: true);
  }

  @protected
  Future<void> preFilterItems(int requestId) async {}

  @protected
  Future<void> postFilterItems() async {}

  @protected
  Future<int> countFilteredItems();

  @protected
  Future<List<T>> fetchItems({required int offset, required int limit});

  @protected
  bool computeHasMore(int itemsFetched, int limit) {
    if (itemsFetched < limit && !isLoading.value) {
      return false;
    }
    return true;
  }

  Future<void> filterItems({bool retainPagination = false}) async {
    while (isDbLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final currentRequestId = ++filterRequestId;
    final int pagesToLoad = (retainPagination && pageVal > 0) ? pageVal : 1;

    anyFilterApplied = true;

    await preFilterItems(currentRequestId);
    if (currentRequestId != filterRequestId) return;

    final count = await countFilteredItems();
    if (currentRequestId != filterRequestId) return;

    selectedItemCount.value = count;

    await _loadNPagesFromStart(pagesToLoad, currentRequestId);

    await postFilterItems();
  }

  @protected
  Future<void> _loadNPagesFromStart(
      int pagesToLoad, int currentRequestId) async {
    isDbLoading = true;
    try {
      final limit = pagesToLoad * pageSizeVal;
      final items = await fetchItems(offset: 0, limit: limit);

      if (currentRequestId != filterRequestId) return;

      loadedItemsVal.clear();
      loadedItemsVal.addAll(items);
      pageVal = pagesToLoad;
      hasMoreVal = computeHasMore(items.length, limit);
    } catch (error, stackTrace) {
      ErrorService.log(
        error.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      isDbLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (isDbLoading || !hasMoreVal) return;

    isDbLoading = true;
    try {
      if (!anyFilterApplied) {
        return filterItems();
      }
      final currentRequestId = ++filterRequestId;

      final items =
          await fetchItems(offset: pageVal * pageSizeVal, limit: pageSizeVal);

      if (currentRequestId != filterRequestId) return;

      loadedItemsVal.addAll(items);
      pageVal++;
      hasMoreVal = computeHasMore(items.length, pageSizeVal);
    } catch (error, stackTrace) {
      ErrorService.log(
        error.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      isDbLoading = false;
      notifyListeners();
    }
  }

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
    filterText = text;
    filterMediaType = type;
    filterGenres = TmdbGenreService().getIdsFromNames(genres);
    filterExcludeGenres = excludeGenres;
    this.filterByProviders = filterByProviders;
    filterProvidersIds = providerListIds;
    filterRating = ratingFilter;
    selectedSort = sort;
    isSortAsc = computeSortDirection(sort, ascending);
    await filterItems();
  }

  void setGenresFilter(List<String> genres, bool excludeGenres) {
    filterGenres = TmdbGenreService().getIdsFromNames(genres);
    filterExcludeGenres = excludeGenres;
    filterItems();
  }

  void setProvidersFilter(bool filterByProviders, List<int> providerIds) {
    this.filterByProviders = filterByProviders;
    filterProvidersIds = providerIds;
    filterItems();
  }

  void setTypeFilter(String type) {
    filterMediaType = type;
    filterItems();
  }

  void setRatingFilter(RatingFilter filter) {
    filterRating = filter;
    filterItems();
  }

  @protected
  bool computeSortDirection(String sort, bool ascending) {
    switch (sort) {
      case SortOption.alphabetically:
        return ascending;
      case SortOption.rating:
      case SortOption.userRating:
      case SortOption.releaseDate:
      case SortOption.dateRated:
      case SortOption.runtime:
      case SortOption.addedOrder:
        return !ascending;
      default:
        return ascending;
    }
  }

  void setSort(String sort, bool ascending) {
    selectedSort = sort;
    isSortAsc = computeSortDirection(sort, ascending);
    filterItems();
  }
}
