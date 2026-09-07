import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import 'package:moviescout/database/realm_models.dart';

class RealmService {
  static late final Realm _realm;

  static Future<void> init() async {
    String? customPath;
    if (!kIsWeb) {
      final dir = await getApplicationCacheDirectory();
      customPath = '${dir.path}/moviescout.realm';
    }

    final config = Configuration.local(
      [
        UserListEntryRealm.schema,
        TmdbTitleRealm.schema,
        TmdbSeasonRealm.schema,
        TmdbEpisodeRealm.schema,
      ],
      schemaVersion: 11,
      migrationCallback: (migration, oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
          _migrateProvidersJson(migration.newRealm);
        }
        if (oldSchemaVersion < 6) {
          final titles = migration.newRealm.all<TmdbTitleRealm>();
          for (final t in titles) {
            t.type = '';
          }
        }
        if (oldSchemaVersion < 7) {
          final episodes = migration.newRealm.all<TmdbEpisodeRealm>();
          for (final episode in episodes) {
            episode.rating = 0.0;
          }
        }
        if (oldSchemaVersion < 11) {
          // Since the schema changed from int addedOrder to DateTime addedDate,
          // the old int column was dropped and a new DateTime column was created.
          // By default, it will be the epoch. Let's do the time simulation based on the
          // assumption we don't have access to the old int values via Dart's typed API.
          // We will assign a chronological date to each entry based on its current position.
          final entries = migration.newRealm.all<UserListEntryRealm>().toList();
          final now = DateTime.now();
          for (var i = 0; i < entries.length; i++) {
            entries[i].addedDate =
                now.subtract(Duration(minutes: entries.length - i));
          }

          final titles = migration.newRealm.all<TmdbTitleRealm>().toList();
          for (var i = 0; i < titles.length; i++) {
            titles[i].addedDate =
                now.subtract(Duration(minutes: titles.length - i));
          }
        }
      },
      path: customPath,
    );
    _realm = Realm(config);
  }

  static void _migrateProvidersJson(Realm realm) {
    final titles = realm.all<TmdbTitleRealm>();
    for (final t in titles) {
      if (t.flatrateProviderIds.isEmpty) {
        final providersJson = t.providersJson;
        if (providersJson != null && providersJson.isNotEmpty) {
          try {
            final map = jsonDecode(providersJson) as Map<String, dynamic>;
            if (map['flatrate'] is List) {
              final ids = (map['flatrate'] as List)
                  .map((p) => p['provider_id'] as int)
                  .toList();
              t.flatrateProviderIds.addAll(ids);
            }
          } catch (_) {}
        }
      }
    }
  }

  static Realm get instance => _realm;

  static void close() {
    _realm.close();
  }
}
