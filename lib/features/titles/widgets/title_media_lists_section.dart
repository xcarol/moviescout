import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/people/widgets/person_chip.dart';
import 'package:moviescout/features/titles/widgets/title_chip.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/core/widgets/boxed_widget.dart';
import 'package:provider/provider.dart';

class TitleMediaListsSection extends StatefulWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;

  const TitleMediaListsSection({
    super.key,
    required this.title,
    required this.tmdbListService,
  });

  @override
  State<TitleMediaListsSection> createState() => _TitleMediaListsSectionState();
}

class _TitleMediaListsSectionState extends State<TitleMediaListsSection> {
  String _selectedSeason = '';

  @override
  Widget build(BuildContext context) {
    final title = widget.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!title.isMovie && title.numberOfSeasons > 0) ...[
          const SizedBox(height: AppSpacing.md),
          _seasonsDropdown(title),
          const SizedBox(height: AppSpacing.md),
        ],
        _castAndCrew(title, PersonAttributes.cast),
        const SizedBox(height: AppSpacing.xl),
        _recommended(title),
        const SizedBox(height: AppSpacing.xl),
        _castAndCrew(title, PersonAttributes.crew),
      ],
    );
  }

  Widget _seasonsDropdown(TmdbTitle title) {
    if (title.isMovie || title.numberOfSeasons == 0) {
      return const SizedBox.shrink();
    }

    final selectSeasonText = AppLocalizations.of(context)!.selectSeason;

    final List<String> seasonOptions = [selectSeasonText];
    for (int i = 1; i <= title.numberOfSeasons; i++) {
      seasonOptions.add(AppLocalizations.of(context)!.seasonLabel(i));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BoxedWidget(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: DropdownSelector(
            maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
            isExpanded: true,
            selectedOption:
                _selectedSeason.isEmpty ? selectSeasonText : _selectedSeason,
            options: seasonOptions,
            onSelected: (option) {
              if (option == selectSeasonText) return;

              final seasonIndex = seasonOptions.indexOf(option);
              if (seasonIndex < 1) return;
              final seasonNumber = seasonIndex;

              context
                  .toSeasonDetails(title, seasonNumber, widget.tmdbListService)
                  .then((_) {
                if (mounted) {
                  setState(() {
                    _selectedSeason = '';
                  });
                }
              });

              setState(() {
                _selectedSeason = option;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _castAndCrew(TmdbTitle title, String type) {
    if (type == PersonAttributes.cast && title.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    if (type == PersonAttributes.crew && title.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<TmdbPerson> people =
        type == PersonAttributes.cast ? title.cast : title.crew;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type == PersonAttributes.cast
                    ? AppLocalizations.of(context)!.cast
                    : AppLocalizations.of(context)!.crew,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toTitlePeopleList(title, type, widget.tmdbListService);
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: people.length > 20 ? 20 : people.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: _personChip(context, people[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _personChip(BuildContext context, TmdbPerson tmdbPerson) {
    return Builder(
      builder: (innerContext) {
        final mediaQuery = MediaQuery.of(innerContext);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: UiUtils.clampedTextScaler(innerContext),
          ),
          child: PersonChip(
            person: tmdbPerson,
            tmdbListService: widget.tmdbListService,
            titleContext: widget.title,
          ),
        );
      },
    );
  }

  Widget _recommended(TmdbTitle title) {
    if (title.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recommended,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
          child: Consumer<RateslistService>(
            builder: (context, ratesService, child) {
              return FutureBuilder<List<double>>(
                future: Future.wait(
                  title.recommendations.map(
                    (recTitle) => ratesService.getRatingAsync(
                        recTitle.tmdbId, recTitle.mediaType),
                  ),
                ),
                builder: (context, snapshot) {
                  final ratings = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: title.recommendations.length,
                    itemBuilder: (context, index) {
                      final recTitle = title.recommendations[index];
                      final isRated =
                          (ratings != null && ratings.length > index)
                              ? ratings[index] > 0.0
                              : false;

                      return TitleChip(
                        title: recTitle,
                        tmdbListService: widget.tmdbListService,
                        isDimmed: isRated,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
