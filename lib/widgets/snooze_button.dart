import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:provider/provider.dart';

Widget snoozeButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer<TmdbRateslistService>(
    builder: (context, rateslistService, _) {
      return FutureBuilder<TmdbTitle?>(
        future:
            rateslistService.getTitleByTmdbId(title.tmdbId, title.mediaType),
        builder: (context, snapshot) {
          final titleFromList = snapshot.data;

          if (titleFromList == null) {
            return const SizedBox.shrink();
          }

          if (titleFromList.status != 'Returning Series') {
            return const SizedBox.shrink();
          }

          bool isSnoozed = titleFromList.isSnoozed;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              rateslistService.toggleSnooze(titleFromList);
            },
            icon: Icon(
              Icons.pause_circle_outline,
              size: 20,
              color: isSnoozed
                  ? Theme.of(context).extension<CustomColors>()!.snoozedTitle
                  : Theme.of(context).disabledColor,
            ),
          );
        },
      );
    },
  );
}
