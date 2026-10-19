import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';

class CloudDatabaseService {
  static SupabaseClient? _client;

  static void init({SupabaseClient? client}) {
    if (client != null) {
      _client = client;
      return;
    }
    _client = Supabase.instance.client;
  }

  static SupabaseClient get instance => _client ?? Supabase.instance.client;

  static User? get currentUser => instance.auth.currentUser;
  static Session? get currentSession => instance.auth.currentSession;
  static bool get isLoggedIn => currentUser != null;

  static void reset() {
    _client = null;
  }

  static Future<T> retryOnFutureJwt<T>(Future<T> Function() operation,
      {int maxAttempts = 3}) async {
    int attempts = 0;
    while (true) {
      try {
        return await operation();
      } on PostgrestException catch (e, stackTrace) {
        attempts++;
        if ((e.code == 'PGRST303' ||
                e.message.contains('JWT issued at future')) &&
            attempts < maxAttempts) {
          await Future.delayed(Duration(milliseconds: 1000 * attempts));
          continue;
        }
        ErrorService.log(
          e,
          stackTrace: stackTrace,
          userMessage: 'PostgREST request failed after $attempts attempts',
        );
        rethrow;
      }
    }
  }
}
