import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_following_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/repositories/title_repository.dart';

import 'package:moviescout/services/legacy/legacy_rateslist_service.dart';

class RateslistService extends TmdbTitleListService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LegacyRateslistService _legacyService;

  TmdbFollowingService? followingService;
  String? _lastUserId;

  RateslistService(TitleRepository repository, this._legacyService)
      : super(AppConstants.rateslist, repository);

  double getRating(int titleId, String mediaType) {
    TmdbTitle? title = getTitleByTmdbIdSync(titleId, mediaType);
    if (title == null) {
      return 0.0;
    }
    return title.rating;
  }

  Future<double> getRatingAsync(int titleId, String mediaType) async {
    TmdbTitle? title = await getTitleByTmdbId(titleId, mediaType);
    if (title == null) {
      return 0.0;
    }
    return title.rating;
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
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      if (accountId.isEmpty || sessionId.isEmpty) return;
      return await _legacyService.syncFromServer(
        accountId: accountId,
        sessionId: sessionId,
        locale: locale,
      );
    }

    await retrieveList(accountId, forceUpdate: true, fetchRemoteData: () async {
      final response = await _supabase
          .from('user_titles')
          .select(
              'tmdb_id, media_type, rating, notify_new_seasons, created_at, rated_date, name, poster_path, vote_average')
          .eq('list_name', AppConstants.rateslist)
          .order('created_at', ascending: true);

      final List<TmdbTitle> parsed = [];
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
          ..notifyNewSeasons = row['notify_new_seasons'] as bool? ?? false;
        parsed.add(newTitle);
      }
      return parsed;
    });

    if (followingService != null) {
      await followingService!.fetchAndApplyFollowingTitles();
    }
    await filterItems();
    _retrieveRatedEpisodes(accountId, sessionId, locale);
  }

  Future<void> _retrieveRatedEpisodes(
      String accountId, String sessionId, Locale locale) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('user_episode_ratings')
            .select()
            .order('rated_date', ascending: false);

        for (final row in response) {
          final tvId = row['show_tmdb_id'] as int;
          final episodeNumber = row['episode_number'] as int;
          final seasonNumber = row['season_number'] as int;
          
          final dbEpisode = await repository.getEpisode(tvId, seasonNumber, episodeNumber);
          
          final parsedDate = row['rated_date'] != null 
              ? DateTime.parse(row['rated_date']) 
              : DateTime.parse(row['created_at']);

          final episode = dbEpisode ?? TmdbEpisode(
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
        return;
      }

      int page = 1;
      int totalPages = 1;
      while (page <= totalPages) {
        final response = await get(
          UrlConstants.tmdbRatedEpisodesEndpoint
              .replaceFirst('{ACCOUNT_ID}', accountId)
              .replaceFirst('{SESSION_ID}', sessionId)
              .replaceFirst('{PAGE}', page.toString())
              .replaceFirst(
                  '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
        );
        if (response.statusCode == 200) {
          totalPages = await _parseAndSaveRatedEpisodes(response);
        }
        page++;
      }
    } catch (e, stack) {
      ErrorService.log(e,
          stackTrace: stack, userMessage: 'Error sync rated episodes');
    }
  }

  Future<int> _parseAndSaveRatedEpisodes(dynamic response) async {
    final Map<String, dynamic> data = body(response);
    final int totalPages = data['total_pages'] ?? 1;
    final List<dynamic> results = data['results'] ?? [];

    for (final item in results) {
      final tvId = item['show_id'] ?? 0;
      final episode = TmdbEpisode.fromMap(item, tvId: tvId);
      episode.rating = (item['rating'] ?? 0.0).toDouble();
      episode.lastUpdated = DateTime.now().toIso8601String();

      final dbEpisode = await repository.getEpisode(
          tvId, episode.seasonNumber, episode.episodeNumber);
      if (dbEpisode != null) {
        episode.stillPathSuffix = dbEpisode.stillPathSuffix;
        episode.guestStarsJson = dbEpisode.guestStarsJson;
        episode.crewJson = dbEpisode.crewJson;
        episode.imagesJson = dbEpisode.imagesJson;
        episode.videosJson = dbEpisode.videosJson;
        if (episode.overview.isEmpty) {
          episode.overview = dbEpisode.overview;
        }
      }

      await repository.putEpisode(episode);
    }

    return totalPages;
  }

  Future<dynamic> _updateTitleRateToSupabase(
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
    return http.Response('', 200);
  }

  Future<void> updateTitleRate(
    String accountId,
    String sessionId,
    TmdbTitle title,
    double rating,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (accountId.isEmpty || sessionId.isEmpty) return;
        return await _legacyService.updateTitleRate(
          accountId,
          sessionId,
          title,
          rating,
        );
      }

      if (rating > 0) {
        title.updateRating(rating);
        title.isPinned = false;

        final watchlistTitle = await repository.getTitleByTmdbId(
            AppConstants.watchlist, title.tmdbId, title.mediaType);
        if (watchlistTitle != null) {
          await repository.deleteTitles(
              AppConstants.watchlist, [title.tmdbId], [title.mediaType]);
          title.inLists = title.inLists.toList()
            ..remove(AppConstants.watchlist);
        }
      } else {
        if (title.notifyNewSeasons && followingService != null) {
          await followingService!.removeFollowingFromServer(title);
          title.notifyNewSeasons = false;
        }
        title.rating = 0.0;
      }
      await updateTitle(accountId, sessionId, title, rating > 0,
          (String accountId, String sessionId) async {
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
      if (user == null) {
        return await _legacyService.toggleNotify(title);
      }

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
      syncFromServer(
          accountId: user.id, sessionId: '', locale: const Locale('en'));
    } else if (user == null) {
      _lastUserId = null;
    }
  }
}
