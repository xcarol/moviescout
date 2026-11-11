import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/notifications/widgets/notify_button.dart';
import 'package:moviescout/features/settings/models/tmdb_provider.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/features/watchlist/widgets/pin_button.dart';
import 'package:moviescout/features/watchlist/widgets/watchlist_button.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final TmdbTitleListService _tmdbListService;

  static double cardHeight = AppSizes.listCardHeight;

  const TitleCard({
    super.key,
    required TmdbTitle title,
    required TmdbTitleListService tmdbListService,
  })  : _title = title,
        _tmdbListService = tmdbListService;

  TmdbTitleListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TmdbTitle?>(
      future:
          _tmdbListService.getTitleByTmdbId(_title.tmdbId, _title.mediaType),
      builder: (context, snapshot) {
        final tmdbTitle = snapshot.data ?? _title;

        return RepaintBoundary(
          child: SizedBox(
            height: cardHeight,
            child: Card(
              child: InkWell(
                onTap: () {
                  context.toTitleDetails(tmdbTitle, tmdbListService);
                },
                child: Row(
                  children: [
                    titlePoster(tmdbTitle.posterPath),
                    const SizedBox(width: AppSpacing.sm),
                    _titleDetails(context, tmdbTitle),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static const double iconTextSpacingCompact = AppSpacing.xxs;
  static const double iconTextSpacingDefault = AppSpacing.xxs;
  static const double betweenSpacingCompact = AppSpacing.xs;
  static const double betweenSpacingDefault = AppSpacing.md;

  List<Widget> buildRatingWidgets(
    BuildContext context, {
    required double rating,
    required Color color,
    bool isCompact = false,
  }) {
    final theme = Theme.of(context);
    final double iconTextSpacing =
        isCompact ? iconTextSpacingCompact : iconTextSpacingDefault;
    final double iconSize = isCompact ? AppSizes.iconSm : AppSizes.iconMd;

    if (rating == AppConstants.seenRating) {
      return [
        Icon(
          Icons.check,
          size: iconSize,
          color: color,
        ),
        if (!isCompact) ...[
          SizedBox(width: iconTextSpacing),
          Text(
            AppLocalizations.of(context)!.seen,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ];
    } else if (rating > 0) {
      return [
        Icon(
          Icons.star,
          size: iconSize,
          color: color,
        ),
        SizedBox(width: iconTextSpacing),
        Text(
          rating == 10.0 ? '10' : rating.toStringAsFixed(1),
          style: isCompact
              ? theme.textTheme.labelMedium
              : theme.textTheme.labelLarge,
        ),
      ];
    }
    return [];
  }

  Widget titleRating(BuildContext context, TmdbTitle tmdbTitle,
      {bool isCompact = false}) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final double iconTextSpacing =
        isCompact ? iconTextSpacingCompact : iconTextSpacingDefault;
    final double betweenSpacing =
        isCompact ? betweenSpacingCompact : betweenSpacingDefault;
    final double iconSize = isCompact ? AppSizes.iconSm : AppSizes.iconMd;

    if (tmdbTitle.voteAverage == 0.0) {
      return const SizedBox.shrink();
    }

    final List<Widget> children = [];
    if (tmdbTitle.voteAverage > 0) {
      children.addAll([
        Icon(
          Icons.star,
          size: iconSize,
          color: customColors.ratedTitle,
        ),
        SizedBox(width: iconTextSpacing),
        Text(
          tmdbTitle.voteAverage.toStringAsFixed(2),
          style: isCompact
              ? theme.textTheme.labelMedium
              : theme.textTheme.labelLarge,
        ),
      ]);
    }

    return Consumer<RateslistService>(
      builder: (context, rateslistService, _) {
        return FutureBuilder<TmdbTitle?>(
          future: rateslistService.getTitleByTmdbId(
              tmdbTitle.tmdbId, tmdbTitle.mediaType),
          builder: (context, snapshot) {
            final ratedTitle = snapshot.data;
            final ratingChildren = List<Widget>.from(children);

            if (ratedTitle != null && ratedTitle.tmdbId > 0) {
              if (ratingChildren.isNotEmpty) {
                ratingChildren.add(SizedBox(width: betweenSpacing));
              }
              ratingChildren.addAll(
                buildRatingWidgets(
                  context,
                  rating: ratedTitle.rating,
                  color: customColors.userRatedTitle,
                  isCompact: isCompact,
                ),
              );
            }

            if (ratingChildren.isEmpty) {
              return SizedBox(height: IconTheme.of(context).size ?? iconSize);
            }

            return Row(children: ratingChildren);
          },
        );
      },
    );
  }

  Widget titlePoster(String? posterPath) {
    return AppCachedImage(
      imageUrl: posterPath,
      type: AppImageType.poster,
      aspectRatio: AppSizes.aspectRatioPoster,
      memCacheWidth: AppSizes.posterCacheWidth,
      memCacheHeight: AppSizes.posterCacheHeight,
    );
  }

  Widget _titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.xxs,
          right: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleHeader(
              tmdbTitle.name,
              maxLines: 2,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    titleSubtitle(context, tmdbTitle),
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            titleRating(context, tmdbTitle),
            const SizedBox(height: AppSpacing.xxs),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_titleBottomRow(context, tmdbTitle)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text titleHeader(
    String name, {
    int maxLines = 1,
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

  Row _titleBottomRow(BuildContext context, TmdbTitle tmdbTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: providers(tmdbTitle)),
        Row(
          children: [
            notifyButton(context, tmdbTitle),
            const SizedBox(width: AppSpacing.xs),
            pinButton(context, tmdbTitle),
            const SizedBox(width: AppSpacing.xs),
            watchlistButton(context, tmdbTitle),
          ],
        ),
      ],
    );
  }

  Widget providers(TmdbTitle tmdbTitle) {
    if (tmdbTitle.providers.isEmpty) {
      return const SizedBox.shrink();
    }
    final streamableProviders = [
      ...tmdbTitle.providers.flatrate,
      ...tmdbTitle.providers.free,
      ...tmdbTitle.providers.ads,
    ];
    final seen = <int>{};
    final uniqueProviders =
        streamableProviders.where((p) => seen.add(p.id)).toList();

    if (uniqueProviders.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      key: ValueKey(tmdbTitle.tmdbId),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: uniqueProviders
            .map<Widget>((provider) => _providerLogo(provider))
            .toList(),
      ),
    );
  }

  Widget _providerLogo(TmdbProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xxs),
      child: Tooltip(
        message: provider.name,
        child: AppCachedImage(
          imageUrl: provider.logoPath,
          type: AppImageType.logo,
          width: AppSizes.providerLogoSize,
          height: AppSizes.providerLogoSize,
          borderRadius: AppRadius.borderXs,
          memCacheWidth: AppSizes.providerCacheSize,
          memCacheHeight: AppSizes.providerCacheSize,
        ),
      ),
    );
  }
}

String titleDate(TmdbTitle tmdbTitle) {
  String text = '';

  if (tmdbTitle.isMovie) {
    text = tmdbTitle.releaseDate.isNotEmpty
        ? tmdbTitle.releaseDate.substring(0, 4)
        : '';
  } else if (tmdbTitle.isSerie) {
    final firstAirDate = tmdbTitle.firstAirDate;
    final isOnAir = tmdbTitle.isOnAir;
    final lastAirDate = tmdbTitle.lastAirDate;

    text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

    if (!tmdbTitle.isMiniSerie) {
      if (isOnAir) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    } else if (isOnAir) {
      text += ' - ...';
    }
  }

  return text;
}

String titleType(BuildContext context, String mediaType) {
  return mediaType == ApiConstants.movie
      ? AppLocalizations.of(context)!.movie
      : AppLocalizations.of(context)!.tvShow;
}

String titleSubtitle(BuildContext context, TmdbTitle tmdbTitle) {
  final date = titleDate(tmdbTitle);
  String typeOrDuration = tmdbTitle.duration;
  if (typeOrDuration.isEmpty) {
    typeOrDuration = titleType(context, tmdbTitle.mediaType);
  }

  if (date.isNotEmpty && typeOrDuration.isNotEmpty) {
    return '$date - $typeOrDuration';
  } else if (date.isNotEmpty) {
    return date;
  } else {
    return typeOrDuration;
  }
}
