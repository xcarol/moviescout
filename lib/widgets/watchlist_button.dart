import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';

Widget watchlistButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer2<TmdbWatchlistService, TmdbUserService>(
    builder: (_, watchlistService, userService, __) {
      if (!userService.isUserLoggedIn) {
        return IconButton(
          icon: const Icon(Icons.highlight_off),
          onPressed: () {
            ErrorService.log(
              'User not logged in',
              userMessage: AppLocalizations.of(context)!.signInToWatchlist,
            );
          },
        );
      }

      bool isInWatchlist = watchlistService.contains(title);

      return IconButton(
        color: isInWatchlist
            ? Theme.of(context).extension<CustomColors>()!.inWatchlist
            : Theme.of(context).extension<CustomColors>()!.notInWatchlist,
        icon: Icon(Icons.remove_red_eye),
        onPressed: () {
          try {
            watchlistService.updateWatchlistTitle(
              userService.accountId,
              userService.sessionId,
              title,
              !isInWatchlist,
            );
          } catch (error, stackTrace) {
            ErrorService.log(
              error,
              stackTrace: stackTrace,
            );
          }
        },
      );
    },
  );
}
