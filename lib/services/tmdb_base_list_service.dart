import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

abstract class TmdbBaseListService<T> extends TmdbBaseService with ChangeNotifier {
  @protected
  String listNameVal = '';
  String get listName => listNameVal;

  @protected
  final List<T> loadedItemsVal = List.empty(growable: true);
  int get loadedItemCount => loadedItemsVal.length;

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
  Future<void> _loadNPagesFromStart(int pagesToLoad, int currentRequestId) async {
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

      final items = await fetchItems(offset: pageVal * pageSizeVal, limit: pageSizeVal);

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
}
