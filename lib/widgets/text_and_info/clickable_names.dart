import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';

import 'package:flutter/gestures.dart';
import 'package:moviescout/widgets/text_and_info/expandable_text.dart';

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
    final List<InlineSpan> spans = [];

    for (int i = 0; i < people.length; i++) {
      final person = people[i];
      final isLast = i == people.length - 1;

      spans.add(TextSpan(
        text: person.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
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
      ));

      if (!isLast) {
        spans.add(const TextSpan(text: ', '));
      }
    }

    final textSpan = TextSpan(children: spans);

    if (useEllipsis) {
      return Text.rich(
        textSpan,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else {
      return ExpandableText(
        textSpan: textSpan,
        initialMaxLines: 1,
      );
    }
  }
}
