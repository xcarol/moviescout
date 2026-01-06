import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';

class TmdbPersonTitlesService extends TmdbListService {
  final List<TmdbTitle> _allTitles = [];
  List<TmdbTitle> _filteredTitles = [];
  final TmdbPerson person;

  TmdbPersonTitlesService(
    super.listName,
    super.repository,
    super.preferencesService, {
    required this.person,
  }) {
    _initializeTitles();
  }

  void _initializeTitles() {
    _allTitles.clear();
    final seenIds = <int>{};
    _allTitles.addAll(
        person.combinedCredits.cast.where((t) => seenIds.add(t.tmdbId)));
    _allTitles.addAll(
        person.combinedCredits.crew.where((t) => seenIds.add(t.tmdbId)));

    for (int i = 0; i < _allTitles.length; i++) {
      _allTitles[i].addedOrder = i;
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
      await filterTitles();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> filterTitles() async {
    clearLoadedTitles(clearGenreCache: false);

    anyFilterApplied = true;

    // Apply filtering to _allTitles
    final filtered = _allTitles.where((title) {
      // Text filter
      if (filterText.isNotEmpty) {
        final query = filterText.toLowerCase();
        if (!title.name.toLowerCase().contains(query) &&
            !title.character.toLowerCase().contains(query) &&
            !title.job.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Media type filter
      if (filterMediaType.isNotEmpty && title.mediaType != filterMediaType) {
        return false;
      }

      // Genre filter
      if (filterGenres.isNotEmpty) {
        if (!title.genreIds.any((id) => filterGenres.contains(id))) {
          return false;
        }
      }

      // Provider filter (not really applicable here as credits usually don't have provider info initially,
      // but we'll follow the logic if available)
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

    // Apply sorting
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
          cmp = a.releaseDate.compareTo(b.releaseDate);
          break;
        case SortOption.runtime:
          cmp = a.runtime.compareTo(b.runtime);
          break;
        case SortOption.addedOrder:
          cmp = a.addedOrder.compareTo(b.addedOrder);
          break;
        default:
          cmp = 0;
      }
      return isSortAsc ? cmp : -cmp;
    });

    // Update total count
    selectedTitleCount.value = filtered.length;
    _filteredTitles = filtered;

    // Initial pagination
    await loadNextPageInternal();
  }

  @override
  Future<void> loadNextPage() async {
    if (isDbLoading || !hasMoreVal) return;
    isDbLoading = true;
    try {
      await loadNextPageInternal();
    } finally {
      isDbLoading = false;
      notifyListeners();
    }
  }

  // Helper for pagination
  Future<void> loadNextPageInternal() async {
    if (!hasMoreVal) return;

    final start = pageVal * pageSizeVal;
    if (start >= _filteredTitles.length) {
      hasMoreVal = false;
      return;
    }

    final end = (start + pageSizeVal) < _filteredTitles.length
        ? (start + pageSizeVal)
        : _filteredTitles.length;

    final chunk = _filteredTitles.sublist(start, end);
    loadedTitlesVal.addAll(chunk);
    pageVal++;

    if (end >= _filteredTitles.length) {
      hasMoreVal = false;
    }
  }

  @override
  Future<void> updateListGenres() async {
    listGenresVal.clear();
    if (_allTitles.isEmpty) {
      _initializeTitles();
    }
    final uniqueGenreIds =
        _allTitles.expand((t) => t.genreIds).toSet().toList();
    final names = TmdbGenreService().getNamesFromIds(uniqueGenreIds);
    listGenresVal = names;
    listGenresVal.sort();
    listGenres.value = [...listGenresVal];
  }

  @override
  bool contains(TmdbTitle title) {
    return _allTitles
        .any((t) => t.tmdbId == title.tmdbId && t.mediaType == title.mediaType);
  }

  @override
  int get listTitleCount => _allTitles.length;

  @override
  bool get listIsEmpty => _allTitles.isEmpty;

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

  Future<void> updateTitles() async {
    await Future.wait(
        _allTitles.map((t) => TmdbTitleService().updateTitleDetails(t)));
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
