import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:moviescout/models/tmdb_provider.dart';
import 'dart:convert';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final logLines = <String>[];
    int scannedCount = 0;
    int updatedCount = 0;
    try {
      await dotenv.load(fileName: ".env");
      await PreferencesService().init();
      await IsarService.init();
      await NotificationService().init();

      logLines.add('-------------------------------------------');
      logLines.add(
          'Start: ${DateTime.now().toLocal().toString().split('.').first}');
      logLines.add('-------------------------------------------');

      final providersStrings =
          PreferencesService().prefs.getStringList('providers') ?? [];
      final List<dynamic> providersList =
          providersStrings.map((s) => jsonDecode(s)).toList();

      final enabledProviderNames = providersList
          .where((p) => p[TmdbProvider.providerEnabled] == 'true')
          .map((p) => p[TmdbProvider.providerName].toString())
          .toList();
      logLines.add('Providers: ${enabledProviderNames.join(', ')}');

      final enabledProviderIds = providersList
          .where((p) => p[TmdbProvider.providerEnabled] == 'true')
          .map((p) => (p[TmdbProvider.providerId] as num).toInt())
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
          scannedCount++;
          if (!TmdbTitleService.isUpToDate(title)) {
            updatedCount++;
            final oldProviders = title.flatrateProviderIds.toSet();
            final enabledProviderSet = enabledProviderIds.toSet();
            final wasAvailable =
                oldProviders.intersection(enabledProviderSet).isNotEmpty;
            final int oldNumberOfSeasons = title.numberOfSeasons;

            await titleService.updateTitleDetails(title);
            await repository.saveTitle(title);

            final oldProviderNames = providersList
                .where((p) => oldProviders.contains(p[TmdbProvider.providerId]))
                .map((p) => p[TmdbProvider.providerName])
                .toList();
            final newProviderNames = providersList
                .where((p) => title.flatrateProviderIds
                    .contains(p[TmdbProvider.providerId]))
                .map((p) => p[TmdbProvider.providerName])
                .toList();

            logLines.add('- Updated: ${title.name}');
            final listOldProviderNames = oldProviderNames.join(', ');
            final listNewProviderNames = newProviderNames.join(', ');
            if (listOldProviderNames != listNewProviderNames) {
              logLines.add('- Old providers: $listOldProviderNames');
              logLines.add('- New providers: $listNewProviderNames');
            }

            // Check for new availability
            if (!wasAvailable) {
              final newProviders = title.flatrateProviderIds.toSet();
              final isAvailable =
                  newProviders.intersection(enabledProviderSet).isNotEmpty;

              final availableProviderNames = providersList
                  .where(
                      (p) => newProviders.contains(p[TmdbProvider.providerId]))
                  .map((p) => p[TmdbProvider.providerName])
                  .toList();

              if (availableProviderNames.isNotEmpty) {
                logLines.add(
                    '- Available: ${title.name} at ${availableProviderNames.join(', ')}');
              }

              if (isAvailable) {
                logLines.add('- Sending notification for ${title.name}');
                await NotificationService().showNotification(
                  id: title.tmdbId,
                  title: localizations.notificationTitle,
                  body: localizations.notificationBody(title.name),
                  imageUrl: title.posterPath,
                  payload: '${title.mediaType}|${title.tmdbId}',
                );
              }
            }

            // Check for new TV season
            if (title.isSerie &&
                title.numberOfSeasons > oldNumberOfSeasons &&
                oldNumberOfSeasons > 0) {
              logLines.add(
                  '- Sending notification for new season of ${title.name} with ${title.numberOfSeasons} seasons');
              await NotificationService().showNotification(
                id: title.tmdbId + 1000000, // Offset to avoid ID collision
                title: localizations.notificationNewSeasonTitle,
                body: localizations.notificationNewSeasonBody(title.name),
                imageUrl: title.posterPath,
                payload: '${title.mediaType}|${title.tmdbId}',
              );
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

      logLines.add('Summary: $scannedCount scanned - $updatedCount updated');
      await _saveLogs(logLines);

      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('Error in background task: $e');
      debugPrint(stackTrace.toString());

      logLines.add('ERROR: $e\n$stackTrace');
      logLines.add(
          'Summary: $scannedCount scanned - $updatedCount updated (Interrupted)');
      await _saveLogs(logLines);

      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          // Firebase might not be initialized if the error happened very early
          await Firebase.initializeApp();
          FirebaseCrashlytics.instance.recordError(e, stackTrace,
              reason: 'Workmanager task error: $task');
        } catch (_) {}
      }
      return Future.value(false);
    }
  });
}

Future<void> _saveLogs(List<String> logLines) async {
  try {
    final prefs = PreferencesService().prefs;
    final currentLogs =
        prefs.getStringList(AppConstants.watchlistUpdateLogs) ?? [];
    final newEntry = logLines.join('\n');
    currentLogs.add(newEntry);
    if (currentLogs.length > 50) {
      currentLogs.removeRange(0, currentLogs.length - 50);
    }
    await prefs.setStringList(AppConstants.watchlistUpdateLogs, currentLogs);
  } catch (e) {
    debugPrint('Error saving logs: $e');
  }
}
