import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId: dotenv.env['OAUTH_CLIENT_ID'])
        .signIn();
    if (googleUser == null) return null; // Usuari cancel·la el login

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  } catch (e) {
    print("Error en Google Sign-In: $e");
    return null;
  }
}

Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}
