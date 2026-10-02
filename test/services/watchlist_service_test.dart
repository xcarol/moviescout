import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/lists/pinned_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;

class MockTitleRepository extends Mock implements LocalTitleRepository {}

class MockPinnedService extends Mock implements PinnedService {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  final Future<dynamic> _future = Future.value(<Map<String, dynamic>>[]);

  @override
  PostgrestFilterBuilder<dynamic> eq(String column, Object value) => this;

  @override
  Future<R> then<R>(FutureOr<R> Function(dynamic value) onValue,
      {Function? onError}) {
    return _future.then(onValue, onError: onError);
  }

  @override
  Future<dynamic> catchError(Function onError,
      {bool Function(Object error)? test}) {
    return _future.catchError(onError, test: test);
  }

  @override
  Future<dynamic> whenComplete(FutureOr<void> Function() action) {
    return _future.whenComplete(action);
  }
}

class FakeTmdbTitle extends Fake implements TmdbTitle {}

void main() {
  late MockTitleRepository mockRepository;
  late MockPinnedService mockPinnedService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late FakePostgrestFilterBuilder fakeFilterBuilder;
  late WatchlistService service;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeTmdbTitle());
    registerFallbackValue(RatingFilter.all);
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() {
    mockRepository = MockTitleRepository();
    mockPinnedService = MockPinnedService();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    fakeFilterBuilder = FakePostgrestFilterBuilder();

    when(() => mockUser.id).thenReturn('test-user-id');
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);

    when(() => mockSupabaseClient.from(any()))
        .thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.upsert(any(),
            onConflict: any(named: 'onConflict')))
        .thenAnswer((_) => fakeFilterBuilder);
    when(() => mockQueryBuilder.delete()).thenAnswer((_) => fakeFilterBuilder);

    when(() => mockRepository.countTitlesFiltered(
          listName: any(named: 'listName'),
          filterText: any(named: 'filterText'),
          filterMediaType: any(named: 'filterMediaType'),
          filterGenres: any(named: 'filterGenres'),
          filterExcludeGenres: any(named: 'filterExcludeGenres'),
          filterByProviders: any(named: 'filterByProviders'),
          filterProvidersIds: any(named: 'filterProvidersIds'),
          filterRating: any(named: 'filterRating'),
          pinned: any(named: 'pinned'),
        )).thenAnswer((_) async => 0);
    when(() => mockRepository.countTitles(AppConstants.watchlist))
        .thenAnswer((_) async => 0);
    when(() => mockRepository.getTitles(
          listName: any(named: 'listName'),
          filterText: any(named: 'filterText'),
          filterMediaType: any(named: 'filterMediaType'),
          filterGenres: any(named: 'filterGenres'),
          filterExcludeGenres: any(named: 'filterExcludeGenres'),
          filterByProviders: any(named: 'filterByProviders'),
          filterProvidersIds: any(named: 'filterProvidersIds'),
          filterRating: any(named: 'filterRating'),
          pinned: any(named: 'pinned'),
          sortOption: any(named: 'sortOption'),
          sortAscending: any(named: 'sortAscending'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer((_) async => <TmdbTitle>[]);
    when(() => mockRepository.hasRatedTitles(any()))
        .thenAnswer((_) async => false);
    when(() =>
            mockRepository.hasTitlesFiltered(listName: AppConstants.watchlist))
        .thenAnswer((_) async => false);
    when(() => mockRepository.getAllGenreIds(AppConstants.watchlist))
        .thenAnswer((_) async => []);

    CloudDatabaseService.init(client: mockSupabaseClient);
    final cloudRepository = CloudTitleRepository(client: mockSupabaseClient);

    service = WatchlistService(
      mockRepository,
      cloudRepository: cloudRepository,
    );
    service.pinnedService = mockPinnedService;
  });

  tearDown(() {
    CloudDatabaseService.reset();
  });

  group('WatchlistService - updateWatchlistTitle', () {
    test('updateWatchlistTitle add=true upserts to Supabase and saves locally',
        () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = true;

      when(() => mockRepository.getMaxAddedOrder(AppConstants.watchlist))
          .thenAnswer((_) async => 0);
      when(() => mockRepository.saveTitles([title], AppConstants.watchlist,
          addedOrders: any(named: 'addedOrders'))).thenAnswer((_) async {});
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);
      when(() => mockRepository.updateIsPinnedList([title]))
          .thenAnswer((_) async {});

      await service.updateWatchlistTitle(title, true);

      expect(title.isPinned, false);
      verify(() => mockRepository.saveTitles([title], AppConstants.watchlist,
          addedOrders: any(named: 'addedOrders'))).called(1);
      verify(() => mockRepository.updateIsPinnedList([title])).called(1);
      verify(() => mockQueryBuilder.upsert(any(),
          onConflict: any(named: 'onConflict'))).called(1);
    });

    test(
        'updateWatchlistTitle add=false deletes from Supabase and unpins if needed',
        () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = true;

      when(() => mockPinnedService.removePinnedFromServer(title))
          .thenAnswer((_) async => true);
      when(() => mockRepository.deleteTitles(
              AppConstants.watchlist, [title.tmdbId], [title.mediaType]))
          .thenAnswer((_) async {});
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);

      await service.updateWatchlistTitle(title, false);

      expect(title.isPinned, false);
      verify(() => mockPinnedService.removePinnedFromServer(title)).called(1);
      verify(() => mockRepository.deleteTitles(
          AppConstants.watchlist, [title.tmdbId], [title.mediaType])).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('updateWatchlistTitle does nothing if user is not logged in',
        () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );

      await service.updateWatchlistTitle(title, true);

      verifyNever(() => mockRepository.saveTitles(any(), any(),
          addedOrders: any(named: 'addedOrders')));
      verifyNever(() =>
          mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict')));
    });
  });

  group('WatchlistService - Pin logic', () {
    test('togglePin adds pin if not pinned and limit not reached', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = false;

      when(() => mockRepository.countTitlesFiltered(
            listName: AppConstants.watchlist,
            pinned: true,
          )).thenAnswer((_) async => 0);
      when(() => mockRepository.updateIsPinnedList([title]))
          .thenAnswer((_) async {});
      when(() => mockPinnedService.addPinnedToServer(title))
          .thenAnswer((_) async => true);

      await service.togglePin(title);

      expect(title.isPinned, true);
      verify(() => mockPinnedService.addPinnedToServer(title)).called(1);
      verify(() => mockRepository.updateIsPinnedList([title])).called(1);
    });

    test('togglePin aborts if pin limit is reached (5 titles)', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = false;

      when(() => mockRepository.countTitlesFiltered(
            listName: AppConstants.watchlist,
            pinned: true,
          )).thenAnswer((_) async => 5);

      await service.togglePin(title, limitReachedMessage: 'Limit reached');

      expect(title.isPinned, false);
      verifyNever(() => mockPinnedService.addPinnedToServer(title));
      verifyNever(() => mockRepository.updateIsPinnedList([title]));
    });

    test('togglePin removes pin if already pinned', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = true;

      when(() => mockRepository.updateIsPinnedList([title]))
          .thenAnswer((_) async {});
      when(() => mockPinnedService.removePinnedFromServer(title))
          .thenAnswer((_) async => true);

      await service.togglePin(title);

      expect(title.isPinned, false);
      verify(() => mockPinnedService.removePinnedFromServer(title)).called(1);
      verify(() => mockRepository.updateIsPinnedList([title])).called(1);
    });

    test('togglePin does nothing if user is not logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = false;

      await service.togglePin(title);

      expect(title.isPinned, false);
      verifyNever(() => mockRepository.countTitlesFiltered(
            listName: any(named: 'listName'),
            pinned: any(named: 'pinned'),
          ));
    });
  });
}
