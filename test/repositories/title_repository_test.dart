import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:moviescout/database/app_database.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/repositories/title_repository.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;

void main() {
  late AppDatabase db;
  late TitleRepository repository;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () {
      try {
        return DynamicLibrary.open('libsqlite3.so');
      } catch (_) {
        return DynamicLibrary.open('libsqlite3.so.0');
      }
    });
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TitleRepository(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TmdbTitleRepository', () {
    test('saveTitle and updateTitleMetadata', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'Title 1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );

      await repository.saveTitles([title], 'watchlist', addedOrders: [0]);

      title.overview = 'Updated overview';
      await repository.updateTitlesMetadata([title]);

      final saved = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(saved!.overview, 'Updated overview');
    });

    test('saveTitles and updateTitlesMetadata with multiple titles', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      final t2 = TmdbTitle(
        tmdbId: 2,
        name: 'T2',
        mediaType: 'tv',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );

      await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [0, 1]);

      t1.overview = 'OV1';
      t2.overview = 'OV2';
      await repository.updateTitlesMetadata([t1, t2]);

      final s1 = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      final s2 = await repository.getTitleByTmdbId('watchlist', 2, 'tv');
      expect(s1!.overview, 'OV1');
      expect(s2!.overview, 'OV2');
    });

    test('saveTitles and updateTitlesMetadata handle empty lists gracefully',
        () async {
      await repository.saveTitles([], 'watchlist');
      await repository.updateTitlesMetadata([]);
      expect(await repository.countTitles('watchlist'), 0);
    });

    test('saveTitles assigns sequential order when addedOrders is omitted',
        () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      final t2 = TmdbTitle(
        tmdbId: 2,
        name: 'T2',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );

      await repository.saveTitles([t1, t2], 'watchlist');
      final entries = await repository.getAllEntries('watchlist');
      expect(entries.length, 2);
      expect(entries[0].addedOrder, 0);
      expect(entries[1].addedOrder, 1);
    });

    test('saveTitles merges metadata when title already exists in database',
        () async {
      final initial = TmdbTitle(
        tmdbId: 10,
        name: 'Initial Name',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
        rating: 8.5,
        isPinned: true,
        notifyNewSeasons: true,
        lastNotifiedSeason: 2,
      );
      await repository.saveTitles([initial], 'rateslist', addedOrders: [0]);

      final incoming = TmdbTitle(
        tmdbId: 10,
        name: 'Updated Name',
        mediaType: 'movie',
        lastUpdated: '2026-02-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        rating: 0.0,
      );
      await repository.saveTitles([incoming], 'otherlist', addedOrders: [0]);

      final saved = await repository.getTitleGlobal(10, 'movie');
      expect(saved!.name, 'Updated Name');
      expect(saved.isPinned, isTrue);
      expect(saved.notifyNewSeasons, isTrue);
      expect(saved.lastNotifiedSeason, 2);
      expect(saved.rating, 8.5);
      expect(saved.dateRated, DateTime(2026, 1, 1));
    });

    test('deleteTitles removes multiple titles and handles empty list',
        () async {
      await repository.deleteTitles('watchlist', [], []);

      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      final t2 = TmdbTitle(
        tmdbId: 2,
        name: 'T2',
        mediaType: 'tv',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [0, 1]);

      await repository.deleteTitles('watchlist', [1, 2], ['movie', 'tv']);

      expect(
          await repository.getTitleByTmdbId('watchlist', 1, 'movie'), isNull);
      expect(await repository.getTitleByTmdbId('watchlist', 2, 'tv'), isNull);
    });

    test(
        'deleteTitles retains title in global table if referenced by another list',
        () async {
      final title = TmdbTitle(
        tmdbId: 10,
        name: 'Shared Title',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([title], 'watchlist', addedOrders: [0]);
      await repository.saveTitles([title], 'favorites', addedOrders: [0]);

      await repository.deleteTitles('watchlist', [10], ['movie']);
      expect(
          await repository.getTitleByTmdbId('watchlist', 10, 'movie'), isNull);
      expect(await repository.getTitleByTmdbId('favorites', 10, 'movie'),
          isNotNull);
      expect(await repository.getTitleGlobal(10, 'movie'), isNotNull);

      await repository.deleteTitles('favorites', [10], ['movie']);
      expect(await repository.getTitleGlobal(10, 'movie'), isNull);
    });

    test('deleteTitles cascades removal of seasons and episodes for TV series',
        () async {
      final tv = TmdbTitle(
        tmdbId: 50,
        name: 'TV Series',
        mediaType: 'tv',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([tv], 'watchlist', addedOrders: [0]);

      await repository.putSeason(TmdbSeason(
        tmdbId: 501,
        tvId: 50,
        seasonNumber: 1,
        name: 'S1',
        overview: '',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-01-01',
      ));
      await repository.putEpisode(TmdbEpisode(
        tmdbId: 5001,
        tvId: 50,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'E1',
        overview: '',
        airDate: '',
        runtime: 45,
        voteAverage: 8.0,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-01-01',
      ));

      await repository.deleteTitles('watchlist', [50], ['tv']);
      expect(await repository.getTitleGlobal(50, 'tv'), isNull);
      expect(await repository.getSeason(50, 1), isNull);
      expect(await repository.getEpisode(50, 1, 1), isNull);
    });

    test('deleteTitles cascades removal of seasons and episodes for miniseries',
        () async {
      final mini = TmdbTitle(
        tmdbId: 60,
        name: 'Miniseries Show',
        mediaType: AppConstants.miniseries,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([mini], 'watchlist', addedOrders: [0]);

      await repository.putSeason(TmdbSeason(
        tmdbId: 601,
        tvId: 60,
        seasonNumber: 1,
        name: 'S1',
        overview: '',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-01-01',
      ));
      await repository.putEpisode(TmdbEpisode(
        tmdbId: 6001,
        tvId: 60,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'E1',
        overview: '',
        airDate: '',
        runtime: 45,
        voteAverage: 8.0,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-01-01',
      ));

      await repository
          .deleteTitles('watchlist', [60], [AppConstants.miniseries]);
      expect(
          await repository.getTitleGlobal(60, AppConstants.miniseries), isNull);
      expect(await repository.getSeason(60, 1), isNull);
      expect(await repository.getEpisode(60, 1, 1), isNull);
    });

    test('clearList deletes list entries and cascades orphan TV data',
        () async {
      final sharedMovie = TmdbTitle(
        tmdbId: 1,
        name: 'Shared Movie',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      final exclusiveTv = TmdbTitle(
        tmdbId: 2,
        name: 'Exclusive TV',
        mediaType: 'tv',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );

      await repository.saveTitles([sharedMovie, exclusiveTv], 'listA',
          addedOrders: [0, 1]);
      await repository.saveTitles([sharedMovie], 'listB', addedOrders: [0]);

      await repository.putSeason(TmdbSeason(
        tmdbId: 20,
        tvId: 2,
        seasonNumber: 1,
        name: 'S1',
        overview: '',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-01-01',
      ));
      await repository.putEpisode(TmdbEpisode(
        tmdbId: 200,
        tvId: 2,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'E1',
        overview: '',
        airDate: '',
        runtime: 50,
        voteAverage: 8.0,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-01-01',
      ));

      await repository.clearList('listA');

      expect(await repository.countTitles('listA'), 0);
      expect(await repository.getAllEntries('listA'), isEmpty);

      expect(await repository.countTitles('listB'), 1);
      expect(await repository.getTitleGlobal(1, 'movie'), isNotNull);

      expect(await repository.getTitleGlobal(2, 'tv'), isNull);
      expect(await repository.getSeason(2, 1), isNull);
      expect(await repository.getEpisode(2, 1, 1), isNull);
    });

    test(
        'clearList cascades deletion of seasons and episodes when mediaType is miniseries',
        () async {
      final mini = TmdbTitle(
        tmdbId: 30,
        name: 'Miniseries Title',
        mediaType: AppConstants.miniseries,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );

      await repository.saveTitles([mini], 'watchlist', addedOrders: [0]);

      await repository.putSeason(TmdbSeason(
        tmdbId: 301,
        tvId: 30,
        seasonNumber: 1,
        name: 'S1',
        overview: '',
        airDate: '',
        voteAverage: 8.5,
        lastUpdated: '2026-01-01',
      ));
      await repository.putEpisode(TmdbEpisode(
        tmdbId: 3001,
        tvId: 30,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'E1',
        overview: '',
        airDate: '',
        runtime: 60,
        voteAverage: 8.5,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-01-01',
      ));

      await repository.clearList('watchlist');

      expect(await repository.countTitles('watchlist'), 0);
      expect(
          await repository.getTitleGlobal(30, AppConstants.miniseries), isNull);
      expect(await repository.getSeason(30, 1), isNull);
      expect(await repository.getEpisode(30, 1, 1), isNull);
    });

    test('hasRatedTitles returns true only when ratings exceed seen threshold',
        () async {
      final unrated = TmdbTitle(
        tmdbId: 1,
        name: 'Unrated',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      final seenOnly = TmdbTitle(
        tmdbId: 2,
        name: 'Seen Only',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
        rating: AppConstants.seenRating,
      );

      await repository.saveTitles([unrated, seenOnly], 'watchlist',
          addedOrders: [0, 1]);
      expect(await repository.hasRatedTitles('watchlist'), isFalse);

      final rated = TmdbTitle(
        tmdbId: 3,
        name: 'Rated Title',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
        rating: 8.0,
      );
      await repository.saveTitles([rated], 'watchlist', addedOrders: [2]);
      expect(await repository.hasRatedTitles('watchlist'), isTrue);
    });

    test('updateIsPinnedList updates multiple items', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      t1.isPinned = true;
      await repository.updateIsPinnedList([t1]);

      final s1 = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(s1!.isPinned, true);
    });

    test('updateRatingList updates multiple items', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      t1.rating = 9.0;
      await repository.updateRatingList([t1]);

      final s1 = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(s1!.rating, 9.0);
    });

    test(
        'updateNotifyNewSeasonsList updates notifyNewSeasons and lastNotifiedSeason',
        () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'tv',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      t1.notifyNewSeasons = true;
      t1.lastNotifiedSeason = 3;
      await repository.updateNotifyNewSeasonsList([t1]);
      var s1 = await repository.getTitleByTmdbId('watchlist', 1, 'tv');
      expect(s1!.notifyNewSeasons, true);
      expect(s1.lastNotifiedSeason, 3);

      t1.notifyNewSeasons = false;
      t1.lastNotifiedSeason = 0;
      await repository.updateNotifyNewSeasonsList([t1]);
      s1 = await repository.getTitleByTmdbId('watchlist', 1, 'tv');
      expect(s1!.notifyNewSeasons, false);
      expect(s1.lastNotifiedSeason, 0);
    });

    test('invalidateSeasonsAndEpisodes resets lastUpdated to epoch timestamp',
        () async {
      final s1 = TmdbSeason(
        tmdbId: 1,
        tvId: 100,
        seasonNumber: 1,
        name: 'S1',
        overview: '',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-05-01T00:00:00.000',
      );
      final s2 = TmdbSeason(
        tmdbId: 2,
        tvId: 200,
        seasonNumber: 1,
        name: 'S2',
        overview: '',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-05-01T00:00:00.000',
      );
      await repository.putSeason(s1);
      await repository.putSeason(s2);

      final ep1 = TmdbEpisode(
        tmdbId: 11,
        tvId: 100,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'Ep1',
        overview: '',
        airDate: '',
        runtime: 50,
        voteAverage: 8.0,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-05-01T00:00:00.000',
      );
      await repository.putEpisode(ep1);

      await repository.invalidateSeasonsAndEpisodes(100);

      final updatedS1 = await repository.getSeason(100, 1);
      final updatedEp1 = await repository.getEpisode(100, 1, 1);
      final untouchedS2 = await repository.getSeason(200, 1);

      final epochStr = DateTime.fromMillisecondsSinceEpoch(0).toIso8601String();
      expect(updatedS1!.lastUpdated, epochStr);
      expect(updatedEp1!.lastUpdated, epochStr);
      expect(untouchedS2!.lastUpdated, '2026-05-01T00:00:00.000');
    });

    test(
        'hasTitlesInList, countTitles, getAllTmdbIds, getAllTitlesInList, getAllEntries',
        () async {
      final t1 = TmdbTitle(
        tmdbId: 10,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [5]);

      expect(await repository.hasTitlesInList([10], 'watchlist'), isTrue);
      expect(await repository.hasTitlesInList([99], 'watchlist'), isFalse);
      expect(await repository.hasTitlesInList([], 'watchlist'), isFalse);

      expect(await repository.countTitles('watchlist'), 1);

      final ids = await repository.getAllTmdbIds('watchlist');
      expect(ids, [10]);

      final titles = await repository.getAllTitlesInList('watchlist');
      expect(titles.length, 1);
      expect(titles.first.tmdbId, 10);

      final entries = await repository.getAllEntries('watchlist');
      expect(entries.length, 1);
      expect(entries.first.tmdbId, 10);
      expect(entries.first.addedOrder, 5);
      expect(entries.first.listName, 'watchlist');
      expect(entries.first.mediaType, 'movie');
    });

    test('getMaxAddedOrder returns maximum order or -1 when empty', () async {
      expect(await repository.getMaxAddedOrder('empty_list'), -1);

      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      final t2 = TmdbTitle(
        tmdbId: 2,
        name: 'T2',
        mediaType: 'movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [3, 9]);
      expect(await repository.getMaxAddedOrder('watchlist'), 9);
    });

    test('getUninitializedTitles finds uninitialized', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: AppConstants.defaultDate,
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      final uninit = await repository.getUninitializedTitles();
      expect(uninit.length, 1);
      expect(uninit.first.tmdbId, 1);
    });

    test('getTitleByTmdbId, getTitleGlobal, and getTitlesByTmdbIds', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      final foundTitle =
          await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(foundTitle, isNotNull);

      final notFound =
          await repository.getTitleByTmdbId('watchlist', 999, 'movie');
      expect(notFound, isNull);

      final globalTitle = await repository.getTitleGlobal(1, 'movie');
      expect(globalTitle, isNotNull);
      expect(globalTitle!.name, 'T1');

      final globalNotFound = await repository.getTitleGlobal(999, 'movie');
      expect(globalNotFound, isNull);

      final multiTitles = await repository.getTitlesByTmdbIds([1]);
      expect(multiTitles.length, 1);

      final emptyTitles = await repository.getTitlesByTmdbIds([]);
      expect(emptyTitles, isEmpty);
    });

    test('Season and Episode methods with ratings and null fallbacks',
        () async {
      expect(await repository.getSeason(999, 1), isNull);
      expect(await repository.getEpisode(999, 1, 1), isNull);

      final season = TmdbSeason(
        tmdbId: 1,
        tvId: 100,
        seasonNumber: 1,
        name: 'S1',
        overview: 'Overview',
        airDate: '',
        voteAverage: 8.0,
        lastUpdated: '2026-07-14',
      );
      await repository.putSeason(season);
      final s = await repository.getSeason(100, 1);
      expect(s!.name, 'S1');

      final epUnrated = TmdbEpisode(
        tmdbId: 1,
        tvId: 100,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'Ep1',
        overview: '',
        airDate: '',
        runtime: 60,
        voteAverage: 8.0,
        lastUpdated: '2026-07-14',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final epRated = TmdbEpisode(
        tmdbId: 2,
        tvId: 100,
        seasonNumber: 1,
        episodeNumber: 2,
        name: 'Ep2',
        overview: '',
        airDate: '',
        runtime: 50,
        voteAverage: 8.5,
        rating: 9.0,
        lastUpdated: '2026-07-14',
        dateRated: DateTime(2026, 1, 1),
      );

      await repository.putEpisode(epUnrated);
      await repository.putEpisode(epRated);

      final e = await repository.getEpisode(100, 1, 1);
      expect(e!.name, 'Ep1');

      final ratedEpisodes = await repository.getRatedEpisodes();
      expect(ratedEpisodes.length, 1);
      expect(ratedEpisodes.first.tmdbId, 2);
      expect(ratedEpisodes.first.rating, 9.0);
    });

    test('getAllGenreIds', () async {
      final t1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        mediaType: 'movie',
        lastUpdated: '2026-07-14',
        dateRated: DateTime.now(),
      );
      t1.genreIds = [28, 12];
      await repository.saveTitles([t1], 'watchlist', addedOrders: [0]);

      final genresList = await repository.getAllGenreIds('watchlist');
      expect(genresList.length, 1);
      expect(genresList.first, containsAll([28, 12]));
    });

    group('Filtering and Sorting getTitles', () {
      setUp(() async {
        final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'Apple',
          originalName: 'Apple Org',
          mediaType: ApiConstants.movie,
          lastUpdated: '2026-07-14',
          dateRated: DateTime(2026, 1, 1),
        );
        t1.overview = 'An apple a day';
        t1.genreIds = [28];
        t1.rating = 8.0;
        t1.isPinned = true;
        t1.effectiveReleaseDate = '2025-01-01';
        t1.effectiveRuntime = 120;
        t1.voteAverage = 7.0;

        final t2 = TmdbTitle(
          tmdbId: 2,
          name: 'Banana',
          originalName: 'Banana Org',
          mediaType: ApiConstants.tv,
          lastUpdated: '2026-07-14',
          dateRated: DateTime(2025, 1, 1),
        );
        t2.tagline = 'Yellow fruit';
        t2.genreIds = [12, 16];
        t2.rating = AppConstants.seenRating;
        t2.notifyNewSeasons = true;
        t2.effectiveReleaseDate = '2026-01-01';
        t2.effectiveRuntime = 60;
        t2.flatrateProviderIds = [8];
        t2.voteAverage = 9.0;

        final t3 = TmdbTitle(
          tmdbId: 3,
          name: 'Chernobyl',
          originalName: 'Chernobyl Org',
          mediaType: ApiConstants.tv,
          type: TvShowType.miniseries,
          lastUpdated: '2026-07-14',
          dateRated: DateTime(2024, 1, 1),
        );
        t3.overview = 'Historical drama mini-series';
        t3.genreIds = [18];
        t3.rating = 9.5;
        t3.effectiveReleaseDate = '2019-05-06';
        t3.effectiveRuntime = 5;
        t3.voteAverage = 9.4;

        await repository.saveTitles([t1, t2, t3], 'watchlist',
            addedOrders: [0, 1, 2]);
      });

      test('Filter by text matching name, originalName, overview, or tagline',
          () async {
        final resName = await repository.getTitles(
            listName: 'watchlist', filterText: 'apple');
        expect(resName.length, 1);
        expect(resName.first.name, 'Apple');

        final resTagline = await repository.getTitles(
            listName: 'watchlist', filterText: 'Yellow');
        expect(resTagline.length, 1);
        expect(resTagline.first.name, 'Banana');

        final resOverview = await repository.getTitles(
            listName: 'watchlist', filterText: 'drama');
        expect(resOverview.length, 1);
        expect(resOverview.first.name, 'Chernobyl');

        final resOriginal = await repository.getTitles(
            listName: 'watchlist', filterText: 'Banana Org');
        expect(resOriginal.length, 1);
        expect(resOriginal.first.name, 'Banana');
      });

      test('Filter by mediaType including movies, tv shows, and miniseries',
          () async {
        final resMovie = await repository.getTitles(
            listName: 'watchlist', filterMediaType: ApiConstants.movie);
        expect(resMovie.length, 1);
        expect(resMovie.first.name, 'Apple');

        final resTv = await repository.getTitles(
            listName: 'watchlist', filterMediaType: ApiConstants.tv);
        expect(resTv.length, 2);
        expect(resTv.map((t) => t.name), containsAll(['Banana', 'Chernobyl']));

        final resMini = await repository.getTitles(
            listName: 'watchlist', filterMediaType: AppConstants.miniseries);
        expect(resMini.length, 1);
        expect(resMini.first.name, 'Chernobyl');
      });

      test('Filter by genres including exclusion', () async {
        final res = await repository
            .getTitles(listName: 'watchlist', filterGenres: [12]);
        expect(res.length, 1);
        expect(res.first.name, 'Banana');

        final resExclude = await repository.getTitles(
          listName: 'watchlist',
          filterGenres: [28],
          filterExcludeGenres: true,
        );
        expect(resExclude.map((t) => t.name), isNot(contains('Apple')));
      });

      test('Filter by providers', () async {
        final res = await repository.getTitles(
          listName: 'watchlist',
          filterByProviders: true,
          filterProvidersIds: [8],
        );
        expect(res.length, 1);
        expect(res.first.name, 'Banana');

        final resEmpty = await repository.getTitles(
          listName: 'watchlist',
          filterByProviders: true,
          filterProvidersIds: [],
        );
        expect(resEmpty.length, 0);
      });

      test('Filter by RatingFilter', () async {
        final resRated = await repository.getTitles(
          listName: 'watchlist',
          filterRating: RatingFilter.rated,
        );
        expect(
            resRated.map((t) => t.name), containsAll(['Apple', 'Chernobyl']));

        final resSeen = await repository.getTitles(
          listName: 'watchlist',
          filterRating: RatingFilter.seenOnly,
        );
        expect(resSeen.length, 1);
        expect(resSeen.first.name, 'Banana');

        final resFollowing = await repository.getTitles(
          listName: 'watchlist',
          filterRating: RatingFilter.followingOnly,
        );
        expect(resFollowing.length, 1);
        expect(resFollowing.first.name, 'Banana');
      });

      test('Filter by pinned true and false', () async {
        final resPinned =
            await repository.getTitles(listName: 'watchlist', pinned: true);
        expect(resPinned.length, 1);
        expect(resPinned.first.name, 'Apple');

        final resUnpinned =
            await repository.getTitles(listName: 'watchlist', pinned: false);
        expect(resUnpinned.map((t) => t.name),
            containsAll(['Banana', 'Chernobyl']));
      });

      test('Sorting variations ascending and descending', () async {
        // userRating
        var res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.userRating,
            sortAscending: false);
        expect(res.first.name, 'Chernobyl'); // 9.5 > 8.0 > seenRating
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.userRating,
            sortAscending: true);
        expect(res.first.name, 'Banana'); // seenRating < 8.0 < 9.5

        // releaseDate
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.releaseDate,
            sortAscending: false);
        expect(res.first.name, 'Banana'); // 2026 > 2025 > 2019
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.releaseDate,
            sortAscending: true);
        expect(res.first.name, 'Chernobyl'); // 2019 < 2025 < 2026

        // runtime
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.runtime,
            sortAscending: false);
        expect(res.first.name, 'Apple');
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.runtime,
            sortAscending: true);
        expect(res.last.name, 'Banana');

        // addedOrder
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.addedOrder,
            sortAscending: false);
        expect(res.first.name, 'Chernobyl'); // order 2
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.addedOrder,
            sortAscending: true);
        expect(res.first.name, 'Apple'); // order 0

        // dateRated
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.dateRated,
            sortAscending: false);
        expect(res.first.name, 'Apple'); // 2026 > 2025 > 2024
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.dateRated,
            sortAscending: true);
        expect(res.first.name, 'Chernobyl'); // 2024 < 2025 < 2026

        // rating (voteAverage)
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.rating,
            sortAscending: false);
        expect(res.first.name, 'Chernobyl'); // 9.4 > 9.0 > 7.0
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.rating,
            sortAscending: true);
        expect(res.first.name, 'Apple'); // 7.0 < 9.0 < 9.4

        // alphabetically
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.alphabetically,
            sortAscending: false);
        expect(res.first.name, 'Chernobyl');
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: SortOption.alphabetically,
            sortAscending: true);
        expect(res.first.name, 'Apple');
      });

      test('Pagination in getTitles', () async {
        final res = await repository.getTitles(
          listName: 'watchlist',
          offset: 1,
          limit: 1,
          sortOption: SortOption.alphabetically,
          sortAscending: true,
        );
        expect(res.length, 1);
        expect(res.first.name, 'Banana');
      });

      test('hasTitlesFiltered and countTitlesFiltered with various filters',
          () async {
        final countText = await repository.countTitlesFiltered(
            listName: 'watchlist', filterText: 'Apple');
        expect(countText, 1);
        expect(
            await repository.hasTitlesFiltered(
                listName: 'watchlist', filterText: 'Apple'),
            isTrue);
        expect(
            await repository.hasTitlesFiltered(
                listName: 'watchlist', filterText: 'Strawberry'),
            isFalse);

        final countMini = await repository.countTitlesFiltered(
          listName: 'watchlist',
          filterMediaType: AppConstants.miniseries,
        );
        expect(countMini, 1);
        expect(
          await repository.hasTitlesFiltered(
              listName: 'watchlist', filterMediaType: AppConstants.miniseries),
          isTrue,
        );

        final countSeen = await repository.countTitlesFiltered(
          listName: 'watchlist',
          filterRating: RatingFilter.seenOnly,
        );
        expect(countSeen, 1);
      });
    });
  });
}
