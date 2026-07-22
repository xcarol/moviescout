import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_watchlist_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart'
    show RatingFilter;

class MockTmdbTitleRepository extends Mock implements TmdbTitleRepository {}

class MockTmdbPinnedService extends Mock implements TmdbPinnedService {}

class TestTmdbWatchlistService extends TmdbWatchlistService {
  TestTmdbWatchlistService(super.listName, super.repository);

  http.Response? mockGetResponse;
  http.Response? mockPostResponse;

  @override
  Future<dynamic> get(String query,
      {ApiVersion version = ApiVersion.v3, String accessToken = ''}) async {
    if (mockGetResponse != null) {
      return mockGetResponse!;
    }
    return http.Response('{"results": []}', 200);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> bodyParam,
      {ApiVersion version = ApiVersion.v3, String accessToken = ''}) async {
    if (mockPostResponse != null) {
      return mockPostResponse!;
    }
    return http.Response('{}', 200);
  }
}

class FakeTmdbTitle extends Fake implements TmdbTitle {}

void main() {
  late MockTmdbTitleRepository mockRepository;
  late MockTmdbPinnedService mockPinnedService;
  late TestTmdbWatchlistService service;

  setUpAll(() async {
    registerFallbackValue(FakeTmdbTitle());
    registerFallbackValue(RatingFilter.all);
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() {
    mockRepository = MockTmdbTitleRepository();
    mockPinnedService = MockTmdbPinnedService();

    // Stub basic repository methods
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
    when(() => mockRepository.countTitlesSync(AppConstants.watchlist))
        .thenReturn(0);
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

    service = TestTmdbWatchlistService(AppConstants.watchlist, mockRepository);
    service.pinnedService = mockPinnedService;
  });

  group('TmdbWatchlistService', () {
    test('updateWatchlistTitle add=true posts to TMDB and updates locally',
        () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = true;

      when(() => mockRepository.saveTitle(title, AppConstants.watchlist, any()))
          .thenAnswer((_) async {});
      when(() => mockRepository.getMaxAddedOrder(AppConstants.watchlist))
          .thenAnswer((_) async => 0);
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);
      when(() => mockRepository.updateIsPinned(title)).thenAnswer((_) async {});

      await service.updateWatchlistTitle('accountId', 'sessionId', title, true);

      expect(title.isPinned, false); // add forces isPinned to false
      verify(() =>
              mockRepository.saveTitle(title, AppConstants.watchlist, any()))
          .called(1);
    });

    test(
        'updateWatchlistTitle add=false deletes from TMDB and unpins if needed',
        () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = true;
      title.inLists = [AppConstants.watchlist];

      when(() => mockPinnedService.removePinnedFromServer(title))
          .thenAnswer((_) async => true);
      when(() => mockRepository.deleteTitle(
              AppConstants.watchlist, title.tmdbId, title.mediaType))
          .thenAnswer((_) async {});
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);

      await service.updateWatchlistTitle(
          'accountId', 'sessionId', title, false);

      expect(title.isPinned, false);
      verify(() => mockPinnedService.removePinnedFromServer(title)).called(1);
      verify(() => mockRepository.deleteTitle(
          AppConstants.watchlist, title.tmdbId, title.mediaType)).called(1);
    });

    test('togglePin adds pin if not pinned and limit not reached', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = false;

      when(() => mockRepository.countTitlesFiltered(
          listName: AppConstants.watchlist,
          pinned: true)).thenAnswer((_) async => 0);
      when(() => mockRepository.updateIsPinned(title)).thenAnswer((_) async {});
      when(() => mockPinnedService.addPinnedToServer(title))
          .thenAnswer((_) async => true);

      await service.togglePin(title);

      expect(title.isPinned, true);
      verify(() => mockPinnedService.addPinnedToServer(title)).called(1);
      verify(() => mockRepository.updateIsPinned(title)).called(1);
    });

    test('togglePin aborts if pin limit is reached', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = false;

      when(() => mockRepository.countTitlesFiltered(
          listName: AppConstants.watchlist,
          pinned: true)).thenAnswer((_) async => 5);

      await service.togglePin(title, limitReachedMessage: 'Limit');

      expect(title.isPinned, false); // did not change
      verifyNever(() => mockPinnedService.addPinnedToServer(title));
      verifyNever(() => mockRepository.updateIsPinned(title));
    });

    test('togglePin removes pin if already pinned', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = true;

      when(() => mockRepository.updateIsPinned(title)).thenAnswer((_) async {});
      when(() => mockPinnedService.removePinnedFromServer(title))
          .thenAnswer((_) async => true);

      await service.togglePin(title);

      expect(title.isPinned, false);
      verify(() => mockPinnedService.removePinnedFromServer(title)).called(1);
      verify(() => mockRepository.updateIsPinned(title)).called(1);
    });
  });
}
