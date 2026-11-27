import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/repositories/local_title_repository.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'package:moviescout/features/titles/services/tmdb_title_service.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/services/tmdb_base_service.dart';
import 'package:moviescout/core/services/youtube_service.dart';

class TmdbSeasonService extends TmdbBaseService {
  final _repository = LocalTitleRepository();

  Future<dynamic> _retrieveSeasonDetails(
    int id,
    int seasonNumber,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbSeasonDetailsEndpoint
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<dynamic> _retrieveSeasonBrief(
    int id,
    int seasonNumber,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbSeasonBriefEndpoint
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<TmdbSeason?> getSeasonDetails(int tvId, int seasonNumber,
      {bool includeYoutubeSearch = false,
      String? seriesName,
      bool isPrefetch = false}) async {
    final dbSeason = await _repository.getSeason(tvId, seasonNumber);

    if (dbSeason != null && TmdbTitleService.isUpToDate(dbSeason)) {
      if (!isPrefetch) {
        _prefetchAdjacents(tvId, seasonNumber, seriesName);
      }
      return dbSeason;
    }

    final primaryLocale = '${getLanguageCode()}-${getCountryCode()}';
    final result = await _retrieveSeasonDetails(
      tvId,
      seasonNumber,
      primaryLocale,
    );

    if (result.statusCode != 200) {
      if (result.statusCode != 404) {
        ErrorService.log(
          'Failed to retrieve season details for $tvId season $seasonNumber - ${result.statusCode} - ${result.body}',
          userMessage: 'Failed to retrieve season details',
        );
      }
      return null;
    }

    final Map<String, dynamic> details = body(result);

    _mergeMediaFallback(details, details);

    final parentTitle = await _repository.getTitleGlobal(tvId, ApiConstants.tv);
    final originalLang = parentTitle?.originalLanguage.trim() ?? '';
    final fallbackLocales = _buildFallbackLocales(
      primaryLocale: primaryLocale,
      originalLanguage: originalLang,
    );

    for (final fbLocale in fallbackLocales) {
      if (!_needsFallback(details)) break;
      final fallbackResult = await _retrieveSeasonBrief(
        tvId,
        seasonNumber,
        fbLocale,
      );

      if (fallbackResult.statusCode == 200) {
        _mergeFallback(details, body(fallbackResult), ApiConstants.tv);
      }
    }

    if ((details[TmdbTitleFields.overview] ?? '').toString().trim().isEmpty) {
      _mergeTranslationsFallback(details, originalLanguage: originalLang);
    }

    if (includeYoutubeSearch && seriesName != null && !kIsWeb) {
      final lang = getLanguageCode();
      final country = getCountryCode();
      final query = '$seriesName season $seasonNumber';
      final youtubeVideos =
          await YoutubeExplodeService().searchTrailers(query, '$lang-$country');

      if (youtubeVideos.isNotEmpty) {
        final List videos = details[TmdbTitleFields.videos] ?? [];
        final Set<String> existingKeys =
            videos.map((v) => v[TmdbTitleFields.key] as String).toSet();

        final List<Map<String, dynamic>> newVideos = youtubeVideos
            .where((v) => !existingKeys.contains(v[TmdbTitleFields.key]))
            .toList();

        if (newVideos.isNotEmpty) {
          details[TmdbTitleFields.videos] = [...videos, ...newVideos];
        }
      }
    }

    final season = TmdbSeason.fromMap(details, tvId: tvId);
    season.lastUpdated = DateTime.now().toIso8601String();

    await _repository.putSeason(season);

    if (!isPrefetch) {
      _prefetchAdjacents(tvId, seasonNumber, seriesName);
    }

    return season;
  }

  Future<void> _prefetchAdjacents(
      int tvId, int seasonNumber, String? seriesName) async {
    if (seasonNumber > 1) {
      getSeasonDetails(tvId, seasonNumber - 1,
          seriesName: seriesName, isPrefetch: true);
    }

    final title = await _repository.getTitleGlobal(tvId, ApiConstants.tv);
    if (title != null && seasonNumber + 1 <= title.numberOfSeasons) {
      getSeasonDetails(tvId, seasonNumber + 1,
          seriesName: seriesName, isPrefetch: true);
    }
  }

  List<String> _buildFallbackLocales({
    required String primaryLocale,
    required String originalLanguage,
  }) {
    final countryCode = getCountryCode().toLowerCase();
    final candidates = <String>[
      if (countryCode.isNotEmpty && countryCode != 'us' && countryCode != 'gb')
        countryCode,
      'en-US',
      if (originalLanguage.isNotEmpty) originalLanguage,
    ];

    final seen = <String>{
      primaryLocale.toLowerCase(),
      getLanguageCode().toLowerCase(),
    };
    final result = <String>[];
    for (final loc in candidates) {
      final key = loc.toLowerCase();
      if (!seen.add(key)) continue;
      if (key == 'en-us') seen.add('en');
      result.add(loc);
    }
    return result;
  }

  bool _hasMissingEpisodeOverview(Map<String, dynamic> target) {
    final episodes = target['episodes'];
    if (episodes is! List) return false;
    return episodes.any((ep) =>
        ep is Map &&
        (ep[TmdbTitleFields.overview] ?? '').toString().trim().isEmpty);
  }

  bool _needsFallback(Map<String, dynamic> target) {
    final hasOverview =
        (target[TmdbTitleFields.overview] ?? '').toString().trim().isNotEmpty;
    final hasImages = target[TmdbTitleFields.images] is List &&
        (target[TmdbTitleFields.images] as List).isNotEmpty;
    final hasVideos = target[TmdbTitleFields.videos] is List &&
        (target[TmdbTitleFields.videos] as List).isNotEmpty;
    return !hasOverview ||
        (!hasImages && !hasVideos) ||
        _hasMissingEpisodeOverview(target);
  }

  void _mergeFallback(Map<String, dynamic> target,
      Map<String, dynamic> fallback, String mediaType) {
    final String currentOverview =
        (target[TmdbTitleFields.overview] ?? '').toString().trim();
    final String fallbackOverview =
        (fallback[TmdbTitleFields.overview] ?? '').toString().trim();

    if (currentOverview.isEmpty && fallbackOverview.isNotEmpty) {
      target[TmdbTitleFields.overview] = fallbackOverview;
    }

    final String currentName =
        (target[TmdbTitleFields.name] ?? '').toString().trim();
    final String fallbackName =
        (fallback[TmdbTitleFields.name] ?? '').toString().trim();
    if (currentName.isEmpty && fallbackName.isNotEmpty) {
      target[TmdbTitleFields.name] = fallbackName;
    }

    _mergeEpisodesFallback(target, fallback);
    _mergeMediaFallback(target, fallback, overwriteIfEmpty: true);
  }

  void _mergeEpisodesFallback(
      Map<String, dynamic> target, Map<String, dynamic> fallback) {
    final targetEpisodes = target['episodes'];
    final fallbackEpisodes = fallback['episodes'];
    if (targetEpisodes is! List || fallbackEpisodes is! List) return;

    final fallbackByNumber = <int, Map<String, dynamic>>{};
    for (final ep in fallbackEpisodes) {
      if (ep is Map<String, dynamic>) {
        final num = ep['episode_number'];
        if (num is int) {
          fallbackByNumber[num] = ep;
        }
      }
    }

    for (final ep in targetEpisodes) {
      if (ep is! Map<String, dynamic>) continue;
      final epNum = ep['episode_number'];
      if (epNum is! int) continue;
      final fbEp = fallbackByNumber[epNum];
      if (fbEp == null) continue;

      final currentOverview =
          (ep[TmdbTitleFields.overview] ?? '').toString().trim();
      final fbOverview =
          (fbEp[TmdbTitleFields.overview] ?? '').toString().trim();
      if (currentOverview.isEmpty && fbOverview.isNotEmpty) {
        ep[TmdbTitleFields.overview] = fbOverview;
      }

      final currentName = (ep[TmdbTitleFields.name] ?? '').toString().trim();
      final fbName = (fbEp[TmdbTitleFields.name] ?? '').toString().trim();
      if (currentName.isEmpty && fbName.isNotEmpty) {
        ep[TmdbTitleFields.name] = fbName;
      }
    }
  }

  void _mergeTranslationsFallback(
    Map<String, dynamic> target, {
    required String originalLanguage,
  }) {
    final translations = target['translations']?['translations'];
    if (translations is! List) return;

    final preferredLangs = <String>[
      if (originalLanguage.isNotEmpty) originalLanguage.toLowerCase(),
      getCountryCode().toLowerCase(),
      'en',
    ];

    Map<String, dynamic>? matchData;
    for (final lang in preferredLangs) {
      for (final item in translations) {
        if (item is! Map) continue;
        final iso = (item['iso_639_1'] ?? '').toString().toLowerCase();
        final data = item['data'];
        if (iso == lang &&
            data is Map<String, dynamic> &&
            (data['overview'] ?? '').toString().trim().isNotEmpty) {
          matchData = data;
          break;
        }
      }
      if (matchData != null) break;
    }

    if (matchData == null) {
      for (final item in translations) {
        if (item is! Map) continue;
        final data = item['data'];
        if (data is Map<String, dynamic> &&
            (data['overview'] ?? '').toString().trim().isNotEmpty) {
          matchData = data;
          break;
        }
      }
    }

    if (matchData == null) return;

    target[TmdbTitleFields.overview] = matchData['overview'].toString().trim();
    if ((target[TmdbTitleFields.name] ?? '').toString().trim().isEmpty &&
        (matchData['name'] ?? '').toString().trim().isNotEmpty) {
      target[TmdbTitleFields.name] = matchData['name'].toString().trim();
    }
  }

  void _mergeMediaFallback(
      Map<String, dynamic> target, Map<String, dynamic> source,
      {bool overwriteIfEmpty = false}) {
    if (source['images'] != null && source['images']['posters'] != null) {
      List<dynamic> posters = List.from(source['images']['posters']);
      if (posters.isNotEmpty || overwriteIfEmpty) {
        posters.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            posters.take(10).map((b) => b['file_path']).toList();
      }
    }

    if (target[TmdbTitleFields.images] is! List) {
      target[TmdbTitleFields.images] = [];
    }
    if (source['videos'] != null && source['videos']['results'] != null) {
      List<dynamic> videos = List.from(source['videos']['results']);

      videos = videos
          .where((v) => (v['site'] ?? '').toString().toLowerCase() == 'youtube')
          .toList();

      if (videos.isNotEmpty || overwriteIfEmpty) {
        videos.sort((a, b) {
          final aOfficial = a['official'] == true ? 1 : 0;
          final bOfficial = b['official'] == true ? 1 : 0;
          if (aOfficial != bOfficial) return bOfficial.compareTo(aOfficial);

          final aTrailer = a['type'] == 'Trailer' ? 1 : 0;
          final bTrailer = b['type'] == 'Trailer' ? 1 : 0;
          return bTrailer.compareTo(aTrailer);
        });

        target[TmdbTitleFields.videos] = videos
            .take(5)
            .map((v) => {
                  TmdbTitleFields.key: v['key'],
                  TmdbTitleFields.site: v['site'],
                  TmdbTitleFields.name: v['name'],
                  TmdbTitleFields.iso6391: v['iso_639_1'],
                  TmdbTitleFields.isSearchResult:
                      v[TmdbTitleFields.isSearchResult] ?? false,
                })
            .toList();
      }
    }

    if (target[TmdbTitleFields.videos] is! List) {
      target[TmdbTitleFields.videos] = [];
    }
  }
}
