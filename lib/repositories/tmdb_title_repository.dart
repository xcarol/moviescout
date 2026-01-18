import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbTitleRepository {
  final _isar = IsarService.instance;

  Future<void> saveTitle(TmdbTitle title) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.put(title);
    });
  }

  Future<void> saveTitles(List<TmdbTitle> titles) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.putAll(titles);
    });
  }

  Future<void> deleteTitle(String listName, int tmdbId) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles
          .filter()
          .listNameEqualTo(listName)
          .tmdbIdEqualTo(tmdbId)
          .deleteAll();
    });
  }

  Future<void> deleteTitles(String listName, List<int> tmdbIds) async {
    await _isar.writeTxn(() async {
      for (final id in tmdbIds) {
        await _isar.tmdbTitles
            .filter()
            .listNameEqualTo(listName)
            .tmdbIdEqualTo(id)
            .deleteAll();
      }
    });
  }

  Future<void> deleteTitlesByQuery(Query<TmdbTitle> query) async {
    await _isar.writeTxn(() async {
      await query.deleteAll();
    });
  }

  Future<void> clearList(String listName) async {
    await _isar.writeTxn(() async {
      await _isar.tmdbTitles.filter().listNameEqualTo(listName).deleteAll();
    });
  }

  void clearListSync(String listName) {
    _isar.writeTxnSync(() {
      _isar.tmdbTitles.filter().listNameEqualTo(listName).deleteAllSync();
    });
  }

  int countTitlesSync(String listName) {
    return _isar.tmdbTitles.filter().listNameEqualTo(listName).countSync();
  }

  int getMaxAddedOrderSync(String listName) {
    final title = _isar.tmdbTitles
        .filter()
        .listNameEqualTo(listName)
        .sortByAddedOrderDesc()
        .findFirstSync();
    return title?.addedOrder ?? -1;
  }

  TmdbTitle? getTitleByTmdbId(String listName, int tmdbId, String mediaType) {
    return _isar.tmdbTitles
        .filter()
        .listNameEqualTo(listName)
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirstSync();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    return _isar.tmdbTitles
        .where()
        .listNameEqualTo(listName)
        .tmdbIdProperty()
        .findAll();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    return _isar.tmdbTitles
        .filter()
        .listNameEqualTo(listName)
        .genreIdsProperty()
        .findAll();
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> buildQuery({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
  }) {
    var query = _isar.tmdbTitles.filter().listNameEqualTo(listName);

    if (pinned != null) {
      query = query.isPinnedEqualTo(pinned);
    }

    if (filterText.isNotEmpty) {
      query = query.nameContains(filterText, caseSensitive: false);
    }

    if (filterGenres.isNotEmpty) {
      query =
          query.anyOf(filterGenres, (q, id) => q.genreIdsElementEqualTo(id));
    }

    if (filterMediaType.isNotEmpty) {
      query = query.mediaTypeEqualTo(filterMediaType);
    }

    if (filterByProviders && filterProvidersIds.isNotEmpty) {
      query = query.anyOf(filterProvidersIds,
          (q, id) => q.flatrateProviderIdsElementEqualTo(id));
    }

    if (filterRating == RatingFilter.rated) {
      query = query.ratingGreaterThan(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.seenOnly) {
      query = query.ratingEqualTo(AppConstants.seenRating);
    }

    return query;
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> applySort({
    required QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> query,
    required String sortOption,
    required bool ascending,
  }) {
    switch (sortOption) {
      case SortOption.rating:
        return ascending
            ? query.sortByVoteAverage()
            : query.sortByVoteAverageDesc();
      case SortOption.userRating:
        return ascending ? query.sortByRating() : query.sortByRatingDesc();
      case SortOption.dateRated:
        return ascending
            ? query.sortByDateRated()
            : query.sortByDateRatedDesc();
      case SortOption.releaseDate:
        return ascending
            ? query.sortByEffectiveReleaseDate()
            : query.sortByEffectiveReleaseDateDesc();
      case SortOption.runtime:
        return ascending
            ? query.sortByIsMovieDesc().thenByEffectiveRuntime()
            : query.sortByIsMovieDesc().thenByEffectiveRuntimeDesc();
      case SortOption.addedOrder:
        return ascending
            ? query.sortByAddedOrder()
            : query.sortByAddedOrderDesc();
      case SortOption.alphabetically:
      default:
        return ascending ? query.sortByName() : query.sortByNameDesc();
    }
  }

  Future<List<TmdbTitle>> getTitles({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    String sortOption = SortOption.alphabetically,
    bool sortAscending = true,
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
    int offset = 0,
    int limit = 10,
  }) {
    final query = buildQuery(
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    );

    final sortedQuery = applySort(
        query: query, sortOption: sortOption, ascending: sortAscending);

    return sortedQuery.offset(offset).limit(limit).findAll();
  }

  Future<int> countTitlesFiltered({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
  }) async {
    final query = buildQuery(
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    );
    return query.count();
  }
}
