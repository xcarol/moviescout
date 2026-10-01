import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/lists/following_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/repositories/title_repository.dart';

class RateslistService extends TmdbTitleListService {
  final SupabaseClient _supabase;

  FollowingService? followingService;
  String? _lastUserId;

  RateslistService(TitleRepository repository, {SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client,
        super(AppConstants.rateslist, repository);

  Future<double> getRatingAsync(int titleId, String mediaType) async {
    final title = await getTitleByTmdbId(titleId, mediaType);
    return title?.rating ?? 0.0;
  }

  Future<DateTime> getRatingDate(int titleId, String mediaType) async {
    TmdbTitle? title = await getTitleByTmdbId(titleId, mediaType);
    if (title == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return title.dateRated;
  }

  @override
  Future<void> syncFromServer({
    Locale? locale,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await retrieveList(
        forceUpdate: true,
        fetchRemoteData: () async {
          final List<TmdbTitle> parsed = [];
          int start = 0;
          const int limit = 1000;
          bool hasMore = true;

          while (hasMore) {
            final response = await _supabase
                .from('user_titles')
                .select(
                    'tmdb_id, media_type, rating, notify_new_seasons, last_notified_season, created_at, rated_date, name, poster_path, vote_average')
                .eq('list_name', AppConstants.rateslist)
                .order('created_at', ascending: true)
                .range(start, start + limit - 1);

            for (var row in response) {
              final newTitle = TmdbTitle(
                tmdbId: row['tmdb_id'] as int,
                mediaType: row['media_type'] as String,
                name: row['name'] as String? ?? '',
                posterPathSuffix: row['poster_path'] as String?,
                voteAverage: (row['vote_average'] as num?)?.toDouble() ?? 0.0,
                lastUpdated: AppConstants.defaultDate,
                dateRated: row['rated_date'] != null
                    ? DateTime.parse(row['rated_date'] as String)
                    : DateTime.parse(AppConstants.defaultDate),
              )
                ..rating = (row['rating'] as num?)?.toDouble() ?? 0.0
                ..notifyNewSeasons = row['notify_new_seasons'] as bool? ?? false
                ..lastNotifiedSeason = row['last_notified_season'] as int? ?? 0;
              parsed.add(newTitle);
            }

            if (response.length < limit) {
              hasMore = false;
            } else {
              start += limit;
            }
          }
          return parsed;
        });

    await filterItems();
    await _retrieveRatedEpisodes();
  }

  Future<void> _retrieveRatedEpisodes() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('user_episode_ratings')
          .select()
          .order('rated_date', ascending: false);

      for (final row in response) {
        final tvId = row['show_tmdb_id'] as int;
        final episodeNumber = row['episode_number'] as int;
        final seasonNumber = row['season_number'] as int;

        final dbEpisode =
            await repository.getEpisode(tvId, seasonNumber, episodeNumber);

        final parsedDate = row['rated_date'] != null
            ? DateTime.parse(row['rated_date'])
            : DateTime.parse(row['created_at']);

        final episode = dbEpisode ??
            TmdbEpisode(
              tmdbId: row['episode_tmdb_id'] as int,
              tvId: tvId,
              seasonNumber: seasonNumber,
              episodeNumber: episodeNumber,
              name: '',
              overview: '',
              airDate: '',
              runtime: 0,
              voteAverage: 0.0,
              lastUpdated: AppConstants.defaultDate,
              dateRated: parsedDate,
            );

        episode.rating = (row['rating'] as num).toDouble();
        episode.dateRated = parsedDate;
        await repository.putEpisode(episode);
      }
    } catch (e, stack) {
      ErrorService.log(e,
          stackTrace: stack, userMessage: 'Error sync rated episodes');
    }
  }

  Future<void> _updateTitleRateToSupabase(
      String userId, TmdbTitle title, double rating) async {
    if (rating > 0) {
      await _supabase.from('user_titles').upsert({
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

      // Mimic TMDB's backend business logic: rating a title auto-removes it from the watchlist
      await _supabase
          .from('user_titles')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.watchlist);
    } else {
      await _supabase
          .from('user_titles')
          .delete()
          .eq('user_id', userId)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.rateslist);
    }
  }

  Future<void> updateTitleRate(
    TmdbTitle title,
    double rating,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      if (rating > 0) {
        title.updateRating(rating);
        title.isPinned = false;

        final watchlistTitle = await repository.getTitleByTmdbId(
            AppConstants.watchlist, title.tmdbId, title.mediaType);
        if (watchlistTitle != null) {
          await repository.deleteTitles(
              AppConstants.watchlist, [title.tmdbId], [title.mediaType]);
        }
      } else {
        if (title.notifyNewSeasons && followingService != null) {
          await followingService!.removeFollowingFromServer(title);
          title.notifyNewSeasons = false;
        }
        title.rating = 0.0;
      }
      await updateTitle(title, rating > 0, () async {
        return _updateTitleRateToSupabase(user.id, title, rating);
      });

      final globalTitle =
          await repository.getTitleGlobal(title.tmdbId, title.mediaType);
      if (rating > 0 || globalTitle != null) {
        await repository.updateRatingList([title]);
        await repository.updateIsPinnedList([title]);
        await repository.updateNotifyNewSeasonsList([title]);
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
      await repository.updateNotifyNewSeasonsList([title]);

      if (title.notifyNewSeasons) {
        await followingService?.addFollowingToServer(title);
      } else {
        await followingService?.removeFollowingFromServer(title);
      }

      await filterItems(retainPagination: true);
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error toggling notify for ${title.name}',
      );
      title.notifyNewSeasons = !title.notifyNewSeasons;
    }
  }

  void updateAuth(SupabaseAuthService authService) {
    final user = authService.currentUser;
    if (user != null && _lastUserId != user.id) {
      _lastUserId = user.id;
      syncFromServer();
    } else if (user == null) {
      _lastUserId = null;
    }
  }
}
