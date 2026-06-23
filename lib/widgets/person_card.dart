import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      fileService: HttpFileService(),
    ),
  );
}

class PersonCard extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  static double cardHeight = 160.0;

  const PersonCard({
    super.key,
    required TmdbPerson person,
    required TmdbTitleListService tmdbListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  TmdbTitleListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    TmdbPerson tmdbPerson = _person;

    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonDetails(
                          person: tmdbPerson,
                          tmdbListService: tmdbListService,
                          titleContext: titleContext,
                          seasonContext: seasonContext,
                          episodeContext: episodeContext,
                        )),
              );
            },
            child: Row(
              children: [
                personPoster(tmdbPerson.posterPath),
                const SizedBox(width: 10),
                _personDetails(context, tmdbPerson),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget personPoster(String? posterPath) {
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

  Text _personName(String name, {int maxLines = 1}) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _personRoleDetails(BuildContext context, TmdbPerson tmdbPerson) {
    final List<String> roles = [];
    if (tmdbPerson.character.isNotEmpty) {
      roles.add(tmdbPerson.character);
    } else {
      if (tmdbPerson.job.isNotEmpty) {
        roles.add(tmdbPerson.localizedJob(context));
      }
      if (tmdbPerson.knownForDepartment.isNotEmpty) {
        roles.add(tmdbPerson.localizedDepartment(context));
      }
    }

    if (roles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        ...roles.map((role) => Text(role, maxLines: 2)),
      ],
    );
  }

  Widget _personDetails(BuildContext context, TmdbPerson tmdbPerson) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _personName(tmdbPerson.name, maxLines: 2),
            _personRoleDetails(context, tmdbPerson),
          ],
        ),
      ),
    );
  }
}
