import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/date_formatter.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

class EpisodeCard extends StatelessWidget {
  final TmdbEpisode _episode;
  final TmdbTitle _title;
  final int seasonNumber;
  final TmdbTitleListService tmdbListService;
  final int? totalEpisodes;

  static double cardHeight = AppSizes.episodeCardHeight;

  const EpisodeCard({
    super.key,
    required TmdbTitle title,
    required this.seasonNumber,
    required TmdbEpisode episode,
    required this.tmdbListService,
    this.totalEpisodes,
  })  : _title = title,
        _episode = episode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.toEpisodeDetails(
                title: _title,
                seasonNumber: seasonNumber,
                episodeNumber: _episode.episodeNumber,
                tmdbListService: tmdbListService,
                initialEpisode: _episode,
                totalEpisodes: totalEpisodes ?? 0,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: AppSizes.episodeThumbnailWidth,
                  child: episodeThumbnail(_episode.stillPath),
                ),
                const SizedBox(width: AppSpacing.sm),
                _episodeDetails(context, _episode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget episodeThumbnail(String? stillPath) {
    return AppCachedImage(
      imageUrl: stillPath,
      type: AppImageType.backdrop,
      aspectRatio: AppSizes.aspectRatioBackdrop,
      memCacheWidth: AppSizes.stillCacheWidth,
      memCacheHeight: AppSizes.stillCacheHeight,
    );
  }

  Widget _episodeDetails(BuildContext context, TmdbEpisode episode) {
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.xs,
          right: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            episodeHeader(
              '${episode.episodeNumber}. ${episode.name}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              DateFormatter.formatDate(context, episode.airDate),
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            if (episode.runtime > 0) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${episode.runtime} min',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.xxs),
            episodeRating(context, episode),
          ],
        ),
      ),
    );
  }

  Text episodeHeader(
    String name, {
    int maxLines = 2,
    TextStyle? style,
  }) {
    return Text(
      name,
      style: style ??
          const TextStyle(
            fontWeight: FontWeight.w600,
          ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget episodeRating(BuildContext context, TmdbEpisode episode) {
    if (episode.voteAverage == 0.0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.star,
          size: AppSizes.iconSm,
          color: theme.extension<CustomColors>()!.ratedTitle,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          episode.voteAverage.toStringAsFixed(2),
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
