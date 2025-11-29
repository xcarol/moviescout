import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_person_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_chip.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PersonDetails extends StatefulWidget {
  final TmdbPerson _person;
  final TmdbListService _tmdbListService;

  const PersonDetails({
    super.key,
    required TmdbPerson person,
    required TmdbListService tmdbListService,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  @override
  State<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  @override
  Widget build(BuildContext context) {
    String appTitle = widget._person.name;

    return FutureBuilder(
      future: TmdbPersonService().updatePersonDetails(widget._person),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: MainAppBar(
            context: context,
            title: appTitle,
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _detailsBody(snapshot.data as TmdbPerson),
          ),
        );
      },
    );
  }

  _detailsBody(TmdbPerson person) {
    final tmdbRateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);
    final userRatedTitles = person.combinedCredits.cast
        .where((title) => tmdbRateslistService.getRating(title.id) != 0)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _banner(person),
        const SizedBox(height: 20),
        _details(person),
        const SizedBox(height: 20),
        _description(person),
        const SizedBox(height: 10),
        const Divider(),
        _externalLinks(person),
        const Divider(),
        const SizedBox(height: 10),
        _credits(person, userRatedTitles),
        const SizedBox(height: 30),
        _userRated(person, userRatedTitles),
      ],
    );
  }

  Widget _characterDetails(TmdbPerson person) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      children: [
        if (person.originalName.isNotEmpty &&
            person.originalName != person.name)
          _originalName(person),
        _birthDay(person),
        _deathDay(person),
        _characterPlaceOfBirth(person),
      ],
    );
  }

  Widget _originalName(TmdbPerson person) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.originalName,
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      Text(person.originalName),
    ]);
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
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      Text('${_formatDate(context, person.birthday)}$ageString'),
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
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
      Text('${_formatDate(context, person.deathday)}$ageString')
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
    } catch (e) {
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
    } catch (e) {
      return '';
    }
  }

  Widget _externalLinks(TmdbPerson person) {
    List<Widget> links = [];

    links.add(
      GestureDetector(
        onTap: () {
          launchUrlString(
            'https://www.themoviedb.org/person/${person.tmdbId}',
          );
        },
        child: SizedBox(
          height: 30,
          child: Image.asset(
            'assets/tmdb-logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (person.imdbId.isNotEmpty) {
      links.add(const SizedBox(width: 20));
      links.add(
        GestureDetector(
          onTap: () {
            launchUrlString('https://www.imdb.com/name/${person.imdbId}');
          },
          child: SizedBox(
            height: 30,
            child: Image.asset(
              'assets/imdb-logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (person.homepage.isNotEmpty) {
      links.add(const SizedBox(width: 20));
      links.add(
        GestureDetector(
          onTap: () {
            launchUrlString(person.homepage);
          },
          child: SizedBox(
            height: 30,
            child: Image.asset(
              'assets/person_web.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: links,
    );
  }

  Widget _details(TmdbPerson person) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _characterNameAndActing(person),
          const SizedBox(height: 10),
          _characterDetails(person),
        ],
      ),
    );
  }

  Widget _characterNameAndActing(TmdbPerson person) {
    if (person.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      '${person.name} - ${person.knownForDepartment}',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.start,
    );
  }

  Widget _banner(TmdbPerson person) {
    double posterWidth = min(MediaQuery.of(context).size.width, 100);
    String image = person.posterPath.isNotEmpty ? person.posterPath : '';

    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: SizedBox(
        width: posterWidth,
        child: AspectRatio(
          aspectRatio: 2 / 3,
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
      ),
    );
  }

  Widget _description(TmdbPerson person) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Text(
        person.biography.isEmpty
            ? AppLocalizations.of(context)!.missingDescription
            : person.biography,
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
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      Text(person.placeOfBirth),
    ]);
  }

  Widget _titleChip(BuildContext context, TmdbTitle tmdbTitle) {
    final clampedScale =
        MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(clampedScale),
      ),
      child: TitleChip(
        title: tmdbTitle,
        tmdbListService: widget._tmdbListService,
      ),
    );
  }

  Widget _credits(TmdbPerson person, List<Credit> userRatedTitles) {
    if (person.combinedCredits.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.filmography,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: person.combinedCredits.cast
                .where((titleRecommended) => !userRatedTitles
                    .any((ratedTitle) => ratedTitle.id == titleRecommended.id))
                .take(10)
                .map(
                  (titleRecommended) => FutureBuilder(
                    future: TmdbTitleService().updateTitleDetails(
                      TmdbTitle.fromMap(title: {
                        'id': titleRecommended.id,
                        'media_type': titleRecommended.mediaType
                      }),
                    ),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: snapshot.connectionState != ConnectionState.done
                            ? Center(child: CircularProgressIndicator())
                            : _titleChip(
                                context,
                                snapshot.data as TmdbTitle,
                              ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _userRated(TmdbPerson person, List<Credit> userRatedTitles) {
    if (userRatedTitles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.userRated,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: userRatedTitles
                .map(
                  (titleRecommended) => FutureBuilder(
                    future: TmdbTitleService().updateTitleDetails(
                      TmdbTitle.fromMap(title: {
                        'id': titleRecommended.id,
                        'media_type': titleRecommended.mediaType
                      }),
                    ),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: snapshot.connectionState != ConnectionState.done
                            ? Center(child: CircularProgressIndicator())
                            : _titleChip(
                                context,
                                snapshot.data as TmdbTitle,
                              ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
