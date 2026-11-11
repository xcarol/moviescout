import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/watchlist/widgets/pin_button.dart';

class PinnedTitleChip extends StatelessWidget {
  final TmdbTitle title;
  final TmdbTitleListService listService;

  static const double cardWidth = AppSizes.pinnedChipWidth;
  static const double cardHeight = AppSizes.pinnedChipHeight;

  const PinnedTitleChip({
    super.key,
    required this.title,
    required this.listService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: customColors.chipCardBackground,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
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
                    Positioned.fill(
                      child: AppCachedImage(
                        imageUrl: title.posterPath,
                        type: AppImageType.poster,
                        memCacheWidth: AppSizes.posterCacheWidth,
                        memCacheHeight: AppSizes.posterCacheHeight,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.micro),
                        decoration: BoxDecoration(
                          color: customColors.chipCardBackground
                              .withValues(alpha: AppOpacity.chipBadge),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(AppRadius.sm),
                          ),
                        ),
                        child: pinButton(context, title),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxs),
                child: Text(
                  title.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
