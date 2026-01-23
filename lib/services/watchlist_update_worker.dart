import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/language_service.dart';
import 'dart:convert';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load(fileName: ".env");
      await PreferencesService().init();
      await IsarService.init();
      await NotificationService().init();

      final providerIdsStr =
          PreferencesService().prefs.getString('providers') ?? '[]';
      final List<dynamic> providersList = jsonDecode(providerIdsStr);
      final enabledProviderIds = providersList
          .where((p) => p['provider_enabled'] == 'true')
          .map((p) => (p['provider_id'] as num).toInt())
          .toList();

      final localeStr =
          PreferencesService().prefs.getString(AppConstants.language) ?? 'ca';
      final locale = LanguageService.parseLocale(localeStr);
      final localizations = await AppLocalizations.delegate.load(locale);

      final repository = TmdbTitleRepository();
      final titleService = TmdbTitleService();

      int page = 0;
      const int pageSize = 50;
      bool hasMore = true;

      while (hasMore) {
        final watchlistTitles = await repository.getTitles(
          listName: AppConstants.watchlist,
          offset: page * pageSize,
          limit: pageSize,
        );

        if (watchlistTitles.isEmpty) {
          hasMore = false;
          break;
        }

        for (final title in watchlistTitles) {
          if (!TmdbTitleService.isUpToDate(title)) {
            final oldProviders = title.flatrateProviderIds.toSet();
            final enabledProviderSet = enabledProviderIds.toSet();
            final wasAvailable =
                oldProviders.intersection(enabledProviderSet).isNotEmpty;

            await titleService.updateTitleDetails(title);
            await repository.saveTitle(title);

            if (!wasAvailable) {
              final newProviders = title.flatrateProviderIds.toSet();
              final isAvailable =
                  newProviders.intersection(enabledProviderSet).isNotEmpty;

              if (isAvailable) {
                await NotificationService().showNotification(
                  id: title.tmdbId,
                  title: localizations.notificationTitle,
                  body: localizations.notificationBody(title.name),
                  imageUrl: title.posterPath,
                  payload: '${title.mediaType}|${title.tmdbId}',
                );
              }
            }

            await Future.delayed(const Duration(milliseconds: 200));
          }
        }

        page++;
        // Safety break if needed, but pagination should handle it
        if (watchlistTitles.length < pageSize) {
          hasMore = false;
        }
      }

      await PreferencesService().prefs.setString(
            AppConstants.lastBackgroundRun,
            DateTime.now().toIso8601String(),
          );

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
