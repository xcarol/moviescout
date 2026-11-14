import 'package:flutter/material.dart';
import 'package:moviescout/features/discovery/models/tmdb_collection.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';

class CollectionCard extends StatelessWidget {
  final TmdbCollection _collection;
  final TmdbTitleListService tmdbListService;

  static double cardHeight = 160.0;

  const CollectionCard({
    super.key,
    required TmdbCollection collection,
    required this.tmdbListService,
  }) : _collection = collection;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              context.toCollectionDetails(_collection, tmdbListService);
            },
            child: Row(
              children: [
                _poster(_collection.posterPath),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _collection.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        if (_collection.overview.isNotEmpty)
                          Text(
                            _collection.overview,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.collection,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _poster(String? posterPath) {
    return AppPosterImage(
      imageUrl: posterPath,
      aspectRatio: 2 / 3,
      fallbackType: PosterFallbackType.movie,
      memCacheWidth: 200,
      memCacheHeight: 300,
      fit: BoxFit.cover,
    );
  }
}
