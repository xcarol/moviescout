import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/screens/providers.dart';
import 'package:moviescout/services/theme_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/color_scheme_form.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = Provider.of<TmdbUserService>(context).isUserLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _userProfileTile(context),
          if (isUserLoggedIn && defaultTargetPlatform == TargetPlatform.linux)
            _importImdbTile(context),
          if (isUserLoggedIn) _providersTile(context),
          _colorSchemeTile(context),
          _aboutTile(context),
          const Divider(),
          _userSessionTile(context, isUserLoggedIn),
        ],
      ),
    );
  }

  Widget _userProfileTile(BuildContext context) {
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

    return UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        backgroundImage: userImage,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      accountName: Text(userName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
          )),
      accountEmail: null,
    );
  }

  Widget _importImdbTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.import_export),
      title: Text(AppLocalizations.of(context)!.imdbImport),
      onTap: () => {
        Navigator.of(context).pop(),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImportIMDB()),
        ),
      },
    );
  }

  Widget _providersTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.tv),
      title: Text(AppLocalizations.of(context)!.providersTitle),
      onTap: () => {
        Navigator.of(context).pop(),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProvidersScreen()),
        ),
      },
    );
  }

  Widget _colorSchemeTile(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);

    return ListTile(
      leading: Icon(Icons.color_lens),
      title: Text(
        AppLocalizations.of(context)!.schemeSelectTitle,
      ),
      onTap: () => {
        Navigator.of(context).pop(),
        showDialog(
          context: context,
          builder: (context) {
            return ColorSchemeForm(
              currentScheme: themeProvider.currentScheme,
              onSubmit: (ThemeSchemes schemeName) {
                themeProvider.setColorScheme(schemeName);
              },
            );
          },
        ),
      },
    );
  }

  Widget _aboutTile(BuildContext context) {
    return AboutListTile(
      icon: Icon(Icons.info),
      applicationName: 'MovieScout',
      applicationVersion: dotenv.env['VERSION'] ?? 'x.x.x',
      applicationIcon: SizedBox(
        width: 48,
        height: 48,
        child: Image.asset('assets/logo-icon.png'),
      ),
      aboutBoxChildren: [
        Text(AppLocalizations.of(context)!.aboutDescription),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: AppLocalizations.of(context)!.aboutGithub),
              TextSpan(
                text: 'github',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(
                      Uri.parse('https://github.com/xcarol/moviescout')),
              ),
            ],
          ),
        )
      ],
      child: Text(AppLocalizations.of(context)!.about),
    );
  }

  Widget _userSessionTile(BuildContext context, bool isUserLoggedIn) {
    return ListTile(
      leading: Icon(isUserLoggedIn ? Icons.logout : Icons.login),
      title: Text(isUserLoggedIn
          ? AppLocalizations.of(context)!.logout
          : AppLocalizations.of(context)!.login),
      onTap: () => {
        Navigator.of(context).pop(),
        if (isUserLoggedIn)
          {_logout(context)}
        else
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            ),
          }
      },
    );
  }

  _logout(BuildContext context) async {
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
