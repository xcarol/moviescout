import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

void main() {
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
  });
}
