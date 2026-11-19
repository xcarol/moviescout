import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/notifications/services/watchlist_notification_evaluator.dart';
import 'package:moviescout/core/utils/app_constants.dart';

void main() {
  Map<String, dynamic> loadJson(String fileName) {
    final file = File('test/test_data/$fileName');
    return jsonDecode(file.readAsStringSync());
  }

  group('WatchlistNotificationEvaluator - checkNeedsUpdate', () {
    final now = DateTime(2026, 3, 29);

    test('Should return light update if never updated', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated': AppConstants.defaultDate,
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.light);
    });

    test('Should return light update if uninitialized serie', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.name: 'Test',
        'last_notified_season': AppConstants.seasonNotInitialized,
        'media_type': 'tv',
        'last_updated': now.toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.light);
    });

    test(
        'Movie: Should return none if recently updated even with seasonNotInitialized',
        () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test Movie',
        TmdbTitleFields.mediaType: 'movie',
        'last_notified_season': AppConstants.seasonNotInitialized,
        'last_updated':
            now.subtract(const Duration(hours: 1)).toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.none);
    });

    test('Serie: Does NOT full update every hour if already initialized to 0',
        () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.mediaType: 'tv',
        'last_notified_season': 0,
        'last_updated': now.toIso8601String(),
        'last_providers_update': now.toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.none);
    });

    test('Should return none if recently updated', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated':
            now.subtract(const Duration(hours: 1)).toIso8601String(),
        'last_providers_update':
            now.subtract(const Duration(hours: 1)).toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.none);
    });

    test('Should return light update if title is stale (>= 1 day)', () {
      final title = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.title: 'Test',
        'last_updated': now.subtract(const Duration(days: 2)).toIso8601String(),
      });
      expect(WatchlistNotificationEvaluator.checkNeedsUpdate(title, now),
          UpdateType.light);
    });
  });

  group('WatchlistNotificationEvaluator - evaluateNotification', () {
    final now = DateTime(2026, 3, 29);
    final enabledProviders = {
      8,
      1796,
      337
    }; // Netflix, Netflix with Ads, Disney Plus

    Map<String, dynamic> prepareTitleMap(Map<String, dynamic> json,
        {String region = 'ES'}) {
      final map = Map<String, dynamic>.from(json);
      if (map.containsKey('watch/providers') &&
          map['watch/providers']['results'] != null) {
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
      map['last_updated'] =
          now.subtract(const Duration(days: 1)).toIso8601String();
      return map;
    }

    test('Movie: Notifies when becomes available', () {
      final serverJson = loadJson('[Lamar Odom]_future_documentary.json');
      serverJson['watch/providers'] = {
        'results': {
          'ES': {
            'flatrate': [
              {'provider_id': 8}
            ]
          }
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
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.newAvailability);
    });

    test(
        'First sync: Does NOT notify even if available when titleBeforeUpdate.lastUpdated == defaultDate',
        () {
      final serverJson = loadJson('[Lamar Odom]_future_documentary.json');
      serverJson['watch/providers'] = {
        'results': {
          'ES': {
            'flatrate': [
              {'provider_id': 8}
            ]
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastUpdated = AppConstants.defaultDate;
      localTitle.flatrateProviderIds = [];

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.none);
    });

    test(
        'Movie: Does NOT notify if already available or removed from providers',
        () {
      final serverJson = loadJson('[Lamar Odom]_future_documentary.json');
      serverJson['watch/providers'] = {
        'results': {
          'ES': {
            'flatrate': [
              {'provider_id': 8}
            ]
          }
        }
      };

      final availableTitle =
          TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localAvailable =
          TmdbTitle.fromMap(title: prepareTitleMap(serverJson));

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localAvailable,
          titleAfterUpdate: availableTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: false,
        ),
        NotificationTrigger.none,
      );

      final removedTitle =
          TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      removedTitle.flatrateProviderIds = [];

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localAvailable,
          titleAfterUpdate: removedTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: false,
        ),
        NotificationTrigger.none,
      );
    });

    test('Serie: Silent initialization on first sync', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastUpdated = AppConstants.defaultDate;
      localTitle.lastNotifiedSeason = AppConstants.seasonNotInitialized;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
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
        {
          'season_number': 2,
          'air_date': '2026-03-28'
        }, // 1 day before 'now' (2026-03-29)
      ];

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.newSeason);
    });

    test(
        'Serie: Notifies on new season if premiere date reached (next_episode)',
        () {
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
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.newSeason);
    });

    test('Serie: Does NOT notify if newest season is too old (14 day rule)',
        () {
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
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.seasonTooOld);
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
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: DateTime(2026, 3, 29),
        notifyCompleteSeason: false,
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
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.none);
    });

    test(
        'Serie: Does NOT notify for S1 even if recently premiered, if it is the first sync',
        () {
      final serverJson = {
        'id': 316324,
        'name': 'Korean Series',
        'first_air_date': '2026-03-24',
        'number_of_seasons': 1,
        'media_type': 'tv',
        'last_episode_to_air': {'season_number': 1, 'air_date': '2026-03-24'},
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));

      // Mimic worker initialization flow
      localTitle.lastNotifiedSeason =
          WatchlistNotificationEvaluator.getBaselineSeason(serverTitle, now);

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.none);
    });

    test('Serie: Does NOT notify if already airing', () {
      final serverJson = loadJson('[Paradise]_no_notification.json');

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
        localTitle,
        now,
        notifyCompleteSeason: false,
      );

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.none);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Does NOT notify if next episode belongs to current season',
        () {
      final serverJson = {
        'id': 12345,
        'name': 'Weekly Show',
        'media_type': 'tv',
        'number_of_seasons': 2,
        'last_episode_to_air': {
          'season_number': 2,
          'episode_number': 5,
          'air_date': '2026-03-28' // aired yesterday
        },
        'next_episode_to_air': {
          'season_number': 2,
          'episode_number': 6,
          'air_date': '2026-04-04' // next week
        },
        'seasons': [
          {'season_number': 1, 'air_date': '2025-01-01'},
          {'season_number': 2, 'air_date': '2026-03-01'},
        ],
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );

      // Should wait till it ends
      expect(trigger, NotificationTrigger.none);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Notifies when season finishes airing completely',
        () {
      final serverJson = {
        'id': 12345,
        'name': 'Weekly Show',
        'media_type': 'tv',
        'number_of_seasons': 2,
        // Last episode of S2 finished recently
        'last_episode_to_air': {
          'season_number': 2,
          'episode_number': 10,
          'air_date': '2026-03-25' // ended 4 days ago
        },
        // No next episode, or next episode is S3 (null usually if not announced)
        'next_episode_to_air': null,
        'seasons': [
          {'season_number': 1, 'air_date': '2025-01-01'},
          {'season_number': 2, 'air_date': '2026-01-01'},
        ],
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );

      expect(trigger, NotificationTrigger.newSeason);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Does NOT notify newAvailability if title becomes available but season is incomplete',
        () {
      final serverJson = {
        'id': 99999,
        'name': 'Monsters of God',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 1,
          'air_date': '2026-03-25'
        },
        'next_episode_to_air': {
          'season_number': 1,
          'episode_number': 2,
          'air_date': '2026-04-01'
        },
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.flatrateProviderIds = [];
      localTitle.lastNotifiedSeason = 0;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );

      expect(trigger, NotificationTrigger.none);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Notifies newAvailability if title becomes available and season is already complete',
        () {
      final serverJson = {
        'id': 99999,
        'name': 'Monsters of God Completed',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 5,
          'air_date': '2026-03-25'
        },
        'next_episode_to_air': null,
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.flatrateProviderIds = [];
      localTitle.lastNotifiedSeason = 0;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );

      expect(trigger, NotificationTrigger.newAvailability);
    });

    test('Serie: Notifies on episode 1 fallback when season airDate is missing',
        () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['last_episode_to_air'] = {
        'season_number': 2,
        'episode_number': 1,
      };
      serverJson['number_of_seasons'] = 2;
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {'season_number': 2},
      ];

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final logLines = <String>[];
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: false,
        logLines: logLines,
      );

      expect(trigger, NotificationTrigger.newSeason);
      expect(logLines.any((l) => l.contains('episode is 1. Notify')), isTrue);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Does NOT notify if season ended too long ago',
        () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['number_of_seasons'] = 2;
      serverJson['next_episode_to_air'] = null;
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {
          'season_number': 2,
          'air_date': '2025-01-01',
          'episode_count': 10,
        },
      ];
      serverJson['last_episode_to_air'] = {
        'season_number': 2,
        'episode_number': 10,
        'air_date': '2025-01-15',
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final logLines = <String>[];
      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
        logLines: logLines,
      );

      expect(trigger, NotificationTrigger.seasonTooOld);
      expect(logLines.any((l) => l.contains('Too old')), isTrue);
    });

    test(
        'Serie: Marks as seasonTooOld when next_episode SxxE01 premiered >= 14 days ago',
        () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      // next_episode is S2E1 on 2026-04-01.
      final testNow = DateTime(2026, 4, 20);

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
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.seasonTooOld);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Two-pass flow notifies when S1 becomes complete after arriving incomplete',
        () {
      // Pass 1: S1 has not started yet on baseline init -> lastNotifiedSeason stays 0
      final initialTitle = TmdbTitle.fromMap(title: {
        'id': 77777,
        'name': 'The Countess of Monte Cristo',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_updated': AppConstants.defaultDate,
      });
      WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
        initialTitle,
        now,
        notifyCompleteSeason: true,
      );
      expect(initialTitle.lastNotifiedSeason, 0);

      // Pass 1 (later): arrives on provider while S1 is still airing -> deferred
      final airingServerJson = {
        'id': 77777,
        'name': 'The Countess of Monte Cristo',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 1,
          'air_date': '2026-03-25'
        },
        'next_episode_to_air': {
          'season_number': 1,
          'episode_number': 2,
          'air_date': '2026-04-01'
        },
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final pass1Server =
          TmdbTitle.fromMap(title: prepareTitleMap(airingServerJson));
      final pass1Local =
          TmdbTitle.fromMap(title: prepareTitleMap(airingServerJson));
      pass1Local.flatrateProviderIds = [];
      pass1Local.lastNotifiedSeason = initialTitle.lastNotifiedSeason;

      final pass1Trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: pass1Local,
        titleAfterUpdate: pass1Server,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );
      expect(pass1Trigger, NotificationTrigger.none);

      // Pass 2: S1 ends within 14 days; providers were persisted in pass 1,
      // and baseline (0) is NOT re-run since lastUpdated != defaultDate.
      final completedServerJson = Map<String, dynamic>.from(airingServerJson)
        ..['last_episode_to_air'] = {
          'season_number': 1,
          'episode_number': 8,
          'air_date': '2026-04-10'
        }
        ..['next_episode_to_air'] = null;

      final pass2Now = DateTime(2026, 4, 12);
      final pass2Server =
          TmdbTitle.fromMap(title: prepareTitleMap(completedServerJson));
      final pass2Local =
          TmdbTitle.fromMap(title: prepareTitleMap(airingServerJson));
      pass2Local.lastNotifiedSeason = pass1Local.lastNotifiedSeason;

      final pass2Trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: pass2Local,
        titleAfterUpdate: pass2Server,
        enabledProviderIds: enabledProviders,
        now: pass2Now,
        notifyCompleteSeason: true,
      );
      expect(pass2Trigger, NotificationTrigger.newSeason);
    });

    test(
        'Serie [notifyCompleteSeason: false]: Notifies newAvailability when arriving in ES even with lastNotifiedSeason == 1 (Monte Cristo)',
        () {
      final baseJson = loadJson('La comptesse de Monte-Cristo.json');
      final testNow = DateTime(2026, 11, 18);

      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(baseJson));
      localTitle.lastNotifiedSeason =
          WatchlistNotificationEvaluator.getBaselineSeason(
        localTitle,
        testNow,
        notifyCompleteSeason: false,
      );
      expect(localTitle.lastNotifiedSeason, 1);
      expect(localTitle.flatrateProviderIds, isEmpty);

      final serverJson = Map<String, dynamic>.from(baseJson);
      final providersMap =
          Map<String, dynamic>.from(baseJson['watch/providers']);
      final resultsMap = Map<String, dynamic>.from(providersMap['results']);
      resultsMap['ES'] = {
        'flatrate': [
          {'provider_id': 8}
        ]
      };
      providersMap['results'] = resultsMap;
      serverJson['watch/providers'] = providersMap;

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: testNow,
        notifyCompleteSeason: false,
      );

      expect(trigger, NotificationTrigger.newAvailability);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Notifies newAvailability when becoming available with season completed > 14 days ago',
        () {
      final serverJson = {
        'id': 88888,
        'name': 'Old Completed Show',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 8,
          'air_date': '2026-01-10',
        },
        'next_episode_to_air': null,
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.flatrateProviderIds = [];
      localTitle.lastNotifiedSeason = 1;

      final trigger = WatchlistNotificationEvaluator.evaluateNotification(
        titleBeforeUpdate: localTitle,
        titleAfterUpdate: serverTitle,
        enabledProviderIds: enabledProviders,
        now: now,
        notifyCompleteSeason: true,
      );

      expect(trigger, NotificationTrigger.newAvailability);
    });

    test(
        'Serie [notifyCompleteSeason: true]: Does NOT notify in pass 2 if lastNotifiedSeason already equals currentSeason',
        () {
      final airingJson = {
        'id': 88889,
        'name': 'Already Baselined Show',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 1,
          'air_date': '2026-03-25',
        },
        'next_episode_to_air': {
          'season_number': 1,
          'episode_number': 2,
          'air_date': '2026-04-01',
        },
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final pass1Server = TmdbTitle.fromMap(title: prepareTitleMap(airingJson));
      final pass1Local = TmdbTitle.fromMap(title: prepareTitleMap(airingJson));
      pass1Local.flatrateProviderIds = [];
      pass1Local.lastNotifiedSeason = 1;

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: pass1Local,
          titleAfterUpdate: pass1Server,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: true,
        ),
        NotificationTrigger.none,
      );

      final completedJson = Map<String, dynamic>.from(airingJson)
        ..['last_episode_to_air'] = {
          'season_number': 1,
          'episode_number': 8,
          'air_date': '2026-04-10',
        }
        ..['next_episode_to_air'] = null;

      final pass2Server =
          TmdbTitle.fromMap(title: prepareTitleMap(completedJson));
      final pass2Local = TmdbTitle.fromMap(title: prepareTitleMap(airingJson));
      pass2Local.lastNotifiedSeason = 1;

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: pass2Local,
          titleAfterUpdate: pass2Server,
          enabledProviderIds: enabledProviders,
          now: DateTime(2026, 4, 12),
          notifyCompleteSeason: true,
        ),
        NotificationTrigger.none,
      );
    });

    test('Serie: Does NOT notify newSeason if title lost availability', () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['last_episode_to_air'] = {
        'season_number': 2,
        'episode_number': 1,
        'air_date': '2026-03-28',
      };
      serverJson['number_of_seasons'] = 2;
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {'season_number': 2, 'air_date': '2026-03-28'},
      ];

      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      serverTitle.flatrateProviderIds = [];

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localTitle,
          titleAfterUpdate: serverTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: false,
        ),
        NotificationTrigger.none,
      );
    });

    test(
        'Serie: Notifies S1 when baseline was 0 and S1 premieres while already on provider',
        () {
      final serverJson = {
        'id': 55555,
        'name': 'Neuromante',
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 1,
          'air_date': '2026-03-28',
        },
        'seasons': [
          {'season_number': 1, 'air_date': '2026-03-28'},
        ],
        'watch/providers': {
          'results': {
            'ES': {
              'flatrate': [
                {'provider_id': 8}
              ]
            }
          }
        }
      };

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 0;

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localTitle,
          titleAfterUpdate: serverTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: false,
        ),
        NotificationTrigger.newSeason,
      );
    });

    test(
        'Serie: Does NOT notify on fallback when season airDate is missing and episodeNumber > 1',
        () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['last_episode_to_air'] = {
        'season_number': 2,
        'episode_number': 2,
      };
      serverJson['next_episode_to_air'] = null;
      serverJson['number_of_seasons'] = 2;
      serverJson['seasons'] = [
        {'season_number': 1, 'air_date': '2020-01-12'},
        {'season_number': 2},
      ];

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localTitle,
          titleAfterUpdate: serverTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: false,
        ),
        NotificationTrigger.none,
      );
    });

    test(
        'Serie [notifyCompleteSeason: true]: Does NOT notify if last_episode belongs to previous season',
        () {
      final serverJson = loadJson('[Dorohedoro]_serie_new_season.json');
      serverJson['number_of_seasons'] = 2;
      serverJson['last_episode_to_air'] = {
        'season_number': 1,
        'episode_number': 12,
        'air_date': '2020-03-29',
      };
      serverJson['next_episode_to_air'] = null;

      final serverTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      final localTitle = TmdbTitle.fromMap(title: prepareTitleMap(serverJson));
      localTitle.lastNotifiedSeason = 1;

      expect(
        WatchlistNotificationEvaluator.evaluateNotification(
          titleBeforeUpdate: localTitle,
          titleAfterUpdate: serverTitle,
          enabledProviderIds: enabledProviders,
          now: now,
          notifyCompleteSeason: true,
        ),
        NotificationTrigger.none,
      );
    });
  });

  group('WatchlistNotificationEvaluator - getBaselineSeason', () {
    final now = DateTime(2026, 3, 29);

    test('Should return 0 when numberOfSeasons <= 0', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 0,
      });
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 0);
    });

    test('Should return last_episode season if available and aired', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'last_episode_to_air': {'season_number': 1},
      });
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 1);
    });

    test(
        'Should return numberOfSeasons when next_episode is null and last_episode is in current season',
        () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'last_episode_to_air': {
          'season_number': 2,
          'episode_number': 8,
          'air_date': '2026-03-25',
        },
      });
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 2);
      expect(
        WatchlistNotificationEvaluator.getBaselineSeason(
          title,
          now,
          notifyCompleteSeason: true,
        ),
        2,
      );
    });

    test(
        'Monte Cristo airing fixture: returns 1 when notifyCompleteSeason is false and 0 when true',
        () {
      final json = loadJson('La comptesse de Monte-Cristo.json');
      final title = TmdbTitle.fromMap(title: json);
      final testNow = DateTime(2026, 11, 18);

      expect(
        WatchlistNotificationEvaluator.getBaselineSeason(
          title,
          testNow,
          notifyCompleteSeason: false,
        ),
        1,
      );
      expect(
        WatchlistNotificationEvaluator.getBaselineSeason(
          title,
          testNow,
          notifyCompleteSeason: true,
        ),
        0,
      );
    });

    test('Should return 0 if S1 has no aired or next episode yet', () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 1,
      });
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 0);
    });

    test(
        'Should return current-1 if SxxE01 has empty air_date and no last_episode in season',
        () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 2,
        'last_episode_to_air': {'season_number': 1},
        'next_episode_to_air': {
          'season_number': 2,
          'episode_number': 1,
          'air_date': '',
        },
      });
      expect(WatchlistNotificationEvaluator.getBaselineSeason(title, now), 1);
    });

    test(
        'Should return current-1 if notifyCompleteSeason is true and current season has incomplete air_date',
        () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 1,
        'last_episode_to_air': {
          'season_number': 1,
          'episode_number': 1,
          'air_date': '',
        },
      });
      expect(
        WatchlistNotificationEvaluator.getBaselineSeason(
          title,
          now,
          notifyCompleteSeason: true,
        ),
        0,
      );
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

    test(
        'Should return current-1 if notifyCompleteSeason is true and season is in progress',
        () {
      final title = TmdbTitle.fromMap(title: {
        'number_of_seasons': 1,
        'next_episode_to_air': {
          'season_number': 1,
          'episode_number': 2,
          'air_date': '2026-04-01',
        },
      });
      expect(
        WatchlistNotificationEvaluator.getBaselineSeason(
          title,
          now,
          notifyCompleteSeason: true,
        ),
        0,
      );
    });
  });

  group('WatchlistNotificationEvaluator - initializeBaselineIfNeeded', () {
    final now = DateTime(2026, 3, 29);

    test('Initializes baseline for serie with seasonNotInitialized', () {
      final title = TmdbTitle.fromMap(title: {
        'id': 1,
        'media_type': 'tv',
        'number_of_seasons': 3,
        'last_episode_to_air': {'season_number': 3, 'air_date': '2026-01-01'},
      });

      expect(title.lastNotifiedSeason, AppConstants.seasonNotInitialized);
      final updated = WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
        title,
        now,
        notifyCompleteSeason: false,
      );

      expect(updated, isTrue);
      expect(title.lastNotifiedSeason, 3);
    });

    test('Does not modify serie already initialized to 0, >0, or movies', () {
      final initializedZero = TmdbTitle.fromMap(title: {
        'id': 1,
        'media_type': 'tv',
        'number_of_seasons': 1,
        'last_episode_to_air': {'season_number': 1, 'air_date': '2026-03-28'},
        'last_notified_season': 0,
      });
      final serie = TmdbTitle.fromMap(title: {
        'id': 2,
        'media_type': 'tv',
        'number_of_seasons': 3,
        'last_notified_season': 2,
      });
      final movie = TmdbTitle.fromMap(title: {
        'id': 3,
        'media_type': 'movie',
      });

      expect(
        WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
          initializedZero,
          now,
          notifyCompleteSeason: false,
        ),
        isFalse,
      );
      expect(initializedZero.lastNotifiedSeason, 0);
      expect(
        WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
          serie,
          now,
          notifyCompleteSeason: false,
        ),
        isFalse,
      );
      expect(serie.lastNotifiedSeason, 2);
      expect(
        WatchlistNotificationEvaluator.initializeBaselineIfNeeded(
          movie,
          now,
          notifyCompleteSeason: false,
        ),
        isFalse,
      );
    });
  });
}
