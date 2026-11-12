import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 336.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 160.0;

class PersonChip extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

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
    return RepaintBoundary(
      child: SizedBox(
        height: CARD_HEIGHT,
        width: CARD_WIDTH,
        child: Card(
          color:
              Theme.of(context).extension<CustomColors>()!.chipCardBackground,
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.chip,
          ),
          child: InkWell(
            onTap: () {
              context.toPersonDetails(
                TmdbPerson.fromMap(person: _person.toMap()),
                _tmdbListService,
                titleContext: titleContext,
                seasonContext: seasonContext,
                episodeContext: episodeContext,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _poster(_person.posterPath),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: Container(
                      color: Theme.of(context)
                          .extension<CustomColors>()!
                          .chipCardBackground
                          .withValues(alpha: 0.95),
                      padding: const EdgeInsets.all(8.0),
                      child: _details(context, _person),
                    ),
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
    final roleText = tmdbPerson.character.isNotEmpty
        ? tmdbPerson.character
        : tmdbPerson.job.isNotEmpty
            ? tmdbPerson.localizedJob(context)
            : ' '; // Space maintains fixed overlay height without text clipping

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbPerson.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          roleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
