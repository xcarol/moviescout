import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/people/services/tmdb_person_service.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/features/people/widgets/person_title_chip.dart';
import 'package:moviescout/core/widgets/expandable_description.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:moviescout/core/widgets/media_carousel.dart';
import 'package:moviescout/core/widgets/action_menu.dart';
import 'package:moviescout/core/services/tmdb_translation_service.dart';
import 'package:moviescout/core/widgets/social_link.dart';
import 'package:moviescout/core/navigation/home_screen_shortcut_service.dart';
import 'package:moviescout/core/utils/snack_bar.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<TmdbPerson> _loadPersonAndRates({bool force = false}) async {
    final person = await TmdbPersonService()
        .updatePersonDetails(widget._person, force: force);

    if (!mounted) return person;
    final tmdbRateslistService =
        Provider.of<RateslistService>(context, listen: false);

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
              ActionMenu(
                editUrl: editUrl,
                fetchTranslations: () => TmdbTranslationService()
                    .getTranslations('person', person.tmdbId),
                originalTitle: person.name,
                originalDescription: person.biography,
                shareUrl: UrlConstants.moviescoutPersonWebTemplate
                    .replaceFirst('{ID}', widget._person.tmdbId.toString()),
                onPin: () async {
                  final loc = AppLocalizations.of(context)!;
                  final success =
                      await HomeScreenShortcutService.pinPersonShortcut(person);
                  if (!success) {
                    SnackMessage.showSnackBar(loc.shortcutFailed);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: _detailsBody(person),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailsBody(TmdbPerson person) {
    final userRatedTitles = _userRatedTitles;
    final dividerColor =
        Theme.of(context).extension<CustomColors>()!.dividerColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.bottomSafeMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _banner(person),
          const SizedBox(height: AppSpacing.lg),
          if (widget.titleContext != null) ...[
            _roleInContext(person),
            const SizedBox(height: AppSpacing.lg),
          ],
          _description(person),
          if (person.biography.isEmpty) _name(person),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: dividerColor),
          _socialLinks(person),
          Divider(color: dividerColor),
          const SizedBox(height: AppSpacing.sm),
          _credits(person),
          const SizedBox(height: AppSpacing.sm),
          _crewCredits(person),
          const SizedBox(height: AppSpacing.xl),
          _ratedCredits(person, userRatedTitles),
          const SizedBox(height: AppSpacing.xl),
          _taggedImages(person),
          const SizedBox(height: AppSpacing.xxl),
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
          const SizedBox(height: AppSpacing.sm),
        ],
        if (person.deathday.isNotEmpty) ...[
          _deathDay(person),
          const SizedBox(height: AppSpacing.sm),
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
      Text(
        '${_formatDate(context, person.birthday)}$ageString',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
      Text(
        AppLocalizations.of(context)!.deathDate,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
      Text(
        '${_formatDate(context, person.deathday)}$ageString',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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

  Widget _socialLinks(TmdbPerson person) {
    List<Widget> links = [];

    links.add(
      SocialLink.image(
        url: UrlConstants.tmdbPersonWebTemplate
            .replaceFirst('{ID}', person.tmdbId.toString()),
        assetPath: 'assets/tmdb-logo.png',
        launchMode: LaunchMode.inAppBrowserView,
      ),
    );

    if (person.imdbId.isNotEmpty) {
      links.add(
        SocialLink.image(
          url: UrlConstants.imdbNameTemplate
              .replaceFirst('{ID}', person.imdbId.toString()),
          assetPath: 'assets/imdb-logo.png',
          launchMode: LaunchMode.inAppBrowserView,
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
        SocialLink.icon(
          url: person.homepage,
          iconData: Icons.language,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.watchOn,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xxs,
          runSpacing: AppSpacing.xxs,
          children: links,
        ),
      ],
    );
  }

  void _addSocialLink(
      List<Widget> links, String? id, String urlTemplate, String logo) {
    if (id != null && id.isNotEmpty) {
      links.add(
        SocialLink.image(
          url: urlTemplate.replaceFirst('{ID}', id),
          assetPath: logo,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '$rolesText${AppLocalizations.of(context)!.inRoleContext(cTitle)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _banner(TmdbPerson person) {
    final double posterWidth = min(
          MediaQuery.sizeOf(context).width *
              AppSizes.personBannerPosterWidthFraction,
          AppSizes.personBannerMaxPosterBaseWidth,
        ) +
        AppSizes.personBannerPosterExtraWidth;
    final double posterHeight = posterWidth / AppSizes.aspectRatioPoster;
    final String image = person.posterPath.isNotEmpty ? person.posterPath : '';

    return Row(
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
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: _characterDetails(person),
          ),
        ),
      ],
    );
  }

  Widget _name(TmdbPerson person) {
    return Text(
      person.name,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.start,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _description(TmdbPerson person) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
      Text(
        person.placeOfBirth,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toPersonTitles(person);
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
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
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toPersonTitles(person, role: PersonTitleRole.crew);
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
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
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.personGalleryHeight,
          child: MediaCarousel(
            images: person.taggedImages,
            backdropPath: '',
            posterPath: '',
            mediaType: ApiConstants.person,
            aspectRatio: AppSizes.aspectRatioBackdrop,
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
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
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
