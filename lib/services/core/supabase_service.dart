import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> init() async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseApiKey = dotenv.env['SUPABASE_API_KEY'] ?? '';

      if (supabaseUrl.isEmpty || supabaseApiKey.isEmpty) {
        throw Exception('Supabase URL or API Key is missing from .env');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseApiKey,
      );
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error initializing Supabase',
        stackTrace: stackTrace,
      );
    }
  }
}
