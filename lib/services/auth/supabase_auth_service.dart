import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';

class SupabaseAuthService extends ChangeNotifier {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;
  SupabaseAuthService._internal();

  final _supabase = Supabase.instance.client;
  
  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<bool> signInWithGoogle() async {
    try {
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      if (webClientId == null || webClientId.isEmpty) {
        throw Exception('GOOGLE_WEB_CLIENT_ID not found in .env');
      }

      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: webClientId);
      
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google idToken not found');
      }

      final authResponse = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      if (authResponse.user != null) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error sign in with Google',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
      await _supabase.auth.signOut();
      notifyListeners();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error on sign out',
        stackTrace: stackTrace,
      );
    }
  }
}
