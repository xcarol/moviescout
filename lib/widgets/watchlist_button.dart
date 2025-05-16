import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';

Widget watchlistButton(
  BuildContext context,
  TmdbTitle title, {
  bool isUpdating = false,
}) {
  TmdbUserService userService =
      Provider.of<TmdbUserService>(context, listen: false);

  if (userService.user == null) {
    return IconButton(
      icon: const Icon(Icons.highlight_off),
      onPressed: () {
        SnackMessage.showSnackBar(
            AppLocalizations.of(context)!.signInToWatchlist);
      },
    );
  }

  if (isUpdating) {
    return IconButton(
      icon: const Icon(Icons.hourglass_empty),
      onPressed: () {},
    );
  }

  return Consumer<TmdbWatchlistService>(
    builder: (_, watchlistService, __) {
      bool isInWatchlist = watchlistService.contains(title);

      return IconButton(
        color: isInWatchlist ? Colors.amber : Colors.grey,
        icon: Icon(Icons.remove_red_eye),
        onPressed: () {
          watchlistService.updateWatchlistTitle(
            userService.accountId,
            userService.sessionId,
            title,
            !isInWatchlist,
          );
        },
      );
    },
  );
}
