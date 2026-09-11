import 'package:moviescout/repositories/title_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbMigrationService {
  final TitleRepository _repository;
  final SupabaseClient _supabase = Supabase.instance.client;

  TmdbMigrationService(this._repository);

  Future<void> migrateLocalDataToSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Sessió de Supabase no iniciada per a la migració.');
    }

    try {
      await _migrateList(AppConstants.watchlist, user.id);
      await _migrateList(AppConstants.rateslist, user.id);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error durant la migració de dades de TMDB a Supabase.',
      );
      rethrow;
    }
  }

  Future<void> _migrateList(String listName, String userId) async {
    final titles = await _repository.getTitles(listName: listName);

    if (titles.isEmpty) return;

    final List<Map<String, dynamic>> records = [];

    for (var title in titles) {
      records.add({
        'user_id': userId,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'list_name': listName,
        'rating': title.rating,
        'is_pinned': title.isPinned,
        'notify_new_seasons': title.notifyNewSeasons,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    }

    await _supabase.from('user_titles').upsert(records);
  }
}
