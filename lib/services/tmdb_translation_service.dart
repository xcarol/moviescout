import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbTranslationService extends TmdbBaseService {
  Future<List<TmdbTranslation>> getTranslations(
      String mediaType, int id) async {
    final response = await get('$mediaType/$id/translations');
    return _parseTranslations(response);
  }

  Future<List<TmdbTranslation>> getSeasonTranslations(
      int tvId, int seasonNumber) async {
    final response = await get('tv/$tvId/season/$seasonNumber/translations');
    return _parseTranslations(response);
  }

  Future<List<TmdbTranslation>> getEpisodeTranslations(
      int tvId, int seasonNumber, int episodeNumber) async {
    final response = await get(
        'tv/$tvId/season/$seasonNumber/episode/$episodeNumber/translations');
    return _parseTranslations(response);
  }

  List<TmdbTranslation> _parseTranslations(dynamic response) {
    if (response == null || response.statusCode != 200) {
      return [];
    }

    final data = body(response);
    if (!data.containsKey('translations')) {
      return [];
    }

    final translationsList = data['translations'] as List;
    return translationsList.map((e) => TmdbTranslation.fromJson(e)).toList();
  }
}
