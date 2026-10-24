import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockCloudTitleRepository extends Mock implements CloudTitleRepository {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late MockCloudTitleRepository mockCloudRepository;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late TmdbProviderService service;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() {
    mockCloudRepository = MockCloudTitleRepository();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockUser.id).thenReturn('user-123');
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockCloudRepository.updateUserProviders(any(), any()))
        .thenAnswer((_) async {});

    CloudDatabaseService.init(client: mockSupabaseClient);
    service = TmdbProviderService(cloudRepository: mockCloudRepository);
  });

  tearDown(() {
    CloudDatabaseService.reset();
  });

  group('TmdbProviderService', () {
    test('initial state is empty and uninitialized', () {
      expect(service.isInitialized, isFalse);
      expect(service.providers, isEmpty);
      expect(service.enabledProviderIds, isEmpty);
    });

    test('applyData enables specified providers and notifies listeners', () {
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'false',
      };
      service.providers[337] = {
        TmdbProvider.providerId: '337',
        TmdbProvider.providerName: 'Disney Plus',
        TmdbProvider.logoPathName: '/disney.png',
        TmdbProvider.providerEnabled: 'false',
      };

      var listenerCalled = false;
      service.addListener(() => listenerCalled = true);

      service.applyData('8');

      expect(listenerCalled, isTrue);
      expect(service.enabledProviderIds, equals([8]));
      expect(
        service.providers[8]![TmdbProvider.providerEnabled],
        equals('true'),
      );
      expect(
        service.providers[337]![TmdbProvider.providerEnabled],
        equals('false'),
      );
    });

    test('getIdsFromNames returns matching provider IDs', () {
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'false',
      };
      service.providers[119] = {
        TmdbProvider.providerId: '119',
        TmdbProvider.providerName: 'Amazon Prime',
        TmdbProvider.logoPathName: '/prime.png',
        TmdbProvider.providerEnabled: 'false',
      };

      final ids = service.getIdsFromNames(['Netflix', 'Unknown']);
      expect(ids, equals([8]));
    });

    test(
        'toggleProvider updates provider status and syncs with cloud repository',
        () async {
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'false',
      };

      when(() => mockCloudRepository.updateUserProviders('user-123', '8'))
          .thenAnswer((_) async {});

      service.toggleProvider(8, true);

      expect(service.enabledProviderIds, equals([8]));
      verify(() => mockCloudRepository.updateUserProviders('user-123', '8'))
          .called(1);
    });

    test(
        'clearProvidersStatus disables all providers and resets initialized flag',
        () {
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'true',
      };

      service.clearProvidersStatus();

      expect(service.isInitialized, isFalse);
      expect(
        service.providers[8]![TmdbProvider.providerEnabled],
        equals('false'),
      );
      expect(service.enabledProviderIds, isEmpty);
    });

    test('toggleProvider disables provider when enabled is false', () {
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'true',
      };

      service.toggleProvider(8, false);

      expect(service.enabledProviderIds, isEmpty);
      verify(() => mockCloudRepository.updateUserProviders('user-123', ''))
          .called(1);
    });

    test('toggleProvider does nothing if user is not logged in', () {
      when(() => mockAuth.currentUser).thenReturn(null);
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'false',
      };

      service.toggleProvider(8, true);

      verifyNever(() => mockCloudRepository.updateUserProviders(any(), any()));
    });

    test('fetchProviders does nothing if user is not logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      await service.fetchProviders();
      verifyNever(() => mockCloudRepository.fetchUserProviders(any()));
    });

    test('fetchProviders catches error if fetchUserProviders throws', () async {
      when(() => mockCloudRepository.fetchUserProviders('user-123'))
          .thenThrow(Exception('Network error'));

      await service.fetchProviders();
      expect(service.enabledProviderIds, isEmpty);
    });

    test('fetchProviders does nothing if remote providers string is null', () async {
      service.isInitialized = true;
      service.providers[8] = {
        TmdbProvider.providerId: '8',
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/netflix.png',
        TmdbProvider.providerEnabled: 'false',
      };

      when(() => mockCloudRepository.fetchUserProviders('user-123'))
          .thenAnswer((_) async => null);

      await service.fetchProviders();

      expect(service.enabledProviderIds, isEmpty);
    });
  });
}
