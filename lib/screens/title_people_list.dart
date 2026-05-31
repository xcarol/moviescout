import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_person_list_service.dart';
import 'package:moviescout/repositories/tmdb_person_repository.dart';
import 'package:moviescout/widgets/person_list.dart';

class TitlePeopleList extends StatefulWidget {
  final TmdbTitle title;
  final String type;
  final TmdbTitleListService tmdbListService;

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
  late TmdbPersonListService _personListService;

  @override
  void initState() {
    super.initState();
    _personListService = TmdbPersonListService(
      repository: TmdbPersonRepository(),
      title: widget.title,
      roleType: widget.type,
    );
  }

  @override
  void dispose() {
    _personListService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleType = widget.type == PersonAttributes.cast
        ? AppLocalizations.of(context)!.cast
        : AppLocalizations.of(context)!.crew;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title.name} - $titleType'),
      ),
      body: PersonList(
        personListService: _personListService,
        type: widget.type,
        titleListService: widget.tmdbListService,
      ),
    );
  }
}
