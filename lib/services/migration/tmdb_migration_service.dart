import 'package:moviescout/models/tmdb_title.dart';
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
        await _supabase
            .from('profiles')
            .update({'providers_string': providers}).eq('id', user.id);
      }

      final watchlistRecords =
          await _prepareRecords(AppConstants.watchlist, user.id);
      final rateslistRecords =
          await _prepareRecords(AppConstants.rateslist, user.id);

      final episodeRecords = await _prepareEpisodeRecords(user.id);

      final allRecords = [...watchlistRecords, ...rateslistRecords];

      final total = allRecords.length + episodeRecords.length;
      if (total == 0) {
        if (onProgress != null) onProgress(1.0, 0, 0);
        return;
      }

      final chunkSize = 50;
      int processed = 0;

      for (var i = 0; i < allRecords.length; i += chunkSize) {
        final chunk = allRecords.sublist(
          i,
          i + chunkSize > allRecords.length ? allRecords.length : i + chunkSize,
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

      for (var i = 0; i < episodeRecords.length; i += chunkSize) {
        final chunk = episodeRecords.sublist(
          i,
          i + chunkSize > episodeRecords.length
              ? episodeRecords.length
              : i + chunkSize,
        );

        await _supabase.from('user_episode_ratings').upsert(
              chunk,
              onConflict: 'user_id, episode_tmdb_id',
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
      sortOption: SortOption.addedOrder,
    );

    int index = 0;
    final baseTime = DateTime.now().toUtc();

    return titles.map((title) {
      final record = <String, dynamic>{
        'user_id': userId,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'list_name': listName,
        'rating': title.rating,
        'is_pinned': title.isPinned,
        'notify_new_seasons': title.notifyNewSeasons,
        'name': title.name,
        'poster_path': title.posterPathSuffix,
        'vote_average': title.voteAverage,
        'created_at': baseTime.add(Duration(milliseconds: index++)).toIso8601String(),
      };
      if (listName == AppConstants.rateslist &&
          title.rating > 0 &&
          title.dateRated.year >= 2000) {
        record['rated_date'] = title.dateRated.toUtc().toIso8601String();
      }
      return record;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _prepareEpisodeRecords(
      String userId) async {
    final episodes = await _repository.getRatedEpisodes();
    if (episodes.isEmpty) return [];

    int index = 0;
    final baseTime = DateTime.now().toUtc();

    return episodes.map((episode) {
      return <String, dynamic>{
        'user_id': userId,
        'show_tmdb_id': episode.tvId,
        'season_number': episode.seasonNumber,
        'episode_number': episode.episodeNumber,
        'episode_tmdb_id': episode.tmdbId,
        'rating': episode.rating,
        'rated_date': episode.lastUpdated,
        'created_at': baseTime.add(Duration(milliseconds: index++)).toIso8601String(),
      };
    }).toList();
  }
}
