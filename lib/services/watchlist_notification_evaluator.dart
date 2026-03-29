import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_constants.dart';

enum UpdateType { none, full, light }

enum NotificationTrigger { none, newAvailability, newSeason }

class WatchlistNotificationEvaluator {
  static UpdateType checkNeedsUpdate(TmdbTitle title, DateTime now) {
    final isUninitialized = title.isSerie && title.lastNotifiedSeason == 0;
    
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
    final wasAvailable = oldProviders.intersection(enabledProviderIds).isNotEmpty;

    final newProviders = titleAfterUpdate.flatrateProviderIds.toSet();
    final isAvailable = newProviders.intersection(enabledProviderIds).isNotEmpty;

    if (isAvailable && !wasAvailable) {
      logLines?.add('- Notification Trigger: Title ${titleAfterUpdate.name} is now available.');
      return NotificationTrigger.newAvailability;
    }

    if (isAvailable && titleAfterUpdate.isSerie) {
      final currentSeason = titleAfterUpdate.numberOfSeasons;
      final lastNotified = titleBeforeUpdate.lastNotifiedSeason;

      if (currentSeason > lastNotified) {
        if (_hasNewSeasonStarted(
          logLines ?? [],
          titleAfterUpdate.nextEpisodeToAir,
          titleAfterUpdate.lastEpisodeToAir,
          currentSeason,
          now,
          titleAfterUpdate.name,
        )) {
          logLines?.add('- Notification Trigger: New season started for ${titleAfterUpdate.name}.');
          return NotificationTrigger.newSeason;
        } else {
          logLines?.add('- Found new season for ${titleAfterUpdate.name} but premiere date not reached.');
        }
      }
    }

    return NotificationTrigger.none;
  }

  static bool _hasNewSeasonStarted(
    List<String> logLines,
    Map<String, dynamic>? nextEpisode,
    Map<String, dynamic>? lastEpisode,
    int currentSeason,
    DateTime now,
    String titleName,
  ) {
    if (lastEpisode != null &&
        (lastEpisode['season_number'] as int) == currentSeason) {
      logLines.add('- check: $titleName S$currentSeason has already started airing.');
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
          if (airDate != null && (airDate.isBefore(now) || airDate.isAtSameMomentAs(now))) {
            logLines.add('- check: $titleName S$nextSeason premiere has arrived ($airDateStr).');
            return true;
          }
        }
      } catch (_) {}
    }
    return false;
  }
}
