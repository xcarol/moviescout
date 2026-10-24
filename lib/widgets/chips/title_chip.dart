import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/cards/title_card.dart';
import 'package:moviescout/widgets/buttons/watchlist_button.dart';
import 'package:moviescout/utils/app_constants.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 336.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 160.0;

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
      } catch (_) {}
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
    final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FutureBuilder<TmdbTitle>(
        future: titleFuture,
        builder: (context, snapshot) {
          // Fallback to widget.title (API data) while waiting to prevent spinners/flickers
          final titleToDisplay = localTitle ?? snapshot.data ?? widget.title;

          return MediaQuery(
            data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(clampedScale)),
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
        color: Theme.of(context)
            .extension<CustomColors>()!
            .watchedOverlayColor,
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
    return RepaintBoundary(
      child: SizedBox(
        height: CARD_HEIGHT,
        width: CARD_WIDTH,
        child: Card(
          color:
              Theme.of(context).extension<CustomColors>()!.chipCardBackground,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TitleDetails(
                          title: _title,
                          tmdbListService: tmdbListService,
                        )),
              );
              onReturnFromDetails?.call();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
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
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: Container(
                      color: Theme.of(context)
                          .extension<CustomColors>()!
                          .chipCardBackground
                          .withValues(alpha: 0.95),
                      padding: const EdgeInsets.all(8.0),
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
        const SizedBox(height: 5),
        titleBottomDetails(context, tmdbTitle),
      ],
    );
  }

  Widget titleHeaderDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbTitle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          titleSubtitle(context, tmdbTitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: titleRating(context, tmdbTitle, isCompact: true),
        ),
      ],
    );
  }

  Widget titleBottomDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return SizedBox(
      height: 30,
      child: providers(tmdbTitle),
    );
  }
}
