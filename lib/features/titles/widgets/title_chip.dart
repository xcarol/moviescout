import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_service.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/features/watchlist/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = AppSizes.posterChipHeight;
// ignore: constant_identifier_names
const double CARD_WIDTH = AppSizes.posterChipWidth;

class TitleChip extends StatefulWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;
  final bool isDimmed;

  const TitleChip({
    super.key,
    required this.title,
    required this.tmdbListService,
    this.isDimmed = false,
  });

  @override
  State<TitleChip> createState() => TitleChipState();
}

class TitleChipState<T extends TitleChip> extends State<T> {
  @protected
  Future<TmdbTitle>? titleFuture;
  @protected
  TmdbTitle? localTitle;
  @protected
  TmdbTitle? ratedTitle;

  @override
  void initState() {
    super.initState();
    loadLocalTitle();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title.tmdbId != oldWidget.title.tmdbId ||
        widget.title.mediaType != oldWidget.title.mediaType) {
      loadLocalTitle();
    }
  }

  @protected
  Future<void> loadLocalTitle() async {
    final local = await widget.tmdbListService
        .getTitleByTmdbId(widget.title.tmdbId, widget.title.mediaType);

    TmdbTitle? rated;
    if (mounted) {
      try {
        final ratesService =
            Provider.of<RateslistService>(context, listen: false);
        rated = await ratesService.getTitleByTmdbId(
            widget.title.tmdbId, widget.title.mediaType);
      } catch (e, stackTrace) {
        ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
      }
    }

    if (mounted) {
      setState(() {
        localTitle = local;
        ratedTitle = rated;
        if (local == null) {
          titleFuture = TmdbTitleService().updateTitleLight(widget.title);
        } else {
          titleFuture = Future.value(local);
        }
      });
    }
  }

  @protected
  bool get shouldDim {
    final isRatedByMainUser = ratedTitle != null &&
        (ratedTitle!.rating > 0 ||
            ratedTitle!.rating == AppConstants.seenRating);
    final isLocallyRated = localTitle != null &&
        (localTitle!.rating > 0 ||
            localTitle!.rating == AppConstants.seenRating);
    return widget.isDimmed || isLocallyRated || isRatedByMainUser;
  }

  @protected
  Widget buildContent(BuildContext context, TmdbTitle titleToDisplay) {
    return TitleChipContent(
      title: titleToDisplay,
      tmdbListService: widget.tmdbListService,
      isDimmed: shouldDim,
      onReturnFromDetails: loadLocalTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: FutureBuilder<TmdbTitle>(
        future: titleFuture,
        builder: (context, snapshot) {
          final titleToDisplay = localTitle ?? snapshot.data ?? widget.title;

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: UiUtils.clampedTextScaler(context),
            ),
            child: buildContent(context, titleToDisplay),
          );
        },
      ),
    );
  }
}

class TitleChipContent extends TitleCard {
  final TmdbTitle _title;
  final VoidCallback? onReturnFromDetails;
  final bool isDimmed;

  const TitleChipContent({
    super.key,
    required super.title,
    required super.tmdbListService,
    this.onReturnFromDetails,
    this.isDimmed = false,
  }) : _title = title;

  Widget posterOverlay(BuildContext context) {
    if (isDimmed) {
      return Container(
        color: Theme.of(context).extension<CustomColors>()!.watchedOverlayColor,
      );
    }

    return Consumer<RateslistService>(
      builder: (context, rateslistService, _) {
        return FutureBuilder<TmdbTitle?>(
          future: rateslistService.getTitleByTmdbId(
              _title.tmdbId, _title.mediaType),
          builder: (context, snapshot) {
            final rated = snapshot.data;
            final isRated = rated != null &&
                (rated.rating > 0 || rated.rating == AppConstants.seenRating);
            if (isRated) {
              return Container(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .watchedOverlayColor,
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return RepaintBoundary(
      child: SizedBox(
        height: CARD_HEIGHT,
        width: CARD_WIDTH,
        child: Card(
          color: customColors.chipCardBackground,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          child: InkWell(
            onTap: () async {
              await context.toTitleDetails(_title, tmdbListService);
              onReturnFromDetails?.call();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.borderMd,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      titlePoster(_title.posterPath),
                      posterOverlay(context),
                    ],
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
                    child: watchlistButton(context, _title),
                  ),
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
                      child: titleDetails(context, _title),
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

  Widget titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleHeaderDetails(context, tmdbTitle),
        const SizedBox(height: AppSpacing.xxs),
        titleBottomDetails(context, tmdbTitle),
      ],
    );
  }

  Widget titleHeaderDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbTitle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          titleSubtitle(context, tmdbTitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xxs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: titleRating(context, tmdbTitle, isCompact: true),
        ),
      ],
    );
  }

  Widget titleBottomDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return SizedBox(
      height: AppSizes.providerLogoSize,
      child: providers(tmdbTitle),
    );
  }
}
