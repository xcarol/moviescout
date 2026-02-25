import 'package:diacritic/diacritic.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/youtube_query_mapper.dart';

abstract class YoutubeService {
  Future<List<Map<String, dynamic>>> searchTrailers(
      String title, String locale);
}

class YoutubeExplodeService implements YoutubeService {
  static final YoutubeExplodeService _instance =
      YoutubeExplodeService._internal();

  factory YoutubeExplodeService() {
    return _instance;
  }

  YoutubeExplodeService._internal();

  final _yt = YoutubeExplode();

  @override
  Future<List<Map<String, dynamic>>> searchTrailers(
      String title, String locale) async {
    final List<Map<String, dynamic>> youtubeResults = [];
    final parts = locale.split('-');
    final ll = parts[0];
    final cc = parts.length > 1 ? parts[1] : '';

    final primaryQuery = YoutubeQueryMapper.getQueryForLanguage(ll, title);
    final results = await _searchRelevant(title, primaryQuery, ll);
    youtubeResults.addAll(results);

    if (youtubeResults.isEmpty &&
        cc.isNotEmpty &&
        ll.toLowerCase() != cc.toLowerCase()) {
      final fallbackQuery = YoutubeQueryMapper.getQueryForCountry(cc, title);
      final fallbackResults = await _searchRelevant(title, fallbackQuery, cc);
      youtubeResults.addAll(fallbackResults);
    }

    return youtubeResults;
  }

  Future<List<Map<String, dynamic>>> _searchRelevant(
      String title, String query, String iso) async {
    final List<Map<String, dynamic>> allResults = [];

    try {
      final searchList = await _yt.search.search(query);
      final results = searchList
          .where((v) => _isRelevant(v, title))
          .take(3)
          .map((v) => {
                TmdbTitleFields.key: v.id.value,
                TmdbTitleFields.site: 'YouTube',
                TmdbTitleFields.name: v.title,
                TmdbTitleFields.isSearchResult: true,
                TmdbTitleFields.iso6391: iso,
              })
          .toList();

      allResults.addAll(results);
    } catch (_) {
      // Silently fail
    }

    return allResults;
  }

  bool _isRelevant(Video video, String targetTitle) {
    if (video.duration == null || video.duration!.inMinutes > 6) return false;

    final videoTitle = removeDiacritics(video.title.toLowerCase());
    final normalizedTarget = removeDiacritics(targetTitle.toLowerCase());

    if (!videoTitle.contains(normalizedTarget)) return false;

    for (final keyword in YoutubeQueryMapper.forbiddenKeywords) {
      if (videoTitle.contains(keyword)) return false;
    }

    bool hasPositive = false;
    for (final keyword in YoutubeQueryMapper.positiveKeywords) {
      if (videoTitle.contains(keyword)) {
        hasPositive = true;
        break;
      }
    }

    return hasPositive;
  }
}
