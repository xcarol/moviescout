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

  Future<bool> isTitleInWatchlist(BuildContext context, int titleId) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return false; // Return false if the user isn't logged in
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    try {
      final snapshot =
          await database.child('users/$uid/watchlistTitleIds').once();

      if (snapshot.snapshot.value != null) {
        final titlesIds = snapshot.snapshot.value as List<dynamic>;
        return titlesIds.contains(titleId);
      } else {
        return false; // Return false if the user has no watchlist
      }
    } catch (e) {
      if (context.mounted) {
        SnackMessage.showSnackBar(context, "isTitleInWatchlist error: $e");
      }
    }
    return false;
  }

  Future<List<int>> readWatchlistTitles(BuildContext context) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return []; // Return an empty list
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    final snapshot =
        await database.child('users/$uid/watchlistTitleIds').once();

    if (snapshot.snapshot.value != null) {
      final titlesIds = snapshot.snapshot.value as List<dynamic>;
      return titlesIds.map((e) => e as int).toList();
    } else {
      return []; // Return an empty list if the user has no watchlist
    }
  }

  Future<void> updateWatchlistTitle(
      BuildContext context, int titleId, bool add) async {
    if (currentUser == null) {
      // Handle the case where the user is not logged in.
      return; // Do nothing if the user isn't logged in
    }
    final uid = await getFirebaseUid(context, currentUser);
    final database = FirebaseDatabase.instance.ref();
    final watchlistRef = database.child('users/$uid/watchlistTitleIds');

    await watchlistRef.once().then((value) async {
      try {
        if (value.snapshot.exists) {
          List<int> watchlist = (value.snapshot.value as List<dynamic>)
              .map((e) => e as int)
              .toList();

          if (add) {
            if (!watchlist.contains(titleId)) {
              watchlist.add(titleId);
            }
          } else {
            watchlist.remove(titleId);
          }
          await watchlistRef.set(watchlist);
        } else {
          if (add) {
            await watchlistRef.set([titleId]);
          }
        }
      } catch (e) {
        if (context.mounted) {
          SnackMessage.showSnackBar(context, "updateWatchlistTitle error: $e");
        }
      }
    });
  }
}
