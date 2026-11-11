import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Widget pinButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer<WatchlistService>(
    builder: (context, watchlistService, _) {
      return FutureBuilder<TmdbTitle?>(
        future:
            watchlistService.getTitleByTmdbId(title.tmdbId, title.mediaType),
        builder: (context, snapshot) {
          final watchlistTitle = snapshot.data;

          if (watchlistTitle == null) {
            return const SizedBox.shrink();
          }

          final isPinned = watchlistTitle.isPinned;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              watchlistService.togglePin(
                watchlistTitle,
                limitReachedMessage:
                    AppLocalizations.of(context)!.pinLimitReached,
              );
            },
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              size: AppSizes.iconMd,
              color: isPinned
                  ? Theme.of(context).extension<CustomColors>()!.pinnedTitle
                  : Theme.of(context).disabledColor,
            ),
            tooltip: isPinned
                ? AppLocalizations.of(context)!.unpin
                : AppLocalizations.of(context)!.pin,
          );
        },
      );
    },
  );
}
