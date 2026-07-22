import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_memory_list_mixin.dart';

class PersonSortOption {
  static const name = 'name';
  static const department = 'department';
  static const job = 'job';
  static const original = 'original';
}

class TmdbPersonListService extends TmdbBaseListService<TmdbPerson>
    with TmdbMemoryListMixin<TmdbPerson> {
  final TmdbTitle title;
  final String roleType; // 'cast' or 'crew'
  final TmdbSeason? season;
  final TmdbEpisode? episode;

  TmdbPersonListService({
    required this.title,
    required this.roleType,
    this.season,
    this.episode,
  }) {
    selectedSort = PersonSortOption.original;
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

    if (selectedSort != PersonSortOption.original) {
      filtered.sort((a, b) {
        int cmp;
        if (selectedSort == PersonSortOption.name) {
          cmp = a.name.compareTo(b.name);
        } else if (selectedSort == PersonSortOption.department) {
          cmp = a.knownForDepartment.compareTo(b.knownForDepartment);
        } else if (selectedSort == PersonSortOption.job) {
          cmp = a.job.compareTo(b.job);
        } else {
          cmp = 0;
        }
        return isSortAsc ? cmp : -cmp;
      });
    }

    if (selectedSort == PersonSortOption.original && !isSortAsc) {
      filteredItems = filtered.reversed.toList();
    } else {
      filteredItems = filtered;
    }
  }
}
