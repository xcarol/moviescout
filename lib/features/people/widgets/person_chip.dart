import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = AppSizes.posterChipHeight;
// ignore: constant_identifier_names
const double CARD_WIDTH = AppSizes.posterChipWidth;

class PersonChip extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  const PersonChip({
    super.key,
    required TmdbPerson person,
    required TmdbTitleListService tmdbListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return RepaintBoundary(
      child: SizedBox(
        height: CARD_HEIGHT,
        width: CARD_WIDTH,
        child: Card(
          color: customColors.chipCardBackground,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          child: InkWell(
            onTap: () {
              context.toPersonDetails(
                TmdbPerson.fromMap(person: _person.toMap()),
                _tmdbListService,
                titleContext: titleContext,
                seasonContext: seasonContext,
                episodeContext: episodeContext,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppCachedImage(
                  imageUrl: _person.posterPath,
                  type: AppImageType.avatar,
                  aspectRatio: AppSizes.aspectRatioPoster,
                  borderRadius: AppRadius.borderMd,
                  memCacheWidth: AppSizes.posterCacheWidth,
                  memCacheHeight: AppSizes.posterCacheHeight,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppRadius.md),
                      bottomRight: Radius.circular(AppRadius.md),
                    ),
                    child: Container(
                      color: customColors.chipCardBackground
                          .withValues(alpha: AppOpacity.chipFooter),
                      padding: AppSpacing.chipPadding,
                      child: _details(context, _person),
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

  Widget _details(BuildContext context, TmdbPerson tmdbPerson) {
    final theme = Theme.of(context);
    final roleText = tmdbPerson.character.isNotEmpty
        ? tmdbPerson.character
        : tmdbPerson.job.isNotEmpty
            ? tmdbPerson.localizedJob(context)
            : ' '; // Space maintains fixed overlay height without text clipping

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbPerson.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          roleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
