import 'package:moviescout/repositories/title_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbMigrationService {
  final TitleRepository _repository;
  final SupabaseClient _supabase = Supabase.instance.client;

  TmdbMigrationService(this._repository);

  Future<void> migrateLocalDataToSupabase({
    required String providers,
    Function(double progress, int current, int total)? onProgress,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Supabase session not initialized for migration.');
    }

    try {
      if (providers.isNotEmpty) {
        await _supabase.from('profiles').update({'providers_string': providers}).eq('id', user.id);
      }

      final watchlistRecords =
          await _prepareRecords(AppConstants.watchlist, user.id);
      final rateslistRecords =
          await _prepareRecords(AppConstants.rateslist, user.id);

      final allRecords = [...watchlistRecords, ...rateslistRecords];

      if (allRecords.isEmpty) {
        if (onProgress != null) onProgress(1.0, 0, 0);
        return;
      }

      final chunkSize = 50;
      int processed = 0;
      final total = allRecords.length;

      for (var i = 0; i < total; i += chunkSize) {
        final chunk = allRecords.sublist(
          i,
          i + chunkSize > total ? total : i + chunkSize,
        );

        await _supabase.from('user_titles').upsert(
              chunk,
              onConflict: 'user_id, tmdb_id, media_type, list_name',
            );

        processed += chunk.length;
        if (onProgress != null) {
          onProgress(processed / total, processed, total);
        }
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Migration to Supabase failed.',
      );
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _prepareRecords(
      String listName, String userId) async {
    final count = await _repository.countTitlesFiltered(listName: listName);
    if (count == 0) return [];

    final titles = await _repository.getTitles(
      listName: listName,
      limit: count,
    );

    return titles
        .map((title) => {
              'user_id': userId,
              'tmdb_id': title.tmdbId,
              'media_type': title.mediaType,
              'list_name': listName,
              'rating': title.rating,
              'is_pinned': title.isPinned,
              'notify_new_seasons': title.notifyNewSeasons,
              'created_at': DateTime.now().toUtc().toIso8601String(),
            })
        .toList();
  }
}
