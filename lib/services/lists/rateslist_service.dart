import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/lists/following_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';

class RateslistService extends TmdbTitleListService {
  final CloudTitleRepository _cloudRepository;

  FollowingService? followingService;
  String? _lastUserId;

  RateslistService(LocalTitleRepository repository,
      {CloudTitleRepository? cloudRepository})
      : _cloudRepository = cloudRepository ?? CloudTitleRepository(),
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
    bool forceUpdate = false,
  }) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) {
      if (loadedItemsVal.isEmpty) await filterItems();
      return;
    }

    await retrieveList(
        forceUpdate: forceUpdate,
        fetchRemoteData: () async {
          final List<TmdbTitle> parsed = [];
          int start = 0;
          const int limit = 1000;
          bool hasMore = true;

          while (hasMore) {
            final titles = await _cloudRepository.fetchUserTitles(
              userId: user.id,
              listName: AppConstants.rateslist,
              start: start,
              limit: limit,
            );
            parsed.addAll(titles);

            if (titles.length < limit) {
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
      final user = CloudDatabaseService.currentUser;
      if (user == null) return;

      final response =
          await _cloudRepository.fetchEpisodeRatings(userId: user.id);

      for (final row in response) {
        final tvId = row['show_tmdb_id'] as int;
        final episodeNumber = row['episode_number'] as int;
        final seasonNumber = row['season_number'] as int;

        final dbEpisode =
            await repository.getEpisode(tvId, seasonNumber, episodeNumber);

        final parsedDate = row['rated_date'] != null
            ? DateTime.parse(row['rated_date'] as String)
            : DateTime.parse(row['created_at'] as String);

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
      await _cloudRepository.upsertRateTitle(
        userId: userId,
        title: title,
        rating: rating,
      );
    } else {
      await _cloudRepository.deleteRateTitle(
        userId: userId,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
      );
    }
  }

  Future<void> updateTitleRate(
    TmdbTitle title,
    double rating,
  ) async {
    try {
      final user = CloudDatabaseService.currentUser;
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
      final user = CloudDatabaseService.currentUser;
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
      syncFromServer(forceUpdate: true);
    } else if (user == null) {
      _lastUserId = null;
    }
  }
}
