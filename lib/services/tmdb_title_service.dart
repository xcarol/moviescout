import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/youtube_service.dart';

class TmdbTitleService extends TmdbBaseService {
  Future<dynamic> _retrieveTitleDetails(
    int id,
    String mediaType,
    String locale,
  ) async {
    final creditsType = mediaType == ApiConstants.movie
        ? TmdbTitleFields.credits
        : TmdbTitleFields.aggregateCredits;

    return get(
      UrlConstants.tmdbDetailsEndpoint
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale)
          .replaceFirst('{CREDITS_TYPE}', creditsType),
    );
  }



  Future<dynamic> _retrieveTitleProviders(
    int id,
    String mediaType,
  ) async {
    return get(
      UrlConstants.tmdbProvidersEndpoint
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString()),
    );
  }

  Future<dynamic> _retrieveTitleLight(
    int id,
    String mediaType,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbLightEndpoint
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  static bool isUpToDate(TmdbItem item) {
    return DateTime.now()
            .difference(
              DateTime.parse(item.lastUpdated),
            )
            .inDays <
        AppConstants.titleUpToDateDays;
  }

  Future<TmdbTitle> updateTitleDetails(TmdbTitle title,
      {bool force = false, bool includeYoutubeSearch = false}) async {
    if (!force && isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleDetails(
      title.tmdbId,
      mediaType,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      ErrorService.log(
        'Failed to retrieve title details for ${title.tmdbId} - ${result.statusCode} - ${result.body}',
        userMessage: 'Failed to retrieve title details',
      );
      return title;
    }

    final Map<String, dynamic> details = body(result);

    _extractProviders(details);
    _extractRecommendations(details);
    _extractExternalIds(details);
    _extractKeywords(details, mediaType);

    _mergeMediaFallback(details, details);
    _mergeTranslationsFallback(details, mediaType);

    if (includeYoutubeSearch) {
      await _addYoutubeTrailers(details);
    }

    details[TmdbTitleFields.homepage] = details['homepage'];
    details[TmdbTitleFields.mediaType] = mediaType;
    details[TmdbTitleFields.lastUpdated] = DateTime.now().toIso8601String();
    details[TmdbTitleFields.lastProvidersUpdate] =
        DateTime.now().toIso8601String();

    title.fillFromMap(details);

    return title;
  }

  Future<void> _addYoutubeTrailers(Map<String, dynamic> details) async {
    final titleName =
        details[TmdbTitleFields.title] ?? details[TmdbTitleFields.name];

    if (titleName != null && titleName.toString().isNotEmpty) {
      final lang = getLanguageCode();
      final country = getCountryCode();
      final youtubeVideos = await YoutubeExplodeService()
          .searchTrailers(titleName.toString(), '$lang-$country');

      if (youtubeVideos.isNotEmpty) {
        final List videos = details[TmdbTitleFields.videos] ?? [];
        final Set<String> existingKeys =
            videos.map((v) => v[TmdbTitleFields.key] as String).toSet();

        final List<Map<String, dynamic>> newVideos = youtubeVideos
            .where((v) => !existingKeys.contains(v[TmdbTitleFields.key]))
            .map((v) {
          final newV = Map<String, dynamic>.from(v);
          newV[TmdbTitleFields.name] = '* ${newV[TmdbTitleFields.name]}';
          return newV;
        }).toList();

        if (newVideos.isNotEmpty) {
          details[TmdbTitleFields.videos] = [...videos, ...newVideos];
        }
      }
    }
  }

  Future<TmdbTitle> updateTitleProviders(TmdbTitle title) async {
    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleProviders(title.tmdbId, mediaType);

    if (result.statusCode != 200) {
      return title;
    }

    final Map<String, dynamic> results = body(result);
    final Map<String, dynamic> providers =
        results['results']?[getCountryCode()] ?? {};

    title.providersJson = jsonEncode(providers);
    TmdbTitle.updateProviderIds(title, providers);

    return title;
  }

  Future<TmdbTitle> updateTitleLight(TmdbTitle title) async {
    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleLight(
      title.tmdbId,
      mediaType,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      return title;
    }

    final Map<String, dynamic> details = body(result);

    _mergeTranslationsFallback(details, mediaType);

    title.numberOfSeasons =
        details[TmdbTitleFields.numberOfSeasons] ?? title.numberOfSeasons;
    title.status = details[TmdbTitleFields.status] ?? title.status;
    title.popularity =
        (details[TmdbTitleFields.popularity] ?? title.popularity).toDouble();
    title.voteAverage =
        (details[TmdbTitleFields.voteAverage] ?? title.voteAverage).toDouble();
    title.voteCount = details[TmdbTitleFields.voteCount] ?? title.voteCount;

    title.runtime = details[TmdbTitleFields.runtime] ?? title.runtime;
    title.numberOfEpisodes =
        details[TmdbTitleFields.numberOfEpisodes] ?? title.numberOfEpisodes;
    title.effectiveRuntime = title.mediaType == ApiConstants.movie
        ? title.runtime
        : title.numberOfEpisodes;

    if (details.containsKey(TmdbTitleFields.nextEpisodeToAir)) {
      title.nextEpisodeToAirJson =
          details[TmdbTitleFields.nextEpisodeToAir] != null
              ? jsonEncode(details[TmdbTitleFields.nextEpisodeToAir])
              : null;
    }
    if (details.containsKey(TmdbTitleFields.lastEpisodeToAir)) {
      title.lastEpisodeToAirJson =
          details[TmdbTitleFields.lastEpisodeToAir] != null
              ? jsonEncode(details[TmdbTitleFields.lastEpisodeToAir])
              : null;
    }

    final providers =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};
    title.providersJson = jsonEncode(providers);
    TmdbTitle.updateProviderIds(title, providers);
    title.lastProvidersUpdate = DateTime.now().toIso8601String();

    return title;
  }

  void _mergeTranslationsFallback(
      Map<String, dynamic> target, String mediaType) {
    if (target['translations'] == null ||
        target['translations']['translations'] == null) {
      return;
    }

    final List<dynamic> translations = target['translations']['translations'];
    final fallbacks = [getCountryCode().toLowerCase(), 'en'];

    for (final fallbackLang in fallbacks) {
      final String currentOverview = target[TmdbTitleFields.overview] ?? '';

      if (currentOverview.isEmpty) {
        final translation = translations.firstWhere(
          (t) =>
              (t['iso_639_1'] ?? '').toString().toLowerCase() == fallbackLang,
          orElse: () => null,
        );

        if (translation != null && translation['data'] != null) {
          final data = translation['data'];
          final String fallbackOverview = data['overview'] ?? '';
          
          if (fallbackOverview.isNotEmpty) {
            target[TmdbTitleFields.overview] = fallbackOverview;

            if (mediaType == ApiConstants.movie) {
              if (data['title'] != null &&
                  data['title'].toString().isNotEmpty) {
                target[TmdbTitleFields.title] = data['title'];
              }
            } else {
              if (data['name'] != null && data['name'].toString().isNotEmpty) {
                target[TmdbTitleFields.name] = data['name'];
              }
            }
            break;
          }
        }
      }
    }
  }

  void _mergeMediaFallback(
      Map<String, dynamic> target, Map<String, dynamic> source,
      {bool overwriteIfEmpty = false}) {
    if (source['images'] != null && source['images']['backdrops'] != null) {
      List<dynamic> backdrops = List.from(source['images']['backdrops']);
      if (backdrops.isNotEmpty || overwriteIfEmpty) {
        backdrops.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            backdrops.take(10).map((b) => b['file_path']).toList();
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

  void _extractProviders(Map<String, dynamic> details) {
    details[TmdbTitleFields.providers] =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};
  }

  void _extractRecommendations(Map<String, dynamic> details) {
    if (details['recommendations'] != null &&
        details['recommendations']['results'] != null) {
      details[TmdbTitleFields.recommendations] =
          details['recommendations']['results'];
    }
  }

  void _extractExternalIds(Map<String, dynamic> details) {
    final externalIds = details['external_ids'];
    if (externalIds != null && externalIds['imdb_id'] != null) {
      details[TmdbTitleFields.imdbId] = externalIds['imdb_id'];
    }
  }

  void _extractKeywords(Map<String, dynamic> details, String mediaType) {
    if (details['keywords'] != null) {
      final List<dynamic>? keywordsList = mediaType == ApiConstants.movie
          ? details['keywords']['keywords']
          : details['keywords']['results'];
          
      if (keywordsList != null) {
        details[TmdbTitleFields.keywordIds] = keywordsList
            .map((k) => k['id'] as int)
            .toList();
      }
    }
  }
}
