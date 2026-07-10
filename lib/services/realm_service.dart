import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../database/realm_models.dart';

class RealmService {
  static late final Realm _realm;

  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    final config = Configuration.local(
      [
        UserListEntryRealm.schema,
        TmdbTitleRealm.schema,
        TmdbSeasonRealm.schema,
        TmdbEpisodeRealm.schema,
      ],
      schemaVersion: 2,
      migrationCallback: (migration, oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
          _migrateProvidersJson(migration.newRealm);
        }
      },
      path: '${dir.path}/moviescout.realm',
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
