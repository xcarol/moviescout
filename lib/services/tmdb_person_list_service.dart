import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/repositories/tmdb_person_repository.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';

class TmdbPersonListService extends TmdbBaseListService<TmdbPerson> {
  final TmdbPersonRepository repository;
  final TmdbTitle title;
  final String roleType; // 'cast' or 'crew'
  final TmdbSeason? season;
  final TmdbEpisode? episode;

  String _selectedSort = 'original';
  bool _isSortAsc = true;

  TmdbPersonListService({
    required this.repository,
    required this.title,
    required this.roleType,
    this.season,
    this.episode,
  }) {
    if (episode != null) {
      listNameVal = '${title.tmdbId}_s${episode!.seasonNumber}e${episode!.episodeNumber}_$roleType';
    } else if (season != null) {
      listNameVal = '${title.tmdbId}_s${season!.seasonNumber}_$roleType';
    } else {
      listNameVal = '${title.tmdbId}_$roleType';
    }
    _initializeList();
  }

  Future<void> _initializeList() async {
    isLoading.value = true;
    try {
      await repository.clearTransientList(listNameVal);

      List<TmdbPerson> people;
      if (episode != null) {
        people = roleType == PersonAttributes.cast ? episode!.cast : episode!.crew;
      } else if (season != null) {
        people = roleType == PersonAttributes.cast ? season!.cast : season!.crew;
      } else {
        people = roleType == PersonAttributes.cast ? title.cast : title.crew;
      }

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
