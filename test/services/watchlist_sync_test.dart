import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/database/app_database.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/local_database_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class MockCloudTitleRepository extends Mock implements CloudTitleRepository {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class FakeTmdbTitle extends Fake implements TmdbTitle {}

void main() {
  late AppDatabase db;
  late LocalTitleRepository localRepo;
  late MockCloudTitleRepository mockCloudRepo;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late WatchlistService watchlistService;

  Future<bool> isInLocalWatchlist(TmdbTitle title) async {
    final item = await localRepo.getTitleByTmdbId(
      AppConstants.watchlist,
      title.tmdbId,
      title.mediaType,
    );
    return item != null;
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeTmdbTitle());
    open.overrideFor(OperatingSystem.linux, () {
      try {
        return DynamicLibrary.open('libsqlite3.so');
      } catch (_) {
        return DynamicLibrary.open('libsqlite3.so.0');
      }
    });
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();

    db = AppDatabase(NativeDatabase.memory());
    await LocalDatabaseService.init(db: db);
    localRepo = LocalTitleRepository(db: db);
    LocalTitleRepository.setMockInstance(localRepo);
  });

  setUp(() async {
    await db.customStatement('DELETE FROM user_list_entries');
    await db.customStatement('DELETE FROM tmdb_titles');

    mockCloudRepo = MockCloudTitleRepository();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockUser.id).thenReturn('user-123');
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    CloudDatabaseService.init(client: mockSupabaseClient);

    watchlistService = WatchlistService(
      localRepo,
      cloudRepository: mockCloudRepo,
    );
  });

  tearDownAll(() async {
    LocalTitleRepository.resetInstance();
    await LocalDatabaseService.close();
    CloudDatabaseService.reset();
  });

  group('Watchlist Data Synchronization', () {
    test('adding title stores locally and triggers cloud upsert', () async {
      final title = TmdbTitle(
        tmdbId: 101,
        name: 'Inception',
        mediaType: ApiConstants.movie,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );

      when(() => mockCloudRepo.upsertWatchlistTitle(
            userId: any(named: 'userId'),
            title: any(named: 'title'),
          )).thenAnswer((_) async {});

      await watchlistService.updateWatchlistTitle(title, true);

      final inLocal = await isInLocalWatchlist(title);
      expect(inLocal, isTrue);

      verify(() => mockCloudRepo.upsertWatchlistTitle(
            userId: 'user-123',
            title: any(
              named: 'title',
              that: predicate<TmdbTitle>((t) => t.tmdbId == 101),
            ),
          )).called(1);
    });

    test('removing title deletes locally and triggers cloud delete', () async {
      final title = TmdbTitle(
        tmdbId: 102,
        name: 'Interstellar',
        mediaType: ApiConstants.movie,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );

      when(() => mockCloudRepo.upsertWatchlistTitle(
            userId: any(named: 'userId'),
            title: any(named: 'title'),
          )).thenAnswer((_) async {});
      when(() => mockCloudRepo.deleteWatchlistTitle(
            userId: any(named: 'userId'),
            tmdbId: any(named: 'tmdbId'),
            mediaType: any(named: 'mediaType'),
          )).thenAnswer((_) async {});

      await watchlistService.updateWatchlistTitle(title, true);
      expect(await isInLocalWatchlist(title), isTrue);

      await watchlistService.updateWatchlistTitle(title, false);
      expect(await isInLocalWatchlist(title), isFalse);

      verify(() => mockCloudRepo.deleteWatchlistTitle(
            userId: 'user-123',
            tmdbId: 102,
            mediaType: ApiConstants.movie,
          )).called(1);
    });

    test('syncFromServer resolves differences between local and cloud', () async {
      final localOnly = TmdbTitle(
        tmdbId: 201,
        name: 'Local Only Movie',
        mediaType: ApiConstants.movie,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final both = TmdbTitle(
        tmdbId: 202,
        name: 'Synced Movie',
        mediaType: ApiConstants.movie,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final cloudOnly = TmdbTitle(
        tmdbId: 203,
        name: 'Cloud Only Movie',
        mediaType: ApiConstants.movie,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );

      await localRepo.saveTitles([localOnly, both], AppConstants.watchlist);
      expect(await isInLocalWatchlist(localOnly), isTrue);
      expect(await isInLocalWatchlist(both), isTrue);

      when(() => mockCloudRepo.fetchUserTitles(
            userId: any(named: 'userId'),
            listName: AppConstants.watchlist,
            start: any(named: 'start'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [both, cloudOnly]);

      await watchlistService.syncFromServer(forceUpdate: true);

      expect(await isInLocalWatchlist(localOnly), isFalse);
      expect(await isInLocalWatchlist(both), isTrue);
      expect(await isInLocalWatchlist(cloudOnly), isTrue);
    });
  });
}
