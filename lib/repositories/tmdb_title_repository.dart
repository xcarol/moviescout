import 'package:isar_community/isar.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/save_logs.dart';

class TmdbTitleRepository {
  final _isar = IsarService.instance;

  Future<void> _logZeroRatingError(TmdbTitle title, {String? listName}) async {
    if (title.rating > 0) return;

    if (listName != null && listName == AppConstants.rateslist) {
      ErrorService.log(
        [
          'listName: $listName',
          'title: ${title.name} rating: ${title.rating} stackTrace: ${StackTrace.current}',
        ],
        stackTrace: StackTrace.current,
        userMessage: 'Zero rating error',
      );
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
      ErrorService.log(
        [
          'lists: [$lists]',
          'title: ${title.name} rating: ${title.rating} stackTrace: ${StackTrace.current}',
        ],
        stackTrace: StackTrace.current,
        userMessage: 'Zero rating error',
      );
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

  void _mergeTitleMetadata(TmdbTitle newTitle, TmdbTitle currentTitle,
      {String? listNameToAdd}) {
    newTitle.id = currentTitle.id;

    bool inListsIsEmpty = newTitle.inLists.isEmpty;

    if (listNameToAdd != null) {
      final mergedLists = Set<String>.from(currentTitle.inLists);
      mergedLists.add(listNameToAdd);
      newTitle.inLists = mergedLists.toList();
    } else {
      newTitle.inLists = currentTitle.inLists;
    }

    if (inListsIsEmpty) {
      newTitle.isPinned = currentTitle.isPinned;
      newTitle.notifyNewSeasons = currentTitle.notifyNewSeasons;
    }

    if (newTitle.rating == 0.0 && currentTitle.rating > 0.0) {
      newTitle.rating = currentTitle.rating;
      newTitle.dateRated = currentTitle.dateRated;
    }
  }

  Future<void> saveTitle(
      TmdbTitle title, String listName, int addedOrder) async {
    await _isar.writeTxn(() async {
      await _logZeroRatingError(title, listName: listName);

      final current = await _isar.tmdbTitles
          .filter()
          .tmdbIdEqualTo(title.tmdbId)
          .mediaTypeEqualTo(title.mediaType)
          .findFirst();

      if (current != null) {
        _mergeTitleMetadata(title, current, listNameToAdd: listName);
      } else {
        if (!title.inLists.contains(listName)) {
          title.inLists = [...title.inLists, listName];
        }
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

    const batchSize = AppConstants.defaultBatchSize;
    for (var i = 0; i < titles.length; i += batchSize) {
      final end =
          (i + batchSize < titles.length) ? i + batchSize : titles.length;
      final batchTitles = titles.sublist(i, end);
      final batchOrders = addedOrders?.sublist(i, end);

      await _isar.writeTxn(() async {
        await _logMultipleZeroRatingError(batchTitles, listName: listName);

        final tmdbIds = batchTitles.map((t) => t.tmdbId).toList();
        final mediaTypes = batchTitles.map((t) => t.mediaType).toList();
        final currentTitles =
            await _isar.tmdbTitles.getAllByTmdbIdMediaType(tmdbIds, mediaTypes);

        for (var j = 0; j < batchTitles.length; j++) {
          final title = batchTitles[j];
          final current = currentTitles[j];

          if (current != null) {
            _mergeTitleMetadata(title, current, listNameToAdd: listName);
          } else {
            if (!title.inLists.contains(listName)) {
              title.inLists = [...title.inLists, listName];
            }
          }
        }
        await _isar.tmdbTitles.putAll(batchTitles);

        final entries = <UserListEntry>[];
        for (var j = 0; j < batchTitles.length; j++) {
          entries.add(UserListEntry(
            listName: listName,
            tmdbId: batchTitles[j].tmdbId,
            mediaType: batchTitles[j].mediaType,
            addedOrder: batchOrders != null ? batchOrders[j] : (i + j),
          ));
        }
        await _isar.userListEntrys.putAll(entries);
      });
    }
  }

  Future<void> updateTitleMetadata(TmdbTitle title) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.tmdbTitles
          .filter()
          .tmdbIdEqualTo(title.tmdbId)
          .mediaTypeEqualTo(title.mediaType)
          .findFirst();

      if (existing != null) {
        _mergeTitleMetadata(title, existing);
      }
      await _logZeroRatingError(title);
      await _isar.tmdbTitles.put(title);
    });
  }

  Future<void> updateTitlesMetadata(List<TmdbTitle> titles) async {
    if (titles.isEmpty) return;

    const batchSize = AppConstants.defaultBatchSize;
    for (var i = 0; i < titles.length; i += batchSize) {
      final end =
          (i + batchSize < titles.length) ? i + batchSize : titles.length;
      final batchTitles = titles.sublist(i, end);

      await _isar.writeTxn(() async {
        final tmdbIds = batchTitles.map((t) => t.tmdbId).toList();
        final mediaTypes = batchTitles.map((t) => t.mediaType).toList();

        final existingTitles =
            await _isar.tmdbTitles.getAllByTmdbIdMediaType(tmdbIds, mediaTypes);

        for (var j = 0; j < batchTitles.length; j++) {
          final title = batchTitles[j];
          final existing = existingTitles[j];

          if (existing != null) {
            _mergeTitleMetadata(title, existing);
          }
        }

        await _logMultipleZeroRatingError(batchTitles);
        await _isar.tmdbTitles.putAll(batchTitles);
      });
    }
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
          if (title.mediaType == ApiConstants.tv ||
              title.mediaType == AppConstants.miniseries) {
            await _isar.tmdbSeasons
                .filter()
                .tvIdEqualTo(title.tmdbId)
                .deleteAll();
            await _isar.tmdbEpisodes
                .filter()
                .tvIdEqualTo(title.tmdbId)
                .deleteAll();
          }
        } else {
          await _isar.tmdbTitles.put(title);
        }
      }
    });
  }

  Future<void> deleteTitles(
      String listName, List<int> tmdbIds, List<String> mediaTypes) async {
    if (tmdbIds.isEmpty) return;

    const batchSize = AppConstants.defaultBatchSize;
    for (var batchStart = 0;
        batchStart < tmdbIds.length;
        batchStart += batchSize) {
      final end = (batchStart + batchSize < tmdbIds.length)
          ? batchStart + batchSize
          : tmdbIds.length;
      final batchIds = tmdbIds.sublist(batchStart, end);
      final batchTypes = mediaTypes.sublist(batchStart, end);

      await _isar.writeTxn(() async {
        for (var i = 0; i < batchIds.length; i++) {
          final id = batchIds[i];
          final type = batchTypes[i];

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
              if (title.mediaType == ApiConstants.tv ||
                  title.mediaType == AppConstants.miniseries) {
                await _isar.tmdbSeasons
                    .filter()
                    .tvIdEqualTo(title.tmdbId)
                    .deleteAll();
                await _isar.tmdbEpisodes
                    .filter()
                    .tvIdEqualTo(title.tmdbId)
                    .deleteAll();
              }
            } else {
              await _isar.tmdbTitles.put(title);
            }
          }
        }
      });
    }
  }

  Future<void> clearList(String listName) async {
    final entriesToRemove =
        await _isar.userListEntrys.filter().listNameEqualTo(listName).findAll();

    const batchSize = AppConstants.defaultBatchSize;
    if (entriesToRemove.isNotEmpty) {
      for (var i = 0; i < entriesToRemove.length; i += batchSize) {
        final end = (i + batchSize < entriesToRemove.length)
            ? i + batchSize
            : entriesToRemove.length;
        final batchEntries = entriesToRemove.sublist(i, end);

        await _isar.writeTxn(() async {
          for (final entry in batchEntries) {
            await _isar.userListEntrys.delete(entry.id);
          }
        });
      }
    }

    // 2. Remove listName from all TmdbTitles that have it
    final titlesToClean = await _isar.tmdbTitles
        .filter()
        .inListsElementEqualTo(listName)
        .findAll();

    if (titlesToClean.isNotEmpty) {
      for (var i = 0; i < titlesToClean.length; i += batchSize) {
        final end = (i + batchSize < titlesToClean.length)
            ? i + batchSize
            : titlesToClean.length;
        final batchTitles = titlesToClean.sublist(i, end);

        await _isar.writeTxn(() async {
          for (final title in batchTitles) {
            title.inLists = title.inLists.where((l) => l != listName).toList();
            if (title.inLists.isEmpty) {
              await _isar.tmdbTitles.delete(title.id);
              if (title.mediaType == ApiConstants.tv ||
                  title.mediaType == AppConstants.miniseries) {
                await _isar.tmdbSeasons
                    .filter()
                    .tvIdEqualTo(title.tmdbId)
                    .deleteAll();
                await _isar.tmdbEpisodes
                    .filter()
                    .tvIdEqualTo(title.tmdbId)
                    .deleteAll();
              }
            } else {
              await _isar.tmdbTitles.put(title);
            }
          }
        });
      }
    }
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

  Future<TmdbTitle?> getTitleByTmdbId(
      String listName, int tmdbId, String mediaType) async {
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

  Future<TmdbSeason?> getSeason(int tvId, int seasonNumber) async {
    return _isar.tmdbSeasons
        .filter()
        .tvIdEqualTo(tvId)
        .seasonNumberEqualTo(seasonNumber)
        .findFirst();
  }

  Future<void> putSeason(TmdbSeason season) async {
    final cached = await getSeason(season.tvId, season.seasonNumber);
    if (cached != null) {
      season.isarId = cached.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.tmdbSeasons.put(season);
    });
  }

  Future<TmdbEpisode?> getEpisode(
      int tvId, int seasonNumber, int episodeNumber) async {
    return _isar.tmdbEpisodes
        .filter()
        .tvIdEqualTo(tvId)
        .seasonNumberEqualTo(seasonNumber)
        .episodeNumberEqualTo(episodeNumber)
        .findFirst();
  }

  Future<void> putEpisode(TmdbEpisode episode) async {
    final cached = await getEpisode(
        episode.tvId, episode.seasonNumber, episode.episodeNumber);
    if (cached != null) {
      episode.isarId = cached.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.tmdbEpisodes.put(episode);
    });
  }

  Future<TmdbTitle?> getTitleGlobal(int tmdbId, String mediaType) async {
    return _isar.tmdbTitles
        .filter()
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirst();
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    if (tmdbIds.isEmpty) return [];

    final results = <TmdbTitle>[];
    const batchSize = AppConstants.defaultBatchSize;

    for (var i = 0; i < tmdbIds.length; i += batchSize) {
      final end =
          (i + batchSize < tmdbIds.length) ? i + batchSize : tmdbIds.length;
      final batch = tmdbIds.sublist(i, end);

      final batchResults = await _isar.tmdbTitles
          .filter()
          .anyOf(batch, (q, id) => q.tmdbIdEqualTo(id))
          .findAll();

      results.addAll(batchResults);
    }

    return results;
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
    bool filterExcludeGenres = false,
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
      if (filterExcludeGenres) {
        for (final id in filterGenres) {
          query = query.not().genreIdsElementEqualTo(id);
        }
      } else {
        query =
            query.anyOf(filterGenres, (q, id) => q.genreIdsElementEqualTo(id));
      }
    }

    if (filterMediaType.isNotEmpty) {
      if (filterMediaType == AppConstants.miniseries) {
        query = query
            .mediaTypeEqualTo(ApiConstants.tv)
            .numberOfSeasonsEqualTo(1)
            .statusEqualTo(TvShowStatus.ended);
      } else {
        query = query.mediaTypeEqualTo(filterMediaType);
      }
    }

    if (filterByProviders && filterProvidersIds.isNotEmpty) {
      query = query.anyOf(filterProvidersIds,
          (q, id) => q.flatrateProviderIdsElementEqualTo(id));
    }

    if (filterRating == RatingFilter.rated) {
      query = query.ratingGreaterThan(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.seenOnly) {
      query = query.ratingEqualTo(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.followingOnly) {
      query = query.notifyNewSeasonsEqualTo(true);
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
    bool filterExcludeGenres = false,
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
      filterExcludeGenres: filterExcludeGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).findAll();

    if (eligibleTitles.isEmpty) return [];

    final entryMetadata =
        await _isar.userListEntrys.filter().listNameEqualTo(listName).findAll();

    final orderMap = {
      for (var e in entryMetadata) '${e.tmdbId}_${e.mediaType}': e.addedOrder
    };

    eligibleTitles.sort((a, b) {
      final orderA = orderMap['${a.tmdbId}_${a.mediaType}'] ?? 0;
      final orderB = orderMap['${b.tmdbId}_${b.mediaType}'] ?? 0;
      return sortAscending
          ? orderA.compareTo(orderB)
          : orderB.compareTo(orderA);
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
    bool filterExcludeGenres = false,
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
        filterExcludeGenres: filterExcludeGenres,
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
      filterExcludeGenres: filterExcludeGenres,
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
    bool filterExcludeGenres = false,
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
      filterExcludeGenres: filterExcludeGenres,
      filterMediaType: filterMediaType,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
    ).count();
  }

  Future<bool> hasTitlesFiltered({
    required String listName,
  }) async {
    final first = await _buildQuery(listName).findFirst();
    return first != null;
  }
}
