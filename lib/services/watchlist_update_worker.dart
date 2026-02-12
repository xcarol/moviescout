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

bool _isBrandNewSeason(Map<String, dynamic>? nextEpisode, int currentSeason) {
  if (nextEpisode == null) return false;

  try {
    final nextSeason = nextEpisode['season_number'] as int;
    final nextEpisodeNum = nextEpisode['episode_number'] as int;
    final airDateStr = nextEpisode['air_date'] as String?;

    if (nextSeason == currentSeason &&
        nextEpisodeNum == 1 &&
        airDateStr != null) {
      final airDate = DateTime.tryParse(airDateStr);
      if (airDate != null &&
          airDate.isBefore(DateTime.now().add(const Duration(days: 1)))) {
        return true;
      }
    }
  } catch (_) {}
  return false;
}

bool _hasNewSeasonStarted(Map<String, dynamic>? nextEpisode,
    Map<String, dynamic>? lastEpisode, int currentSeason) {
  if (lastEpisode != null &&
      (lastEpisode['season_number'] as int) == currentSeason) {
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
        if (airDate != null &&
            airDate.isBefore(DateTime.now().add(const Duration(days: 1)))) {
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
    try {
      await dotenv.load(fileName: ".env");
      await PreferencesService().init();
      await IsarService.init();
      await NotificationService().init();

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

            final newProviders = title.flatrateProviderIds.toSet();
            final isAvailable =
                newProviders.intersection(enabledProviderSet).isNotEmpty;

            if (isAvailable) {
              if (!wasAvailable) {
                await NotificationService().showNotification(
                  id: title.tmdbId,
                  title: localizations.notificationTitle,
                  body: localizations.notificationBody(title.name),
                  imageUrl: title.posterPath,
                  payload: '${title.mediaType}|${title.tmdbId}',
                );
                if (title.isSerie) {
                  title.lastNotifiedSeason = title.numberOfSeasons;
                  await repository.saveTitle(title);
                }
              } else if (title.isSerie) {
                final currentSeason = title.numberOfSeasons;

                // Initialize lastNotifiedSeason if it's 0 (first run with this feature)
                if (title.lastNotifiedSeason == 0 && currentSeason > 0) {
                  final isBrandNew =
                      _isBrandNewSeason(title.nextEpisodeToAir, currentSeason);

                  if (isBrandNew) {
                    title.lastNotifiedSeason = currentSeason - 1;
                  } else {
                    title.lastNotifiedSeason = currentSeason;
                  }
                  await repository.saveTitle(title);
                }

                if (currentSeason > title.lastNotifiedSeason) {
                  final shouldNotify = _hasNewSeasonStarted(
                      title.nextEpisodeToAir,
                      title.lastEpisodeToAir,
                      currentSeason);

                  if (shouldNotify) {
                    await NotificationService().showNotification(
                      id: title.tmdbId + 1000000,
                      title: localizations.notificationNewSeasonTitle,
                      body: localizations.notificationNewSeasonBody(title.name),
                      imageUrl: title.posterPath,
                      payload: '${title.mediaType}|${title.tmdbId}',
                    );
                    title.lastNotifiedSeason = currentSeason;
                    await repository.saveTitle(title);
                  } else {}
                }
              }
            } else {
              if (title.isSerie &&
                  title.lastNotifiedSeason == 0 &&
                  title.numberOfSeasons > 0) {
                // initialize silently
                title.lastNotifiedSeason = title.numberOfSeasons;
                await repository.saveTitle(title);
              }
            }

            await Future.delayed(const Duration(milliseconds: 200));
          }
        }

        page++;
        if (watchlistTitles.length < pageSize) {
          hasMore = false;
        }
      }

      await PreferencesService().prefs.setString(
            AppConstants.lastBackgroundRun,
            DateTime.now().toIso8601String(),
          );

      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('Error in background task: $e');
      debugPrint(stackTrace.toString());

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
