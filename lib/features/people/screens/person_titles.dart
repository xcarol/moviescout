import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/people/services/tmdb_person_titles_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/core/widgets/item_list.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/features/titles/repositories/local_title_repository.dart';

class PersonTitles extends StatefulWidget {
  final TmdbPerson _person;
  final PersonTitleRole role;

  const PersonTitles({
    super.key,
    required TmdbPerson person,
    this.role = PersonTitleRole.character,
  }) : _person = person;

  @override
  State<PersonTitles> createState() => _PersonTitlesState();
}

class _PersonTitlesState extends State<PersonTitles> {
  late final TmdbPersonTitlesService _personTitlesService;

  @override
  void initState() {
    super.initState();
    _personTitlesService = TmdbPersonTitlesService(
      'person_titles_${widget._person.tmdbId}',
      LocalTitleRepository.instance,
      person: widget._person,
      role: widget.role,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _personTitlesService.retrieveList(
        fetchRemoteData: () async => [],
      );
    });
  }

  @override
  void dispose() {
    _personTitlesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget._person.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: SafeArea(
        top: false,
        child: ChangeNotifierProvider<TmdbTitleListService>.value(
          value: _personTitlesService,
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Selector<TmdbTitleListService, bool>(
      selector: (_, service) => service.listIsEmpty && !service.isLoading.value,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, isEmpty, child) {
        if (isEmpty) {
          return emptyBody();
        } else {
          return listBody();
        }
      },
    );
  }

  Widget emptyBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.emptyList,
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget listBody() {
    return ItemList(
      _personTitlesService,
      key: ValueKey('person_title_list_${widget._person.tmdbId}'),
    );
  }
}
