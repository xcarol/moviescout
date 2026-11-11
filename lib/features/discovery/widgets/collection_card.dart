import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/discovery/models/tmdb_collection.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class CollectionCard extends StatelessWidget {
  final TmdbCollection _collection;
  final TmdbTitleListService tmdbListService;

  static double cardHeight = AppSizes.listCardHeight;

  const CollectionCard({
    super.key,
    required TmdbCollection collection,
    required this.tmdbListService,
  }) : _collection = collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                AppCachedImage(
                  imageUrl: _collection.posterPath,
                  type: AppImageType.poster,
                  aspectRatio: AppSizes.aspectRatioPoster,
                  memCacheWidth: AppSizes.posterCacheWidth,
                  memCacheHeight: AppSizes.posterCacheHeight,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xs,
                      bottom: AppSpacing.xs,
                      right: AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _collection.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (_collection.overview.isNotEmpty)
                          Text(
                            _collection.overview,
                            style: theme.textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.collection,
                            style: theme.textTheme.bodySmall,
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
}
