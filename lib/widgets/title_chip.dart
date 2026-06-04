import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/watchlist_button.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 480.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 200.0;

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
  late Future<TmdbTitle> _titleFuture;

  @override
  void initState() {
    super.initState();
    _titleFuture = TmdbTitleService().updateTitleLight(widget.title);
  }

  @override
  void didUpdateWidget(covariant TitleChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title.tmdbId != oldWidget.title.tmdbId ||
        widget.title.mediaType != oldWidget.title.mediaType) {
      _titleFuture = TmdbTitleService().updateTitleLight(widget.title);
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
              title: snapshot.data!,
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
          child: Column(
            children: [
              SizedBox(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: titlePoster(_title.posterPath),
                ),
              ),
              const SizedBox(width: 10),
              _titleDetails(context, _title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleHeader(tmdbTitle.name, maxLines: 2),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${titleDate(tmdbTitle)} - ${tmdbTitle.duration}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  Flexible(child: providers(tmdbTitle)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
