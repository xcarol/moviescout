import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/person_title_chip.dart'; // To reuse TmdbTitleRoleTranslation

class PersonTitleCard extends TitleCard {
  final TmdbTitle _title;

  const PersonTitleCard({
    super.key,
    required super.title,
    required super.tmdbListService,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: TitleCard.cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TitleDetails(
                          title: _title,
                          tmdbListService: tmdbListService,
                        )),
              );
            },
            child: Row(
              children: [
                titlePoster(_title.posterPath),
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
    final role = tmdbTitle.getRoleString(context);
    final dateString = titleSubtitle(context, tmdbTitle);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (role.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                role,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
