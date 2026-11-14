import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/watchlist/widgets/pin_button.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';

class PinnedTitleChip extends StatelessWidget {
  final TmdbTitle title;
  final TmdbTitleListService listService;

  static const double cardWidth = 100.0;
  static const double cardHeight = 165.0;

  const PinnedTitleChip({
    super.key,
    required this.title,
    required this.listService,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: Theme.of(context).extension<CustomColors>()!.chipCardBackground,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.chip,
        ),
        child: InkWell(
          onTap: () {
            context.toTitleDetails(title, listService);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: _poster(title.posterPath)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: AppRadius.radiusSm,
                          ),
                        ),
                        child: pinButton(context, title),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppSpacing.edgeInsetsAllXs,
                child: Text(
                  title.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _poster(String? posterPath) {
    return AppPosterImage(
      imageUrl: posterPath,
      aspectRatio: null,
      fallbackType:
          title.isMovie ? PosterFallbackType.movie : PosterFallbackType.tvShow,
      memCacheWidth: 200,
      memCacheHeight: 300,
      fit: BoxFit.cover,
      fallbackFit: BoxFit.contain,
    );
  }
}
