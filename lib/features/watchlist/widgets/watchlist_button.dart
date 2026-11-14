import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.highlight_off, size: 20),
              onPressed: () {
                SnackMessage.showSnackBar(
                    AppLocalizations.of(context)!.signInToWatchlist);
              },
            );
          }

          bool isInWatchlist = snapshot.data ?? false;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: isInWatchlist
                ? Theme.of(context).extension<CustomColors>()!.inWatchlist
                : Theme.of(context).extension<CustomColors>()!.notInWatchlist,
            icon: const Icon(Icons.remove_red_eye, size: 20),
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
