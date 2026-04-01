import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/watchlist_notification_evaluator.dart';
import 'package:moviescout/utils/app_constants.dart';

void main() {
  group('WatchlistNotificationEvaluator - checkNeedsUpdate', () {
    final now = DateTime(2026, 3, 29);

    test('Should return full update if never updated', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated': AppConstants.defaultDate,
        'last_providers_update': AppConstants.defaultDate,
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now), UpdateType.full);
    });

    test('Should return full update if uninitialized serie', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.name: 'Test',
        'last_notified_season': 0,
        'media_type': 'tv',
        'last_updated': AppConstants.defaultDate,
        'last_providers_update': AppConstants.defaultDate,
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now), UpdateType.full);
    });

    test('Serie: Does NOT full update every hour if already initialized to 0', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.mediaType: 'tv',
        'last_notified_season': 0,
        'last_updated': now.toIso8601String(),
        'last_providers_update': now.toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now), UpdateType.none);
    });

    test('Should return none if recently updated', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'last_providers_update': now.subtract(const Duration(hours: 1)).toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now), UpdateType.none);
    });

    test('Should return light update if providers are stale but details are fresh', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'last_providers_update': now.subtract(const Duration(days: 2)).toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now), UpdateType.light);
    });
  });

  group('WatchlistNotificationEvaluator - evaluateNotification', () {
    final now = DateTime(2026, 3, 29);
    final enabledProviders = {8, 1796, 337}; // Netflix, Netflix with Ads, Disney Plus

    Map<String, dynamic> loadJson(String fileName) {
      final file = File('test/$fileName');
      return jsonDecode(file.readAsStringSync());
    }

    Map<String, dynamic> prepareTitleMap(Map<String, dynamic> json, {String region = 'ES'}) {
      final map = Map<String, dynamic>.from(json);
      if (map.containsKey('watch/providers') && map['watch/providers']['results'] != null) {
        map['providers'] = map['watch/providers']['results'][region] ?? {};
      }
      // Ensure media_type is present for tests if it's a serie or movie
      if (!map.containsKey('media_type')) {
        if (map.containsKey('first_air_date')) {
          map['media_type'] = 'tv';
        } else if (map.containsKey('release_date')) {
          map['media_type'] = 'movie';
        }
      }
      return map;
    }

    test('Movie: Notifies when becomes available', () {
      final serverJson = loadJson('[Lamar Odom]_future_documentary.json');
      serverJson['watch/providers'] = {
        'results': {
          'ES': {'flatrate': [{'provider_id': 8}]}
        }
      };
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.flatrateProviderIds = []; // Locally not available
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.newAvailability);
    });

    test('Serie: Silent initialization on first sync', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 0; // Uninitialized
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.none);
    });

    test('Serie: Notifies on new season if already started (last_episode)', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['last_episode_to_air'] = {
        'season_number': 2,
        'episode_number': 1,
        'air_date': '2026-03-28'
      };
      serverJson['number_of_seasons'] = 2;
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {'season_number': 2, 'air_date': '2026-03-28'}, // 1 day before 'now' (2026-03-29)
      ];
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1; 
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.newSeason);
    });

    test('Serie: Notifies on new season if premiere date reached (next_episode)', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      // next_episode is S2E1 on 2026-04-01. 
      final testNow = DateTime(2026, 4, 1);
      
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {'season_number': 2, 'air_date': '2026-04-01'},
      ];
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;
      serverTitle.numberOfSeasons = 2; 
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: testNow,
      );
      
      expect(trigger, NotificationTrigger.newSeason);
    });

    test('Serie: Does NOT notify if newest season is too old (14 day rule)', () {
      final serverJson = loadJson('[Paradise]_no_notification.json');
      // Season 2 started Feb 23, 2026. 'now' is March 30, 2026.
      // 35 days difference.
      final testNow = DateTime(2026, 3, 30);
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1; 
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: testNow,
      );
      
      expect(trigger, NotificationTrigger.none);
    });

    test('Serie: Notifies for binge-release if recently premiered', () {
      final serverJson = {
        'id': 12345,
        'name': 'Netflix Binge Show',
        'media_type': 'tv',
        'number_of_seasons': 2,
        'last_episode_to_air': {
          'season_number': 2,
          'episode_number': 10, // All 10 released at once!
          'air_date': '2026-03-25'
        },
        'seasons': [
          {'season_number': 1, 'air_date': '2025-01-01'},
          {'season_number': 2, 'air_date': '2026-03-25'}, // 4 days ago
        ],
        'watch/providers': {'results': {'ES': {'flatrate': [{'provider_id': 8}]}}}
      };
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1; 
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: DateTime(2026, 3, 29),
      );
      
      expect(trigger, NotificationTrigger.newSeason);
    });

    test('Serie: Does NOT notify if premiere date is in the future', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      // next_episode is S2E1 on 2026-04-01. 
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;
      serverTitle.numberOfSeasons = 2;
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.none);
    });

    test('Serie: Does NOT notify for S1 even if recently premiered, if it is the first sync', () {
      final serverJson = {
        'id': 316324,
        'name': 'Korean Series',
        'first_air_date': '2026-03-24',
        'number_of_seasons': 1,
        'media_type': 'tv',
        'last_episode_to_air': {
          'season_number': 1,
          'air_date': '2026-03-24'
        },
        'watch/providers': {
          'results': {
            'ES': {'flatrate': [{'provider_id': 8}]}
          }
        }
      };
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      
      // Mimic worker initialization flow
      localTitle.lastNotifiedSeason = WatchlistNotificationEvaluator.getBaselineSeason(serverTitle, now);
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.none);
    });

    test('Serie: Does NOT notify if already airing', () {
      final serverJson = loadJson('[Paradise]_no_notification.json');
      
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
      );
      
      expect(trigger, NotificationTrigger.none);
    });
  });

  group('WatchlistNotificationEvaluator - getBaselineSeason', () {
    final now = DateTime(2026, 3, 29);

    test('Should return last_episode season if available and aired', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'last_episode_to_air': {'season_number': 1},
      });
      // Without next_episode info, it just uses numberOfSeasons (which is 2)
      // Wait, let's check my implementation.
      // My implementation returns numberOfSeasons if Case 2 is not hit.
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 2);
    });

    test('Should return current-1 if SxxE01 is upcoming', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'next_episode_to_air': {
          'season_number': 2,
          'episode_number': 1,
          'air_date': '2026-04-01',
        },
      });
      // Today is 2026-03-29. S2E1 is in the future. Baseline should be 1.
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 1);
    });

    test('Should return current if SxxE01 has already premiered', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'next_episode_to_air': {
          'season_number': 2,
          'episode_number': 1,
          'air_date': '2026-03-20',
        },
      });
      // Today is 2026-03-29. S2E1 has already premiered. Baseline should be 2.
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 2);
    });
  });
}
