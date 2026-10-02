import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/lists/following_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;

class MockTitleRepository extends Mock implements LocalTitleRepository {}

class MockFollowingService extends Mock implements FollowingService {}

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
  late MockFollowingService mockFollowingService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late FakePostgrestFilterBuilder fakeFilterBuilder;
  late RateslistService service;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeTmdbTitle());
    registerFallbackValue(RatingFilter.all);
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() {
    mockRepository = MockTitleRepository();
    mockFollowingService = MockFollowingService();
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
    when(() => mockRepository.countTitles(AppConstants.rateslist))
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
            mockRepository.hasTitlesFiltered(listName: AppConstants.rateslist))
        .thenAnswer((_) async => false);
    when(() => mockRepository.getAllGenreIds(AppConstants.rateslist))
        .thenAnswer((_) async => []);

    CloudDatabaseService.init(client: mockSupabaseClient);
    final cloudRepository = CloudTitleRepository(client: mockSupabaseClient);

    service = RateslistService(
      mockRepository,
      cloudRepository: cloudRepository,
    );
    service.followingService = mockFollowingService;
  });

  tearDown(() {
    CloudDatabaseService.reset();
  });

  group('RateslistService - updateTitleRate', () {
    test(
        'updateTitleRate rating > 0 updates server and removes from watchlist if present',
        () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.isPinned = true;

      when(() => mockRepository.getTitleByTmdbId(
              AppConstants.watchlist, title.tmdbId, title.mediaType))
          .thenAnswer((_) async => title);
      when(() => mockRepository.deleteTitles(
              AppConstants.watchlist, [title.tmdbId], [title.mediaType]))
          .thenAnswer((_) async {});
      when(() => mockRepository.saveTitles([title], AppConstants.rateslist,
          addedOrders: any(named: 'addedOrders'))).thenAnswer((_) async {});
      when(() => mockRepository.getMaxAddedOrder(AppConstants.rateslist))
          .thenAnswer((_) async => 0);
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);
      when(() => mockRepository.updateRatingList([title]))
          .thenAnswer((_) async {});
      when(() => mockRepository.updateIsPinnedList([title]))
          .thenAnswer((_) async {});
      when(() => mockRepository.updateNotifyNewSeasonsList([title]))
          .thenAnswer((_) async {});

      await service.updateTitleRate(title, 8.0);

      expect(title.rating, 8.0);
      expect(title.isPinned, false);

      verify(() => mockRepository.deleteTitles(
          AppConstants.watchlist, [title.tmdbId], [title.mediaType])).called(1);
      verify(() => mockRepository.saveTitles([title], AppConstants.rateslist,
          addedOrders: any(named: 'addedOrders'))).called(1);
      verify(() => mockRepository.updateRatingList([title])).called(1);
      verify(() => mockQueryBuilder.upsert(any(),
          onConflict: any(named: 'onConflict'))).called(1);
    });

    test(
        'updateTitleRate rating == 0 deletes from server and cleans following config',
        () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.tv,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.notifyNewSeasons = true;
      title.rating = 8.0;

      when(() => mockFollowingService.removeFollowingFromServer(title))
          .thenAnswer((_) async => true);
      when(() => mockRepository.deleteTitles(
              AppConstants.rateslist, [title.tmdbId], [title.mediaType]))
          .thenAnswer((_) async {});
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);

      await service.updateTitleRate(title, 0.0);

      expect(title.rating, 0.0);
      expect(title.notifyNewSeasons, false);

      verify(() => mockFollowingService.removeFollowingFromServer(title))
          .called(1);
      verify(() => mockRepository.deleteTitles(
          AppConstants.rateslist, [title.tmdbId], [title.mediaType])).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('updateTitleRate does nothing if user is not logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.movie,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );

      await service.updateTitleRate(title, 8.0);

      verifyNever(() => mockRepository.saveTitles(any(), any(),
          addedOrders: any(named: 'addedOrders')));
      verifyNever(() =>
          mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict')));
    });
  });

  group('RateslistService - toggleNotify', () {
    test('toggleNotify adds following if not following', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.tv,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.notifyNewSeasons = false;

      when(() => mockRepository.updateNotifyNewSeasonsList([title]))
          .thenAnswer((_) async {});
      when(() => mockFollowingService.addFollowingToServer(title))
          .thenAnswer((_) async => true);

      await service.toggleNotify(title);

      expect(title.notifyNewSeasons, true);
      verify(() => mockFollowingService.addFollowingToServer(title)).called(1);
      verify(() => mockRepository.updateNotifyNewSeasonsList([title]))
          .called(1);
    });

    test('toggleNotify removes following if already following', () async {
      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.tv,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.notifyNewSeasons = true;

      when(() => mockRepository.updateNotifyNewSeasonsList([title]))
          .thenAnswer((_) async {});
      when(() => mockFollowingService.removeFollowingFromServer(title))
          .thenAnswer((_) async => true);

      await service.toggleNotify(title);

      expect(title.notifyNewSeasons, false);
      verify(() => mockFollowingService.removeFollowingFromServer(title))
          .called(1);
      verify(() => mockRepository.updateNotifyNewSeasonsList([title]))
          .called(1);
    });

    test('toggleNotify does nothing if user is not logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final title = TmdbTitle(
        tmdbId: 1,
        mediaType: ApiConstants.tv,
        name: 'Test',
        lastUpdated: DateTime.now().toIso8601String(),
        dateRated: DateTime.now(),
      );
      title.notifyNewSeasons = false;

      await service.toggleNotify(title);

      expect(title.notifyNewSeasons, false);
      verifyNever(() => mockFollowingService.addFollowingToServer(title));
      verifyNever(() => mockRepository.updateNotifyNewSeasonsList([title]));
    });
  });
}
