import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/utils/url_constants.dart';

class TmdbCollection implements TmdbItem {
  @override
  int tmdbId;
  @override
  String name;
  String overview;
  String? posterPathSuffix;
  String? backdropPathSuffix;
  @override
  String lastUpdated;

  TmdbCollection({
    required this.tmdbId,
    required this.name,
    this.overview = '',
    this.posterPathSuffix,
    this.backdropPathSuffix,
    required this.lastUpdated,
  });

  factory TmdbCollection.fromMap({required Map<dynamic, dynamic> collection}) {
    return TmdbCollection(
      tmdbId: collection['id'] ?? 0,
      name: collection['name'] ?? '',
      overview: collection['overview'] ?? '',
      posterPathSuffix: collection['poster_path'],
      backdropPathSuffix: collection['backdrop_path'],
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }

  String get posterPath =>
      posterPathSuffix != null && posterPathSuffix!.isNotEmpty
          ? UrlConstants.tmdbImageOriginalTemplate
              .replaceFirst('{PATH}', posterPathSuffix!)
          : '';

  String get backdropPath =>
      backdropPathSuffix != null && backdropPathSuffix!.isNotEmpty
          ? UrlConstants.tmdbImageOriginalTemplate
              .replaceFirst('{PATH}', backdropPathSuffix!)
          : '';
}
