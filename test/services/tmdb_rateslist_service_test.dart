import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_following_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/tmdb_base_list_service.dart'
    show RatingFilter;

class MockTmdbTitleRepository extends Mock implements TmdbTitleRepository {}

class MockTmdbFollowingService extends Mock implements TmdbFollowingService {}

class TestTmdbRateslistService extends TmdbRateslistService {
  TestTmdbRateslistService(super.listName, super.repository);

  http.Response? mockGetResponse;
  http.Response? mockPostResponse;
  http.Response? mockDeleteResponse;

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

  @override
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? body,
      ApiVersion version = ApiVersion.v3,
      String accessToken = ''}) async {
    if (mockDeleteResponse != null) {
      return mockDeleteResponse!;
    }
    return http.Response('{}', 200);
  }
}

class FakeTmdbTitle extends Fake implements TmdbTitle {}

void main() {
  late MockTmdbTitleRepository mockRepository;
  late MockTmdbFollowingService mockFollowingService;
  late TestTmdbRateslistService service;

  setUpAll(() async {
    registerFallbackValue(FakeTmdbTitle());
    registerFallbackValue(RatingFilter.all);
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() {
    mockRepository = MockTmdbTitleRepository();
    mockFollowingService = MockTmdbFollowingService();

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
    when(() => mockRepository.countTitlesSync(AppConstants.rateslist))
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
            mockRepository.hasTitlesFiltered(listName: AppConstants.rateslist))
        .thenAnswer((_) async => false);
    when(() => mockRepository.getAllGenreIds(AppConstants.rateslist))
        .thenAnswer((_) async => []);

    service = TestTmdbRateslistService(AppConstants.rateslist, mockRepository);
    service.followingService = mockFollowingService;
  });

  group('TmdbRateslistService', () {
    test(
        'updateTitleRate rating > 0 updates server and removes from watchlist if present',
        () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.movie,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.isPinned = true;
      title.inLists = [AppConstants.watchlist];

      when(() => mockRepository.getTitleByTmdbId(
              AppConstants.watchlist, title.tmdbId, title.mediaType))
          .thenAnswer((_) async => title); // Exists in watchlist
      when(() => mockRepository.deleteTitle(
              AppConstants.watchlist, title.tmdbId, title.mediaType))
          .thenAnswer((_) async {});
      when(() => mockRepository.saveTitle(title, AppConstants.rateslist, any()))
          .thenAnswer((_) async {});
      when(() => mockRepository.getMaxAddedOrder(AppConstants.rateslist))
          .thenAnswer((_) async => 0);
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);
      when(() => mockRepository.updateRating(title)).thenAnswer((_) async {});
      when(() => mockRepository.updateIsPinned(title)).thenAnswer((_) async {});
      when(() => mockRepository.updateNotifyNewSeasons(title))
          .thenAnswer((_) async {});

      await service.updateTitleRate('accountId', 'sessionId', title, 8.0);

      expect(title.rating, 8.0);
      expect(title.isPinned, false);
      expect(title.inLists.contains(AppConstants.watchlist), false);

      verify(() => mockRepository.deleteTitle(
          AppConstants.watchlist, title.tmdbId, title.mediaType)).called(1);
      verify(() =>
              mockRepository.saveTitle(title, AppConstants.rateslist, any()))
          .called(1);
      verify(() => mockRepository.updateRating(title)).called(1);
    });

    test(
        'updateTitleRate rating == 0 deletes from server and cleans following config',
        () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.tv,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.notifyNewSeasons = true;
      title.rating = 8.0;
      title.inLists = [AppConstants.rateslist];

      when(() => mockFollowingService.removeFollowingFromServer(title))
          .thenAnswer((_) async => true);
      when(() => mockRepository.deleteTitle(
              AppConstants.rateslist, title.tmdbId, title.mediaType))
          .thenAnswer((_) async {});
      when(() => mockRepository.getTitleGlobal(title.tmdbId, title.mediaType))
          .thenAnswer((_) async => null);

      await service.updateTitleRate('accountId', 'sessionId', title, 0.0);

      expect(title.rating, 0.0);
      expect(title.notifyNewSeasons, false);

      verify(() => mockFollowingService.removeFollowingFromServer(title))
          .called(1);
      verify(() => mockRepository.deleteTitle(
          AppConstants.rateslist, title.tmdbId, title.mediaType)).called(1);
    });

    test('toggleNotify adds following if not following', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.tv,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.notifyNewSeasons = false;

      when(() => mockRepository.updateNotifyNewSeasons(title))
          .thenAnswer((_) async {});
      when(() => mockFollowingService.addFollowingToServer(title))
          .thenAnswer((_) async => true);

      await service.toggleNotify(title);

      expect(title.notifyNewSeasons, true);
      verify(() => mockFollowingService.addFollowingToServer(title)).called(1);
      verify(() => mockRepository.updateNotifyNewSeasons(title)).called(1);
    });

    test('toggleNotify removes following if already following', () async {
      final title = TmdbTitle(
          tmdbId: 1,
          mediaType: ApiConstants.tv,
          name: 'Test',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now());
      title.notifyNewSeasons = true;

      when(() => mockRepository.updateNotifyNewSeasons(title))
          .thenAnswer((_) async {});
      when(() => mockFollowingService.removeFollowingFromServer(title))
          .thenAnswer((_) async => true);

      await service.toggleNotify(title);

      expect(title.notifyNewSeasons, false);
      verify(() => mockFollowingService.removeFollowingFromServer(title))
          .called(1);
      verify(() => mockRepository.updateNotifyNewSeasons(title)).called(1);
    });
  });
}
