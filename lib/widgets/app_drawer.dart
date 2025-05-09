import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/snack_bar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = Provider.of<TmdbUserService>(context).isUserLoggedIn;
    var user = Provider.of<TmdbUserService>(context).user;
    ImageProvider<Object>? userImage = user != null
        ? NetworkImage(
            'https://www.gravatar.com/avatar/${user['avatar']['gravatar']['hash']}?s=200')
        : AssetImage('assets/anonymous.png');
    var userName = user != null
        ? user['name'].toString().isNotEmpty
            ? user['name']
            : user['username']
        : AppLocalizations.of(context)!.anonymousUser;

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
            accountName: Text(userName),
            accountEmail: null,
          ),
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
    final tmdbUserService =
        Provider.of<TmdbUserService>(context, listen: false);
    final tmdbWatchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    final tmdbRateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);
    final logoutSuccessText = AppLocalizations.of(context)!.logoutSuccess;

    await tmdbUserService.logout().catchError((error) {
      SnackMessage.showSnackBar(
        error.toString(),
      );
    });

    tmdbWatchlistService.clearList();
    tmdbRateslistService.clearList();
    SnackMessage.showSnackBar(logoutSuccessText);
  }
}
