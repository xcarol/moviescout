import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:moviescout/database/connection/setup_sqlite.dart';
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
  int get schemaVersion => 2;

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
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await _migrateUserListEntriesOrder();
        }
      },
      beforeOpen: (details) async {
        if (!kIsWeb) {
          await customStatement('PRAGMA journal_mode = WAL;');
        }
        await customStatement('PRAGMA foreign_keys = ON;');
        await _migrateUserListEntriesOrder();
      },
    );
  }

  Future<void> _migrateUserListEntriesOrder() async {
    await customStatement(
        'DROP TABLE IF EXISTS tmp_for_copy_user_list_entries;');
    await customStatement('DROP TABLE IF EXISTS tmp_new_user_list_entries;');
    final columns =
        await customSelect('PRAGMA table_info("user_list_entries");').get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();
    if (columnNames.isEmpty) return;

    if (columnNames.contains('added_order')) {
      await customStatement('CREATE TABLE "tmp_new_user_list_entries" ('
          '"id" TEXT NOT NULL, '
          '"list_name" TEXT NOT NULL, '
          '"tmdb_id" INTEGER NOT NULL, '
          '"media_type" TEXT NOT NULL, '
          '"created_at" INTEGER NOT NULL, '
          'PRIMARY KEY("id"));');
      await customStatement(
          'INSERT OR REPLACE INTO "tmp_new_user_list_entries" ("id", "list_name", "tmdb_id", "media_type", "created_at") '
          'SELECT "id", "list_name", "tmdb_id", "media_type", (1577836800 + "added_order") '
          'FROM "user_list_entries";');
      await customStatement('DROP TABLE "user_list_entries";');
      await customStatement(
          'ALTER TABLE "tmp_new_user_list_entries" RENAME TO "user_list_entries";');
    }
    await customStatement(
        'CREATE INDEX IF NOT EXISTS "idx_user_list_entries_list_order" ON "user_list_entries" ("list_name", "created_at");');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS "idx_user_list_entries_lookup" ON "user_list_entries" ("list_name", "tmdb_id", "media_type");');
  }

  static QueryExecutor _openConnection() {
    setupSqlite();
    return driftDatabase(
      name: 'moviescout',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
