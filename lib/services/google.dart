import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

const List<String> scopes = <String>['email'];
late GoogleSignIn _googleSignIn;

GoogleService defaultAppInstance = GoogleService();

class GoogleService {
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  static GoogleService get instance {
    return defaultAppInstance;
  }

  init() async {
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
    await _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  Future<List<String>> readFavoriteMovies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in.
      return []; // Return an empty list
    }
    final uid = user.uid;
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('users/$uid/favoriteMovieIds').once();

    if (snapshot.snapshot.value != null) {
      final favoriteIds = snapshot.snapshot.value as List<dynamic>;
      return favoriteIds.map((e) => e.toString()).toList();
    } else {
      return []; // Return an empty list if the user has no favorites
    }
  }

  Future<void> updateFavoriteMovie(String movieId, bool add) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in.
      return; // Do nothing if the user isn't logged in
    }
    final uid = user.uid;
    final database = FirebaseDatabase.instance.ref();
    final favoritesRef = database.child('users/$uid/favoriteMovieIds');

    await favoritesRef.once().then((value) async {
      if (value.snapshot.exists) {
        List<String> favorites = (value.snapshot.value as List<dynamic>)
            .map((e) => e.toString())
            .toList();

        if (add) {
          if (!favorites.contains(movieId)) {
            favorites.add(movieId);
          }
        } else {
          favorites.remove(movieId);
        }
        await favoritesRef.set(favorites);
      } else {
        if (add) {
          await favoritesRef.set([movieId]);
        }
      }
    });
  }
}
