import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/widgets/horizontal_chip_rail.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/people/widgets/person_chip.dart';
import 'package:moviescout/features/seasons/widgets/season_chip.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/widgets/title_chip.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TitleMediaListsSection extends StatelessWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;

  const TitleMediaListsSection({
    super.key,
    required this.title,
    required this.tmdbListService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!title.isMovie && title.numberOfSeasons > 0) ...[
          AppSpacing.gapLg,
          _seasonsSection(context, title),
          AppSpacing.gapXl,
        ],
        _castAndCrew(context, title, PersonAttributes.cast),
        const SizedBox(height: 30),
        _recommended(context, title),
        const SizedBox(height: 30),
        _castAndCrew(context, title, PersonAttributes.crew),
      ],
    );
  }

  List<Map<String, dynamic>> _resolveSeasons(TmdbTitle title) {
    final parsed = title.seasons
        .whereType<Map>()
        .map((s) => Map<String, dynamic>.from(s))
        .where((s) => (s['season_number'] as int? ?? 0) > 0)
        .toList()
      ..sort((a, b) => ((a['season_number'] as int?) ?? 0)
          .compareTo((b['season_number'] as int?) ?? 0));

    if (parsed.isNotEmpty) {
      return parsed;
    }

    return List.generate(
      title.numberOfSeasons,
      (index) => <String, dynamic>{
        'season_number': index + 1,
      },
    );
  }

  Widget _seasonsSection(BuildContext context, TmdbTitle title) {
    if (title.isMovie || title.numberOfSeasons <= 0) {
      return const SizedBox.shrink();
    }

    final seasons = _resolveSeasons(title);
    if (seasons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectSeason,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.gapMd,
        HorizontalChipRail(
          children: seasons.map((season) {
            final seasonNumber = (season['season_number'] as int?) ?? 1;
            return SeasonChip(
              season: season,
              onTap: () {
                context.toSeasonDetails(
                  title,
                  seasonNumber,
                  tmdbListService,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _castAndCrew(BuildContext context, TmdbTitle title, String type) {
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toTitlePeopleList(title, type, tmdbListService);
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        HorizontalChipRail(
          children: people
              .take(20)
              .map(
                (person) => PersonChip(
                  person: person,
                  tmdbListService: tmdbListService,
                  titleContext: title,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _recommended(BuildContext context, TmdbTitle title) {
    if (title.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recommended,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 336.0,
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
                        tmdbListService: tmdbListService,
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
