import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/theme/app_dimensions.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class SeasonChip extends StatelessWidget {
  final Map<String, dynamic> season;
  final VoidCallback onTap;

  const SeasonChip({
    super.key,
    required this.season,
    required this.onTap,
  });

  String? _resolvePosterUrl() {
    final rawPath = (season['poster_path'] ?? '').toString().trim();
    if (rawPath.isEmpty) return null;
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return rawPath;
    }
    return UrlConstants.tmdbImageW500Template.replaceFirst('{PATH}', rawPath);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final loc = AppLocalizations.of(context)!;

    final int seasonNumber = (season['season_number'] as int?) ?? 0;
    final String rawName = (season['name'] ?? '').toString().trim();
    final String titleText =
        rawName.isNotEmpty ? rawName : loc.seasonLabel(seasonNumber);

    final int episodeCount = (season['episode_count'] as int?) ?? 0;
    final String airDate = (season['air_date'] ?? '').toString().trim();
    final String year = airDate.length >= 4 ? airDate.substring(0, 4) : '';
    final String metaText = [
      if (episodeCount > 0) '$episodeCount ${loc.episodes}',
      if (year.isNotEmpty) year,
    ].join(' · ');

    return RepaintBoundary(
      child: SizedBox(
        width: AppDimensions.seasonChipWidth,
        child: Card(
          color: customColors.chipCardBackground,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.chip,
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppPosterImage(
                  imageUrl: _resolvePosterUrl(),
                  aspectRatio: 2 / 3,
                  fallbackType: PosterFallbackType.tvShow,
                  memCacheWidth: 300,
                  memCacheHeight: 450,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: AppSpacing.edgeInsetsAllSm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titleText,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (metaText.isNotEmpty) ...[
                        AppSpacing.gapXxs,
                        Text(
                          metaText,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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
