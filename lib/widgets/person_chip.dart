import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/widgets/title_card.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 400.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 200.0;

class PersonChip extends Card {
  final TmdbPerson _person;

  const PersonChip({
    super.key,
    required person,
  }) : _person = person;

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
                        person: TmdbPerson.fromMap(person: _person.map),
                      )),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 10),
              Row(
                children: [_details(context, _person)],
              ),
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

  Text _characterName(String name, {int maxLines = 1}) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _characterName(tmdbPerson.character, maxLines: 2),
            const SizedBox(height: 5),
            Text(tmdbPerson.name),
          ],
        ),
      ),
    );
  }
}
