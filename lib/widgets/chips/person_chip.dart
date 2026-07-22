import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/cards/title_card.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';

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
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonDetails(
                          person: TmdbPerson.fromMap(person: _person.toMap()),
                          tmdbListService: _tmdbListService,
                          titleContext: titleContext,
                          seasonContext: seasonContext,
                          episodeContext: episodeContext,
                        )),
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
    if (posterPath == null || posterPath.isEmpty) {
      return AspectRatio(
        aspectRatio: 2 / 3,
        child: SvgPicture.asset(
          'assets/person.svg',
          fit: BoxFit.contain,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: CachedNetworkImage(
        imageUrl: posterPath,
        cacheManager: CustomCacheManager.instance,
        fit: BoxFit.cover,
        memCacheHeight: 300,
        memCacheWidth: 200,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        cacheKey: posterPath,
        errorWidget: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/person.svg',
            fit: BoxFit.contain,
          );
        },
      ),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          roleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
