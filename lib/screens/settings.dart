import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/screens/providers.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/services/region_service.dart';
import 'package:moviescout/services/theme_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/utils/deep_link_utils.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/color_scheme_form.dart';
import 'package:moviescout/widgets/language_form.dart';
import 'package:moviescout/widgets/notification_permission_dialog.dart';
import 'package:moviescout/widgets/region_form.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = Provider.of<TmdbUserService>(context).isUserLoggedIn;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.settings,
      ),
      body: ListView(
        children: [
          if (isUserLoggedIn && defaultTargetPlatform == TargetPlatform.linux)
            _importImdbTile(context),
          if (isUserLoggedIn) _providersTile(context),
          _colorSchemeTile(context),
          _languageTile(context),
          _regionTile(context),
          _notificationsTile(context),
          _notifyCompleteSeasonTile(context),
          if (defaultTargetPlatform == TargetPlatform.android)
            _verifyDeepLinksTile(context),
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

  Widget _notifyCompleteSeasonTile(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return SwitchListTile(
      secondary: const Icon(Icons.done_all),
      title: Text(AppLocalizations.of(context)!.notifyCompleteSeason),
      value: notificationService.notifyCompleteSeason,
      onChanged: notificationService.enabled
          ? (bool value) async {
              await notificationService.setNotifyCompleteSeason(value);
            }
          : null,
    );
  }

  Widget _importImdbTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.import_export),
      title: Text(AppLocalizations.of(context)!.imdbImport),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImportIMDB()),
        );
      },
    );
  }

  Widget _providersTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tv),
      title: Text(AppLocalizations.of(context)!.providersTitle),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProvidersScreen()),
        );
      },
    );
  }

  Widget _colorSchemeTile(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);

    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: Text(
        AppLocalizations.of(context)!.schemeSelectTitle,
      ),
      onTap: () {
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
        );
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
        }
      },
    );
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
        await DeepLinkUtils.openDeepLinkSettings(context);
      },
    );
  }
}
