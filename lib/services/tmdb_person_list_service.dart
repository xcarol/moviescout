import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_person_repository.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';

class TmdbPersonListService extends TmdbBaseListService<TmdbPerson> {
  final TmdbPersonRepository repository;
  final TmdbTitle title;
  final String roleType; // 'cast' or 'crew'

  String _selectedSort = 'original';
  bool _isSortAsc = true;

  TmdbPersonListService({
    required this.repository,
    required this.title,
    required this.roleType,
  }) {
    listNameVal = '${title.tmdbId}_$roleType';
    _initializeList();
  }

  Future<void> _initializeList() async {
    isLoading.value = true;
    try {
      await repository.clearTransientList(listNameVal);

      final List<TmdbPerson> people = roleType == PersonAttributes.cast ? title.cast : title.crew;
      for (var person in people) {
        person.transientListId = listNameVal;
      }
      
      await repository.savePeople(people);
      
      await filterItems();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    // Clear the transient list when service is disposed
    repository.clearTransientList(listNameVal);
    super.dispose();
  }

  void setSort(String sort, bool ascending) {
    _selectedSort = sort;
    _isSortAsc = ascending;
    filterItems();
  }

  @override
  Future<int> countFilteredItems() async {
    return repository.countPeople(
      transientListId: listNameVal,
      filterText: filterText,
    );
  }

  @override
  Future<List<TmdbPerson>> fetchItems({required int offset, required int limit}) async {
    return repository.getPeople(
      transientListId: listNameVal,
      filterText: filterText,
      sortOption: _selectedSort,
      sortAscending: _isSortAsc,
      offset: offset,
      limit: limit,
    );
  }
}
