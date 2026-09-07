import 'package:flutter/material.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _initAuthListener();
  }

  User? get currentUser => SupabaseService().client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  void _initAuthListener() {
    SupabaseService().client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    try {
      final response = await SupabaseService().client.auth.signInWithPassword(
            email: email,
            password: password,
          );
      return response;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error signing in with email',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<AuthResponse?> signUpWithEmail(String email, String password) async {
    try {
      final response = await SupabaseService().client.auth.signUp(
            email: email,
            password: password,
          );
      return response;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error signing up with email',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google Sign In using google_sign_in package and Supabase
  }

  Future<void> signOut() async {
    try {
      await SupabaseService().client.auth.signOut();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error signing out',
        stackTrace: stackTrace,
      );
    }
  }
}
