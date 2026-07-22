import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:provider/provider.dart';

Widget notifyButton(
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

          if (titleFromList.status != TvShowStatus.returning) {
            return const SizedBox.shrink();
          }

          bool notifyNewSeasons = titleFromList.notifyNewSeasons;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              rateslistService.toggleNotify(titleFromList);
            },
            icon: Icon(
              notifyNewSeasons
                  ? Icons.notifications_active
                  : Icons.notifications_off_outlined,
              size: 20,
              color: notifyNewSeasons
                  ? Theme.of(context).extension<CustomColors>()!.followingTitle
                  : Theme.of(context).disabledColor,
            ),
          );
        },
      );
    },
  );
}
