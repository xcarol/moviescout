import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviescout/services/google.dart';
import 'web_sign_in_button_mobile_fake.dart'
    if (dart.library.js_util) 'web_sign_in_button.dart' show buildSignInButton;
import 'package:moviescout/services/snack_bar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = GoogleService.instance.currentUser;
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
                if (user != null) {logout(context)} else {login(context)}
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
                logout(context),
              },
            ),
        ],
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    try {
      await GoogleService.instance.signIn();
      if (context.mounted) {
        SnackMessage.showSnackBar(
            context, AppLocalizations.of(context)!.loginSuccess);
      }
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(context, "signIn error: ${error.toString()}");
      }
    }
  }

  logout(BuildContext context) async {
    try {
      await GoogleService.instance.signOut();
      if (context.mounted) {
        SnackMessage.showSnackBar(
            context, AppLocalizations.of(context)!.logoutSuccess);
      }
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(
            context, "signOut error: ${error.toString()}");
      }
    }
  }
}
