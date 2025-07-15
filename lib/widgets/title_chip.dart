import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/watchlist_button.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 480.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 200.0;

class TitleChip extends TitleCard {
  final TmdbTitle _title;

  const TitleChip({
    super.key,
    required super.title,
    required super.tmdbListService,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    TmdbTitle tmdbTitle = tmdbListService.titles.firstWhere(
      (title) => title.id == _title.id,
      orElse: () => _title,
    );

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
                        title: TmdbTitle(title: tmdbTitle.map),
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
                  child: titlePoster(tmdbTitle.posterPath),
                ),
              ),
              const SizedBox(width: 10),
              _titleDetails(context, tmdbTitle),
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
