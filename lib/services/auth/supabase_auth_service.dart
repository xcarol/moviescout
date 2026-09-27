import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';

class SupabaseAuthService extends ChangeNotifier {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;

  Map<String, dynamic>? userProfile;

  SupabaseAuthService._internal() {
    _supabase.auth.onAuthStateChange.listen((data) async {
      if (_supabase.auth.currentUser != null) {
        await fetchProfile();
      } else {
        userProfile = null;
      }
      notifyListeners();
    });
  }

  final _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<void> fetchProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        if (response != null) {
          userProfile = response;
          notifyListeners();
        } else {
          final metadata = user.userMetadata;
          final displayName = metadata?['full_name'] ?? metadata?['name'] ?? '';
          final avatar = metadata?['avatar_url'] ?? metadata?['picture'] ?? '';
          try {
            await _supabase.from('profiles').upsert({
              'id': user.id,
              'username': displayName,
              'avatar_url': avatar,
            });
            userProfile = {
              'id': user.id,
              'username': displayName,
              'avatar_url': avatar,
            };
            notifyListeners();
          } catch (_) {}
        }
      }
    } catch (e) {
      // Ignorar errors de càrrega
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: '${Uri.base.origin}/',
        );
      }

      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      if (webClientId == null || webClientId.isEmpty) {
        throw Exception('GOOGLE_WEB_CLIENT_ID not found in .env');
      }

      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        clientId: kIsWeb ? webClientId : null,
        serverClientId: kIsWeb ? null : webClientId,
      );

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
        final metadata = authResponse.user!.userMetadata;
        final displayName = metadata?['full_name'] ??
            metadata?['name'] ??
            googleUser.displayName ??
            '';
        final avatar = metadata?['avatar_url'] ??
            metadata?['picture'] ??
            googleUser.photoUrl ??
            '';

        try {
          await _supabase.from('profiles').upsert({
            'id': authResponse.user!.id,
            'username': displayName,
            'avatar_url': avatar,
          });
        } catch (_) {}

        await fetchProfile();
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
      if (!kIsWeb) {
        await GoogleSignIn.instance.disconnect();
      }
      await _supabase.auth.signOut();
      userProfile = null;
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
