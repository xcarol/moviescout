import 'package:flutter_test/flutter_test.dart';
import 'package:realm/realm.dart';
import 'package:moviescout/database/realm_models.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;

void main() {
  late Realm realm;
  late TmdbTitleRepository repository;

  setUp(() {
    final config = Configuration.inMemory(
      [
        UserListEntryRealm.schema,
        TmdbTitleRealm.schema,
        TmdbSeasonRealm.schema,
        TmdbEpisodeRealm.schema,
      ],
    );
    realm = Realm(config);
    repository = TmdbTitleRepository(realm: realm);
  });

  tearDown(() {
    realm.close();
  });

  group('TmdbTitleRepository', () {
    test('saveTitle and updateTitleMetadata', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          name: 'Title 1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());

      await repository.saveTitle(title, 'watchlist', 0);

      title.overview = 'Updated overview';
      await repository.updateTitleMetadata(title);

      final saved = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(saved!.overview, 'Updated overview');
    });

    test('saveTitles and updateTitlesMetadata', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      final t2 = TmdbTitle(
          tmdbId: 2,
          name: 'T2',
          mediaType: 'tv',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());

      await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [0, 1]);

      t1.overview = 'OV1';
      t2.overview = 'OV2';
      await repository.updateTitlesMetadata([t1, t2]);

      final s1 = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      final s2 = await repository.getTitleByTmdbId('watchlist', 2, 'tv');
      expect(s1!.overview, 'OV1');
      expect(s2!.overview, 'OV2');
    });

    test('deleteTitles removes multiple titles', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      final t2 = TmdbTitle(
          tmdbId: 2,
          name: 'T2',
          mediaType: 'tv',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [0, 1]);

      await repository.deleteTitles('watchlist', [1, 2], ['movie', 'tv']);

      expect(
          await repository.getTitleByTmdbId('watchlist', 1, 'movie'), isNull);
      expect(await repository.getTitleByTmdbId('watchlist', 2, 'tv'), isNull);
    });

    test('updateIsPinnedList updates multiple items', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

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
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

      t1.rating = 9.0;
      await repository.updateRatingList([t1]);

      final s1 = await repository.getTitleByTmdbId('watchlist', 1, 'movie');
      expect(s1!.rating, 9.0);
    });

    test('updateNotifyNewSeasons updates individual and list', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'tv',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

      t1.notifyNewSeasons = true;
      await repository.updateNotifyNewSeasons(t1);
      var s1 = await repository.getTitleByTmdbId('watchlist', 1, 'tv');
      expect(s1!.notifyNewSeasons, true);

      t1.notifyNewSeasons = false;
      await repository.updateNotifyNewSeasonsList([t1]);
      s1 = await repository.getTitleByTmdbId('watchlist', 1, 'tv');
      expect(s1!.notifyNewSeasons, false);
    });

    test('hasTitlesInList, countTitlesSync, getAllTmdbIds, getAllTitlesInList',
        () async {
      final t1 = TmdbTitle(
          tmdbId: 10,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

      expect(await repository.hasTitlesInList([10], 'watchlist'), isTrue);
      expect(await repository.hasTitlesInList([99], 'watchlist'), isFalse);

      expect(repository.countTitlesSync('watchlist'), 1);

      final ids = await repository.getAllTmdbIds('watchlist');
      expect(ids, [10]);

      final titles = await repository.getAllTitlesInList('watchlist');
      expect(titles.length, 1);
      expect(titles.first.tmdbId, 10);
    });

    test('getUninitializedTitles finds uninitialized', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: AppConstants.defaultDate,
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

      final uninit = await repository.getUninitializedTitles();
      expect(uninit.length, 1);
      expect(uninit.first.tmdbId, 1);
    });

    test('getTitleByTmdbIdSync and getTitlesByTmdbIds', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      await repository.saveTitle(t1, 'watchlist', 0);

      final syncTitle =
          repository.getTitleByTmdbIdSync('watchlist', 1, 'movie');
      expect(syncTitle, isNotNull);

      final multiTitles = await repository.getTitlesByTmdbIds([1]);
      expect(multiTitles.length, 1);
    });

    test('Season and Episode methods', () async {
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

      final episode = TmdbEpisode(
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
      );
      await repository.putEpisode(episode);
      final e = await repository.getEpisode(100, 1, 1);
      expect(e!.name, 'Ep1');
    });

    test('getAllGenreIds', () async {
      final t1 = TmdbTitle(
          tmdbId: 1,
          name: 'T1',
          mediaType: 'movie',
          lastUpdated: '2026-07-14',
          dateRated: DateTime.now());
      t1.genreIds = [28, 12];
      await repository.saveTitle(t1, 'watchlist', 0);

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
            mediaType: 'movie',
            lastUpdated: '2026-07-14',
            dateRated: DateTime(2026, 1, 1));
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
            mediaType: 'tv',
            lastUpdated: '2026-07-14',
            dateRated: DateTime(2025, 1, 1));
        t2.tagline = 'Yellow fruit';
        t2.genreIds = [12, 16];
        t2.rating = AppConstants.seenRating; // Seen but not rated
        t2.notifyNewSeasons = true;
        t2.effectiveReleaseDate = '2026-01-01';
        t2.effectiveRuntime = 60;
        t2.flatrateProviderIds = [8]; // Netflix
        t2.voteAverage = 9.0;

        await repository.saveTitles([t1, t2], 'watchlist', addedOrders: [0, 1]);
      });

      test('Filter by text', () async {
        final res = await repository.getTitles(
            listName: 'watchlist', filterText: 'apple');
        expect(res.length, 1);
        expect(res.first.name, 'Apple');

        final res2 = await repository.getTitles(
            listName: 'watchlist', filterText: 'Yellow');
        expect(res2.length, 1);
        expect(res2.first.name, 'Banana');
      });

      test('Filter by genres', () async {
        final res = await repository
            .getTitles(listName: 'watchlist', filterGenres: [12]);
        expect(res.length, 1);
        expect(res.first.name, 'Banana');

        final res2 = await repository.getTitles(
            listName: 'watchlist',
            filterGenres: [28],
            filterExcludeGenres: true);
        expect(res2.length, 1);
        expect(res2.first.name, 'Banana'); // Excludes Apple
      });

      test('Filter by providers', () async {
        final res = await repository.getTitles(
            listName: 'watchlist',
            filterByProviders: true,
            filterProvidersIds: [8]);
        expect(res.length, 1);
        expect(res.first.name, 'Banana');

        final resEmpty = await repository.getTitles(
            listName: 'watchlist',
            filterByProviders: true,
            filterProvidersIds: []);
        expect(resEmpty.length, 0);
      });

      test('Filter by RatingFilter', () async {
        final resRated = await repository.getTitles(
            listName: 'watchlist', filterRating: RatingFilter.rated);
        expect(resRated.length, 1);
        expect(resRated.first.name, 'Apple');

        final resSeen = await repository.getTitles(
            listName: 'watchlist', filterRating: RatingFilter.seenOnly);
        expect(resSeen.length, 1);
        expect(resSeen.first.name, 'Banana');

        final resFollowing = await repository.getTitles(
            listName: 'watchlist', filterRating: RatingFilter.followingOnly);
        expect(resFollowing.length, 1);
        expect(resFollowing.first.name, 'Banana');
      });

      test('Filter by pinned', () async {
        final res =
            await repository.getTitles(listName: 'watchlist', pinned: true);
        expect(res.length, 1);
        expect(res.first.name, 'Apple');
      });

      test('Sorting variations', () async {
        // userRating
        var res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: 'userRating',
            sortAscending: false);
        expect(res.first.name, 'Apple'); // 8.0 > seenRating

        // releaseDate
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: 'releaseDate',
            sortAscending: false);
        expect(res.first.name, 'Banana'); // 2026 > 2025

        // runtime
        res = await repository.getTitles(
            listName: 'watchlist', sortOption: 'runtime', sortAscending: false);
        expect(res.first.name, 'Apple'); // 120 > 60

        // addedOrder
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: 'addedOrder',
            sortAscending: false);
        expect(res.first.name, 'Banana'); // order 1 > order 0

        // dateRated
        res = await repository.getTitles(
            listName: 'watchlist',
            sortOption: 'dateRated',
            sortAscending: false);
        expect(res.first.name, 'Apple'); // 2026 > 2025

        // rating (voteAverage)
        res = await repository.getTitles(
            listName: 'watchlist', sortOption: 'rating', sortAscending: false);
        expect(res.first.name, 'Banana'); // 9.0 > 7.0
      });

      test('Pagination in getTitles', () async {
        final res = await repository.getTitles(
            listName: 'watchlist', offset: 1, limit: 1);
        expect(res.length, 1);
        // Alphabetically ascending: Apple (0), Banana (1)
        expect(res.first.name, 'Banana');
      });

      test('hasTitlesFiltered and countTitlesFiltered', () async {
        final count = await repository.countTitlesFiltered(
            listName: 'watchlist', filterText: 'Apple');
        expect(count, 1);

        final has = await repository.hasTitlesFiltered(
            listName: 'watchlist', filterText: 'Apple');
        expect(has, isTrue);

        final hasNot = await repository.hasTitlesFiltered(
            listName: 'watchlist', filterText: 'Strawberry');
        expect(hasNot, isFalse);
      });
    });
  });
}
