import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/watchlist_button.dart';

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

  @override
  void initState() {
    super.initState();
    _checkInitFuture();
  }

  @override
  void didUpdateWidget(covariant TitleChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title.tmdbId != oldWidget.title.tmdbId ||
        widget.title.mediaType != oldWidget.title.mediaType) {
      _checkInitFuture();
    }
  }

  void _checkInitFuture() {
    final localTitle = widget.tmdbListService.getTitleByTmdbIdSync(
        widget.title.tmdbId, widget.title.mediaType);
    if (localTitle == null) {
      _titleFuture = TmdbTitleService().updateTitleLight(widget.title);
    } else {
      _titleFuture = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

    // Always fetch latest from DB synchronously in case it was updated (e.g. returning from details)
    final localTitle = widget.tmdbListService.getTitleByTmdbIdSync(
        widget.title.tmdbId, widget.title.mediaType);

    if (localTitle != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(clampedScale)),
          child: _TitleChipContent(
            title: localTitle,
            tmdbListService: widget.tmdbListService,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FutureBuilder<TmdbTitle>(
        future: _titleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: CARD_HEIGHT,
              width: CARD_WIDTH,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(clampedScale)),
            child: _TitleChipContent(
              title: snapshot.data ?? widget.title,
              tmdbListService: widget.tmdbListService,
            ),
          );
        },
      ),
    );
  }
}

class _TitleChipContent extends TitleCard {
  final TmdbTitle _title;

  const _TitleChipContent({
    required super.title,
    required super.tmdbListService,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT,
      width: CARD_WIDTH,
      child: Card(
        color: Theme.of(context).extension<CustomColors>()!.chipCardBackground,
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TitleDetails(
                        title: _title,
                        tmdbListService: tmdbListService,
                      )),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: titlePoster(_title.posterPath),
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
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Theme.of(context)
                          .extension<CustomColors>()!
                          .chipCardBackground
                          .withValues(alpha: 0.8),
                      padding: const EdgeInsets.all(8.0),
                      child: _titleDetails(context, _title),
                    ),
                  ),
                ),
              ),
            ],
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
          '${titleDate(tmdbTitle)} - ${tmdbTitle.duration}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        titleRating(
          context,
          tmdbTitle,
          extraWidgets: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  watchlistButton(context, tmdbTitle),
                ],
              ),
            ),
          ],
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
