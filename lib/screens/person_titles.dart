import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/services/tmdb_person_titles_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';

class PersonTitles extends StatefulWidget {
  final TmdbPerson _person;

  const PersonTitles({
    super.key,
    required TmdbPerson person,
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
      Provider.of<TmdbTitleRepository>(context, listen: false),
      person: widget._person,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userService = Provider.of<TmdbUserService>(context, listen: false);
      _personTitlesService.retrieveList(
        userService.accountId,
        retrieveMovies: () async => [],
        retrieveTvshows: () async => [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget._person.name;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: appTitle,
      ),
      drawer: AppDrawer(),
      body: ChangeNotifierProvider<TmdbListService>.value(
        value: _personTitlesService,
        child: body(),
      ),
    );
  }

  Widget body() {
    return Selector<TmdbListService, bool>(
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
    return Column(
      children: [
        TitleList(
          _personTitlesService,
          key: ValueKey('person_title_list_${widget._person.tmdbId}'),
        ),
      ],
    );
  }
}
