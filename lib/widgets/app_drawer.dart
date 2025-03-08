import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/snack_bar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn =
        Provider.of<TmdbUserService>(context).isUserLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // UserAccountsDrawerHeader(
          //   currentAccountPicture: CircleAvatar(
          //     backgroundImage: userImage,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.inversePrimary,
          //   ),
          //   accountName: Text(
          //     user?.displayName ?? AppLocalizations.of(context)!.anonymousUser,
          //   ),
          //   accountEmail: Text(isUserLoggedIn?.email ?? ''),
          // ),
          if (isUserLoggedIn)
            ListTile(
              leading: Icon(Icons.import_export),
              title: Text(AppLocalizations.of(context)!.imdbImport),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImportIMDB()),
                ),
              },
            ),
          ListTile(
            leading: Icon(isUserLoggedIn ? Icons.logout : Icons.login),
            title: Text(isUserLoggedIn
                ? AppLocalizations.of(context)!.logout
                : AppLocalizations.of(context)!.login),
            onTap: () => {
              Navigator.of(context).pop(),
              if (isUserLoggedIn)
                {logout(context)}
              else
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  ),
                }
            },
          ),
        ],
      ),
    );
  }

  logout(BuildContext context) async {
    await Provider.of<TmdbUserService>(context, listen: false)
        .logout()
        .catchError((error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(
          context,
          error.toString(),
        );
      }
    });
    if (context.mounted) {
      SnackMessage.showSnackBar(
        context,
        AppLocalizations.of(context)!.logoutSuccess,
      );
    }
  }
}
