import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../database/realm_models.dart';

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
      schemaVersion: 5,
      migrationCallback: (migration, oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
          _migrateProvidersJson(migration.newRealm);
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
