import 'package:supabase_flutter/supabase_flutter.dart';

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
}
