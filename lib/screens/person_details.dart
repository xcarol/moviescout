import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_person_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/widgets/person_title_chip.dart';
import 'package:moviescout/widgets/expandable_description.dart';
import 'package:moviescout/screens/person_titles.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:moviescout/widgets/edit_button.dart';
import 'package:moviescout/widgets/translations_button.dart';
import 'package:moviescout/services/tmdb_translation_service.dart';
import 'package:moviescout/widgets/boxed_widget.dart';
import 'package:moviescout/services/home_screen_shortcut_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/widgets/custom_refresh_builder.dart';
import 'package:moviescout/widgets/bottom_clamping_scroll_physics.dart';

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
  final _refreshController = IndicatorController();

  @override
  void initState() {
    super.initState();
    _personFuture = _loadPersonAndRates();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<TmdbPerson> _loadPersonAndRates({bool force = false}) async {
    final person = await TmdbPersonService()
        .updatePersonDetails(widget._person, force: force);

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
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final person = snapshot.data as TmdbPerson;
        final String editUrl = UrlConstants.tmdbPersonEditWebTemplate
            .replaceFirst('{ID}', person.tmdbId.toString());

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
                icon: const Icon(Icons.add_to_home_screen),
                onPressed: () async {
                  final loc = AppLocalizations.of(context)!;
                  final success =
                      await HomeScreenShortcutService.pinPersonShortcut(person);
                  if (!success) {
                    SnackMessage.showSnackBar(loc.shortcutFailed);
                  }
                },
                tooltip: AppLocalizations.of(context)!.addToHomeScreen,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  final String link = UrlConstants.moviescoutPersonWebTemplate
                      .replaceFirst('{ID}', widget._person.tmdbId.toString());
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse(link)),
                  );
                },
                tooltip: AppLocalizations.of(context)!.shareLink,
              ),
            ],
          ),
          body: CustomRefreshIndicator(
            controller: _refreshController,
            offsetToArmed: 100,
            onRefresh: () async {
              final newFuture = _loadPersonAndRates(force: true);
              setState(() {
                _personFuture = newFuture;
              });
              await newFuture;
            },
            builder: customRefreshBuilder,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(
                parent: BottomClampingScrollPhysics(
                  topRefreshController: _refreshController,
                  parent: ClampingWithOverscrollPhysics(
                    state: _refreshController,
                  ),
                ),
              ),
              child: _detailsBody(person),
            ),
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
          if (person.biography.isEmpty) _name(person),
          const SizedBox(height: 10),
          Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor),
          _externalLinks(person),
          Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor),
          const SizedBox(height: 10),
          _credits(person),
          const SizedBox(height: 10),
          _crewCredits(person),
          const SizedBox(height: 30),
          _ratedCredits(person, userRatedTitles),
          const SizedBox(height: 30),
          _taggedImages(person),
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
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      Text(
        '${_formatDate(context, person.birthday)}$ageString',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
      Text(
        '${_formatDate(context, person.deathday)}$ageString',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
            Uri.parse(UrlConstants.tmdbPersonWebTemplate
                .replaceFirst('{ID}', person.tmdbId.toString())),
            mode: LaunchMode.inAppWebView,
          );
        },
        child: SizedBox(
          height: 20,
          child: Image.asset(
            'assets/tmdb-logo-square.png',
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
              Uri.parse(UrlConstants.imdbNameTemplate
                  .replaceFirst('{ID}', person.imdbId.toString())),
              mode: LaunchMode.inAppBrowserView,
            );
          },
          child: SizedBox(
            height: 20,
            child: Image.asset(
              'assets/imdb-logo-square.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    final externalIds = person.externalIds;

    _addSocialLink(links, externalIds['wikidata_id'],
        'https://www.wikidata.org/wiki/{ID}', 'assets/wikidata.png');
    _addSocialLink(links, externalIds['facebook_id'],
        'https://facebook.com/{ID}', 'assets/facebook.png');
    _addSocialLink(links, externalIds['instagram_id'],
        'https://instagram.com/{ID}', 'assets/instagram.png');
    _addSocialLink(
        links, externalIds['twitter_id'], 'https://x.com/{ID}', 'assets/X.png');
    _addSocialLink(links, externalIds['tiktok_id'], 'https://tiktok.com/@{ID}',
        'assets/tiktok.png');
    _addSocialLink(links, externalIds['youtube_id'], 'https://youtube.com/{ID}',
        'assets/youtube.png');

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
        Text(
          AppLocalizations.of(context)!.watchOn,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: links,
        ),
      ],
    );
  }

  void _addSocialLink(
      List<Widget> links, String? id, String urlTemplate, String logo) {
    if (id != null && id.isNotEmpty) {
      links.add(
        BoxedWidget(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          onPressed: () {
            launchUrl(
              Uri.parse(urlTemplate.replaceFirst('{ID}', id)),
              mode: LaunchMode.externalApplication,
            );
          },
          child: SizedBox(
            height: 20,
            child: Image.asset(
              logo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
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
            child: MediaCarousel(
              images: person.images,
              backdropPath: '',
              posterPath: image,
              mediaType: ApiConstants.person,
              isLoading: false,
              aspectRatio: posterWidth / posterHeight,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: _characterDetails(person),
            ),
          ),
        ],
      ),
    );
  }

  Widget _name(TmdbPerson person) {
    return Text(
      person.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.start,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
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
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.cast,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.crew,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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

  Widget _taggedImages(TmdbPerson person) {
    if (person.taggedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.gallery,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200.0,
          child: MediaCarousel(
            images: person.taggedImages,
            backdropPath: '',
            posterPath: '',
            mediaType: ApiConstants.person,
            aspectRatio: 16 / 9,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
