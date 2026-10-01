import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:provider/provider.dart';

Widget watchlistButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer2<WatchlistService, SupabaseAuthService>(
    builder: (_, watchlistService, authService, __) {
      return FutureBuilder(
        future: watchlistService.contains(title),
        builder: (context, snapshot) {
          bool isLoggedIn = authService.isLoggedIn;
          if (!isLoggedIn) {
            return IconButton(
              icon: const Icon(Icons.highlight_off),
              onPressed: () {
                SnackMessage.showSnackBar(
                    AppLocalizations.of(context)!.signInToWatchlist);
              },
            );
          }

          bool isInWatchlist = snapshot.data ?? false;

          return IconButton(
            color: isInWatchlist
                ? Theme.of(context).extension<CustomColors>()!.inWatchlist
                : Theme.of(context).extension<CustomColors>()!.notInWatchlist,
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              try {
                watchlistService.updateWatchlistTitle(
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
    },
  );
}
