import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';

Widget snoozeButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer<TmdbWatchlistService>(
    builder: (context, watchlistService, _) {
      return FutureBuilder<TmdbTitle?>(
        future: watchlistService.getTitleByTmdbId(title.tmdbId, title.mediaType),
        builder: (context, snapshot) {
          final watchlistTitle = snapshot.data;

          if (watchlistTitle == null) {
            return const SizedBox.shrink();
          }

          if (watchlistTitle.status != 'Returning Series') {
            return const SizedBox.shrink();
          }

          bool isSnoozed = watchlistTitle.isSnoozed;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              watchlistService.toggleSnooze(watchlistTitle);
            },
            icon: Icon(
              isSnoozed ? Icons.nights_stay : Icons.nights_stay_outlined,
              size: 20,
              color: isSnoozed
                  ? Theme.of(context).extension<CustomColors>()!.ratedTitle
                  : Theme.of(context).extension<CustomColors>()!.notSelected,
            ),
          );
        },
      );
    },
  );
}
