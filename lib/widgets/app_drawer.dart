import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            accountName: Text(
              user?.displayName ?? AppLocalizations.of(context)!.anonymousUser,
            ),
            accountEmail: Text(user?.emailVerified == true ? user!.email! : ''),
          ),
          ListTile(
            leading: Icon(user != null ? Icons.logout : Icons.login),
            title: Text(user != null
                ? AppLocalizations.of(context)!.logout
                : AppLocalizations.of(context)!.login),
            onTap: () => {
              Navigator.of(context).pop(),
              if (user != null) {logout()} else {login()}
            },
          ),
        ],
      ),
    );
  }

  login() async {
    User? user = await signInWithGoogle();
    if (user != null) {
      print("Sessió iniciada amb: ${user.displayName}");
    } else {
      print("Error en iniciar sessió.");
    }
  }

  logout() async {
    await signOutGoogle();
    print("Sessió finalitzada.");
  }
}
