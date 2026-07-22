import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/cards/title_card.dart';
import 'package:moviescout/widgets/buttons/watchlist_button.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 336.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 160.0;

class TitleChip extends StatefulWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;

  const TitleChip({
    super.key,
    required this.title,
    required this.tmdbListService,
  });

  @override
  State<TitleChip> createState() => _TitleChipState();
}

class _TitleChipState extends State<TitleChip> {
  Future<TmdbTitle>? _titleFuture;
  TmdbTitle? _localTitle;

  @override
  void initState() {
    super.initState();
    _loadLocalTitle();
  }

  @override
  void didUpdateWidget(covariant TitleChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title.tmdbId != oldWidget.title.tmdbId ||
        widget.title.mediaType != oldWidget.title.mediaType) {
      _loadLocalTitle();
    }
  }

  Future<void> _loadLocalTitle() async {
    final local = await widget.tmdbListService
        .getTitleByTmdbId(widget.title.tmdbId, widget.title.mediaType);

    if (mounted) {
      setState(() {
        _localTitle = local;
        if (local == null) {
          _titleFuture = TmdbTitleService().updateTitleLight(widget.title);
        } else {
          _titleFuture = Future.value(local);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FutureBuilder<TmdbTitle>(
        future: _titleFuture,
        builder: (context, snapshot) {
          // Fallback to widget.title (API data) while waiting to prevent spinners/flickers
          final titleToDisplay = _localTitle ?? snapshot.data ?? widget.title;

          return MediaQuery(
            data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(clampedScale)),
            child: _TitleChipContent(
              title: titleToDisplay,
              tmdbListService: widget.tmdbListService,
              onReturnFromDetails: _loadLocalTitle,
            ),
          );
        },
      ),
    );
  }
}

class _TitleChipContent extends TitleCard {
  final TmdbTitle _title;
  final VoidCallback? onReturnFromDetails;

  const _TitleChipContent({
    required super.title,
    required super.tmdbListService,
    this.onReturnFromDetails,
  }) : _title = title;

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
                  child: titlePoster(_title.posterPath),
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
                      child: _titleDetails(context, _title),
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

  Widget _titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
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
        const SizedBox(height: 5),
        SizedBox(
          height: 30,
          child: providers(tmdbTitle),
        ),
      ],
    );
  }
}
