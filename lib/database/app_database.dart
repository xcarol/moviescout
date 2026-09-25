import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:moviescout/database/drift_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  UserListEntries,
  TmdbTitles,
  TmdbSeasons,
  TmdbEpisodes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        for (final entity in allSchemaEntities) {
          try {
            await m.create(entity);
          } catch (e) {
            if (e.toString().contains('already exists')) {
              try {
                await m.drop(entity);
                await m.create(entity);
              } catch (_) {}
            } else {
              rethrow;
            }
          }
        }
      },
      beforeOpen: (details) async {
        if (!kIsWeb) {
          await customStatement('PRAGMA journal_mode = WAL;');
        }
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  static QueryExecutor _openConnection() {
    if (!kIsWeb && Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        try {
          return DynamicLibrary.open('libsqlite3.so');
        } catch (_) {
          return DynamicLibrary.open('libsqlite3.so.0');
        }
      });
    }
    return driftDatabase(
      name: 'moviescout',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
        shareAcrossIsolates: true,
      ),
    );
  }
}
