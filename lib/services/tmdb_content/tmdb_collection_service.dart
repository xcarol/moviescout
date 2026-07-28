import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/models/tmdb_title.dart';

class TmdbCollectionService extends TmdbBaseService {
  Future<Map<String, dynamic>> getCollectionDetails(int id, String locale) async {
    final futures = await Future.wait([
      get(UrlConstants.tmdbCollectionDetailsEndpoint
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale)),
      get(UrlConstants.tmdbCollectionTranslationsEndpoint.replaceFirst('{ID}', id.toString())),
      get(UrlConstants.tmdbCollectionImagesEndpoint.replaceFirst('{ID}', id.toString())),
    ]);

    final response = futures[0];
    if (response.statusCode != 200) {
      return {};
    }

    final data = body(response);

    if (futures[1].statusCode == 200) {
      data['translations'] = body(futures[1]);
    }

    if (futures[2].statusCode == 200) {
      data['images'] = body(futures[2]);
    }
    _mergeTranslationsFallback(data);
    _mergeImages(data);
    return data;
  }

  void _mergeTranslationsFallback(Map<String, dynamic> target) {
    if (target['translations'] == null ||
        target['translations']['translations'] == null) {
      return;
    }

    final List<dynamic> translations = target['translations']['translations'];
    final fallbacks = [getCountryCode().toLowerCase(), 'en'];

    for (final fallbackLang in fallbacks) {
      final String currentOverview = target['overview'] ?? '';
      final String currentName = target['name'] ?? '';

      if (currentOverview.isEmpty || currentName.isEmpty) {
        final translation = translations.firstWhere(
          (t) =>
              (t['iso_639_1'] ?? '').toString().toLowerCase() == fallbackLang,
          orElse: () => null,
        );

        if (translation != null && translation['data'] != null) {
          final data = translation['data'];
          
          if (currentOverview.isEmpty) {
            final String fallbackOverview = data['overview'] ?? '';
            if (fallbackOverview.isNotEmpty) {
              target['overview'] = fallbackOverview;
            }
          }
          
          if (currentName.isEmpty) {
            final String fallbackName = data['name'] ?? data['title'] ?? '';
            if (fallbackName.isNotEmpty) {
              target['name'] = fallbackName;
            }
          }

          if ((target['overview'] ?? '').isNotEmpty && (target['name'] ?? '').isNotEmpty) {
            break;
          }
        }
      } else {
        break;
      }
    }
  }

  void _mergeImages(Map<String, dynamic> target) {
    if (target['images'] != null && target['images']['backdrops'] != null) {
      List<dynamic> backdrops = List.from(target['images']['backdrops']);
      if (backdrops.isNotEmpty) {
        backdrops.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            backdrops.take(10).map((b) => b['file_path']).toList();
      }
    }

    if (target[TmdbTitleFields.images] is! List) {
      target[TmdbTitleFields.images] = [];
    }
  }
}
