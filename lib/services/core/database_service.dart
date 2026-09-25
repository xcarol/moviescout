import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moviescout/database/app_database.dart';

class DatabaseService {
  static AppDatabase? _db;

  static Future<void> init({AppDatabase? db}) async {
    if (db != null) {
      _db = db;
      return;
    }

    if (_db != null) return;

    if (!kIsWeb) {
      await _cleanupLegacyRealmFiles();
    }

    _db = AppDatabase();
  }

  static Future<void> _cleanupLegacyRealmFiles() async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final realmFiles = [
        '${cacheDir.path}/moviescout.realm',
        '${cacheDir.path}/moviescout.realm.lock',
        '${cacheDir.path}/moviescout.realm.note',
        '${cacheDir.path}/moviescout.realm.management',
      ];

      for (final path in realmFiles) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
        final dir = Directory(path);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      }
    } catch (_) {}
  }

  static AppDatabase get instance => _db!;

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
