import 'dart:convert';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_constants.dart';

enum UpdateType { none, full, light }

enum NotificationTrigger { none, newAvailability, newSeason }

class WatchlistNotificationEvaluator {
  static UpdateType checkNeedsUpdate(TmdbTitle title, DateTime now) {
    final isUninitialized = title.isSerie &&
        title.lastNotifiedSeason == 0 &&
        title.lastUpdated == AppConstants.defaultDate;

    // Check for full update (details and providers)
    final lastUpdated = DateTime.tryParse(title.lastUpdated) ??
        DateTime.parse(AppConstants.defaultDate);
    final needsFull = now.difference(lastUpdated).inDays >=
            AppConstants.watchlistTitleUpdateFrequencyDays ||
        isUninitialized;

    if (needsFull) {
      return UpdateType.full;
    }

    // Check for light update (providers only)
    final lastProvidersUpdate = DateTime.tryParse(title.lastProvidersUpdate) ??
        DateTime.parse(AppConstants.defaultDate);
    final needsLight = now.difference(lastProvidersUpdate).inDays >=
        AppConstants.watchlistProvidersUpdateFrequencyDays;

    if (needsLight) {
      return UpdateType.light;
    }

    return UpdateType.none;
  }

  static int getBaselineSeason(TmdbTitle title, DateTime now) {
    final currentSeason = title.numberOfSeasons;
    final nextEpisode = title.nextEpisodeToAir;

    if (nextEpisode != null &&
        nextEpisode['episode_number'] == 1 &&
        nextEpisode['season_number'] != null) {
      final nextSeason = nextEpisode['season_number'] as int;
      final airDateStr = nextEpisode['air_date'] as String?;
      if (airDateStr != null) {
        final airDate = DateTime.tryParse(airDateStr);
        if (airDate != null && airDate.isAfter(now)) {
          return nextSeason - 1;
        }
      }
    }

    return currentSeason;
  }

  static NotificationTrigger evaluateNotification({
    required TmdbTitle titleBeforeUpdate,
    required TmdbTitle titleAfterUpdate,
    required Set<int> enabledProviderIds,
    required DateTime now,
    List<String>? logLines,
  }) {
    final oldProviders = titleBeforeUpdate.flatrateProviderIds.toSet();
    final wasAvailable =
        oldProviders.intersection(enabledProviderIds).isNotEmpty;

    final newProviders = titleAfterUpdate.flatrateProviderIds.toSet();
    final isAvailable =
        newProviders.intersection(enabledProviderIds).isNotEmpty;

    if (isAvailable && !wasAvailable) {
      logLines?.add(
          '- Notification Trigger: Title ${titleAfterUpdate.name} is now available.');
      return NotificationTrigger.newAvailability;
    }

    if (isAvailable && titleAfterUpdate.isSerie) {
      final currentSeason = titleAfterUpdate.numberOfSeasons;
      final lastNotified = titleBeforeUpdate.lastNotifiedSeason;

      if (currentSeason > lastNotified) {
        if (_hasNewSeasonStarted(
          logLines ?? [],
          titleAfterUpdate,
          currentSeason,
          now,
        )) {
          logLines?.add(
              '- Notification Trigger: New season started for ${titleAfterUpdate.name}.');
          return NotificationTrigger.newSeason;
        } else {
          logLines?.add(
              '- Found new season for ${titleAfterUpdate.name} but premiere date not reached or too old.');
        }
      }
    }

    return NotificationTrigger.none;
  }

  static bool _hasNewSeasonStarted(
    List<String> logLines,
    TmdbTitle title,
    int currentSeason,
    DateTime now,
  ) {
    final lastEpisode = title.lastEpisodeToAir;
    final nextEpisode = title.nextEpisodeToAir;
    final titleName = title.name;

    if (lastEpisode != null &&
        (lastEpisode['season_number'] as int) == currentSeason) {
      final seasonAirDate = _getSeasonAirDate(title, currentSeason);
      if (seasonAirDate != null) {
        final daysSinceStart = now.difference(seasonAirDate).inDays;
        if (daysSinceStart >= 0 &&
            daysSinceStart <
                AppConstants.watchlistNewSeasonNotificationWindowDays) {
          logLines.add(
              '- check: $titleName S$currentSeason started $daysSinceStart days ago. Notify.');
          return true;
        } else {
          logLines.add(
              '- check: $titleName S$currentSeason started $daysSinceStart days ago. Too old.');
        }
      } else {
        // Fallback if no season air date: use the old "Episode 1" rule as a safe default
        if ((lastEpisode['episode_number'] as int) == 1) {
          logLines.add(
              '- check: $titleName S$currentSeason has no date but episode is 1. Notify.');
          return true;
        }
      }
    }

    if (nextEpisode != null) {
      try {
        final nextSeason = nextEpisode['season_number'] as int;
        final nextEpisodeNum = nextEpisode['episode_number'] as int;
        if (nextSeason == currentSeason && nextEpisodeNum == 1) {
          final airDateStr = nextEpisode['air_date'] as String?;
          if (airDateStr != null) {
            final airDate = DateTime.tryParse(airDateStr);
            if (airDate != null &&
                airDate.isBefore(now.add(const Duration(seconds: 1)))) {
              final daysSinceStart = now.difference(airDate).inDays;
              if (daysSinceStart >= 0 &&
                  daysSinceStart <
                      AppConstants.watchlistNewSeasonNotificationWindowDays) {
                logLines.add(
                    '- check: $titleName S$currentSeason premiered today/recently via next_episode. Notify.');
                return true;
              }
            }
          }
        }
      } catch (e) {
        logLines.add('- Error parsing nextEpisode air date: $e');
      }
    }

    return false;
  }

  static DateTime? _getSeasonAirDate(TmdbTitle title, int seasonNumber) {
    if (title.seasonsJson == null) return null;
    try {
      final List<dynamic> seasons = jsonDecode(title.seasonsJson!);
      for (var season in seasons) {
        if (season['season_number'] == seasonNumber) {
          final airDateStr = season['air_date'] as String?;
          if (airDateStr != null) {
            return DateTime.tryParse(airDateStr);
          }
        }
      }
    } catch (_) {}
    return null;
  }
}
