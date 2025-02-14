import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:moviescout/services/google.dart';

typedef HandleSignInFn = Future<void> Function();

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = GoogleSignInService.instance.currentUser;
    NetworkImage? userImage = NetworkImage(user?.photoUrl ?? '');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: userImage,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            accountName: Text(
              user?.displayName ?? AppLocalizations.of(context)!.anonymousUser,
            ),
            accountEmail: Text(user?.email ?? ''),
          ),
          if (!kIsWeb)
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
          if (kIsWeb && user == null)
            ListTile(
              leading: buildSignInButton(),
              title: Text(AppLocalizations.of(context)!.login),
            ),
          if (kIsWeb && user != null)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () => {
                Navigator.of(context).pop(),
                logout(),
              },
            ),
        ],
      ),
    );
  }

  Widget buildSignInButton({HandleSignInFn? onPressed}) {
    return web.renderButton(
      configuration: GSIButtonConfiguration(
        type: GSIButtonType.icon,
      ),
    );
  }

  Future<void> login() async {
    try {
      await GoogleSignInService.instance.signIn();
    } catch (error) {
      print(error);
    }
  }

  logout() async {
    await GoogleSignInService.instance.signOut();
    print("Sessió finalitzada.");
  }
}
