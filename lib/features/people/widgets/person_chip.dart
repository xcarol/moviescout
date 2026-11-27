import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_dimensions.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

class PersonChip extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  static const double cardWidth = AppDimensions.personChipWidth;
  static const double cardHeight = AppDimensions.personChipHeight;

  const PersonChip({
    super.key,
    required person,
    required tmdbListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  @override
  Widget build(BuildContext context) {
    final tmdbPerson = _person;

    return RepaintBoundary(
      child: SizedBox(
        width: cardWidth,
        child: Card(
          color:
              Theme.of(context).extension<CustomColors>()!.chipCardBackground,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.chip,
          ),
          child: InkWell(
            onTap: () {
              context.toPersonDetails(
                TmdbPerson.fromMap(person: tmdbPerson.toMap()),
                _tmdbListService,
                titleContext: titleContext,
                seasonContext: seasonContext,
                episodeContext: episodeContext,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _poster(tmdbPerson.posterPath),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: AppSpacing.edgeInsetsAllSm,
                    child: _details(context, tmdbPerson),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _poster(String? posterPath) {
    return AppPosterImage(
      imageUrl: posterPath,
      aspectRatio: 2 / 3,
      fallbackType: PosterFallbackType.person,
      memCacheWidth: 200,
      memCacheHeight: 300,
      fit: BoxFit.cover,
    );
  }

  Widget _details(BuildContext context, TmdbPerson tmdbPerson) {
    final theme = Theme.of(context);
    final roleText = tmdbPerson.character.isNotEmpty
        ? tmdbPerson.character
        : tmdbPerson.job.isNotEmpty
            ? tmdbPerson.localizedJob(context)
            : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbPerson.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (roleText.isNotEmpty) ...[
          AppSpacing.gapXxs,
          Text(
            roleText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
