import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../models/tmdb_title.dart';
import '../models/user_list_entry.dart';
import '../models/tmdb_season.dart';
import '../models/tmdb_episode.dart';

class IsarService {
  static late final Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    _isar = await Isar.open(
      [
        TmdbTitleSchema,
        UserListEntrySchema,
        TmdbSeasonSchema,
        TmdbEpisodeSchema
      ],
      directory: dir.path,
      inspector: kDebugMode,
    );

    final prefs = await SharedPreferences.getInstance();
    
    // TODO: [NaN Migration] Remove this migration block in a few months (e.g., late 2026).
    // This is a one-time migration to clean up existing NaN values stored in Isar.
    // It triggers the Dart constructors to convert any NaN values to 0.0,
    // and then resaves them, permanently eliminating NaNs from the Rust DB.
    if (prefs.getBool('nan_migration_v3') != true) {
      try {
        await _isar.writeTxn(() async {
          final titles = await _isar.tmdbTitles.where().findAll();
          await _isar.tmdbTitles.putAll(titles);

          final seasons = await _isar.tmdbSeasons.where().findAll();
          await _isar.tmdbSeasons.putAll(seasons);

          final episodes = await _isar.tmdbEpisodes.where().findAll();
          await _isar.tmdbEpisodes.putAll(episodes);
        });
        await prefs.setBool('nan_migration_v3', true);
      } catch (e) {
        debugPrint('Error running NaN migration: $e');
      }
    }
  }

  static Isar get instance => _isar;

  static Future<void> close() async {
    await _isar.close();
  }
}
