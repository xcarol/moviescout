import 'package:flutter/material.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/people/widgets/person_title_chip.dart'; // To reuse TmdbTitleRoleTranslation

import 'package:moviescout/features/people/models/tmdb_person.dart';

class PersonTitleCard extends TitleCard {
  final TmdbTitle _title;
  final PersonTitleRole role;

  const PersonTitleCard({
    super.key,
    required super.title,
    required super.tmdbListService,
    this.role = PersonTitleRole.character,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: TitleCard.cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              context.toTitleDetails(_title, tmdbListService);
            },
            child: Row(
              children: [
                titlePoster(
                  _title.posterPath,
                  fallbackType: _title.isMovie
                      ? PosterFallbackType.movie
                      : PosterFallbackType.tvShow,
                ),
                const SizedBox(width: 10),
                _personTitleDetails(context, _title),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _personTitleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final roleText = tmdbTitle.getRoleString(context, role: role);
    final dateString = titleSubtitle(context, tmdbTitle);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            titleHeader(tmdbTitle.name),
            if (dateString.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                dateString,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
            if (roleText.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                roleText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 5),
            titleRating(context, tmdbTitle),
          ],
        ),
      ),
    );
  }
}
