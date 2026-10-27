import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });
  group('CloudDatabaseService', () {
    late MockSupabaseClient mockClient;
    late MockGoTrueClient mockAuth;
    late MockUser mockUser;
    late MockSession mockSession;

    setUp(() {
      mockClient = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      mockUser = MockUser();
      mockSession = MockSession();

      when(() => mockClient.auth).thenReturn(mockAuth);
    });

    tearDown(() {
      CloudDatabaseService.reset();
    });

    test('init with client sets instance', () {
      CloudDatabaseService.init(client: mockClient);
      expect(CloudDatabaseService.instance, equals(mockClient));
    });

    test('currentUser returns user when logged in', () {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      CloudDatabaseService.init(client: mockClient);

      expect(CloudDatabaseService.currentUser, equals(mockUser));
      expect(CloudDatabaseService.isLoggedIn, isTrue);
    });

    test('currentUser returns null and isLoggedIn is false when logged out',
        () {
      when(() => mockAuth.currentUser).thenReturn(null);
      CloudDatabaseService.init(client: mockClient);

      expect(CloudDatabaseService.currentUser, isNull);
      expect(CloudDatabaseService.isLoggedIn, isFalse);
    });

    test('currentSession returns session when active', () {
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      CloudDatabaseService.init(client: mockClient);

      expect(CloudDatabaseService.currentSession, equals(mockSession));
    });

    test('reset clears the client instance', () {
      CloudDatabaseService.init(client: mockClient);
      expect(CloudDatabaseService.instance, equals(mockClient));

      CloudDatabaseService.reset();
      expect(
        () => CloudDatabaseService.instance,
        throwsA(isA<AssertionError>()),
      );
    });

    test('retryOnFutureJwt returns result on first success', () async {
      int calls = 0;
      final result = await CloudDatabaseService.retryOnFutureJwt(() async {
        calls++;
        return 'success';
      });

      expect(result, 'success');
      expect(calls, 1);
    });

    test('retryOnFutureJwt retries and succeeds when code is PGRST303', () {
      fakeAsync((async) {
        int calls = 0;
        String? result;

        CloudDatabaseService.retryOnFutureJwt(() async {
          calls++;
          if (calls == 1) {
            throw const PostgrestException(
              message: 'JWT error',
              code: 'PGRST303',
            );
          }
          return 'retry-success';
        }, maxAttempts: 3)
            .then((val) => result = val);

        async.elapse(const Duration(seconds: 2));
        expect(calls, 2);
        expect(result, 'retry-success');
      });
    });

    test('retryOnFutureJwt retries when message contains JWT issued at future',
        () {
      fakeAsync((async) {
        int calls = 0;
        String? result;

        CloudDatabaseService.retryOnFutureJwt(() async {
          calls++;
          if (calls == 1) {
            throw const PostgrestException(
              message: 'JWT issued at future date',
            );
          }
          return 'jwt-future-success';
        }, maxAttempts: 3)
            .then((val) => result = val);

        async.elapse(const Duration(seconds: 2));
        expect(calls, 2);
        expect(result, 'jwt-future-success');
      });
    });

    test('retryOnFutureJwt rethrows and stops when maxAttempts exhausted', () {
      fakeAsync((async) {
        int calls = 0;
        Object? thrownError;

        CloudDatabaseService.retryOnFutureJwt<void>(() async {
          calls++;
          throw const PostgrestException(
            message: 'JWT error',
            code: 'PGRST303',
          );
        }, maxAttempts: 2)
            .catchError((err) {
          thrownError = err;
        });

        async.elapse(const Duration(seconds: 5));
        expect(calls, 2);
        expect(thrownError, isA<PostgrestException>());
      });
    });

    test('retryOnFutureJwt rethrows immediately for non-JWT PostgrestException',
        () async {
      int calls = 0;
      expect(
        () => CloudDatabaseService.retryOnFutureJwt(() async {
          calls++;
          throw const PostgrestException(
            message: 'Row not found',
            code: 'PGRST116',
          );
        }, maxAttempts: 3),
        throwsA(isA<PostgrestException>()),
      );
      expect(calls, 1);
    });

    test('retryOnFutureJwt rethrows non-PostgrestException immediately',
        () async {
      int calls = 0;
      expect(
        () => CloudDatabaseService.retryOnFutureJwt(() async {
          calls++;
          throw Exception('network failure');
        }),
        throwsA(isA<Exception>()),
      );
      expect(calls, 1);
    });
  });
}
