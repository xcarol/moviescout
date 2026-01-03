import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class PersonCard extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbListService _tmdbListService;

  static double cardHeight = 160.0;

  const PersonCard({
    super.key,
    required TmdbPerson person,
    required TmdbListService tmdbListService,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  TmdbListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    TmdbPerson tmdbPerson = _person;

    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonDetails(
                          person: tmdbPerson,
                          tmdbListService: tmdbListService,
                        )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: personPoster(tmdbPerson.posterPath),
                  ),
                  const SizedBox(width: 10),
                  _personDetails(context, tmdbPerson),
                ],
              ),
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
          'assets/movie.svg',
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
            'assets/movie.svg',
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

  Widget _personDetails(BuildContext context, TmdbPerson tmdbPerson) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _personName(tmdbPerson.name, maxLines: 2),
            const SizedBox(height: 5),
            if (tmdbPerson.character.isNotEmpty) const SizedBox(height: 5),
            if (tmdbPerson.character.isNotEmpty)
              Text(tmdbPerson.character, maxLines: 2),
            if (tmdbPerson.job.isNotEmpty) const SizedBox(height: 5),
            if (tmdbPerson.job.isNotEmpty) Text(tmdbPerson.job, maxLines: 2),
          ],
        ),
      ),
    );
  }
}
