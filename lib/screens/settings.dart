import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/ai_settings.dart';
import 'package:moviescout/screens/import_imdb.dart';
import 'package:moviescout/screens/import_tmdb.dart';
import 'package:moviescout/screens/providers.dart';
import 'package:moviescout/services/api/ai_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/notifications/notification_service.dart';
import 'package:moviescout/services/settings/region_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_lists/discoverlist_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/widgets/dialogs_and_forms/language_form.dart';
import 'package:moviescout/widgets/dialogs_and_forms/notification_permission_dialog.dart';
import 'package:moviescout/widgets/dialogs_and_forms/region_form.dart';
import 'package:moviescout/services/settings/app_settings_service.dart';
import 'package:moviescout/widgets/settings/settings_group.dart';
import 'package:moviescout/widgets/settings/settings_info_sheet.dart';
import 'package:moviescout/widgets/settings/settings_switch_tile.dart';
import 'package:moviescout/widgets/settings/settings_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authService = Provider.of<SupabaseAuthService>(context);
    final languageProvider = Provider.of<LanguageService>(context);
    final regionProvider = Provider.of<RegionService>(context);
    final appSettings = Provider.of<AppSettingsService>(context);
    final notificationService = Provider.of<NotificationService>(context);
    final providerService = Provider.of<TmdbProviderService>(context);
    final isUserLoggedIn = authService.isLoggedIn;

    final selectedProvidersCount = providerService.enabledProviderIds.length;
    final providersSubtitle = selectedProvidersCount > 0
        ? l10n.settingsProvidersCount(selectedProvidersCount)
        : l10n.settingsProvidersNone;

    final notificationsSubtitle = notificationService.enabled
        ? l10n.settingsNotificationsEnabledSubtitle
        : l10n.settingsNotificationsDisabledSubtitle;

    final notifySeasonSubtitle = notificationService.notifyCompleteSeason
        ? l10n.settingsNotifySeasonComplete
        : l10n.settingsNotifySeasonFirstEp;

    final aiStatusSubtitle = AiService().apiKey.isNotEmpty
        ? l10n.settingsAiConfigured
        : l10n.settingsAiNotConfigured;

    final publicProfileSubtitle = authService.isPublicProfile
        ? l10n.settingsProfilePublic
        : l10n.settingsProfilePrivate;

    final communityTabSubtitle = appSettings.showCommunityTab
        ? l10n.settingsCommunityVisible
        : l10n.settingsCommunityHidden;

    final showEditSubtitle = appSettings.showEditContent
        ? l10n.settingsEditVisible
        : l10n.settingsEditHidden;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          SettingsGroup(
            title: l10n.settingsSectionPreferences,
            children: [
              SettingsTile(
                icon: Icons.language,
                title: l10n.selectLanguage,
                subtitle: _getLanguageDisplayName(
                  languageProvider.currentLanguage,
                  context,
                ),
                onTap: () => _changeLanguage(context, languageProvider),
              ),
              SettingsTile(
                icon: Icons.public,
                title: l10n.selectRegion,
                subtitle: _regionSubtitle(regionProvider, context),
                onTap: () => _changeRegion(context, regionProvider),
              ),
              SettingsTile(
                icon: Icons.tv,
                title: l10n.providersTitle,
                subtitle: providersSubtitle,
                onInfoTap: () => _showProvidersInfo(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProvidersScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsGroup(
            title: l10n.settingsSectionNotifications,
            children: [
              SettingsSwitchTile(
                icon: Icons.notifications,
                title: l10n.notifications,
                subtitle: notificationsSubtitle,
                value: notificationService.enabled,
                onInfoTap: () => _showNotificationsInfo(context),
                onChanged: (bool value) async {
                  final success = await notificationService.setEnabled(value);
                  if (!success && value && context.mounted) {
                    NotificationPermissionDialog.show(context);
                  }
                },
              ),
              SettingsSwitchTile(
                isSubOption: true,
                icon: Icons.done_all,
                title: l10n.notifyCompleteSeason,
                subtitle: notifySeasonSubtitle,
                value: notificationService.notifyCompleteSeason,
                enabled: notificationService.enabled,
                onChanged: notificationService.enabled
                    ? (bool value) async {
                        await notificationService.setNotifyCompleteSeason(value);
                      }
                    : null,
              ),
            ],
          ),
          if (isUserLoggedIn)
            SettingsGroup(
              title: l10n.settingsSectionCommunity,
              children: [
                SettingsSwitchTile(
                  icon: Icons.group,
                  title: l10n.publicProfileTitle,
                  subtitle: publicProfileSubtitle,
                  value: authService.isPublicProfile,
                  onInfoTap: () => _showProfileInfo(context),
                  onChanged: (bool value) async {
                    await authService.setPublicProfile(value);
                  },
                ),
                SettingsSwitchTile(
                  icon: Icons.people_alt_outlined,
                  title: l10n.communityTabTitle,
                  subtitle: communityTabSubtitle,
                  value: appSettings.showCommunityTab,
                  onChanged: (bool value) async {
                    await appSettings.setShowCommunityTab(value);
                  },
                ),
              ],
            ),
          SettingsGroup(
            title: l10n.settingsSectionTools,
            children: [
              SettingsTile(
                icon: Icons.auto_awesome,
                title: l10n.aiSettingsTitle,
                subtitle: aiStatusSubtitle,
                onInfoTap: () => _showAiInfo(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AiSettingsScreen(),
                    ),
                  );
                },
              ),
              SettingsSwitchTile(
                icon: Icons.edit,
                title: l10n.showEditContent,
                subtitle: showEditSubtitle,
                value: appSettings.showEditContent,
                onInfoTap: () => _showEditInfo(context),
                onChanged: (bool value) async {
                  await appSettings.setShowEditContent(value);
                },
              ),
            ],
          ),
          if (isUserLoggedIn)
            SettingsGroup(
              title: l10n.settingsSectionData,
              children: [
                SettingsTile(
                  icon: Icons.cloud_download,
                  title: l10n.tmdbImport,
                  subtitle: l10n.settingsTmdbSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportTmdbScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.import_export,
                  title: l10n.imdbImport,
                  subtitle: l10n.settingsImdbSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportIMDB(),
                      ),
                    );
                  },
                ),
              ],
            ),
          if (isUserLoggedIn) ...[
            const SizedBox(height: 8.0),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.35),
              clipBehavior: Clip.antiAlias,
              child: SettingsTile(
                icon: Icons.delete_forever,
                title: l10n.deleteAccount,
                subtitle: l10n.settingsDeleteAccountSubtitle,
                isDestructive: true,
                onTap: () => _confirmDeleteAccount(context),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ],
      ),
    );
  }

  void _showProvidersInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SettingsInfoSheet.show(
      context: context,
      headerIcon: Icons.tv,
      title: l10n.settingsInfoProvidersTitle,
      subtitle: l10n.settingsInfoProvidersIntro,
      closeButtonLabel: l10n.understood,
      items: [
        SettingsInfoItem(
          icon: Icons.notifications_active_outlined,
          title: l10n.settingsInfoProvidersItem1Title,
          description: l10n.settingsInfoProvidersItem1Desc,
        ),
        SettingsInfoItem(
          icon: Icons.filter_alt_outlined,
          title: l10n.settingsInfoProvidersItem2Title,
          description: l10n.settingsInfoProvidersItem2Desc,
        ),
        SettingsInfoItem(
          icon: Icons.public,
          title: l10n.settingsInfoProvidersItem3Title,
          description: l10n.settingsInfoProvidersItem3Desc,
        ),
      ],
    );
  }

  void _showNotificationsInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SettingsInfoSheet.show(
      context: context,
      headerIcon: Icons.notifications_active_outlined,
      title: l10n.settingsInfoNotificationsTitle,
      subtitle: l10n.settingsInfoNotificationsIntro,
      closeButtonLabel: l10n.understood,
      items: [
        SettingsInfoItem(
          icon: Icons.movie_outlined,
          title: l10n.settingsInfoNotificationsItem1Title,
          description: l10n.settingsInfoNotificationsItem1Desc,
        ),
        SettingsInfoItem(
          icon: Icons.tv,
          title: l10n.settingsInfoNotificationsItem2Title,
          description: l10n.settingsInfoNotificationsItem2Desc,
        ),
        SettingsInfoItem(
          icon: Icons.battery_charging_full_outlined,
          title: l10n.settingsInfoNotificationsItem3Title,
          description: l10n.settingsInfoNotificationsItem3Desc,
        ),
      ],
    );
  }

  void _showAiInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SettingsInfoSheet.show(
      context: context,
      headerIcon: Icons.auto_awesome,
      title: l10n.settingsInfoAiTitle,
      subtitle: l10n.settingsInfoAiIntro,
      note: l10n.settingsInfoAiNote,
      closeButtonLabel: l10n.understood,
      items: [
        SettingsInfoItem(
          icon: Icons.translate,
          title: l10n.settingsInfoAiItem1Title,
          description: l10n.settingsInfoAiItem1Desc,
        ),
        SettingsInfoItem(
          icon: Icons.search,
          title: l10n.settingsInfoAiItem2Title,
          description: l10n.settingsInfoAiItem2Desc,
        ),
        SettingsInfoItem(
          icon: Icons.security,
          title: l10n.settingsInfoAiItem3Title,
          description: l10n.settingsInfoAiItem3Desc,
        ),
      ],
    );
  }

  void _showProfileInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SettingsInfoSheet.show(
      context: context,
      headerIcon: Icons.group_outlined,
      title: l10n.settingsInfoProfileTitle,
      subtitle: l10n.settingsInfoProfileIntro,
      closeButtonLabel: l10n.understood,
      items: [
        SettingsInfoItem(
          icon: Icons.share_outlined,
          title: l10n.settingsInfoProfileItem1Title,
          description: l10n.settingsInfoProfileItem1Desc,
        ),
        SettingsInfoItem(
          icon: Icons.lock_outline,
          title: l10n.settingsInfoProfileItem2Title,
          description: l10n.settingsInfoProfileItem2Desc,
        ),
        SettingsInfoItem(
          icon: Icons.people_alt_outlined,
          title: l10n.settingsInfoProfileItem3Title,
          description: l10n.settingsInfoProfileItem3Desc,
        ),
      ],
    );
  }

  void _showEditInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SettingsInfoSheet.show(
      context: context,
      headerIcon: Icons.edit_note_outlined,
      title: l10n.settingsInfoEditTitle,
      subtitle: l10n.settingsInfoEditIntro,
      note: l10n.settingsInfoEditNote,
      closeButtonLabel: l10n.understood,
      items: [
        SettingsInfoItem(
          icon: Icons.edit_outlined,
          title: l10n.settingsInfoEditItem1Title,
          description: l10n.settingsInfoEditItem1Desc,
        ),
        SettingsInfoItem(
          icon: Icons.groups_outlined,
          title: l10n.settingsInfoEditItem2Title,
          description: l10n.settingsInfoEditItem2Desc,
        ),
        SettingsInfoItem(
          icon: Icons.translate,
          title: l10n.settingsInfoEditItem3Title,
          description: l10n.settingsInfoEditItem3Desc,
        ),
      ],
    );
  }

  String _getLanguageDisplayName(String code, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case AppConstants.catalan:
        return l10n.catalan;
      case AppConstants.spanish:
        return l10n.spanish;
      case AppConstants.english:
        return l10n.english;
      case AppConstants.french:
        return l10n.french;
      case AppConstants.german:
        return l10n.german;
      case AppConstants.italian:
        return l10n.italian;
      case AppConstants.portugueseBr:
        return l10n.portugueseBr;
      case AppConstants.portuguesePt:
        return l10n.portuguesePt;
      case AppConstants.basque:
        return l10n.basque;
      case AppConstants.galician:
        return l10n.galician;
      default:
        return code;
    }
  }

  Future<void> _changeLanguage(
    BuildContext context,
    LanguageService languageProvider,
  ) async {
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
      await languageProvider.setLanguage(selectedLanguage);
    }
  }

  Future<void> _changeRegion(
    BuildContext context,
    RegionService regionProvider,
  ) async {
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
    }
  }

  String _regionSubtitle(RegionService regionProvider, BuildContext context) {
    final manual = regionProvider.manualRegion;
    String subtitle;

    if (manual != null) {
      final name = regionProvider.getRegionName(manual);
      subtitle = name.isNotEmpty ? name : manual;
    } else {
      final autoText = AppLocalizations.of(context)!.regionAuto;
      final detected = regionProvider.detectedRegion;
      if (detected != null && detected.isNotEmpty) {
        final name = regionProvider.getRegionName(detected);
        subtitle = '$autoText (${name.isNotEmpty ? name : detected})';
      } else {
        subtitle = autoText;
      }
    }

    return subtitle;
  }

  void _confirmDeleteAccount(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final deleteColor = customColors?.destructiveAction ?? Colors.redAccent;
    final supabaseAuthService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final tmdbWatchlistService =
        Provider.of<WatchlistService>(context, listen: false);
    final tmdbRateslistService =
        Provider.of<RateslistService>(context, listen: false);
    final tmdbDiscoverlistService =
        Provider.of<TmdbDiscoverlistService>(context, listen: false);
    final userLocale = Localizations.localeOf(context);
    final successMessage = AppLocalizations.of(context)!.deleteAccountSuccess;
    final errorMessage = AppLocalizations.of(context)!.deleteAccountError;
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteAccountConfirmTitle),
          content:
              Text(AppLocalizations.of(context)!.deleteAccountConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: deleteColor,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final success = await supabaseAuthService.deleteAccount();

                if (success) {
                  await tmdbWatchlistService.clearList();
                  await tmdbRateslistService.clearList();
                  await tmdbDiscoverlistService.clearList();
                  await tmdbDiscoverlistService.retrieveDiscoverlist(
                    userLocale,
                    forceUpdate: true,
                  );

                  SnackMessage.showSnackBar(successMessage);
                  navigator.popUntil((route) => route.isFirst);
                } else {
                  SnackMessage.showSnackBar(errorMessage);
                }
              },
              child: Text(AppLocalizations.of(context)!.deleteAccount),
            ),
          ],
        );
      },
    );
  }
}
