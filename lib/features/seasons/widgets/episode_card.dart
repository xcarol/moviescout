import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_dimensions.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/date_formatter.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class EpisodeCard extends StatelessWidget {
  final TmdbEpisode _episode;
  final TmdbTitle _title;
  final int seasonNumber;
  final TmdbTitleListService tmdbListService;
  final int? totalEpisodes;

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
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact =
                  constraints.maxWidth <= AppBreakpoints.largeScreenMinWidth;

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _episodeThumbnail(_episode.stillPath, isCompact: true),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: _episodeDetails(context, _episode),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppDimensions.episodeStillWidth,
                    child:
                        _episodeThumbnail(_episode.stillPath, isCompact: false),
                  ),
                  AppSpacing.gapMd,
                  Expanded(child: _episodeDetails(context, _episode)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _episodeThumbnail(String? stillPath, {required bool isCompact}) {
    return AppPosterImage(
      imageUrl: stillPath,
      aspectRatio: 16 / 9,
      fallbackType: PosterFallbackType.tvShow,
      memCacheWidth: isCompact ? 640 : 320,
      memCacheHeight: isCompact ? 360 : 180,
      fit: BoxFit.cover,
    );
  }

  Widget _episodeDetails(BuildContext context, TmdbEpisode episode) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final secondaryColor = theme.colorScheme.onSurfaceVariant;
    final formattedDate = DateFormatter.formatDate(context, episode.airDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _episodeTopRow(context, episode),
        if (episode.name.isNotEmpty) ...[
          AppSpacing.gapXs,
          Text(
            episode.name,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (formattedDate.isNotEmpty || episode.runtime > 0) ...[
          AppSpacing.gapXs,
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xxs,
            children: [
              if (formattedDate.isNotEmpty)
                Text(
                  formattedDate,
                  style: textTheme.bodySmall?.copyWith(color: secondaryColor),
                ),
              if (episode.runtime > 0)
                Text(
                  '${episode.runtime} min',
                  style: textTheme.bodySmall?.copyWith(color: secondaryColor),
                ),
            ],
          ),
        ],
        if (episode.overview.isNotEmpty) ...[
          AppSpacing.gapXs,
          Text(
            episode.overview,
            style: textTheme.bodySmall?.copyWith(color: secondaryColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _episodeTopRow(BuildContext context, TmdbEpisode episode) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final episodeLabel =
        AppLocalizations.of(context)!.episodeLabel(episode.episodeNumber);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            episodeLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (episode.voteAverage > 0) ...[
          AppSpacing.gapSm,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: customColors.ratedTitle,
              ),
              AppSpacing.gapXs,
              Text(
                episode.voteAverage == 10.0
                    ? '10'
                    : episode.voteAverage.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: customColors.ratedTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
