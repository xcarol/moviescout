import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moviescout/services/snack_bar.dart';

const List<String> scopes = <String>['email'];
late GoogleSignIn _googleSignIn;

GoogleService defaultAppInstance = GoogleService();

Future<String?> getFirebaseUid(BuildContext context, googleUser) async {
  if (googleUser != null) {
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      return firebaseUser?.uid;
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors (e.g., network issues, invalid credentials)
      if (context.mounted) {
        SnackMessage.showSnackBar(
            context, "getFirebaseUid - Firebase Authentication error: $e");
      }
      return null;
    }
  } else {
    return null; // Sign-in failed
  }
}

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

  Future<bool> isFavoriteTitle(BuildContext context, int movieId) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return false; // Return false if the user isn't logged in
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    try {
      final snapshot =
          await database.child('users/$uid/favoriteTitleIds').once();

      if (snapshot.snapshot.value != null) {
        final favoriteIds = snapshot.snapshot.value as List<dynamic>;
        return favoriteIds.contains(movieId);
      } else {
        return false; // Return false if the user has no favorites
      }
    } catch (e) {
      if (context.mounted) {
        SnackMessage.showSnackBar(context, "isFavoriteTitle error: $e");
      }
    }
    return false;
  }

  Future<List<int>> readFavoriteTitles(BuildContext context) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return []; // Return an empty list
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('users/$uid/favoriteTitleIds').once();

    if (snapshot.snapshot.value != null) {
      final favoriteIds = snapshot.snapshot.value as List<dynamic>;
      return favoriteIds.map((e) => e as int).toList();
    } else {
      return []; // Return an empty list if the user has no favorites
    }
  }

  Future<void> updateFavoriteTitle(
      BuildContext context, int movieId, bool add) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return; // Do nothing if the user isn't logged in
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    final favoritesRef = database.child('users/$uid/favoriteTitleIds');

    await favoritesRef.once().then((value) async {
      try {
        if (value.snapshot.exists) {
          List<int> favorites = (value.snapshot.value as List<dynamic>)
              .map((e) => e as int)
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
      } catch (e) {
        if (context.mounted) {
          SnackMessage.showSnackBar(context, "updateFavoriteTitle error: $e");
        }
      }
    });
  }
}
