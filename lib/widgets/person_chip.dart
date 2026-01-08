import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/title_card.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 420.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 200.0;

class PersonChip extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbListService _tmdbListService;

  const PersonChip({
    super.key,
    required person,
    required tmdbListService,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT,
      width: CARD_WIDTH,
      child: Card(
        color: Theme.of(context).extension<CustomColors>()!.chipCardBackground,
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PersonDetails(
                        person: TmdbPerson.fromMap(person: _person.toMap()),
                        tmdbListService: _tmdbListService,
                      )),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: _poster(_person.posterPath),
                ),
              ),
              const SizedBox(height: 10),
              _details(context, _person),
            ],
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

  Widget _details(BuildContext context, TmdbPerson tmdbPerson) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _personName(tmdbPerson.name, maxLines: 2),
          const SizedBox(height: 5),
          if (tmdbPerson.character.isNotEmpty) const SizedBox(height: 5),
          if (tmdbPerson.character.isNotEmpty)
            Text(tmdbPerson.character,
                overflow: TextOverflow.ellipsis, maxLines: 2),
          if (tmdbPerson.job.isNotEmpty) const SizedBox(height: 5),
          if (tmdbPerson.job.isNotEmpty)
            Text(tmdbPerson.job, overflow: TextOverflow.ellipsis, maxLines: 2),
        ],
      ),
    );
  }
}
