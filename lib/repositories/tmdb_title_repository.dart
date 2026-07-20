import 'package:realm/realm.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/realm_service.dart';
import 'package:moviescout/database/realm_models.dart';
import 'package:moviescout/database/realm_mappers.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbTitleRepository {
  final Realm _realm;

  TmdbTitleRepository({Realm? realm}) : _realm = realm ?? RealmService.instance;

  void _mergeTitleMetadata(TmdbTitle newTitle, TmdbTitle currentTitle,
      {String? listNameToAdd}) {
    if (listNameToAdd != null) {
      final mergedLists = Set<String>.from(currentTitle.inLists);
      mergedLists.add(listNameToAdd);
      newTitle.inLists = mergedLists.toList();
    } else {
      newTitle.inLists = currentTitle.inLists;
    }

    newTitle.isPinned = currentTitle.isPinned;
    newTitle.notifyNewSeasons = currentTitle.notifyNewSeasons;
    newTitle.lastNotifiedSeason = currentTitle.lastNotifiedSeason;
    if (newTitle.rating == 0.0 && currentTitle.rating > 0.0) {
      newTitle.rating = currentTitle.rating;
      newTitle.dateRated = currentTitle.dateRated;
    }

    newTitle.omdbRatingsJson ??= currentTitle.omdbRatingsJson;
  }

  void _mergeOrAddTitleMetadata(TmdbTitle title, String listName) {
    final current =
        _realm.find<TmdbTitleRealm>('${title.tmdbId}_${title.mediaType}');

    if (current != null) {
      _mergeTitleMetadata(title, RealmMapper.toDomainTitle(current),
          listNameToAdd: listName);
    } else {
      if (!title.inLists.contains(listName)) {
        title.inLists = [...title.inLists, listName];
      }
    }
  }

  Future<void> saveTitle(
      TmdbTitle title, String listName, int addedOrder) async {
    _realm.write(() {
      _mergeOrAddTitleMetadata(title, listName);
      _realm.add(RealmMapper.toRealmTitle(title), update: true);

      _realm.add(
          UserListEntryRealm(
            '${listName}_${title.tmdbId}_${title.mediaType}',
            listName,
            title.tmdbId,
            title.mediaType,
            addedOrder,
          ),
          update: true);
    });
  }

  void _runInBatches<T>(
      List<T> items, void Function(List<T> batch, int startIdx) action) {
    const batchSize = AppConstants.defaultBatchSize;
    for (var i = 0; i < items.length; i += batchSize) {
      final end = (i + batchSize < items.length) ? i + batchSize : items.length;
      final batch = items.sublist(i, end);
      action(batch, i);
    }
  }

  Future<void> saveTitles(List<TmdbTitle> titles, String listName,
      {List<int>? addedOrders}) async {
    if (titles.isEmpty) return;

    _runInBatches(
      titles,
      (batchTitles, i) {
        final batchOrders = addedOrders?.sublist(i, i + batchTitles.length);

        _realm.write(() {
          for (var j = 0; j < batchTitles.length; j++) {
            final title = batchTitles[j];
            _mergeOrAddTitleMetadata(title, listName);
          }
          _realm.addAll(batchTitles.map((t) => RealmMapper.toRealmTitle(t)),
              update: true);

          final entries = <UserListEntryRealm>[];
          for (var j = 0; j < batchTitles.length; j++) {
            entries.add(UserListEntryRealm(
              '${listName}_${batchTitles[j].tmdbId}_${batchTitles[j].mediaType}',
              listName,
              batchTitles[j].tmdbId,
              batchTitles[j].mediaType,
              batchOrders != null ? batchOrders[j] : (i + j),
            ));
          }
          _realm.addAll(entries, update: true);
        });
      },
    );
  }

  Future<void> updateTitleMetadata(TmdbTitle title) async {
    _realm.write(() {
      final existing =
          _realm.find<TmdbTitleRealm>('${title.tmdbId}_${title.mediaType}');

      if (existing != null) {
        _mergeTitleMetadata(title, RealmMapper.toDomainTitle(existing));
      }
      _realm.add(RealmMapper.toRealmTitle(title), update: true);
    });
  }

  Future<void> updateTitlesMetadata(List<TmdbTitle> titles) async {
    if (titles.isEmpty) return;

    _runInBatches(titles, (batchTitles, i) {
      _realm.write(() {
        for (var j = 0; j < batchTitles.length; j++) {
          final title = batchTitles[j];
          final existing =
              _realm.find<TmdbTitleRealm>('${title.tmdbId}_${title.mediaType}');

          if (existing != null) {
            _mergeTitleMetadata(title, RealmMapper.toDomainTitle(existing));
          }
        }
        _realm.addAll(batchTitles.map((t) => RealmMapper.toRealmTitle(t)),
            update: true);
      });
    });
  }

  Future<void> _updateTitlesField(List<TmdbTitle> titles,
      void Function(TmdbTitleRealm, TmdbTitle) updateFn) async {
    _realm.write(() {
      for (var title in titles) {
        final existing =
            _realm.find<TmdbTitleRealm>('${title.tmdbId}_${title.mediaType}');
        if (existing != null) {
          updateFn(existing, title);
        } else {
          _realm.add(RealmMapper.toRealmTitle(title));
        }
      }
    });
  }

  Future<void> updateIsPinned(TmdbTitle title) => updateIsPinnedList([title]);

  Future<void> updateIsPinnedList(List<TmdbTitle> titles) {
    return _updateTitlesField(titles, (existing, title) {
      existing.isPinned = title.isPinned;
    });
  }

  Future<void> updateRating(TmdbTitle title) => updateRatingList([title]);

  Future<void> updateRatingList(List<TmdbTitle> titles) {
    return _updateTitlesField(titles, (existing, title) {
      existing.rating = title.rating;
      existing.dateRated = title.dateRated;
    });
  }

  Future<void> updateNotifyNewSeasons(TmdbTitle title) =>
      updateNotifyNewSeasonsList([title]);

  Future<void> updateNotifyNewSeasonsList(List<TmdbTitle> titles) {
    return _updateTitlesField(titles, (existing, title) {
      existing.notifyNewSeasons = title.notifyNewSeasons;
      existing.lastNotifiedSeason = title.lastNotifiedSeason;
    });
  }

  Future<void> deleteTitle(String listName, int tmdbId, String mediaType) =>
      deleteTitles(listName, [tmdbId], [mediaType]);

  void _deleteOrphanTitle(TmdbTitleRealm title) {
    if (title.inLists.isEmpty) {
      final mediaType = title.mediaType;
      final titleTmdbId = title.tmdbId;
      _realm.delete(title);
      if (mediaType == ApiConstants.tv ||
          mediaType == AppConstants.miniseries) {
        final seasons = _realm.query<TmdbSeasonRealm>(
            '${TmdbSeasonRealmFields.tvId} == \$0', [titleTmdbId]);
        _realm.deleteMany(seasons);
        final episodes = _realm.query<TmdbEpisodeRealm>(
            '${TmdbEpisodeRealmFields.tvId} == \$0', [titleTmdbId]);
        _realm.deleteMany(episodes);
      }
    }
  }

  Future<void> invalidateSeasonsAndEpisodes(int tvId) async {
    _realm.write(() {
      final seasons = _realm.query<TmdbSeasonRealm>(
          '${TmdbSeasonRealmFields.tvId} == \$0', [tvId]);
      _realm.deleteMany(seasons);
      final episodes = _realm.query<TmdbEpisodeRealm>(
          '${TmdbEpisodeRealmFields.tvId} == \$0', [tvId]);
      _realm.deleteMany(episodes);
    });
  }

  Future<void> deleteTitles(
      String listName, List<int> tmdbIds, List<String> mediaTypes) async {
    if (tmdbIds.isEmpty) return;

    _realm.write(() {
      for (var i = 0; i < tmdbIds.length; i++) {
        final id = tmdbIds[i];
        final type = mediaTypes[i];

        final entries = _realm.query<UserListEntryRealm>(
            '${UserListEntryRealmFields.listName} == \$0 AND ${UserListEntryRealmFields.tmdbId} == \$1 AND ${UserListEntryRealmFields.mediaType} == \$2',
            [listName, id, type]);
        _realm.deleteMany(entries);

        final title = _realm.find<TmdbTitleRealm>('${id}_$type');

        if (title != null) {
          title.inLists.remove(listName);
          _deleteOrphanTitle(title);
        }
      }
    });
  }

  Future<void> clearList(String listName) async {
    _realm.write(() {
      final entriesToRemove = _realm.query<UserListEntryRealm>(
          '${UserListEntryRealmFields.listName} == \$0', [listName]);
      _realm.deleteMany(entriesToRemove);

      final titlesToClean = _realm.query<TmdbTitleRealm>(
          '\$0 IN ${TmdbTitleRealmFields.inLists}', [listName]).toList();

      for (final title in titlesToClean) {
        title.inLists.remove(listName);
        _deleteOrphanTitle(title);
      }
    });
  }

  Future<bool> hasRatedTitles(String listName) async {
    final count = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists} AND ${TmdbTitleRealmFields.rating} > \$1',
        [listName, AppConstants.seenRating]).length;
    return count > 0;
  }

  Future<bool> hasTitlesInList(List<int> tmdbIds, String listName) async {
    if (tmdbIds.isEmpty) return false;
    final count = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists} AND ${TmdbTitleRealmFields.tmdbId} IN \$1',
        [listName, tmdbIds]).length;
    return count > 0;
  }

  Future<List<TmdbTitle>> getUninitializedTitles() async {
    final query = _realm.query<TmdbTitleRealm>(
        '${TmdbTitleRealmFields.lastUpdated} == \$0',
        [AppConstants.defaultDate]);
    final results = query.toList();
    return results.map(RealmMapper.toDomainTitle).toList();
  }

  int countTitlesSync(String listName) {
    return _realm.query<UserListEntryRealm>(
        '${UserListEntryRealmFields.listName} == \$0', [listName]).length;
  }

  Future<int> getMaxAddedOrder(String listName) async {
    final entries = _realm.query<UserListEntryRealm>(
        '${UserListEntryRealmFields.listName} == \$0 SORT(${UserListEntryRealmFields.addedOrder} DESC)',
        [listName]);
    return entries.isNotEmpty ? entries.first.addedOrder : -1;
  }

  Future<TmdbTitle?> getTitleByTmdbId(
      String listName, int tmdbId, String mediaType) async {
    final realmObj = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists} AND ${TmdbTitleRealmFields.tmdbId} == \$1 AND ${TmdbTitleRealmFields.mediaType} == \$2',
        [listName, tmdbId, mediaType]).firstOrNull;
    return realmObj != null ? RealmMapper.toDomainTitle(realmObj) : null;
  }

  TmdbTitle? getTitleByTmdbIdSync(
      String listName, int tmdbId, String mediaType) {
    final realmObj = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists} AND ${TmdbTitleRealmFields.tmdbId} == \$1 AND ${TmdbTitleRealmFields.mediaType} == \$2',
        [listName, tmdbId, mediaType]).firstOrNull;
    return realmObj != null ? RealmMapper.toDomainTitle(realmObj) : null;
  }

  Future<TmdbSeason?> getSeason(int tvId, int seasonNumber) async {
    final realmObj = _realm.find<TmdbSeasonRealm>('${tvId}_$seasonNumber');
    return realmObj != null ? RealmMapper.toDomainSeason(realmObj) : null;
  }

  Future<void> putSeason(TmdbSeason season) async {
    _realm.write(() {
      _realm.add(RealmMapper.toRealmSeason(season), update: true);
    });
  }

  Future<TmdbEpisode?> getEpisode(
      int tvId, int seasonNumber, int episodeNumber) async {
    final realmObj =
        _realm.find<TmdbEpisodeRealm>('${tvId}_${seasonNumber}_$episodeNumber');
    return realmObj != null ? RealmMapper.toDomainEpisode(realmObj) : null;
  }

  Future<void> putEpisode(TmdbEpisode episode) async {
    _realm.write(() {
      _realm.add(RealmMapper.toRealmEpisode(episode), update: true);
    });
  }

  Future<TmdbTitle?> getTitleGlobal(int tmdbId, String mediaType) async {
    final realmObj = _realm.query<TmdbTitleRealm>(
        '${TmdbTitleRealmFields.tmdbId} == \$0 AND ${TmdbTitleRealmFields.mediaType} == \$1',
        [tmdbId, mediaType]).firstOrNull;
    return realmObj != null ? RealmMapper.toDomainTitle(realmObj) : null;
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    if (tmdbIds.isEmpty) return [];
    final realmObjs = _realm.query<TmdbTitleRealm>(
        '${TmdbTitleRealmFields.tmdbId} IN \$0', [tmdbIds]);
    return realmObjs.map((e) => RealmMapper.toDomainTitle(e)).toList();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    final entries = _realm.query<UserListEntryRealm>(
        '${UserListEntryRealmFields.listName} == \$0', [listName]);
    return entries.map((e) => e.tmdbId).toList();
  }

  Future<List<UserListEntry>> getAllEntries(String listName) async {
    final entries = _realm.query<UserListEntryRealm>(
        '${UserListEntryRealmFields.listName} == \$0', [listName]);
    return entries.map((e) => RealmMapper.toDomainUserListEntry(e)).toList();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    final titles = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists}', [listName]);
    return titles.map((e) => e.genreIds.toList()).toList();
  }

  Future<List<TmdbTitle>> getAllTitlesInList(String listName) async {
    final titles = _realm.query<TmdbTitleRealm>(
        '\$0 IN ${TmdbTitleRealmFields.inLists}', [listName]);
    return titles.map((e) => RealmMapper.toDomainTitle(e)).toList();
  }

  RealmResults<TmdbTitleRealm> _buildQuery({
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
  }) {
    final queryBuffer = StringBuffer();
    final args = <Object?>[];

    queryBuffer.write('\$0 IN ${TmdbTitleRealmFields.inLists}');
    args.add(listName);

    if (pinned != null) {
      queryBuffer
          .write(' AND ${TmdbTitleRealmFields.isPinned} == \$${args.length}');
      args.add(pinned);
    }

    if (filterText.isNotEmpty) {
      final index = args.length;
      queryBuffer.write(
          ' AND (${TmdbTitleRealmFields.name} CONTAINS[c] \$$index OR ${TmdbTitleRealmFields.originalName} CONTAINS[c] \$$index OR ${TmdbTitleRealmFields.overview} CONTAINS[c] \$$index OR ${TmdbTitleRealmFields.tagline} CONTAINS[c] \$$index)');
      args.add(filterText);
    }

    if (filterGenres.isNotEmpty) {
      if (filterExcludeGenres) {
        for (final genre in filterGenres) {
          queryBuffer.write(
              ' AND NOT (${TmdbTitleRealmFields.genreIds} == \$${args.length})');
          args.add(genre);
        }
      } else {
        queryBuffer.write(' AND (');
        for (int i = 0; i < filterGenres.length; i++) {
          queryBuffer
              .write('${TmdbTitleRealmFields.genreIds} == \$${args.length}');
          args.add(filterGenres[i]);
          if (i < filterGenres.length - 1) {
            queryBuffer.write(' OR ');
          }
        }
        queryBuffer.write(')');
      }
    }

    if (filterMediaType.isNotEmpty) {
      if (filterMediaType == AppConstants.miniseries) {
        queryBuffer.write(
            ' AND ${TmdbTitleRealmFields.mediaType} == \$${args.length} AND ${TmdbTitleRealmFields.numberOfSeasons} == 1 AND ${TmdbTitleRealmFields.status} == \$${args.length + 1}');
        args.add(ApiConstants.tv);
        args.add('Ended');
      } else {
        queryBuffer.write(
            ' AND ${TmdbTitleRealmFields.mediaType} == \$${args.length}');
        args.add(filterMediaType);
      }
    }

    if (filterByProviders) {
      if (filterProvidersIds.isNotEmpty) {
        queryBuffer.write(' AND (');
        for (int i = 0; i < filterProvidersIds.length; i++) {
          queryBuffer.write(
              'ANY ${TmdbTitleRealmFields.flatrateProviderIds} == \$${args.length}');
          args.add(filterProvidersIds[i]);
          if (i < filterProvidersIds.length - 1) {
            queryBuffer.write(' OR ');
          }
        }
        queryBuffer.write(')');
      } else {
        queryBuffer.write(' AND FALSEPREDICATE');
      }
    }

    if (filterRating == RatingFilter.rated) {
      queryBuffer
          .write(' AND ${TmdbTitleRealmFields.rating} > \$${args.length}');
      args.add(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.seenOnly) {
      queryBuffer
          .write(' AND ${TmdbTitleRealmFields.rating} == \$${args.length}');
      args.add(AppConstants.seenRating);
    } else if (filterRating == RatingFilter.followingOnly) {
      queryBuffer.write(
          ' AND ${TmdbTitleRealmFields.notifyNewSeasons} == \$${args.length}');
      args.add(true);
    }

    if (sortOption != SortOption.addedOrder) {
      String sortField = TmdbTitleRealmFields.name;
      switch (sortOption) {
        case SortOption.rating:
          sortField = TmdbTitleRealmFields.voteAverage;
          break;
        case SortOption.userRating:
          sortField = TmdbTitleRealmFields.rating;
          break;
        case SortOption.dateRated:
          sortField = TmdbTitleRealmFields.dateRated;
          break;
        case SortOption.releaseDate:
          sortField = TmdbTitleRealmFields.effectiveReleaseDate;
          break;
        case SortOption.runtime:
          sortField = TmdbTitleRealmFields.effectiveRuntime;
          break;
        case SortOption.alphabetically:
        default:
          sortField = TmdbTitleRealmFields.name;
          break;
      }
      final ascDesc = sortAscending ? 'ASC' : 'DESC';
      if (sortOption == SortOption.runtime) {
        queryBuffer.write(
            ' SORT(${TmdbTitleRealmFields.mediaType} ASC, ${TmdbTitleRealmFields.effectiveRuntime} $ascDesc)');
      } else {
        queryBuffer.write(' SORT($sortField $ascDesc)');
      }
    }

    return _realm.query<TmdbTitleRealm>(queryBuffer.toString(), args);
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
    final results = _buildQuery(
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
      sortOption: sortOption,
      sortAscending: sortAscending,
    );

    if (sortOption == SortOption.addedOrder) {
      final entries = await getAllEntries(listName);
      final orderMap = {
        for (var e in entries) '${e.tmdbId}_${e.mediaType}': e.addedOrder
      };
      var filtered = results.toList();
      filtered.sort((a, b) {
        final orderA = orderMap[a.id] ?? 0;
        final orderB = orderMap[b.id] ?? 0;
        return sortAscending
            ? orderA.compareTo(orderB)
            : orderB.compareTo(orderA);
      });

      final start = offset;
      final end = (offset + limit) > filtered.length
          ? filtered.length
          : (offset + limit);
      if (start >= filtered.length) return [];

      return filtered
          .sublist(start, end)
          .map((e) => RealmMapper.toDomainTitle(e))
          .toList();
    }

    return results
        .skip(offset)
        .take(limit)
        .map((e) => RealmMapper.toDomainTitle(e))
        .toList();
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
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    ).length;
  }

  Future<bool> hasTitlesFiltered({
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
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    ).isNotEmpty;
  }
}
