import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_person_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/widgets/person_title_chip.dart';
import 'package:moviescout/widgets/expandable_description.dart';
import 'package:moviescout/screens/person_titles.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moviescout/widgets/edit_button.dart';
import 'package:moviescout/widgets/translations_button.dart';
import 'package:moviescout/services/tmdb_translation_service.dart';
import 'package:moviescout/widgets/boxed_widget.dart';

class PersonDetails extends StatefulWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  const PersonDetails({
    super.key,
    required TmdbPerson person,
    required TmdbTitleListService tmdbListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  @override
  State<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  late Future<TmdbPerson> _personFuture;
  List<TmdbTitle> _userRatedTitles = [];

  @override
  void initState() {
    super.initState();
    _personFuture = _loadPersonAndRates();
  }

  Future<TmdbPerson> _loadPersonAndRates() async {
    final person =
        await TmdbPersonService().updatePersonDetails(widget._person);

    if (!mounted) return person;
    final tmdbRateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);

    final ratedTitles = <TmdbTitle>[];
    for (var title in person.combinedCredits.cast) {
      final rating = await tmdbRateslistService.getRatingAsync(
          title.tmdbId, title.mediaType);
      if (rating != 0) {
        ratedTitles.add(title);
      }
    }

    if (mounted) {
      setState(() {
        _userRatedTitles = ratedTitles;
      });
    }

    return person;
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget._person.name;

    return FutureBuilder(
      future: _personFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final person = snapshot.data as TmdbPerson;
        final String editUrl =
            'https://www.themoviedb.org/person/${person.tmdbId}/edit';

        return Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            actions: [
              EditButton(url: editUrl),
              TranslationsButton(
                  editUrl: editUrl,
                  fetchTranslations: () => TmdbTranslationService()
                      .getTranslations('person', person.tmdbId),
                  originalTitle: person.name,
                  originalDescription: person.biography),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  final String link =
                      'https://${ApiConstants.tmdbHost}/person/${widget._person.tmdbId}';
                  SharePlus.instance.share(
                    ShareParams(text: '${widget._person.name}\n$link'),
                  );
                },
                tooltip: AppLocalizations.of(context)!.shareLink,
              ),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _detailsBody(person),
          ),
        );
      },
    );
  }

  Widget _detailsBody(TmdbPerson person) {
    final userRatedTitles = _userRatedTitles;

    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _banner(person),
          const SizedBox(height: 20),
          if (widget.titleContext != null) ...[
            _roleInContext(person),
            const SizedBox(height: 20)
          ],
          _description(person),
          const SizedBox(height: 10),
          Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor),
          const SizedBox(height: 10),
          _credits(person),
          const SizedBox(height: 10),
          _crewCredits(person),
          const SizedBox(height: 30),
          _ratedCredits(person, userRatedTitles),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _characterDetails(TmdbPerson person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (person.birthday.isNotEmpty) ...[
          _birthDay(person),
          const SizedBox(height: 10),
        ],
        if (person.deathday.isNotEmpty) ...[
          _deathDay(person),
          const SizedBox(height: 10),
        ],
        if (person.placeOfBirth.isNotEmpty) ...[
          _characterPlaceOfBirth(person),
        ],
      ],
    );
  }

  Widget _birthDay(TmdbPerson person) {
    if (person.birthday.isEmpty) {
      return const SizedBox.shrink();
    }

    String ageString = '';
    if (person.deathday.isEmpty) {
      final age = _calculateAge(person.birthday);
      if (age.isNotEmpty) {
        ageString = ' ($age ${AppLocalizations.of(context)!.years})';
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.birthDate,
        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
      ),
      Text(
        '${_formatDate(context, person.birthday)}$ageString',
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ]);
  }

  Widget _deathDay(TmdbPerson person) {
    if (person.deathday.isEmpty) {
      return const SizedBox.shrink();
    }

    String ageString = '';
    final age = _calculateAge(person.birthday, person.deathday);
    if (age.isNotEmpty) {
      ageString = ' ($age ${AppLocalizations.of(context)!.years})';
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.deathDate,
          style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
      Text(
        '${_formatDate(context, person.deathday)}$ageString',
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ]);
  }

  String _formatDate(BuildContext context, String dateString) {
    if (dateString.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMMd(locale).format(date);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
      );
      return dateString;
    }
  }

  String _calculateAge(String birthDateString, [String? deathDateString]) {
    if (birthDateString.isEmpty) {
      return '';
    }
    try {
      final birthDate = DateTime.parse(birthDateString);
      final toDate = deathDateString != null && deathDateString.isNotEmpty
          ? DateTime.parse(deathDateString)
          : DateTime.now();

      int age = toDate.year - birthDate.year;
      if (toDate.month < birthDate.month ||
          (toDate.month == birthDate.month && toDate.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
      );
      return '';
    }
  }

  Widget _externalLinks(TmdbPerson person) {
    List<Widget> links = [];

    links.add(
      BoxedWidget(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        onPressed: () {
          launchUrl(
            Uri.parse('https://www.themoviedb.org/person/${person.tmdbId}'),
            mode: LaunchMode.inAppWebView,
          );
        },
        child: SizedBox(
          height: 20,
          child: Image.asset(
            'assets/tmdb-logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (person.imdbId.isNotEmpty) {
      links.add(
        BoxedWidget(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          onPressed: () {
            launchUrl(
              Uri.parse('https://www.imdb.com/name/${person.imdbId}'),
              mode: LaunchMode.inAppBrowserView,
            );
          },
          child: SizedBox(
            height: 20,
            child: Image.asset(
              'assets/imdb-logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (person.homepage.isNotEmpty) {
      links.add(
        BoxedWidget(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          onPressed: () {
            launchUrl(
              Uri.parse(person.homepage),
              mode: LaunchMode.inAppBrowserView,
            );
          },
          child: SizedBox(
            height: 20,
            child: Image.asset(
              'assets/person_web.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Obre amb',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: links,
        ),
      ],
    );
  }

  String? _buildContextTitle(BuildContext context) {
    if (widget.titleContext == null) return null;

    String cTitle = widget.titleContext!.name;
    if (widget.episodeContext != null) {
      cTitle +=
          ' - ${AppLocalizations.of(context)!.seasonLabel(widget.episodeContext!.seasonNumber)}, ${AppLocalizations.of(context)!.episodeLabel(widget.episodeContext!.episodeNumber)}';
    } else if (widget.seasonContext != null) {
      cTitle +=
          ' - ${AppLocalizations.of(context)!.seasonLabel(widget.seasonContext!.seasonNumber)}';
    }
    return cTitle;
  }

  Widget _roleInContext(TmdbPerson person) {
    final List<String> roles = [];
    if (person.character.isNotEmpty) {
      roles.add(person.character);
    } else {
      if (person.job.isNotEmpty) {
        roles.add(person.localizedJob(context));
      }
      if (person.knownForDepartment.isNotEmpty) {
        roles.add(person.localizedDepartment(context));
      }
    }
    if (roles.isEmpty) return const SizedBox.shrink();

    String rolesText = roles.join(', ');
    String? cTitle = _buildContextTitle(context);
    if (cTitle == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            '$rolesText${AppLocalizations.of(context)!.inRoleContext(cTitle)}',
            style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _banner(TmdbPerson person) {
    double posterWidth = min(MediaQuery.sizeOf(context).width * 0.4, 150) + 30;
    double posterHeight = posterWidth * 1.5;
    String image = person.posterPath.isNotEmpty ? person.posterPath : '';

    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: posterWidth,
            height: posterHeight,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) {
                return SvgPicture.asset(
                  'assets/person.svg',
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              height: posterHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: _characterDetails(person),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Divider(
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .dividerColor),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 8),
                        child: _externalLinks(person),
                      ),
                      Divider(
                          height: 1,
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .dividerColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _description(TmdbPerson person) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: ExpandableDescription(
        text: person.biography,
        initialMaxLines: 10,
      ),
    );
  }

  Widget _characterPlaceOfBirth(TmdbPerson person) {
    if (person.placeOfBirth.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.placeOfBirth,
        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
      ),
      Text(
        person.placeOfBirth,
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ]);
  }

  Widget _credits(TmdbPerson person) {
    if (person.combinedCredits.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    final seen = <String>{};
    final uniqueCast = person.combinedCredits.cast
        .where((title) => seen.add('${title.mediaType}_${title.tmdbId}'))
        .toList()
      ..sort(
          (a, b) => b.effectiveReleaseDate.compareTo(a.effectiveReleaseDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.cast,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonTitles(person: person),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 336.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: uniqueCast.length > 10 ? 10 : uniqueCast.length,
            itemBuilder: (context, index) {
              return PersonTitleChip(
                title: uniqueCast[index],
                tmdbListService: widget._tmdbListService,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _crewCredits(TmdbPerson person) {
    if (person.combinedCredits.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    final seen = <String>{};
    final uniqueCrew = person.combinedCredits.crew
        .where((title) => seen.add('${title.mediaType}_${title.tmdbId}'))
        .toList()
      ..sort(
          (a, b) => b.effectiveReleaseDate.compareTo(a.effectiveReleaseDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.crew,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonTitles(
                        person: person, role: PersonTitleRole.crew),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 336.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: uniqueCrew.length > 10 ? 10 : uniqueCrew.length,
            itemBuilder: (context, index) {
              return PersonTitleChip(
                title: uniqueCrew[index],
                tmdbListService: widget._tmdbListService,
                role: PersonTitleRole.crew,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _ratedCredits(TmdbPerson person, List<TmdbTitle> userRatedTitles) {
    if (userRatedTitles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.ratedCredits,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 336.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userRatedTitles.length,
            itemBuilder: (context, index) {
              return PersonTitleChip(
                title: userRatedTitles[index],
                tmdbListService: widget._tmdbListService,
              );
            },
          ),
        ),
      ],
    );
  }
}
