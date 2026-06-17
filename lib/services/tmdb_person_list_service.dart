import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_memory_list_mixin.dart';

class TmdbPersonListService extends TmdbBaseListService<TmdbPerson>
    with TmdbMemoryListMixin<TmdbPerson> {
  final TmdbTitle title;
  final String roleType; // 'cast' or 'crew'
  final TmdbSeason? season;
  final TmdbEpisode? episode;

  String _selectedSort = 'original';
  bool _isSortAsc = true;

  TmdbPersonListService({
    required this.title,
    required this.roleType,
    this.season,
    this.episode,
  }) {
    if (episode != null) {
      listNameVal =
          '${title.tmdbId}_s${episode!.seasonNumber}e${episode!.episodeNumber}_$roleType';
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
      List<TmdbPerson> people;
      if (episode != null) {
        people =
            roleType == PersonAttributes.cast ? episode!.cast : episode!.crew;
      } else if (season != null) {
        people =
            roleType == PersonAttributes.cast ? season!.cast : season!.crew;
      } else {
        people = roleType == PersonAttributes.cast ? title.cast : title.crew;
      }

      allItems.clear();
      allItems.addAll(people);

      await filterItems();
    } finally {
      isLoading.value = false;
    }
  }

  void setSort(String sort, bool ascending) {
    _selectedSort = sort;
    _isSortAsc = ascending;
    filterItems();
  }

  @override
  void applyFiltersAndSort() {
    final filtered = allItems.where((person) {
      if (filterText.isNotEmpty) {
        final query = filterText.toLowerCase();
        if (!person.name.toLowerCase().contains(query) &&
            !person.character.toLowerCase().contains(query) &&
            !person.job.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    if (_selectedSort != 'original') {
      filtered.sort((a, b) {
        int cmp;
        if (_selectedSort == 'name') {
          cmp = a.name.compareTo(b.name);
        } else if (_selectedSort == 'department') {
          cmp = a.knownForDepartment.compareTo(b.knownForDepartment);
        } else if (_selectedSort == 'job') {
          cmp = a.job.compareTo(b.job);
        } else {
          cmp = 0;
        }
        return _isSortAsc ? cmp : -cmp;
      });
    }

    if (_selectedSort == 'original' && !_isSortAsc) {
      filteredItems = filtered.reversed.toList();
    } else {
      filteredItems = filtered;
    }
  }
}
