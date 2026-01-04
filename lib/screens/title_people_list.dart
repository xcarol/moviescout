import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/person_list.dart';

class TitlePeopleList extends StatefulWidget {
  final TmdbTitle title;
  final String type;
  final TmdbListService tmdbListService;

  const TitlePeopleList({
    super.key,
    required this.title,
    required this.type,
    required this.tmdbListService,
  });

  @override
  State<TitlePeopleList> createState() => _TitlePeopleListState();
}

class _TitlePeopleListState extends State<TitlePeopleList> {
  @override
  Widget build(BuildContext context) {
    final people = widget.type == PersonAttributes.cast
        ? widget.title.cast
        : widget.title.crew;
    final titleType = widget.type == PersonAttributes.cast
        ? AppLocalizations.of(context)!.cast
        : AppLocalizations.of(context)!.crew;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: '${widget.title.name} - $titleType',
      ),
      drawer: AppDrawer(),
      body: PersonList(
        people: people,
        type: widget.type,
        listService: widget.tmdbListService,
      ),
    );
  }
}
