import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/features/titles/widgets/user_rate_button.dart';
import 'package:moviescout/features/titles/widgets/rate_form.dart';
import 'package:moviescout/core/widgets/boxed_widget.dart';
import 'package:moviescout/features/titles/widgets/omdb_rating_widget.dart';
import 'package:provider/provider.dart';

class TitleRatingSection extends StatelessWidget {
  final TmdbTitle title;
  final List<Map<String, dynamic>>? omdbRatings;
  final bool isUpdatingRatings;
  final Future<void> Function(double rating) onRatingChanged;

  const TitleRatingSection({
    super.key,
    required this.title,
    required this.omdbRatings,
    required this.isUpdatingRatings,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    String titleVoteAverage = '-.-';

    if (title.firstAirDate.isNotEmpty &&
        DateTime.parse(title.firstAirDate).isAfter(DateTime.now())) {
      return Text(AppLocalizations.of(context)!.notReleasedYet);
    }
    if (title.voteAverage > 0) {
      titleVoteAverage = title.voteAverage == 10.0
          ? '10'
          : title.voteAverage.toStringAsFixed(1);
    }

    List<Widget> topChildren = [];
    if (title.voteAverage > 0) {
      topChildren.add(
        Tooltip(
          message: 'The Movie Database',
          child: BoxedWidget(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/tmdb-logo.png', height: 16),
                const SizedBox(width: 5),
                Text(
                  titleVoteAverage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (omdbRatings != null && omdbRatings!.isNotEmpty) {
      for (var rating in omdbRatings!) {
        topChildren.add(OmdbRatingWidget(rating: rating));
      }
    }

    if (isUpdatingRatings) {
      topChildren.add(
        const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      );
    }

    List<Widget> leftColChildren = [];
    List<Widget> rightColChildren = [];
    for (int i = 0; i < 2; i++) {
      if (i > 0) {
        leftColChildren.add(const SizedBox(height: 12));
        rightColChildren.add(const SizedBox(height: 12));
      }
      leftColChildren.add(topChildren.length > i * 2
          ? topChildren[i * 2]
          : const SizedBox(height: 24));
      rightColChildren.add(topChildren.length > i * 2 + 1
          ? topChildren[i * 2 + 1]
          : const SizedBox(height: 24));
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        runSpacing: 15,
        children: [
          if (topChildren.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leftColChildren,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: rightColChildren,
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
          Consumer<RateslistService>(
            builder: (context, ratingService, child) {
              return FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  ratingService.getRatingDate(title.tmdbId, title.mediaType),
                  ratingService.contains(title),
                  ratingService.getRatingAsync(title.tmdbId, title.mediaType),
                ]),
                builder: (context, snapshot) {
                  final isUserLoggedIn =
                      Provider.of<SupabaseAuthService>(context).isLoggedIn;

                  final titleRatingDate = snapshot.data?[0] as DateTime? ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  final titleRating = snapshot.data?[2] as double? ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.your_rate.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserRateButton(
                            isUserLoggedIn: isUserLoggedIn,
                            rating: titleRating,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return RateForm(
                                  title: title.name,
                                  initialRate: titleRating,
                                  initialDate: titleRatingDate,
                                  onSubmit: (double rating) async {
                                    await onRatingChanged(rating);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: !isUserLoggedIn ||
                                        titleRating > AppConstants.seenRating
                                    ? Theme.of(context).disabledColor
                                    : (titleRating == AppConstants.seenRating
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                width: 1,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.button,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: !isUserLoggedIn ||
                                    titleRating > AppConstants.seenRating
                                ? null
                                : () async {
                                    final newRating =
                                        titleRating == AppConstants.seenRating
                                            ? 0.0
                                            : AppConstants.seenRating;

                                    await onRatingChanged(newRating);
                                  },
                            child: Tooltip(
                              message: titleRating == AppConstants.seenRating
                                  ? AppLocalizations.of(context)!.seen
                                  : AppLocalizations.of(context)!.markAsSeen,
                              child: Icon(
                                titleRating > 0
                                    ? Symbols.done_outline
                                    : Symbols.check,
                                size: 16,
                                color: titleRating > 0
                                    ? (!isUserLoggedIn ||
                                            titleRating >
                                                AppConstants.seenRating
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).colorScheme.primary)
                                    : (isUserLoggedIn
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Theme.of(context).disabledColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
