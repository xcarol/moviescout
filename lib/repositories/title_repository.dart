import 'package:drift/drift.dart';
import 'package:moviescout/database/app_database.dart';
import 'package:moviescout/database/drift_mappers.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/core/database_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class TitleRepository {
  final AppDatabase _db;

  TitleRepository({AppDatabase? db}) : _db = db ?? DatabaseService.instance;

  void _mergeTitleMetadata(TmdbTitle newTitle, TmdbTitle currentTitle,
      {String? listName}) {
    if (listName != AppConstants.watchlist) {
      newTitle.isPinned = currentTitle.isPinned;
    }

    if (listName != AppConstants.rateslist) {
      newTitle.notifyNewSeasons = currentTitle.notifyNewSeasons;
      newTitle.lastNotifiedSeason = currentTitle.lastNotifiedSeason;
    }

    if (newTitle.rating == 0.0 && currentTitle.rating > 0.0) {
      newTitle.rating = currentTitle.rating;
      newTitle.dateRated = currentTitle.dateRated;
    }

    newTitle.omdbRatingsJson ??= currentTitle.omdbRatingsJson;
  }

  Future<void> saveTitles(List<TmdbTitle> titles, String listName,
      {List<int>? addedOrders}) async {
    if (titles.isEmpty) return;

    await _db.transaction(() async {
      for (var j = 0; j < titles.length; j++) {
        final title = titles[j];
        final id = '${title.tmdbId}_${title.mediaType}';
        final existing = await (_db.select(_db.tmdbTitles)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();

        if (existing != null) {
          _mergeTitleMetadata(title, DriftMapper.toDomainTitle(existing),
              listName: listName);
        }

        await _db
            .into(_db.tmdbTitles)
            .insertOnConflictUpdate(DriftMapper.toCompanionTitle(title));

        final order = addedOrders != null ? addedOrders[j] : j;
        await _db.into(_db.userListEntries).insertOnConflictUpdate(
              UserListEntriesCompanion(
                id: Value('${listName}_${title.tmdbId}_${title.mediaType}'),
                listName: Value(listName),
                tmdbId: Value(title.tmdbId),
                mediaType: Value(title.mediaType),
                addedOrder: Value(order),
              ),
            );
      }
    });
  }

  Future<void> updateTitlesMetadata(List<TmdbTitle> titles) async {
    if (titles.isEmpty) return;

    await _db.transaction(() async {
      for (final title in titles) {
        final id = '${title.tmdbId}_${title.mediaType}';
        final existing = await (_db.select(_db.tmdbTitles)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();

        if (existing != null) {
          _mergeTitleMetadata(title, DriftMapper.toDomainTitle(existing));
        }

        await _db
            .into(_db.tmdbTitles)
            .insertOnConflictUpdate(DriftMapper.toCompanionTitle(title));
      }
    });
  }

  Future<void> updateIsPinnedList(List<TmdbTitle> titles) async {
    await _db.batch((batch) {
      for (final title in titles) {
        final id = '${title.tmdbId}_${title.mediaType}';
        batch.update(
          _db.tmdbTitles,
          TmdbTitlesCompanion(isPinned: Value(title.isPinned)),
          where: (t) => t.id.equals(id),
        );
      }
    });
  }

  Future<void> updateRatingList(List<TmdbTitle> titles) async {
    await _db.batch((batch) {
      for (final title in titles) {
        final id = '${title.tmdbId}_${title.mediaType}';
        batch.update(
          _db.tmdbTitles,
          TmdbTitlesCompanion(
            rating: Value(title.rating),
            dateRated: Value(title.dateRated),
          ),
          where: (t) => t.id.equals(id),
        );
      }
    });
  }

  Future<void> updateNotifyNewSeasonsList(List<TmdbTitle> titles) async {
    await _db.batch((batch) {
      for (final title in titles) {
        final id = '${title.tmdbId}_${title.mediaType}';
        batch.update(
          _db.tmdbTitles,
          TmdbTitlesCompanion(
            notifyNewSeasons: Value(title.notifyNewSeasons),
            lastNotifiedSeason: Value(title.lastNotifiedSeason),
          ),
          where: (t) => t.id.equals(id),
        );
      }
    });
  }

  Future<void> invalidateSeasonsAndEpisodes(int tvId) async {
    final epochDateStr =
        DateTime.fromMillisecondsSinceEpoch(0).toIso8601String();
    await _db.transaction(() async {
      await (_db.update(_db.tmdbSeasons)..where((s) => s.tvId.equals(tvId)))
          .write(TmdbSeasonsCompanion(lastUpdated: Value(epochDateStr)));
      await (_db.update(_db.tmdbEpisodes)..where((e) => e.tvId.equals(tvId)))
          .write(TmdbEpisodesCompanion(lastUpdated: Value(epochDateStr)));
    });
  }

  Future<void> deleteTitles(
      String listName, List<int> tmdbIds, List<String> mediaTypes) async {
    if (tmdbIds.isEmpty) return;

    await _db.transaction(() async {
      for (var i = 0; i < tmdbIds.length; i++) {
        final id = tmdbIds[i];
        final type = mediaTypes[i];

        await (_db.delete(_db.userListEntries)
              ..where((e) =>
                  e.listName.equals(listName) &
                  e.tmdbId.equals(id) &
                  e.mediaType.equals(type)))
            .go();

        final remainingEntries = await (_db.select(_db.userListEntries)
              ..where((e) => e.tmdbId.equals(id) & e.mediaType.equals(type)))
            .get();

        final titleId = '${id}_$type';
        if (remainingEntries.isEmpty) {
          await (_db.delete(_db.tmdbTitles)..where((t) => t.id.equals(titleId)))
              .go();
          if (type == ApiConstants.tv || type == AppConstants.miniseries) {
            await (_db.delete(_db.tmdbSeasons)..where((s) => s.tvId.equals(id)))
                .go();
            await (_db.delete(_db.tmdbEpisodes)
                  ..where((e) => e.tvId.equals(id)))
                .go();
          }
        }
      }
    });
  }

  Future<void> clearList(String listName) async {
    await _db.transaction(() async {
      final entries = await (_db.select(_db.userListEntries)
            ..where((e) => e.listName.equals(listName)))
          .get();

      await (_db.delete(_db.userListEntries)
            ..where((e) => e.listName.equals(listName)))
          .go();

      for (final entry in entries) {
        final remaining = await (_db.select(_db.userListEntries)
              ..where((e) =>
                  e.tmdbId.equals(entry.tmdbId) &
                  e.mediaType.equals(entry.mediaType)))
            .get();

        final titleId = '${entry.tmdbId}_${entry.mediaType}';
        if (remaining.isEmpty) {
          await (_db.delete(_db.tmdbTitles)..where((t) => t.id.equals(titleId)))
              .go();
          if (entry.mediaType == ApiConstants.tv ||
              entry.mediaType == AppConstants.miniseries) {
            await (_db.delete(_db.tmdbSeasons)
                  ..where((s) => s.tvId.equals(entry.tmdbId)))
                .go();
            await (_db.delete(_db.tmdbEpisodes)
                  ..where((e) => e.tvId.equals(entry.tmdbId)))
                .go();
          }
        }
      }
    });
  }

  Future<bool> hasRatedTitles(String listName) async {
    final query = _db.select(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ])
      ..where(_db.userListEntries.listName.equals(listName))
      ..where(_db.tmdbTitles.rating.isBiggerThanValue(AppConstants.seenRating))
      ..limit(1);

    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<bool> hasTitlesInList(List<int> tmdbIds, String listName) async {
    if (tmdbIds.isEmpty) return false;
    final query = _db.select(_db.userListEntries)
      ..where((e) => e.listName.equals(listName) & e.tmdbId.isIn(tmdbIds))
      ..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<List<TmdbTitle>> getUninitializedTitles() async {
    final query = _db.select(_db.tmdbTitles)
      ..where((t) => t.lastUpdated.equals(AppConstants.defaultDate));
    final results = await query.get();
    return results.map(DriftMapper.toDomainTitle).toList();
  }

  Future<int> countTitles(String listName) async {
    final countExp = _db.userListEntries.id.count();
    final query = _db.selectOnly(_db.userListEntries)
      ..addColumns([countExp])
      ..where(_db.userListEntries.listName.equals(listName));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getMaxAddedOrder(String listName) async {
    final query = _db.select(_db.userListEntries)
      ..where((e) => e.listName.equals(listName))
      ..orderBy([(e) => OrderingTerm.desc(e.addedOrder)])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.addedOrder ?? -1;
  }

  Future<TmdbTitle?> getTitleByTmdbId(
      String listName, int tmdbId, String mediaType) async {
    final query = _db.select(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ])
      ..where(_db.userListEntries.listName.equals(listName))
      ..where(_db.tmdbTitles.tmdbId.equals(tmdbId))
      ..where(_db.tmdbTitles.mediaType.equals(mediaType))
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row != null
        ? DriftMapper.toDomainTitle(row.readTable(_db.tmdbTitles))
        : null;
  }

  Future<TmdbSeason?> getSeason(int tvId, int seasonNumber) async {
    final query = _db.select(_db.tmdbSeasons)
      ..where((s) => s.tvId.equals(tvId) & s.seasonNumber.equals(seasonNumber))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null ? DriftMapper.toDomainSeason(result) : null;
  }

  Future<void> putSeason(TmdbSeason season) async {
    await _db
        .into(_db.tmdbSeasons)
        .insertOnConflictUpdate(DriftMapper.toCompanionSeason(season));
  }

  Future<TmdbEpisode?> getEpisode(
      int tvId, int seasonNumber, int episodeNumber) async {
    final query = _db.select(_db.tmdbEpisodes)
      ..where((e) =>
          e.tvId.equals(tvId) &
          e.seasonNumber.equals(seasonNumber) &
          e.episodeNumber.equals(episodeNumber))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null ? DriftMapper.toDomainEpisode(result) : null;
  }

  Future<void> putEpisode(TmdbEpisode episode) async {
    await _db
        .into(_db.tmdbEpisodes)
        .insertOnConflictUpdate(DriftMapper.toCompanionEpisode(episode));
  }

  Future<List<TmdbEpisode>> getRatedEpisodes() async {
    final query = _db.select(_db.tmdbEpisodes)
      ..where((e) => e.rating.isBiggerThanValue(0.0));
    final results = await query.get();
    return results.map(DriftMapper.toDomainEpisode).toList();
  }

  Future<TmdbTitle?> getTitleGlobal(int tmdbId, String mediaType) async {
    final query = _db.select(_db.tmdbTitles)
      ..where((t) => t.tmdbId.equals(tmdbId) & t.mediaType.equals(mediaType))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null ? DriftMapper.toDomainTitle(result) : null;
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    if (tmdbIds.isEmpty) return [];
    final query = _db.select(_db.tmdbTitles)
      ..where((t) => t.tmdbId.isIn(tmdbIds));
    final results = await query.get();
    return results.map(DriftMapper.toDomainTitle).toList();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    final query = _db.select(_db.userListEntries)
      ..where((e) => e.listName.equals(listName));
    final results = await query.get();
    return results.map((e) => e.tmdbId).toList();
  }

  Future<List<UserListEntry>> getAllEntries(String listName) async {
    final query = _db.select(_db.userListEntries)
      ..where((e) => e.listName.equals(listName));
    final results = await query.get();
    return results.map(DriftMapper.toDomainUserListEntry).toList();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    final query = _db.select(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ])
      ..where(_db.userListEntries.listName.equals(listName));

    final results = await query.get();
    return results
        .map((row) => row.readTable(_db.tmdbTitles).genreIds.toList())
        .toList();
  }

  Future<List<TmdbTitle>> getAllTitlesInList(String listName) async {
    final query = _db.select(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ])
      ..where(_db.userListEntries.listName.equals(listName));

    final results = await query.get();
    return results
        .map((row) => DriftMapper.toDomainTitle(row.readTable(_db.tmdbTitles)))
        .toList();
  }

  void _applyFilters({
    required dynamic query,
    required String listName,
    String filterText = '',
    String filterMediaType = '',
    List<int> filterGenres = const [],
    bool filterExcludeGenres = false,
    bool filterByProviders = false,
    List<int> filterProvidersIds = const [],
    RatingFilter filterRating = RatingFilter.all,
    bool? pinned,
  }) {
    query.where(_db.userListEntries.listName.equals(listName));

    if (pinned != null) {
      query.where(_db.tmdbTitles.isPinned.equals(pinned));
    }

    if (filterText.isNotEmpty) {
      final pattern = '%$filterText%';
      query.where(
        _db.tmdbTitles.name.like(pattern) |
            _db.tmdbTitles.originalName.like(pattern) |
            _db.tmdbTitles.overview.like(pattern) |
            _db.tmdbTitles.tagline.like(pattern),
      );
    }

    if (filterGenres.isNotEmpty) {
      if (filterExcludeGenres) {
        for (final genre in filterGenres) {
          query.where(CustomExpression<bool>(
              'NOT EXISTS (SELECT 1 FROM json_each(tmdb_titles.genre_ids) WHERE value = $genre)'));
        }
      } else {
        final genresList = filterGenres.join(',');
        query.where(CustomExpression<bool>(
            'EXISTS (SELECT 1 FROM json_each(tmdb_titles.genre_ids) WHERE value IN ($genresList))'));
      }
    }

    if (filterMediaType.isNotEmpty) {
      if (filterMediaType == AppConstants.miniseries) {
        query.where(_db.tmdbTitles.mediaType.equals(ApiConstants.tv) &
            _db.tmdbTitles.type.equals(TvShowType.miniseries));
      } else {
        query.where(_db.tmdbTitles.mediaType.equals(filterMediaType));
      }
    }

    if (filterByProviders) {
      if (filterProvidersIds.isNotEmpty) {
        final providersList = filterProvidersIds.join(',');
        query.where(CustomExpression<bool>(
            'EXISTS (SELECT 1 FROM json_each(tmdb_titles.flatrate_provider_ids) WHERE value IN ($providersList))'));
      } else {
        query.where(const CustomExpression<bool>('0 = 1'));
      }
    }

    if (filterRating == RatingFilter.rated) {
      query.where(
          _db.tmdbTitles.rating.isBiggerThanValue(AppConstants.seenRating));
    } else if (filterRating == RatingFilter.seenOnly) {
      query.where(_db.tmdbTitles.rating.equals(AppConstants.seenRating));
    } else if (filterRating == RatingFilter.followingOnly) {
      query.where(_db.tmdbTitles.notifyNewSeasons.equals(true));
    }
  }

  JoinedSelectStatement _buildJoinedQuery({
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
    final query = _db.select(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ]);

    _applyFilters(
      query: query,
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    );

    if (sortOption == SortOption.addedOrder) {
      query.orderBy([
        OrderingTerm(
          expression: _db.userListEntries.addedOrder,
          mode: sortAscending ? OrderingMode.asc : OrderingMode.desc,
        )
      ]);
    } else if (sortOption == SortOption.runtime) {
      query.orderBy([
        OrderingTerm.asc(_db.tmdbTitles.mediaType),
        OrderingTerm(
          expression: _db.tmdbTitles.effectiveRuntime,
          mode: sortAscending ? OrderingMode.asc : OrderingMode.desc,
        ),
      ]);
    } else {
      Expression sortField = _db.tmdbTitles.name;
      switch (sortOption) {
        case SortOption.rating:
          sortField = _db.tmdbTitles.voteAverage;
          break;
        case SortOption.userRating:
          sortField = _db.tmdbTitles.rating;
          break;
        case SortOption.dateRated:
          sortField = _db.tmdbTitles.dateRated;
          break;
        case SortOption.releaseDate:
          sortField = _db.tmdbTitles.effectiveReleaseDate;
          break;
        case SortOption.alphabetically:
        default:
          sortField = _db.tmdbTitles.name;
          break;
      }
      query.orderBy([
        OrderingTerm(
          expression: sortField,
          mode: sortAscending ? OrderingMode.asc : OrderingMode.desc,
        )
      ]);
    }

    return query;
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
    final query = _buildJoinedQuery(
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      sortOption: sortOption,
      sortAscending: sortAscending,
      filterRating: filterRating,
      pinned: pinned,
    );

    query.limit(limit, offset: offset);
    final rows = await query.get();
    return rows
        .map((row) => DriftMapper.toDomainTitle(row.readTable(_db.tmdbTitles)))
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
    final countExp = _db.tmdbTitles.id.count();
    final query = _db.selectOnly(_db.tmdbTitles).join([
      innerJoin(
        _db.userListEntries,
        _db.userListEntries.tmdbId.equalsExp(_db.tmdbTitles.tmdbId) &
            _db.userListEntries.mediaType.equalsExp(_db.tmdbTitles.mediaType),
      ),
    ])
      ..addColumns([countExp]);

    _applyFilters(
      query: query,
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    );

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
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
    final count = await countTitlesFiltered(
      listName: listName,
      filterText: filterText,
      filterMediaType: filterMediaType,
      filterGenres: filterGenres,
      filterExcludeGenres: filterExcludeGenres,
      filterByProviders: filterByProviders,
      filterProvidersIds: filterProvidersIds,
      filterRating: filterRating,
      pinned: pinned,
    );
    return count > 0;
  }
}
