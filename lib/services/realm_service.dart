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
      schemaVersion: 1,
      path: '${dir.path}/moviescout.realm',
    );
    _realm = Realm(config);
  }

  static Realm get instance => _realm;

  static void close() {
    _realm.close();
  }
}
