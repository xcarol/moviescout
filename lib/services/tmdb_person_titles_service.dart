import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';

import 'package:moviescout/services/tmdb_memory_list_mixin.dart';

class TmdbPersonTitlesService extends TmdbTitleListService
    with TmdbMemoryListMixin<TmdbTitle> {
  final TmdbPerson person;
  final PersonTitleRole role;

  TmdbPersonTitlesService(
    super.listName,
    super.repository, {
    required this.person,
    this.role = PersonTitleRole.character,
  }) {
    _initializeTitles();
  }

  @override
  String get defaultSort => SortOption.releaseDate;

  @override
  bool get defaultSortAsc => true;

  @override
  bool get isRefreshable => false;

  void _initializeTitles() {
    allItems.clear();
    final seenIds = <int>{};

    if (role == PersonTitleRole.crew) {
      allItems.addAll(
          person.combinedCredits.crew.where((t) => seenIds.add(t.tmdbId)));
    } else {
      allItems.addAll(
          person.combinedCredits.cast.where((t) => seenIds.add(t.tmdbId)));
    }

    for (int i = 0; i < allItems.length; i++) {
      allItems[i].addedOrder = i;
    }
  }

  @override
  Future<void> retrieveList(
    String accountId, {
    required Future<List> Function() retrieveMovies,
    required Future<List> Function() retrieveTvshows,
    bool forceUpdate = false,
  }) async {
    // In-memory service doesn't need to fetch from server or sync with DB.
    // It's already initialized with the person's credits.
    isLoading.value = true;
    try {
      await updateTitles();
      await updateListGenres();
      await filterItems();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void applyFiltersAndSort() {
    final filtered = allItems.where((title) {
      if (filterText.isNotEmpty) {
        final query = filterText.toLowerCase();
        if (!title.name.toLowerCase().contains(query) &&
            !title.character.toLowerCase().contains(query) &&
            !title.job.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (filterMediaType.isNotEmpty) {
        if (filterMediaType == AppConstants.miniseries) {
          if (!title.isMiniSerie) return false;
        } else if (title.mediaType != filterMediaType) {
          return false;
        }
      }
      if (filterGenres.isNotEmpty) {
        if (!title.genreIds.any((id) => filterGenres.contains(id))) {
          return false;
        }
      }
      if (filterByProviders && filterProvidersIds.isNotEmpty) {
        if (title.flatrateProviderIds.isEmpty) {
          return false;
        }
        if (!title.flatrateProviderIds
            .any((id) => filterProvidersIds.contains(id))) {
          return false;
        }
      }

      return true;
    }).toList();

    filtered.sort((a, b) {
      int cmp;
      switch (selectedSort) {
        case SortOption.alphabetically:
          cmp = a.name.compareTo(b.name);
          break;
        case SortOption.rating:
          cmp = a.voteAverage.compareTo(b.voteAverage);
          break;
        case SortOption.userRating:
          cmp = a.rating.compareTo(b.rating);
          break;
        case SortOption.dateRated:
          cmp = a.dateRated.compareTo(b.dateRated);
          break;
        case SortOption.releaseDate:
          cmp = a.effectiveReleaseDate.compareTo(b.effectiveReleaseDate);
          break;
        case SortOption.runtime:
          cmp = a.effectiveRuntime.compareTo(b.effectiveRuntime);
          break;
        case SortOption.addedOrder:
          cmp = a.addedOrder.compareTo(b.addedOrder);
          break;
        default:
          cmp = 0;
      }
      return isSortAsc ? cmp : -cmp;
    });

    filteredItems = filtered;
  }

  @override
  Future<void> updateListGenres() async {
    listGenresVal.clear();
    if (allItems.isEmpty) {
      _initializeTitles();
    }
    final uniqueGenreIds = allItems.expand((t) => t.genreIds).toSet().toList();
    final names = TmdbGenreService().getNamesFromIds(uniqueGenreIds);
    listGenresVal = names;
    listGenresVal.sort();
    listGenres.value = [...listGenresVal];
  }

  @override
  Future<bool> contains(TmdbTitle title) async {
    return allItems
        .any((t) => t.tmdbId == title.tmdbId && t.mediaType == title.mediaType);
  }

  @override
  int get listTitleCount => allItems.length;

  @override
  bool get listIsEmpty => allItems.isEmpty;

  @override
  Future<void> clearList() async {
    // Do nothing for in-memory service
  }

  @override
  Future<void> updateTitle(
    String accountId,
    String sessionId,
    TmdbTitle title,
    bool add,
    Future<dynamic> Function(String, String) updateTitleToServer,
  ) async {
    throw Exception(
        'Update operations are not supported in TmdbPersonTitlesService');
  }

  bool _localUserRatingAvailable = false;

  @override
  bool get userRatingAvailable => _localUserRatingAvailable;

  Future<void> updateTitles() async {
    if (allItems.isNotEmpty) {
      final tmdbIds = allItems.map((t) => t.tmdbId).toList();
      _localUserRatingAvailable =
          await repository.hasTitlesInList(tmdbIds, AppConstants.rateslist);

      if (_localUserRatingAvailable) {
        final dbTitles = await repository.getTitlesByTmdbIds(tmdbIds);
        final dbTitlesMap = {
          for (var t in dbTitles) '${t.tmdbId}_${t.mediaType}': t
        };
        for (var title in allItems) {
          final dbTitle = dbTitlesMap['${title.tmdbId}_${title.mediaType}'];
          if (dbTitle != null) {
            title.rating = dbTitle.rating;
            title.dateRated = dbTitle.dateRated;
          }
        }
      }
    }
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
