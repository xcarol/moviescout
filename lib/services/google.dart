import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> scopes = <String>['email'];
late GoogleSignIn _googleSignIn;

GoogleSignInService defaultAppInstance = GoogleSignInService();

class GoogleSignInService {
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  static GoogleSignInService get instance {
    return defaultAppInstance;
  }

  initService() async {
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: dotenv.env['OAUTH_CLIENT_ID'],
        scopes: scopes,
      );
    } else {
      _googleSignIn = GoogleSignIn(
        serverClientId: dotenv.env['OAUTH_CLIENT_ID'],
        scopes: scopes,
      );
    }

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      // But in web, if more persmissions are required at some time, 
      // this is the place to check for them using canAccessScopes method.
      // Check it out at https://pub.dev/packages/google_sign_in_web
    });

    _googleSignIn.signInSilently();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      print("Error in signOutGoogle: $e");
    }
  }
}
