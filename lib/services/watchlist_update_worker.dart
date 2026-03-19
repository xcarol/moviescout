import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/saved_notification.dart';
import 'dart:convert';

bool _isBrandNewSeason(List<String> logLines, Map<String, dynamic>? nextEpisode,
    Map<String, dynamic>? lastEpisode, int currentSeason, String titleName) {
  if (nextEpisode != null) {
    try {
      final nextSeason = nextEpisode['season_number'] as int;
      final airDateStr = nextEpisode['air_date'] as String?;

      if (nextSeason == currentSeason && airDateStr != null) {
        final airDate = DateTime.tryParse(airDateStr);
        if (airDate != null &&
            airDate
                .isAfter(DateTime.now().subtract(const Duration(days: 14)))) {
          logLines.add(
              '- init: $titleName S$nextSeason is future or recent ($airDateStr). Considering brand new.');
          return true;
        }
      }
    } catch (_) {}
  }

  if (lastEpisode != null) {
    try {
      final lastSeason = lastEpisode['season_number'] as int;
      final airDateStr = lastEpisode['air_date'] as String?;

      if (lastSeason == currentSeason && airDateStr != null) {
        final airDate = DateTime.tryParse(airDateStr);
        if (airDate != null &&
            airDate
                .isAfter(DateTime.now().subtract(const Duration(days: 14)))) {
          logLines.add(
              '- init: $titleName S$lastSeason premiered recently ($airDateStr). Considering brand new.');
          return true;
        }
      }
    } catch (_) {}
  }

  return false;
}

bool _hasNewSeasonStarted(
    List<String> logLines,
    Map<String, dynamic>? nextEpisode,
    Map<String, dynamic>? lastEpisode,
    int currentSeason,
    String titleName) {
  if (lastEpisode != null &&
      (lastEpisode['season_number'] as int) == currentSeason) {
    logLines
        .add('- check: $titleName S$currentSeason has already started airing.');
    return true;
  } else if (nextEpisode != null) {
    try {
      final nextSeason = nextEpisode['season_number'] as int;
      final nextEpisodeNum = nextEpisode['episode_number'] as int;
      final airDateStr = nextEpisode['air_date'] as String?;

      if (nextSeason == currentSeason &&
          nextEpisodeNum == 1 &&
          airDateStr != null) {
        final airDate = DateTime.tryParse(airDateStr);
        if (airDate != null && airDate.isBefore(DateTime.now())) {
          logLines.add(
              '- check: $titleName S$nextSeason premiere has arrived ($airDateStr).');
          return true;
        }
      }
    } catch (_) {}
  }
  return false;
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final logLines = <String>[];
    int scannedCount = 0;
    int updatedCount = 0;
    int notifiedCount = 0;
    int skippedCount = 0;
    try {
      await dotenv.load(fileName: ".env");
      await PreferencesService().init();
      await IsarService.init();
      await NotificationService().init();

      logLines.add('---------------------------');
      logLines.add(
          'Start: ${DateTime.now().toLocal().toString().split('.').first}');
      logLines.add('---------------------------');

      final providersStrings =
          PreferencesService().prefs.getStringList('providers') ?? [];
      final List<dynamic> providersList =
          providersStrings.map((s) => jsonDecode(s)).toList();

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

      final watchlistTitles = await repository.getTitles(
        listName: AppConstants.watchlist,
        limit: repository.countTitlesSync(AppConstants.watchlist),
      );

      for (final title in watchlistTitles) {
        scannedCount++;
        final isUninitialized = title.isSerie && title.lastNotifiedSeason == 0;
        final needsFull = DateTime.now()
                    .difference(DateTime.parse(title.lastUpdated))
                    .inDays >=
                AppConstants.watchlistTitleUpdateFrequencyDays ||
            isUninitialized;
        final needsLight = DateTime.now()
                .difference(DateTime.parse(title.lastProvidersUpdate))
                .inDays >=
            AppConstants.watchlistProvidersUpdateFrequencyDays;

        if (needsFull || needsLight) {
          if (updatedCount >= AppConstants.watchlistMaxUpdatesPerRun) {
            logLines.add('- Max updates per run reached ($updatedCount)');
            break;
          }
          updatedCount++;
          final oldProviders = title.flatrateProviderIds.toSet();
          final enabledProviderSet = enabledProviderIds.toSet();
          final wasAvailable =
              oldProviders.intersection(enabledProviderSet).isNotEmpty;

          if (needsFull) {
            logLines.add(
                '- Full update: ${title.name}. lastUpdated: ${title.lastUpdated}');
            await titleService.updateTitleDetails(title);
          } else {
            logLines.add(
                '- Light update: ${title.name}. lastProvidersUpdate: ${title.lastProvidersUpdate}');
            await titleService.updateTitleLight(title);
          }
          await repository.updateTitleMetadata(title);

          final oldProviderNames = providersList
              .where((p) => oldProviders.contains(p[TmdbProvider.providerId]))
              .map((p) => p[TmdbProvider.providerName])
              .toList();
          final newProviderNames = providersList
              .where((p) => title.flatrateProviderIds
                  .contains(p[TmdbProvider.providerId]))
              .map((p) => p[TmdbProvider.providerName])
              .toList();

          if (oldProviderNames.join(', ') != newProviderNames.join(', ')) {
            logLines.add('- Old providers: ${oldProviderNames.join(', ')}');
            logLines.add('- New providers: ${newProviderNames.join(', ')}');
          }

          final newProviders = title.flatrateProviderIds.toSet();
          final isAvailable =
              newProviders.intersection(enabledProviderSet).isNotEmpty;

          if (isAvailable) {
            final availableProviderNames = providersList
                .where((p) => newProviders.contains(p[TmdbProvider.providerId]))
                .map((p) => p[TmdbProvider.providerName])
                .toList();

            if (availableProviderNames.isNotEmpty) {
              logLines.add(
                  '- Available: ${title.name} at ${availableProviderNames.join(', ')}');
            }

            if (!wasAvailable) {
              // Title just became available
              logLines.add(
                  '- Sending notification for ${title.name} (Now available)');
              await NotificationService().showNotification(
                id: title.tmdbId,
                title: localizations.notificationTitle,
                body: localizations.notificationBody(title.name),
                imageUrl: title.posterPath,
                payload: '${title.mediaType}|${title.tmdbId}',
              );
              await _saveNotification(SavedNotification(
                id: title.tmdbId,
                title: title.name,
                body: localizations.notificationTitle,
                imageUrl: title.posterPath,
                payload: '${title.mediaType}|${title.tmdbId}',
                timestamp: DateTime.now(),
              ));
              notifiedCount++;
              if (title.isSerie) {
                title.lastNotifiedSeason = title.numberOfSeasons;
                await repository.updateTitleMetadata(title);
              }
            } else if (title.isSerie) {
              final currentSeason = title.numberOfSeasons;

              // Initialize lastNotifiedSeason if it's 0 (first run with this feature)
              if (title.lastNotifiedSeason == 0 && currentSeason > 0) {
                final isBrandNew = _isBrandNewSeason(
                    logLines,
                    title.nextEpisodeToAir,
                    title.lastEpisodeToAir,
                    currentSeason,
                    title.name);

                if (isBrandNew) {
                  title.lastNotifiedSeason = currentSeason - 1;
                  logLines.add(
                      '- Initializing lastNotifiedSeason = ${currentSeason - 1} for ${title.name} (brand new season)');
                } else {
                  title.lastNotifiedSeason = currentSeason;
                  logLines.add(
                      '- Initializing lastNotifiedSeason = $currentSeason for ${title.name}');
                }
                await repository.updateTitleMetadata(title);
              }

              if (currentSeason > title.lastNotifiedSeason) {
                final shouldNotify = _hasNewSeasonStarted(
                    logLines,
                    title.nextEpisodeToAir,
                    title.lastEpisodeToAir,
                    currentSeason,
                    title.name);

                if (shouldNotify) {
                  logLines.add(
                      '- Sending notification for new season of ${title.name} (${title.numberOfSeasons} seasons)');
                  await NotificationService().showNotification(
                    id: title.tmdbId + 1000000,
                    title: localizations.notificationNewSeasonTitle,
                    body: localizations.notificationNewSeasonBody(title.name),
                    imageUrl: title.posterPath,
                    payload: '${title.mediaType}|${title.tmdbId}',
                  );
                  await _saveNotification(SavedNotification(
                    id: title.tmdbId + 1000000,
                    title: title.name,
                    body: localizations.notificationNewSeasonTitle,
                    imageUrl: title.posterPath,
                    payload: '${title.mediaType}|${title.tmdbId}',
                    timestamp: DateTime.now(),
                  ));
                  notifiedCount++;
                  title.lastNotifiedSeason = currentSeason;
                  await repository.updateTitleMetadata(title);
                } else {
                  logLines.add(
                      '- Found new season for ${title.name} but rules forbid notification. '
                      'Next: ${title.nextEpisodeToAir?['air_date']} | Last: ${title.lastEpisodeToAir?['air_date']}');
                }
              }
            } else {
              logLines.add(
                  '- No notification needed for ${title.name}. Already available at ${availableProviderNames.join(', ')}.');
            }
          } else {
            if (wasAvailable) {
              logLines.add(
                  '- Title ${title.name} is no longer available on enabled providers.');
            }
            if (title.isSerie &&
                title.lastNotifiedSeason == 0 &&
                title.numberOfSeasons > 0) {
              // initialize silently
              logLines.add(
                  '- Initializing silently ${title.name} (${title.numberOfSeasons} seasons)');
              title.lastNotifiedSeason = title.numberOfSeasons;
              await repository.updateTitleMetadata(title);
            }
          }

          await Future.delayed(const Duration(milliseconds: 200));
        } else {
          skippedCount++;
        }
      }

      await PreferencesService().prefs.setString(
            AppConstants.lastBackgroundRun,
            DateTime.now().toIso8601String(),
          );

      logLines.add(
          'Summary: $scannedCount scanned - $updatedCount updated - $skippedCount skipped - $notifiedCount notified');
      logLines.add('---------------------------');
      logLines
          .add('End: ${DateTime.now().toLocal().toString().split('.').first}');
      logLines.add('---------------------------');
      await _saveLogs(logLines);

      return Future.value(true);
    } catch (error, stackTrace) {
      logLines.add('ERROR: $error\n$stackTrace');
      logLines.add(
          'Summary: $scannedCount scanned - $updatedCount updated (Interrupted)');
      await _saveLogs(logLines);

      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error in background task',
        showSnackBar: false,
      );
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

Future<void> _saveNotification(SavedNotification notification) async {
  try {
    final prefs = PreferencesService().prefs;
    final currentListStr =
        prefs.getStringList(AppConstants.savedNotifications) ?? [];

    final currentList =
        currentListStr.map((e) => SavedNotification.fromJson(e)).toList();

    currentList.insert(0, notification);

    if (currentList.length > 20) {
      currentList.removeRange(20, currentList.length);
    }

    final newListStr = currentList.map((e) => e.toJson()).toList();
    await prefs.setStringList(AppConstants.savedNotifications, newListStr);
  } catch (e) {
    debugPrint('Error saving notification: $e');
  }
}
