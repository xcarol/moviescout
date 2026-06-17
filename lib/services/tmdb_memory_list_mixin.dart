import 'package:moviescout/services/tmdb_base_list_service.dart';

mixin TmdbMemoryListMixin<T> on TmdbBaseListService<T> {
  final List<T> allItems = [];
  List<T> filteredItems = [];

  /// Subclasses must implement this to populate [filteredItems] from [allItems]
  /// based on their specific filtering and sorting logic.
  void applyFiltersAndSort();

  @override
  Future<void> preFilterItems(int requestId) async {
    applyFiltersAndSort();
  }

  @override
  Future<int> countFilteredItems() async {
    return filteredItems.length;
  }

  @override
  Future<List<T>> fetchItems({required int offset, required int limit}) async {
    int end = offset + limit;
    if (end > filteredItems.length) end = filteredItems.length;
    if (offset >= filteredItems.length) return [];

    return filteredItems.sublist(offset, end);
  }
}
