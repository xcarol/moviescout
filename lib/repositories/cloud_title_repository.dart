import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/title_comment.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class CloudTitleRepository {
  final SupabaseClient _client;

  CloudTitleRepository({SupabaseClient? client})
      : _client = client ?? CloudDatabaseService.instance;

  Future<T> _retryOnFutureJwt<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST303' || e.message.contains('JWT issued at future')) {
        await Future.delayed(const Duration(milliseconds: 1500));
        return await operation();
      }
      rethrow;
    }
  }

  Future<List<TmdbTitle>> fetchUserTitles({
    required String userId,
    required String listName,
    int limit = 1000,
    int start = 0,
  }) async {
    return _retryOnFutureJwt(() async {
      final response = await _client
          .from('user_titles')
          .select(
              'tmdb_id, media_type, rating, is_pinned, notify_new_seasons, last_notified_season, created_at, rated_date, name, poster_path, vote_average')
          .eq('user_id', userId)
          .eq('list_name', listName)
          .order('created_at', ascending: true)
          .range(start, start + limit - 1);

      return (response as List<dynamic>).map((row) {
        final r = row as Map<String, dynamic>;
        final dateRated = r['rated_date'] != null
            ? DateTime.parse(r['rated_date'] as String)
            : DateTime.parse(AppConstants.defaultDate);
        final createdAt = r['created_at'] != null
            ? DateTime.parse(r['created_at'] as String)
            : null;
        return TmdbTitle(
          tmdbId: r['tmdb_id'] as int,
          mediaType: r['media_type'] as String,
          name: r['name'] as String? ?? '',
          posterPathSuffix: r['poster_path'] as String?,
          voteAverage: (r['vote_average'] as num?)?.toDouble() ?? 0.0,
          lastUpdated: AppConstants.defaultDate,
          dateRated: dateRated,
          createdAt: createdAt,
        )
          ..isPinned = r['is_pinned'] as bool? ?? false
          ..rating = (r['rating'] as num?)?.toDouble() ?? 0.0
          ..notifyNewSeasons = r['notify_new_seasons'] as bool? ?? false
          ..lastNotifiedSeason = r['last_notified_season'] as int? ?? 0;
      }).toList();
    });
  }

  Future<void> upsertWatchlistTitle({
    required String userId,
    required TmdbTitle title,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client.from('user_titles').upsert({
        'user_id': userId,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'list_name': AppConstants.watchlist,
        'is_pinned': false,
        'name': title.name,
        'poster_path': title.posterPathSuffix,
        'vote_average': title.voteAverage,
      }, onConflict: 'user_id, tmdb_id, media_type, list_name');
    });
  }

  Future<void> deleteWatchlistTitle({
    required String userId,
    required int tmdbId,
    required String mediaType,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client
          .from('user_titles')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType)
          .eq('list_name', AppConstants.watchlist);
    });
  }

  Future<void> upsertRateTitle({
    required String userId,
    required TmdbTitle title,
    required double rating,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client.from('user_titles').upsert({
        'user_id': userId,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'list_name': AppConstants.rateslist,
        'rating': rating,
        'notify_new_seasons': title.notifyNewSeasons,
        'name': title.name,
        'poster_path': title.posterPathSuffix,
        'vote_average': title.voteAverage,
        'rated_date': title.dateRated.toUtc().toIso8601String(),
      }, onConflict: 'user_id, tmdb_id, media_type, list_name');
    });

    await deleteWatchlistTitle(
      userId: userId,
      tmdbId: title.tmdbId,
      mediaType: title.mediaType,
    );
  }

  Future<void> deleteRateTitle({
    required String userId,
    required int tmdbId,
    required String mediaType,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client
          .from('user_titles')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType)
          .eq('list_name', AppConstants.rateslist);
    });
  }

  Future<bool> updatePinned({
    required String userId,
    required int tmdbId,
    required String mediaType,
    required bool isPinned,
  }) async {
    return _retryOnFutureJwt(() async {
      await _client
          .from('user_titles')
          .update({'is_pinned': isPinned})
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType)
          .eq('list_name', AppConstants.watchlist);
      return true;
    });
  }

  Future<bool> updateNotification({
    required String userId,
    required int tmdbId,
    required String mediaType,
    required bool notifyNewSeasons,
    int? lastNotifiedSeason,
  }) async {
    return _retryOnFutureJwt(() async {
      final data = <String, dynamic>{
        'notify_new_seasons': notifyNewSeasons,
      };
      if (lastNotifiedSeason != null) {
        data['last_notified_season'] = lastNotifiedSeason;
      }
      await _client
          .from('user_titles')
          .update(data)
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType)
          .eq('list_name', AppConstants.rateslist);
      return true;
    });
  }

  Future<void> syncNotification({
    required String userId,
    required TmdbTitle title,
    required bool addedToWatchlist,
    required bool isInRateslist,
  }) async {
    if (isInRateslist) {
      await updateNotification(
        userId: userId,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
        notifyNewSeasons: title.notifyNewSeasons,
        lastNotifiedSeason: title.lastNotifiedSeason,
      );
    }
    if (addedToWatchlist) {
      await upsertWatchlistTitle(
        userId: userId,
        title: title,
      );
    }
  }

  Future<void> bulkUpsertUserTitles(List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return;
    await _retryOnFutureJwt(() async {
      await _client.from('user_titles').upsert(
            records,
            onConflict: 'user_id, tmdb_id, media_type, list_name',
          );
    });
  }

  Future<List<Map<String, dynamic>>> fetchEpisodeRatings({
    required String userId,
  }) async {
    return _retryOnFutureJwt(() async {
      final response = await _client
          .from('user_episode_ratings')
          .select()
          .eq('user_id', userId)
          .order('rated_date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> upsertEpisodeRating({
    required String userId,
    required TmdbEpisode episode,
    required double rating,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client.from('user_episode_ratings').upsert({
        'user_id': userId,
        'show_tmdb_id': episode.tvId,
        'season_number': episode.seasonNumber,
        'episode_number': episode.episodeNumber,
        'episode_tmdb_id': episode.tmdbId,
        'rating': rating,
        'rated_date': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id, episode_tmdb_id');
    });
  }

  Future<void> deleteEpisodeRating({
    required String userId,
    required int episodeTmdbId,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client
          .from('user_episode_ratings')
          .delete()
          .eq('user_id', userId)
          .eq('episode_tmdb_id', episodeTmdbId);
    });
  }

  Future<void> bulkUpsertEpisodeRatings(
      List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return;
    await _retryOnFutureJwt(() async {
      await _client.from('user_episode_ratings').upsert(
            records,
            onConflict: 'user_id, episode_tmdb_id',
          );
    });
  }

  Future<String?> fetchUserProviders(String userId) async {
    return _retryOnFutureJwt(() async {
      final response = await _client
          .from('profiles')
          .select('providers_string')
          .eq('id', userId)
          .maybeSingle();
      return response != null ? response['providers_string'] as String? : null;
    });
  }

  Future<void> updateUserProviders(String userId, dynamic data) async {
    await _retryOnFutureJwt(() async {
      await _client
          .from('profiles')
          .upsert({'id': userId, 'providers_string': data});
    });
  }

  Future<List<TitleComment>> fetchTitleComments({
    required int tmdbId,
    required String mediaType,
  }) async {
    return _retryOnFutureJwt(() async {
      final response = await _client
          .from('user_comments')
          .select(
              'id, user_id, tmdb_id, media_type, comment, created_at, updated_at, profiles(username)')
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType)
          .order('created_at', ascending: false);

      return (response as List<dynamic>).map((row) {
        return TitleComment.fromMap(row as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<TitleComment> upsertComment({
    required String userId,
    required int tmdbId,
    required String mediaType,
    required String comment,
  }) async {
    return _retryOnFutureJwt(() async {
      final response = await _client
          .from('user_comments')
          .upsert({
            'user_id': userId,
            'tmdb_id': tmdbId,
            'media_type': mediaType,
            'comment': comment,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          }, onConflict: 'user_id, tmdb_id, media_type')
          .select(
              'id, user_id, tmdb_id, media_type, comment, created_at, updated_at, profiles(username)')
          .single();

      return TitleComment.fromMap(response);
    });
  }

  Future<void> deleteComment({
    required String userId,
    required int tmdbId,
    required String mediaType,
  }) async {
    await _retryOnFutureJwt(() async {
      await _client
          .from('user_comments')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', mediaType);
    });
  }
}
