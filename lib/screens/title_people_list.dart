import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_person_list_service.dart';
import 'package:moviescout/widgets/lists/person_list.dart';

class TitlePeopleList extends StatefulWidget {
  final TmdbTitle title;
  final String type;
  final TmdbTitleListService tmdbListService;
  final TmdbSeason? season;
  final TmdbEpisode? episode;

  const TitlePeopleList({
    super.key,
    required this.title,
    required this.type,
    required this.tmdbListService,
    this.season,
    this.episode,
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
      title: widget.title,
      roleType: widget.type,
      season: widget.season,
      episode: widget.episode,
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
        titleContext: widget.title,
        seasonContext: widget.season,
        episodeContext: widget.episode,
      ),
    );
  }
}
