import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/screens/providers.dart';
import 'package:moviescout/screens/watchlist_logs_screen.dart';
import 'package:moviescout/services/discoverlist_service.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/services/theme_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/services/region_service.dart';
import 'package:moviescout/widgets/color_scheme_form.dart';
import 'package:moviescout/widgets/language_form.dart';
import 'package:moviescout/widgets/region_form.dart';
import 'package:moviescout/widgets/notification_permission_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/utils/deep_link_utils.dart';
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
          _languageTile(context),
          _regionTile(context),
          _notificationsTile(context),
          if (defaultTargetPlatform == TargetPlatform.android)
            _verifyDeepLinksTile(context),
          _aboutTile(context),
          const Divider(),
          _userSessionTile(context, isUserLoggedIn),
        ],
      ),
    );
  }

  Widget _notificationsTile(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: Text(AppLocalizations.of(context)!.notifications),
      value: notificationService.enabled,
      onChanged: (bool value) async {
        final success = await notificationService.setEnabled(value);
        if (!success && value && context.mounted) {
          NotificationPermissionDialog.show(context);
        }
      },
    );
  }

  Widget _userProfileTile(BuildContext context) {
    var user = Provider.of<TmdbUserService>(context).user;

    ImageProvider<Object>? userImage;

    if (user != null) {
      userImage = user['avatar']['tmdb'] != null &&
              user['avatar']['tmdb'].isNotEmpty
          ? CachedNetworkImageProvider(
              'https://image.tmdb.org/t/p/w185/${user['avatar']['tmdb']['avatar_path']}')
          : CachedNetworkImageProvider(
              'https://www.gravatar.com/avatar/${user['avatar']['gravatar']['hash']}?s=200');
    }

    var userName = user != null
        ? user['name'].toString().isNotEmpty
            ? user['name']
            : user['username']
        : AppLocalizations.of(context)!.anonymousUser;

    return UserAccountsDrawerHeader(
      currentAccountPicture: user != null
          ? CircleAvatar(
              backgroundImage: userImage,
            )
          : CircleAvatar(
              child: SvgPicture.asset(
                'assets/account.svg',
                width: 80,
                height: 80,
              ),
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

  Widget _languageTile(BuildContext context) {
    final languageProvider = Provider.of<LanguageService>(context);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(
        AppLocalizations.of(context)!.selectLanguage,
      ),
      onTap: () async {
        final String? selectedLanguage = await showDialog<String>(
          context: context,
          builder: (context) {
            return LanguageForm(
              currentLanguage: languageProvider.currentLanguage,
            );
          },
        );

        if (selectedLanguage != null &&
            selectedLanguage != languageProvider.currentLanguage) {
          languageProvider.setLanguage(selectedLanguage);
          await TmdbGenreService().reload();

          if (context.mounted) {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.languageChangeTitle),
                content:
                    Text(AppLocalizations.of(context)!.languageChangeContent),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else if (context.mounted) {
          Navigator.of(context).pop();
        }
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
        const SizedBox(height: 16),
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Close About dialog
                Navigator.pop(context); // Close Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WatchlistLogsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Logs d\'actualització'),
            ),
          ],
        ),
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

  void _logout(BuildContext context) async {
    final tmdbUserService =
        Provider.of<TmdbUserService>(context, listen: false);
    final tmdbWatchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    final tmdbRateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);
    final tmdbDiscoverlistService =
        Provider.of<TmdbDiscoverlistService>(context, listen: false);
    final logoutSuccessText = AppLocalizations.of(context)!.logoutSuccess;
    final userLocale = Localizations.localeOf(context);

    await tmdbUserService.logout(context).catchError((error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
      );
    });

    await tmdbWatchlistService.clearList();
    await tmdbRateslistService.clearList();
    await tmdbDiscoverlistService.clearList();

    await tmdbDiscoverlistService.retrieveDiscoverlist(
      '',
      '',
      userLocale,
      forceUpdate: true,
    );

    SnackMessage.showSnackBar(logoutSuccessText);

    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _regionTile(BuildContext context) {
    final regionProvider = Provider.of<RegionService>(context);

    return ListTile(
      leading: const Icon(Icons.public),
      title: Text(
        AppLocalizations.of(context)!.selectRegion,
      ),
      onTap: () async {
        final String? selectedRegion = await showDialog<String?>(
          context: context,
          builder: (context) {
            return RegionForm(
              currentRegion: regionProvider.manualRegion,
            );
          },
        );

        if (selectedRegion != regionProvider.manualRegion) {
          regionProvider.setManualRegion(selectedRegion);

          if (context.mounted) {
            final watchlistService =
                Provider.of<TmdbWatchlistService>(context, listen: false);
            final rateslistService =
                Provider.of<TmdbRateslistService>(context, listen: false);

            watchlistService.updateProviders();
            rateslistService.updateProviders();

            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  Widget _verifyDeepLinksTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: Text(AppLocalizations.of(context)!.verifyDeepLinks),
      onTap: () async {
        Navigator.of(context).pop();
        await DeepLinkUtils.openDeepLinkSettings(context);
      },
    );
  }
}
