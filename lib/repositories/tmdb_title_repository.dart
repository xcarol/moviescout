import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/user_list_entry.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/realm_service.dart';
import 'package:moviescout/database/realm_models.dart';
import 'package:moviescout/database/realm_mappers.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/save_logs.dart';

class TmdbTitleRepository {
  final _realm = RealmService.instance;

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

    final inRatesList = _realm.query<UserListEntryRealm>(
        r'tmdbId == $0 AND mediaType == $1', [title.tmdbId, title.mediaType]);

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
      saveLogs([
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
    _realm.write(() {
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

  Future<void> saveTitles(List<TmdbTitle> titles, String listName,
      {List<int>? addedOrders}) async {
    if (titles.isEmpty) return;

    const batchSize = AppConstants.defaultBatchSize;
    for (var i = 0; i < titles.length; i += batchSize) {
      final end =
          (i + batchSize < titles.length) ? i + batchSize : titles.length;
      final batchTitles = titles.sublist(i, end);
      final batchOrders = addedOrders?.sublist(i, end);

      _realm.write(() {
        for (var j = 0; j < batchTitles.length; j++) {
          final title = batchTitles[j];
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
    }
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

    const batchSize = AppConstants.defaultBatchSize;
    for (var i = 0; i < titles.length; i += batchSize) {
      final end =
          (i + batchSize < titles.length) ? i + batchSize : titles.length;
      final batchTitles = titles.sublist(i, end);

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
    }
  }

  Future<void> deleteTitle(
      String listName, int tmdbId, String mediaType) async {
    _realm.write(() {
      final entries = _realm.query<UserListEntryRealm>(
          r'listName == $0 AND tmdbId == $1 AND mediaType == $2',
          [listName, tmdbId, mediaType]);
      _realm.deleteMany(entries);

      final title = _realm.find<TmdbTitleRealm>('${tmdbId}_$mediaType');

      if (title != null) {
        title.inLists.remove(listName);
        if (title.inLists.isEmpty) {
          final mediaType = title.mediaType;
          _realm.delete(title);
          if (mediaType == ApiConstants.tv ||
              mediaType == AppConstants.miniseries) {
            final seasons =
                _realm.query<TmdbSeasonRealm>(r'tvId == $0', [tmdbId]);
            _realm.deleteMany(seasons);
            final episodes =
                _realm.query<TmdbEpisodeRealm>(r'tvId == $0', [tmdbId]);
            _realm.deleteMany(episodes);
          }
        }
      }
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
            r'listName == $0 AND tmdbId == $1 AND mediaType == $2',
            [listName, id, type]);
        _realm.deleteMany(entries);

        final title = _realm.find<TmdbTitleRealm>('${id}_$type');

        if (title != null) {
          title.inLists.remove(listName);
          if (title.inLists.isEmpty) {
            final mediaType = title.mediaType;
            final titleTmdbId = title.tmdbId;
            _realm.delete(title);
            if (mediaType == ApiConstants.tv ||
                mediaType == AppConstants.miniseries) {
              final seasons =
                  _realm.query<TmdbSeasonRealm>(r'tvId == $0', [titleTmdbId]);
              _realm.deleteMany(seasons);
              final episodes =
                  _realm.query<TmdbEpisodeRealm>(r'tvId == $0', [titleTmdbId]);
              _realm.deleteMany(episodes);
            }
          }
        }
      }
    });
  }

  Future<void> clearList(String listName) async {
    _realm.write(() {
      final entriesToRemove =
          _realm.query<UserListEntryRealm>(r'listName == $0', [listName]);
      _realm.deleteMany(entriesToRemove);

      final titlesToClean = _realm
          .query<TmdbTitleRealm>(r'inLists CONTAINS $0', [listName]).toList();

      for (final title in titlesToClean) {
        title.inLists.remove(listName);
        if (title.inLists.isEmpty) {
          final mediaType = title.mediaType;
          final titleTmdbId = title.tmdbId;
          _realm.delete(title);
          if (mediaType == ApiConstants.tv ||
              mediaType == AppConstants.miniseries) {
            final seasons =
                _realm.query<TmdbSeasonRealm>(r'tvId == $0', [titleTmdbId]);
            _realm.deleteMany(seasons);
            final episodes =
                _realm.query<TmdbEpisodeRealm>(r'tvId == $0', [titleTmdbId]);
            _realm.deleteMany(episodes);
          }
        }
      }
    });
  }

  Future<bool> hasRatedTitles(String listName) async {
    final count = _realm.query<TmdbTitleRealm>(
        r'$0 IN inLists AND rating > 0.0', [listName]).length;
    return count > 0;
  }

  Future<int> getMaxAddedOrder(String listName) async {
    final entries = _realm.query<UserListEntryRealm>(
        r'listName == $0 SORT(addedOrder DESC)', [listName]);
    return entries.isNotEmpty ? entries.first.addedOrder : -1;
  }

  int countTitlesSync(String listName) {
    return _realm
        .query<UserListEntryRealm>(r'listName == $0', [listName]).length;
  }

  Future<TmdbTitle?> getTitleByTmdbId(
      String listName, int tmdbId, String mediaType) async {
    final realmObj = _realm.query<TmdbTitleRealm>(
        r'$0 IN inLists AND tmdbId == $1 AND mediaType == $2',
        [listName, tmdbId, mediaType]).firstOrNull;
    return realmObj != null ? RealmMapper.toDomainTitle(realmObj) : null;
  }

  TmdbTitle? getTitleByTmdbIdSync(
      String listName, int tmdbId, String mediaType) {
    final realmObj = _realm.query<TmdbTitleRealm>(
        r'$0 IN inLists AND tmdbId == $1 AND mediaType == $2',
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
    final realmObj = _realm.find<TmdbTitleRealm>('${tmdbId}_$mediaType');
    return realmObj != null ? RealmMapper.toDomainTitle(realmObj) : null;
  }

  Future<List<TmdbTitle>> getTitlesByTmdbIds(List<int> tmdbIds) async {
    if (tmdbIds.isEmpty) return [];
    final realmObjs = _realm.query<TmdbTitleRealm>(r'tmdbId IN $0', [tmdbIds]);
    return realmObjs.map((e) => RealmMapper.toDomainTitle(e)).toList();
  }

  Future<List<int>> getAllTmdbIds(String listName) async {
    final entries =
        _realm.query<UserListEntryRealm>(r'listName == $0', [listName]);
    return entries.map((e) => e.tmdbId).toList();
  }

  Future<List<UserListEntry>> getAllEntries(String listName) async {
    final entries =
        _realm.query<UserListEntryRealm>(r'listName == $0', [listName]);
    return entries.map((e) => RealmMapper.toDomainUserListEntry(e)).toList();
  }

  Future<List<List<int>>> getAllGenreIds(String listName) async {
    final titles = _realm.query<TmdbTitleRealm>(r'$0 IN inLists', [listName]);
    return titles.map((e) => e.genreIds.toList()).toList();
  }

  Future<List<TmdbTitle>> getAllTitlesInList(String listName) async {
    final titles = _realm.query<TmdbTitleRealm>(r'$0 IN inLists', [listName]);
    return titles.map((e) => RealmMapper.toDomainTitle(e)).toList();
  }

  List<TmdbTitle> _filterAndSortTitles(
    List<TmdbTitle> titles, {
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
    var filtered = titles.where((t) {
      if (pinned != null && t.isPinned != pinned) return false;
      if (filterText.isNotEmpty) {
        final lower = filterText.toLowerCase();
        if (!t.name.toLowerCase().contains(lower) &&
            !t.originalName.toLowerCase().contains(lower) &&
            !t.overview.toLowerCase().contains(lower) &&
            !t.tagline.toLowerCase().contains(lower)) {
          return false;
        }
      }
      if (filterGenres.isNotEmpty) {
        if (filterExcludeGenres) {
          if (filterGenres.any((id) => t.genreIds.contains(id))) return false;
        } else {
          if (!filterGenres.any((id) => t.genreIds.contains(id))) return false;
        }
      }
      if (filterMediaType.isNotEmpty) {
        if (filterMediaType == AppConstants.miniseries) {
          if (t.mediaType != ApiConstants.tv ||
              t.numberOfSeasons != 1 ||
              t.status != TvShowStatus.ended) return false;
        } else {
          if (t.mediaType != filterMediaType) return false;
        }
      }
      if (filterByProviders && filterProvidersIds.isNotEmpty) {
        if (!filterProvidersIds.any((id) => t.flatrateProviderIds.contains(id)))
          return false;
      }
      if (filterRating == RatingFilter.rated) {
        if (t.rating <= AppConstants.seenRating) return false;
      } else if (filterRating == RatingFilter.seenOnly) {
        if (t.rating != AppConstants.seenRating) return false;
      } else if (filterRating == RatingFilter.followingOnly) {
        if (t.notifyNewSeasons != true) return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      int result = 0;
      switch (sortOption) {
        case SortOption.rating:
          result = a.voteAverage.compareTo(b.voteAverage);
          break;
        case SortOption.userRating:
          result = a.rating.compareTo(b.rating);
          break;
        case SortOption.dateRated:
          result = a.dateRated.compareTo(b.dateRated);
          break;
        case SortOption.releaseDate:
          result = a.effectiveReleaseDate.compareTo(b.effectiveReleaseDate);
          break;
        case SortOption.runtime:
          final isMovieA = a.mediaType == ApiConstants.movie ? 1 : 0;
          final isMovieB = b.mediaType == ApiConstants.movie ? 1 : 0;
          result = isMovieB.compareTo(isMovieA);
          if (result == 0) {
            result = a.effectiveRuntime.compareTo(b.effectiveRuntime);
          }
          break;
        case SortOption.alphabetically:
        default:
          result = a.name.compareTo(b.name);
          break;
      }
      return sortAscending ? result : -result;
    });

    return filtered;
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
    final titles = await getAllTitlesInList(listName);

    if (sortOption == SortOption.addedOrder) {
      final entries = await getAllEntries(listName);
      final orderMap = {
        for (var e in entries) '${e.tmdbId}_${e.mediaType}': e.addedOrder
      };

      var filtered = _filterAndSortTitles(
        titles,
        filterText: filterText,
        filterMediaType: filterMediaType,
        filterGenres: filterGenres,
        filterExcludeGenres: filterExcludeGenres,
        filterByProviders: filterByProviders,
        filterProvidersIds: filterProvidersIds,
        filterRating: filterRating,
        pinned: pinned,
        sortOption: SortOption.alphabetically,
      );

      filtered.sort((a, b) {
        final orderA = orderMap['${a.tmdbId}_${a.mediaType}'] ?? 0;
        final orderB = orderMap['${b.tmdbId}_${b.mediaType}'] ?? 0;
        return sortAscending
            ? orderA.compareTo(orderB)
            : orderB.compareTo(orderA);
      });

      final start = offset;
      final end = (offset + limit) > filtered.length
          ? filtered.length
          : (offset + limit);
      if (start >= filtered.length) return [];
      return filtered.sublist(start, end);
    }

    final filtered = _filterAndSortTitles(
      titles,
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

    final start = offset;
    final end =
        (offset + limit) > filtered.length ? filtered.length : (offset + limit);
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end);
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
    final titles = await getAllTitlesInList(listName);
    return _filterAndSortTitles(
      titles,
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
  }) async {
    final count = await countTitlesFiltered(listName: listName);
    return count > 0;
  }
}
