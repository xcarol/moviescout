import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/saved_notification.dart';
import 'package:moviescout/services/watchlist_notification_evaluator.dart';
import 'package:moviescout/utils/save_logs.dart';

Future<bool> updateTitle(
    TmdbTitle title,
    bool fullUpdate,
    List<String> logLines,
    List<dynamic> providersList,
    List<int> enabledProviderIds,
    TmdbTitleService titleService,
    TmdbTitleRepository repository,
    AppLocalizations localizations,
    DateTime now,
    bool notifyCompleteSeason) async {
  final titleBeforeUpdate = TmdbTitle.fromMap(title: title.toMap());

  if (fullUpdate) {
    logLines
        .add('FULL UPDATE: ${title.name}. lastUpdated: ${title.lastUpdated}');
    await titleService.updateTitleDetails(title);
  } else {
    logLines.add(
        'LIGHT UPDATE: ${title.name}. lastProvidersUpdate: ${title.lastProvidersUpdate}');
    await titleService.updateTitleLight(title);
  }

  if (title.lastNotifiedSeason == 0 && title.isSerie) {
    title.lastNotifiedSeason =
        WatchlistNotificationEvaluator.getBaselineSeason(title, now);
    await repository.updateTitleMetadata(title);
  }

  final trigger = WatchlistNotificationEvaluator.evaluateNotification(
    titleBeforeUpdate: titleBeforeUpdate,
    titleAfterUpdate: title,
    enabledProviderIds: enabledProviderIds.toSet(),
    now: now,
    notifyCompleteSeason: notifyCompleteSeason,
    logLines: logLines,
  );

  if (trigger == NotificationTrigger.none) {
    if (fullUpdate ||
        titleBeforeUpdate.lastProvidersUpdate != title.lastProvidersUpdate) {
      await repository.updateTitleMetadata(title);
    }
    return false;
  }

  // Handle Notifications
  final availableProviderIds = title.flatrateProviderIds
      .where((id) => enabledProviderIds.contains(id))
      .toList();

  String providerName = '';
  if (availableProviderIds.isNotEmpty) {
    final firstId = availableProviderIds.first;
    for (final p in providersList) {
      if (p is Map && p[TmdbProvider.providerId] == firstId) {
        providerName = TmdbProvider(provider: p).name;
        break;
      }
    }
  }

  if (trigger == NotificationTrigger.newAvailability) {
    logLines.add('- Sending notification for ${title.name} (Now available)');

    await NotificationService().showNotification(
      id: title.tmdbId,
      title: localizations.notificationTitle,
      body: localizations.notificationBody(title.name, providerName),
      imageUrl: title.posterPath,
      payload: '${title.mediaType}|${title.tmdbId}',
    );
    await _saveNotification(SavedNotification(
      id: title.tmdbId,
      title: title.name,
      body: localizations.notificationTitle,
      imageUrl: title.posterPath,
      payload: '${title.mediaType}|${title.tmdbId}',
      timestamp: now,
      providerIds: availableProviderIds,
    ));

    if (title.isSerie) {
      title.lastNotifiedSeason = title.numberOfSeasons;
    }
    title.isSnoozed = false;
    await repository.updateTitleMetadata(title);
    return true;
  }

  if (trigger == NotificationTrigger.newSeason) {
    logLines.add(
        '- Sending notification for new season of ${title.name} (${title.numberOfSeasons} seasons)');

    await NotificationService().showNotification(
      id: title.tmdbId + 1000000,
      title: localizations.notificationNewSeasonTitle,
      body: localizations.notificationNewSeasonBody(providerName, title.name),
      imageUrl: title.posterPath,
      payload: '${title.mediaType}|${title.tmdbId}',
    );

    await _saveNotification(SavedNotification(
      id: title.tmdbId + 1000000,
      title: title.name,
      body: localizations.notificationNewSeasonTitle,
      imageUrl: title.posterPath,
      payload: '${title.mediaType}|${title.tmdbId}',
      timestamp: now,
      providerIds: availableProviderIds,
    ));

    title.lastNotifiedSeason = title.numberOfSeasons;
    title.isSnoozed = false;

    if (!title.inLists.contains(AppConstants.watchlist)) {
      title.inLists = [...title.inLists, AppConstants.watchlist];
      final accountId = PreferencesService().prefs.getString('accountId') ?? '';
      final sessionId = PreferencesService().prefs.getString('sessionId') ?? '';
      if (accountId.isNotEmpty && sessionId.isNotEmpty) {
        final watchlistService =
            TmdbWatchlistService(AppConstants.watchlist, repository);
        await watchlistService.updateWatchlistTitle(
            accountId, sessionId, title, true);
      }
    }

    await repository.updateTitleMetadata(title);
    return true;
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

      final notifyCompleteSeason = PreferencesService()
              .prefs
              .getBool(AppConstants.notifyCompleteSeason) ??
          false;

      final repository = TmdbTitleRepository();
      final titleService = TmdbTitleService();

      final watchlistTitles = await repository.getTitles(
        listName: AppConstants.watchlist,
        limit: repository.countTitlesSync(AppConstants.watchlist),
      );

      final snoozedTitles = await repository.getTitles(
        listName: AppConstants.rateslist,
        filterRating: RatingFilter.snoozedOnly,
        limit: await repository.countTitlesFiltered(
            listName: AppConstants.rateslist,
            filterRating: RatingFilter.snoozedOnly),
      );

      final allTitlesMap = <String, TmdbTitle>{};
      for (final title in watchlistTitles) {
        allTitlesMap['${title.mediaType}_${title.tmdbId}'] = title;
      }
      for (final title in snoozedTitles) {
        allTitlesMap['${title.mediaType}_${title.tmdbId}'] = title;
      }
      final allTitlesToScan = allTitlesMap.values.toList();

      for (final title in allTitlesToScan) {
        scannedCount++;
        final now = DateTime.now();
        UpdateType updateType =
            WatchlistNotificationEvaluator.checkNeedsUpdate(title, now);

        if (updateType == UpdateType.none) {
          skippedCount++;
          continue;
        }

        if (updatedCount >= AppConstants.watchlistMaxUpdatesPerRun) {
          logLines.add('- Max updates per run reached ($updatedCount)');
          break;
        }

        updatedCount++;
        final notified = await updateTitle(
            title,
            updateType == UpdateType.full,
            logLines,
            providersList,
            enabledProviderIds,
            titleService,
            repository,
            localizations,
            now,
            notifyCompleteSeason);

        if (notified) {
          notifiedCount++;
        }

        await Future.delayed(const Duration(milliseconds: 200));
        logLines.add('');
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
      await saveLogs(logLines);

      return Future.value(true);
    } catch (error, stackTrace) {
      logLines.add('ERROR: $error\n$stackTrace');
      logLines.add(
          'Summary: $scannedCount scanned - $updatedCount updated (Interrupted)');
      await saveLogs(logLines);

      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error in background task',
      );
      return Future.value(false);
    }
  });
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
