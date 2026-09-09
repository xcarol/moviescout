import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_following_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/workers/uninitialized_titles_worker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/repositories/title_repository.dart';

class RateslistService extends TmdbTitleListService {
  final SupabaseClient _supabase = Supabase.instance.client;
  TmdbFollowingService? followingService;

  RateslistService(TitleRepository repository)
      : super(AppConstants.rateslist, repository);

  @override
  Future<void> syncFromServer({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await retrieveList(accountId, forceUpdate: true, fetchRemoteData: () async {
      final response = await _supabase
          .from('user_titles')
          .select('tmdb_id, media_type, rating, notify_new_seasons, created_at')
          .eq('list_name', AppConstants.rateslist)
          .order('created_at', ascending: true);

      final List<TmdbTitle> parsed = [];
      for (var row in response) {
        final newTitle = TmdbTitle(
          tmdbId: row['tmdb_id'] as int,
          mediaType: row['media_type'] as String,
          name: '',
          lastUpdated: DateTime.now().toIso8601String(),
          dateRated: DateTime.now(),
        )
          ..rating = (row['rating'] as num?)?.toDouble() ?? 0.0
          ..notifyNewSeasons = row['notify_new_seasons'] as bool? ?? false;
        parsed.add(newTitle);
      }
      return parsed;
    });

    UninitializedTitlesWorker.dispatch();
    await _syncRatedEpisodes(user.id);
  }

  Future<void> _syncRatedEpisodes(String userId) async {
    try {
      final response = await _supabase
          .from('user_episode_ratings')
          .select(
              'show_tmdb_id, season_number, episode_number, episode_tmdb_id, rating')
          .eq('user_id', userId);

      for (var row in response) {
        final showTmdbId = row['show_tmdb_id'] as int;
        final sNum = row['season_number'] as int;
        final eNum = row['episode_number'] as int;
        final epTmdbId = row['episode_tmdb_id'] as int;
        final rating = (row['rating'] as num).toDouble();

        TmdbEpisode? ep = await repository.getEpisode(showTmdbId, sNum, eNum);
        ep ??= TmdbEpisode(
          tmdbId: epTmdbId,
          tvId: showTmdbId,
          name: '',
          overview: '',
          runtime: 0,
          airDate: '',
          voteAverage: 0.0,
          lastUpdated: DateTime.now().toIso8601String(),
          seasonNumber: sNum,
          episodeNumber: eNum,
        );

        if (ep.rating != rating) {
          ep.rating = rating;
          ep.lastUpdated = DateTime.now().toIso8601String();
          await repository.putEpisode(ep);
        }
      }
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace, userMessage: 'Error syncing rated episodes');
    }
  }

  Future<void> updateTitleRate(
    String accountId,
    String sessionId,
    TmdbTitle title,
    double rating,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      if (rating > 0) {
        title.updateRating(rating);
        title.isPinned = false;

        final watchlistTitle = await repository.getTitleByTmdbId(
            AppConstants.watchlist, title.tmdbId, title.mediaType);
        if (watchlistTitle != null) {
          await _supabase
              .from('user_titles')
              .delete()
              .eq('user_id', user.id)
              .eq('tmdb_id', title.tmdbId)
              .eq('media_type', title.mediaType)
              .eq('list_name', AppConstants.watchlist);

          await repository.deleteTitles(
              AppConstants.watchlist, [title.tmdbId], [title.mediaType]);
          title.inLists = title.inLists.toList()
            ..remove(AppConstants.watchlist);
        }

        await _supabase.from('user_titles').upsert({
          'user_id': user.id,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'list_name': AppConstants.rateslist,
          'rating': rating,
          'notify_new_seasons': title.notifyNewSeasons,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      } else {
        if (title.notifyNewSeasons && followingService != null) {
          title.notifyNewSeasons = false;
        }
        title.rating = 0.0;

        await _supabase
            .from('user_titles')
            .delete()
            .eq('user_id', user.id)
            .eq('tmdb_id', title.tmdbId)
            .eq('media_type', title.mediaType)
            .eq('list_name', AppConstants.rateslist);
      }

      final globalTitle =
          await repository.getTitleGlobal(title.tmdbId, title.mediaType);
      if (rating > 0 || globalTitle != null) {
        await repository.updateRatingList([title]);
        await repository.updateIsPinnedList([title]);
        await repository.updateNotifyNewSeasonsList([title]);
      }

      if (rating > 0 && !title.inLists.contains(AppConstants.rateslist)) {
        await repository.saveTitles([title], AppConstants.rateslist);
      } else if (rating == 0 &&
          title.inLists.contains(AppConstants.rateslist)) {
        await repository.deleteTitles(
            AppConstants.rateslist, [title.tmdbId], [title.mediaType]);
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error updating rate for ${title.name}',
      );
    }
  }

  Future<void> toggleNotify(TmdbTitle title) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      title.notifyNewSeasons = !title.notifyNewSeasons;

      await _supabase
          .from('user_titles')
          .update({
            'notify_new_seasons': title.notifyNewSeasons,
          })
          .eq('user_id', user.id)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.rateslist);

      await repository.updateNotifyNewSeasonsList([title]);
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error toggling notifications for ${title.name}',
      );
      title.notifyNewSeasons = !title.notifyNewSeasons;
    }
  }
}
