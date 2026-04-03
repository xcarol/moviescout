import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/save_logs.dart';

class TmdbTitleRepository {
  final _isar = IsarService.instance;


  Future<void> _logZeroRatingError(TmdbTitle title, {String? listName}) async {
    if (title.rating > 0) return;

    if (listName != null && listName == AppConstants.rateslist) {
      return saveLogs([
        '== ZERO ERROR ==',
        'listName: $listName',
        'title: ${title.name} rating: ${title.rating} stackTrace: ${StackTrace.current}',
        '== ZERO ERROR ==',
      ]);
    }

    final inRatesList = await _isar.userListEntrys
        .filter()
        .tmdbIdEqualTo(title.tmdbId)
        .mediaTypeEqualTo(title.mediaType)
        .findAll();

    final lists = inRatesList.map((e) => e.listName).toList().join(', ');

    if (inRatesList.any((e) => e.listName == AppConstants.rateslist)) {
      return saveLogs([
        '== ZERO ERROR ==',
        'lists: [$lists]',
        'title: ${title.name} rating: ${title.rating} stackTrace: ${StackTrace.current}',
        '== ZERO ERROR ==',
      ]);
    }
  }

  Future<void> _logMultipleZeroRatingError(List<TmdbTitle> titles,
      {String? listName}) async {
    for (final title in titles) {
      await _logZeroRatingError(title, listName: listName);
    }
  }

  Future<void> saveTitle(
      TmdbTitle title, String listName, int addedOrder) async {
    await _isar.writeTxn(() async {
      await _logZeroRatingError(title, listName: listName);
      
      if (!title.inLists.contains(listName)) {
        title.inLists = [...title.inLists, listName];
      }
      await _isar.tmdbTitles.put(title);
      
      await _isar.userListEntrys.put(UserListEntry(
        listName: listName,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
        addedOrder: addedOrder,
      ));
    });
  }

  Future<void> saveTitles(List<TmdbTitle> titles, String listName,
      {List<int>? addedOrders}) async {
    if (titles.isEmpty) return;

    await _isar.writeTxn(() async {
      await _logMultipleZeroRatingError(titles, listName: listName);
      
      for (final title in titles) {
        if (!title.inLists.contains(listName)) {
          title.inLists = [...title.inLists, listName];
        }
      }
      await _isar.tmdbTitles.putAll(titles);
      
      final entries = <UserListEntry>[];
      for (var i = 0; i < titles.length; i++) {
        entries.add(UserListEntry(
          listName: listName,
          tmdbId: titles[i].tmdbId,
          mediaType: titles[i].mediaType,
          addedOrder: addedOrders != null ? addedOrders[i] : i,
        ));
      }
      await _isar.userListEntrys.putAll(entries);
    });
  }

  Future<void> updateTitleMetadata(TmdbTitle title) async {
    await _isar.writeTxn(() async {
      await _logZeroRatingError(title);

      if (title.inLists.isEmpty) {
        final existing = await _isar.tmdbTitles
            .filter()
            .tmdbIdEqualTo(title.tmdbId)
            .mediaTypeEqualTo(title.mediaType)
            .findFirst();
        if (existing != null) {
          title.inLists = existing.inLists;
          if (!title.isPinned) {
            title.isPinned = existing.isPinned;
          }
        }
      }

      await _isar.tmdbTitles.put(title);
    });
  }

  Future<void> updateTitlesMetadata(List<TmdbTitle> titles) async {
    await _isar.writeTxn(() async {
      await _logMultipleZeroRatingError(titles);

      for (final title in titles) {
        if (title.inLists.isEmpty) {
          final existing = await _isar.tmdbTitles
              .filter()
              .tmdbIdEqualTo(title.tmdbId)
              .mediaTypeEqualTo(title.mediaType)
              .findFirst();
          if (existing != null) {
            title.inLists = existing.inLists;
            if (!title.isPinned) {
              title.isPinned = existing.isPinned;
            }
          }
        }
      }

      await _isar.tmdbTitles.putAll(titles);
    });
  }

  Future<void> deleteTitle(
      String listName, int tmdbId, String mediaType) async {
    await _isar.writeTxn(() async {
      await _isar.userListEntrys
          .filter()
          .listNameEqualTo(listName)
          .tmdbIdEqualTo(tmdbId)
          .mediaTypeEqualTo(mediaType)
          .deleteAll();

      final title = await _isar.tmdbTitles
          .filter()
          .tmdbIdEqualTo(tmdbId)
          .mediaTypeEqualTo(mediaType)
          .findFirst();

      if (title != null) {
        title.inLists = title.inLists.where((l) => l != listName).toList();
        if (title.inLists.isEmpty) {
          await _isar.tmdbTitles.delete(title.id);
        } else {
          await _isar.tmdbTitles.put(title);
        }
      }
    });
  }

  Future<void> deleteTitles(
      String listName, List<int> tmdbIds, List<String> mediaTypes) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < tmdbIds.length; i++) {
        final id = tmdbIds[i];
        final type = mediaTypes[i];
        
        await _isar.userListEntrys
            .filter()
            .listNameEqualTo(listName)
            .tmdbIdEqualTo(id)
            .mediaTypeEqualTo(type)
            .deleteAll();

        final title = await _isar.tmdbTitles
            .filter()
            .tmdbIdEqualTo(id)
            .mediaTypeEqualTo(type)
            .findFirst();

        if (title != null) {
          title.inLists = title.inLists.where((l) => l != listName).toList();
          if (title.inLists.isEmpty) {
            await _isar.tmdbTitles.delete(title.id);
          } else {
            await _isar.tmdbTitles.put(title);
          }
        }
      }
    });
  }

  Future<void> clearList(String listName) async {
    await _isar.writeTxn(() async {
      final entriesToRemove = await _isar.userListEntrys
          .filter()
          .listNameEqualTo(listName)
          .findAll();

      await _isar.userListEntrys.filter().listNameEqualTo(listName).deleteAll();

      for (final entry in entriesToRemove) {
        final title = await _isar.tmdbTitles
            .filter()
            .tmdbIdEqualTo(entry.tmdbId)
            .mediaTypeEqualTo(entry.mediaType)
            .findFirst();

        if (title != null) {
          title.inLists = title.inLists.where((l) => l != listName).toList();
          if (title.inLists.isEmpty) {
            await _isar.tmdbTitles.delete(title.id);
          } else {
            await _isar.tmdbTitles.put(title);
          }
        }
      }
    });
  }

  Future<bool> hasRatedTitles(String listName) async {
    final count = await _isar.tmdbTitles
        .filter()
        .inListsElementEqualTo(listName)
        .ratingGreaterThan(AppConstants.seenRating)
        .count();
    return count > 0;
  }

  int countTitlesSync(String listName) {
    return _isar.userListEntrys.filter().listNameEqualTo(listName).countSync();
  }

  Future<int> getMaxAddedOrder(String listName) async {
    final entry = await _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .sortByAddedOrderDesc()
        .findFirst();
    return entry?.addedOrder ?? -1;
  }

  Future<TmdbTitle?> getTitleByTmdbId(String listName, int tmdbId, String mediaType) async {
    return await _isar.tmdbTitles
        .filter()
        .inListsElementEqualTo(listName)
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirst();
  }

  TmdbTitle? getTitleByTmdbIdSync(
      String listName, int tmdbId, String mediaType) {
    return _isar.tmdbTitles
        .filter()
        .inListsElementEqualTo(listName)
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirstSync();
  }

  Future<TmdbTitle?> getTitleGlobal(int tmdbId, String mediaType) async {
    return _isar.tmdbTitles
        .filter()
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirst();
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    return _isar.tmdbTitles
        .filter()
        .anyOf(tmdbIds, (q, id) => q.tmdbIdEqualTo(id))
        .findAll();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    return _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .tmdbIdProperty()
        .findAll();
  }

  Future<List<UserListEntry>> getAllEntries(String listName) async {
    return _isar.userListEntrys.filter().listNameEqualTo(listName).findAll();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    return await _isar.tmdbTitles
        .filter()
        .inListsElementEqualTo(listName)
        .genreIdsProperty()
        .findAll();
  }

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> _buildQuery(
    String listName, {
    bool? pinned,
    String filterText = '',
    List<int> filterGenres = const [],
    String filterMediaType = '',
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
  }) {
    var query = _isar.tmdbTitles.filter().inListsElementEqualTo(listName);

    if (pinned != null) {
      query = query.isPinnedEqualTo(pinned);
    }

    if (filterText.isNotEmpty) {
      query = query.group((q) => q
          .nameContains(filterText, caseSensitive: false)
          .or()
          .originalNameContains(filterText, caseSensitive: false)
          .or()
          .overviewContains(filterText, caseSensitive: false)
          .or()
          .taglineContains(filterText, caseSensitive: false));
    }

    if (filterGenres.isNotEmpty) {
      query = query.anyOf(filterGenres, (q, id) => q.genreIdsElementEqualTo(id));
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

  QueryBuilder<TmdbTitle, TmdbTitle, QAfterSortBy> _applySort(
    QueryBuilder<TmdbTitle, TmdbTitle, QAfterFilterCondition> query,
    String sortOption,
    bool sortAscending,
  ) {
    switch (sortOption) {
      case SortOption.rating:
        return sortAscending
            ? query.sortByVoteAverage()
            : query.sortByVoteAverageDesc();
      case SortOption.userRating:
        return sortAscending ? query.sortByRating() : query.sortByRatingDesc();
      case SortOption.dateRated:
        return sortAscending
            ? query.sortByDateRated()
            : query.sortByDateRatedDesc();
      case SortOption.releaseDate:
        return sortAscending
            ? query.sortByEffectiveReleaseDate()
            : query.sortByEffectiveReleaseDateDesc();
      case SortOption.runtime:
        return sortAscending
            ? query.sortByIsMovieDesc().thenByEffectiveRuntime()
            : query.sortByIsMovieDesc().thenByEffectiveRuntimeDesc();
      case SortOption.alphabetically:
      default:
        return sortAscending ? query.sortByName() : query.sortByNameDesc();
    }
  }

  Future<List<TmdbTitle>> _getTitlesSortedByAddedOrder({
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
    bool sortAscending = true,
    int offset = 0,
    int limit = 10,
  }) async {
    final eligibleTitles = await _buildQuery(
      listName,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).findAll();

    if (eligibleTitles.isEmpty) return [];

    final entryMetadata = await _isar.userListEntrys
        .filter()
        .listNameEqualTo(listName)
        .findAll();

    final orderMap = {
      for (var e in entryMetadata) '${e.tmdbId}_${e.mediaType}': e.addedOrder
    };

    eligibleTitles.sort((a, b) {
      final orderA = orderMap['${a.tmdbId}_${a.mediaType}'] ?? 0;
      final orderB = orderMap['${b.tmdbId}_${b.mediaType}'] ?? 0;
      return sortAscending ? orderA.compareTo(orderB) : orderB.compareTo(orderA);
    });

    final start = offset;
    final end = (offset + limit) > eligibleTitles.length
        ? eligibleTitles.length
        : (offset + limit);

    if (start >= eligibleTitles.length) return [];

    return eligibleTitles.sublist(start, end);
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
  }) async {
    if (sortOption == SortOption.addedOrder) {
      return _getTitlesSortedByAddedOrder(
        listName: listName,
        filterText: filterText,
        filterMediaType: filterMediaType,
        filterGenres: filterGenres,
        filterByProviders: filterByProviders,
        filterProvidersIds: filterProvidersIds,
        filterRating: filterRating,
        pinned: pinned,
        sortAscending: sortAscending,
        offset: offset,
        limit: limit,
      );
    }

    var query = _buildQuery(
      listName,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    );

    final sortedQuery = _applySort(query, sortOption, sortAscending);
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
    return _buildQuery(
      listName,
      pinned: pinned,
      filterText: filterText,
      filterGenres: filterGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).count();
  }
}
