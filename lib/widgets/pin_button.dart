import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';

Widget pinButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer<TmdbWatchlistService>(
    builder: (context, watchlistService, _) {
      final watchlistTitle =
          watchlistService.getTitleByTmdbId(title.tmdbId, title.mediaType);

      if (watchlistTitle == null) {
        return const SizedBox.shrink();
      }

      bool isPinned = watchlistTitle.isPinned;

      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          watchlistService.togglePin(
            watchlistTitle,
            limitReachedMessage: AppLocalizations.of(context)!.pinLimitReached,
          );
        },
        icon: Icon(
          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
          size: 20,
          color: isPinned
              ? Theme.of(context).extension<CustomColors>()!.pinnedTitle
              : Theme.of(context).extension<CustomColors>()!.notSelected,
        ),
        tooltip: isPinned
            ? AppLocalizations.of(context)!.unpin
            : AppLocalizations.of(context)!.pin,
      );
    },
  );
}
