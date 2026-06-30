import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';

class ClickableNames extends StatelessWidget {
  final List<TmdbPerson> people;
  final bool useEllipsis;
  final TmdbTitleListService tmdbListService;

  const ClickableNames({
    super.key,
    required this.people,
    required this.tmdbListService,
    this.useEllipsis = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: people.asMap().entries.map((entry) {
        final index = entry.key;
        final person = entry.value;
        final isLast = index == people.length - 1;

        Widget nameWidget = InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetails(
                  person: person,
                  tmdbListService: tmdbListService,
                ),
              ),
            );
          },
          child: Text(
            person.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            overflow: useEllipsis ? TextOverflow.ellipsis : null,
          ),
        );

        if (useEllipsis) {
          nameWidget = Flexible(child: nameWidget);
        }

        Widget child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            nameWidget,
            if (!isLast) const Text(', '),
          ],
        );

        if (useEllipsis) {
          child = Flexible(child: child);
        }

        return child;
      }).toList(),
    );
  }
}
