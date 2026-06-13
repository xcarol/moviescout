import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/services/isar_service.dart';

class TmdbPersonRepository {
  final _isar = IsarService.instance;

  Future<void> savePeople(List<TmdbPerson> people) async {
    if (people.isEmpty) return;

    const batchSize = 250;
    for (var i = 0; i < people.length; i += batchSize) {
      final end =
          (i + batchSize < people.length) ? i + batchSize : people.length;
      final batch = people.sublist(i, end);
      await _isar.writeTxn(() async {
        await _isar.tmdbPersons.putAll(batch);
      });
    }
  }

  Future<void> clearTransientList(String transientListId) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbPersons
          .filter()
          .transientListIdEqualTo(transientListId)
          .deleteAll();
    });
  }

  Future<List<TmdbPerson>> getPeople({
    required String transientListId,
    String filterText = '',
    String filterDepartment = '',
    String sortOption = 'original',
    bool sortAscending = true,
    int offset = 0,
    int limit = 10,
  }) async {
    var query =
        _isar.tmdbPersons.filter().transientListIdEqualTo(transientListId);

    if (filterText.isNotEmpty) {
      query = query.group((q) => q
          .nameContains(filterText, caseSensitive: false)
          .or()
          .characterContains(filterText, caseSensitive: false)
          .or()
          .jobContains(filterText, caseSensitive: false));
    }

    if (filterDepartment.isNotEmpty) {
      query = query.knownForDepartmentEqualTo(filterDepartment);
    }

    QueryBuilder<TmdbPerson, TmdbPerson, QAfterSortBy>? sortedQuery;

    if (sortOption == 'name') {
      sortedQuery = sortAscending ? query.sortByName() : query.sortByNameDesc();
    } else if (sortOption == 'department') {
      sortedQuery = sortAscending
          ? query.sortByKnownForDepartment()
          : query.sortByKnownForDepartmentDesc();
    } else if (sortOption == 'job') {
      sortedQuery = sortAscending ? query.sortByJob() : query.sortByJobDesc();
    }

    if (sortedQuery != null) {
      return await sortedQuery.offset(offset).limit(limit).findAll();
    } else {
      // Default Isar sorting (by internal ID) preserves insertion order, which is the TMDB API order.
      // Since Isar 3 doesn't have sortByIdDesc(), we'll fetch all and reverse if needed,
      // or just return the ascending paginated results. Usually TMDB order is ascending.
      if (!sortAscending) {
        // If they specifically ask for descending original order,
        // we have to reverse the whole list in memory and then paginate, because Isar lacks sortByIdDesc.
        final allResults = await query.findAll();
        final reversed = allResults.reversed.toList();
        return reversed.skip(offset).take(limit).toList();
      }
      return await query.offset(offset).limit(limit).findAll();
    }
  }

  Future<int> countPeople({
    required String transientListId,
    String filterText = '',
    String filterDepartment = '',
  }) async {
    var query =
        _isar.tmdbPersons.filter().transientListIdEqualTo(transientListId);

    if (filterText.isNotEmpty) {
      query = query.group((q) => q
          .nameContains(filterText, caseSensitive: false)
          .or()
          .characterContains(filterText, caseSensitive: false)
          .or()
          .jobContains(filterText, caseSensitive: false));
    }

    if (filterDepartment.isNotEmpty) {
      query = query.knownForDepartmentEqualTo(filterDepartment);
    }

    return await query.count();
  }
}
