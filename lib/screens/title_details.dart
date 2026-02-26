import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart'
    show TmdbTitleRepository;
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/screens/title_people_list.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/region_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/person_chip.dart';
import 'package:moviescout/widgets/rate_form.dart';
import 'package:moviescout/widgets/title_chip.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:moviescout/widgets/pin_button.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class TitleDetails extends StatefulWidget {
  final TmdbTitle _title;
  final TmdbListService _tmdbListService;

  const TitleDetails({
    super.key,
    required TmdbTitle title,
    required TmdbListService tmdbListService,
  })  : _title = title,
        _tmdbListService = tmdbListService;

  @override
  State<TitleDetails> createState() => _TitleDetailsState();
}

class _TitleDetailsState extends State<TitleDetails> {
  late Future<TmdbTitle> _titleFuture;

  @override
  void initState() {
    super.initState();
    _titleFuture = _updatedTitle();
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget._title.name;

    return FutureBuilder(
      future: _titleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final TmdbTitle titleDetails = snapshot.data as TmdbTitle;

        return Scaffold(
          appBar: MainAppBar(
            context: context,
            title: appTitle,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  final String link =
                      'https://${ApiConstants.tmdbHost}/${widget._title.mediaType}/${widget._title.tmdbId}';
                  SharePlus.instance.share(
                    ShareParams(text: '${widget._title.name}\n$link'),
                  );
                },
                tooltip: AppLocalizations.of(context)!.shareLink,
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _detailsBody(titleDetails),
          ),
        );
      },
    );
  }

  Future<TmdbTitle> _updatedTitle() async {
    final String lastUpdated = widget._title.lastUpdated;
    final TmdbTitle title =
        await TmdbTitleService().updateTitleDetails(widget._title, force: true);

    if (lastUpdated != title.lastUpdated && title.id != Isar.autoIncrement) {
      final repository = TmdbTitleRepository();
      await repository.saveTitle(title);
    }

    return title;
  }

  Widget _detailsBody(TmdbTitle title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediaCarousel(title: title),
        const SizedBox(height: 20),
        _details(title),
      ],
    );
  }

  Widget _infoColumn(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        if (value is Widget) value else Text(value.toString()),
      ],
    );
  }

  Widget _infoLine(TmdbTitle title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _infoColumn(AppLocalizations.of(context)!.originaTitle,
                    title.originalName),
                const SizedBox(width: 20),
                _infoColumn(AppLocalizations.of(context)!.originalLanguage,
                    LanguageService().getLanguageName(title.originalLanguage)),
                const SizedBox(width: 20),
                _infoColumn(
                    AppLocalizations.of(context)!.originCountry,
                    title.originCountry
                        .map((c) => RegionService().getRegionName(c))
                        .join(', ')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _creditsInfo(TmdbTitle title) {
    if (title.creditsJson == null) return const SizedBox.shrink();

    Widget? creatorsWidget;
    if (title.isMovie) {
      final directors = title.crew.where((c) => c.job == 'Director').toList();
      if (directors.isNotEmpty) {
        creatorsWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _infoColumn(AppLocalizations.of(context)!.director,
              _clickableNames(directors)),
        );
      }
    } else {
      final creators = title.crew
          .where((c) => c.job == 'Executive Producer' || c.job == 'Creator')
          .take(3)
          .toList();
      if (creators.isNotEmpty) {
        creatorsWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _infoColumn(
              AppLocalizations.of(context)!.creator, _clickableNames(creators)),
        );
      }
    }

    Widget? writersWidget;
    final writers = title.crew
        .where((c) =>
            c.job == 'Writer' || c.job == 'Screenplay' || c.job == 'Author')
        .toList();

    if (writers.isNotEmpty) {
      writersWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _infoColumn(
            AppLocalizations.of(context)!.writer, _clickableNames(writers)),
      );
    }

    if (creatorsWidget == null && writersWidget == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (creatorsWidget != null) creatorsWidget,
        if (creatorsWidget != null && writersWidget != null)
          const SizedBox(height: 10),
        if (writersWidget != null) writersWidget,
      ],
    );
  }

  Widget _clickableNames(List<TmdbPerson> people) {
    return Row(
      children: people.asMap().entries.map((entry) {
        final index = entry.key;
        final person = entry.value;
        final isLast = index == people.length - 1;

        return Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetails(
                      person: person,
                      tmdbListService: widget._tmdbListService,
                    ),
                  ),
                );
              },
              child: Text(
                person.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (!isLast) const Text(', '),
          ],
        );
      }).toList(),
    );
  }

  Widget _externalLinks(TmdbTitle title) {
    List<Widget> links = [];

    final buttonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );

    links.add(
      OutlinedButton(
        style: buttonStyle,
        onPressed: () {
          launchUrl(
            Uri.parse(
              'https://www.themoviedb.org/${title.mediaType}/${title.tmdbId}',
            ),
            mode: LaunchMode.inAppWebView,
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

    if (title.imdbId.isNotEmpty) {
      links.add(const SizedBox(width: 10));
      links.add(
        OutlinedButton(
          style: buttonStyle,
          onPressed: () {
            launchUrl(
              Uri.parse('https://www.imdb.com/title/${title.imdbId}'),
              mode: LaunchMode.inAppBrowserView,
            );
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

    if (title.homepage.isNotEmpty) {
      links.add(const SizedBox(width: 10));
      links.add(
        OutlinedButton(
          style: buttonStyle,
          onPressed: () {
            launchUrl(
              Uri.parse(title.homepage),
              mode: LaunchMode.externalApplication,
            );
          },
          child: SizedBox(
            height: 30,
            width: 30,
            child: Icon(
              Icons.language,
              size: 30,
              color: Theme.of(context).colorScheme.onSurface,
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

  Widget _details(TmdbTitle title) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleLine(title),
          const SizedBox(height: 10),
          _tagLine(title),
          const SizedBox(height: 10),
          _durationAndWatchlist(title),
          const SizedBox(height: 10),
          _rating(title),
          const SizedBox(height: 10),
          _genres(title),
          const SizedBox(height: 10),
          _description(title),
          const SizedBox(height: 30),
          _infoLine(title),
          const SizedBox(height: 10),
          _creditsInfo(title),
          const Divider(),
          _externalLinks(title),
          const Divider(),
          const SizedBox(height: 10),
          _providers(title),
          const SizedBox(height: 30),
          _recommended(title),
          const SizedBox(height: 30),
          _castAndCrew(title, PersonAttributes.cast),
          const SizedBox(height: 30),
          _castAndCrew(title, PersonAttributes.crew),
        ],
      ),
    );
  }

  Widget _titleLine(TmdbTitle title) {
    if (title.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      title.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.start,
    );
  }

  Widget _tagLine(TmdbTitle title) {
    if (title.tagline.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      title.tagline,
      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
      textAlign: TextAlign.start,
    );
  }

  Widget _durationAndWatchlist(TmdbTitle title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '${_releaseDates(title)} - ${_duration(title)}',
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            pinButton(context, title),
            const SizedBox(width: 8),
            watchlistButton(context, title),
          ],
        ),
      ],
    );
  }

  Widget _rating(TmdbTitle title) {
    String titleVoteAverage = '-.-';

    if (title.firstAirDate.isNotEmpty &&
        DateTime.parse(title.firstAirDate).isAfter(DateTime.now())) {
      return Text(AppLocalizations.of(context)!.notReleasedYet);
    }

    if (title.voteAverage > 0) {
      titleVoteAverage = title.voteAverage.toStringAsFixed(2);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 5),
            Text(titleVoteAverage),
          ],
        ),
        Consumer<TmdbRateslistService>(
          builder: (context, ratingService, child) {
            final titleRating =
                ratingService.getRating(title.tmdbId, title.mediaType);
            final titleRatingDate =
                ratingService.getRatingDate(title.tmdbId, title.mediaType);

            return Row(
              children: [
                Icon(Icons.star,
                    color: Theme.of(context)
                        .extension<CustomColors>()!
                        .ratedTitle),
                const SizedBox(width: 5),
                if (ratingService.contains(title))
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      titleRating == AppConstants.seenRating
                          ? AppLocalizations.of(context)!.seen
                          : '$titleRating',
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()!
                            .ratedTitle,
                      ),
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return RateForm(
                                title: title.name,
                                initialRate: titleRating,
                                initialDate: titleRatingDate,
                                onSubmit: (double rating) {
                                  Provider.of<TmdbRateslistService>(context,
                                          listen: false)
                                      .updateTitleRate(
                                    Provider.of<TmdbUserService>(context,
                                            listen: false)
                                        .accountId,
                                    Provider.of<TmdbUserService>(context,
                                            listen: false)
                                        .sessionId,
                                    title,
                                    rating,
                                  );
                                },
                              );
                            },
                          ),
                          child: Text(AppLocalizations.of(context)!.rate),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: titleRating > AppConstants.seenRating
                                  ? Theme.of(context).disabledColor
                                  : (titleRating == AppConstants.seenRating
                                      ? Theme.of(context)
                                          .extension<CustomColors>()!
                                          .ratedTitle
                                      : Theme.of(context).colorScheme.primary),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: titleRating > AppConstants.seenRating
                              ? null // Disabled if rated
                              : () {
                                  final newRating =
                                      titleRating == AppConstants.seenRating
                                          ? 0.0
                                          : AppConstants.seenRating;
                                  Provider.of<TmdbRateslistService>(context,
                                          listen: false)
                                      .updateTitleRate(
                                    Provider.of<TmdbUserService>(context,
                                            listen: false)
                                        .accountId,
                                    Provider.of<TmdbUserService>(context,
                                            listen: false)
                                        .sessionId,
                                    title,
                                    newRating,
                                  );
                                },
                          child: Tooltip(
                            message: titleRating == AppConstants.seenRating
                                ? AppLocalizations.of(context)!.seen
                                : AppLocalizations.of(context)!.markAsSeen,
                            child: Icon(
                              titleRating > 0
                                  ? Symbols.done_outline
                                  : Symbols.check,
                              color: titleRating > 0
                                  ? (titleRating > AppConstants.seenRating
                                      ? Theme.of(context).disabledColor
                                      : Theme.of(context)
                                          .extension<CustomColors>()!
                                          .ratedTitle)
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _genres(TmdbTitle title) {
    List<Widget> genres = [];

    if (title.genres.isEmpty) {
      return const SizedBox();
    }

    for (TmdbGenre genre in title.genres) {
      genres.add(Chip(
        label: Text(genre.name),
        padding: EdgeInsets.all(5),
      ));
      genres.add(const SizedBox(width: 5));
    }

    return Row(
      children: [
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: genres,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _releaseDates(TmdbTitle title) {
    String text;

    if (title.isMovie) {
      text = _movieDate(title);
    } else {
      text = _tvShowDates(title);
    }

    return text;
  }

  String _movieDate(TmdbTitle title) {
    return title.releaseDate.isNotEmpty
        ? title.releaseDate.substring(0, 4)
        : '';
  }

  String _tvShowDates(TmdbTitle title) {
    String text =
        title.firstAirDate.isNotEmpty ? title.firstAirDate.substring(0, 4) : '';

    if (!title.isMiniSerie) {
      if (title.isOnAir) {
        text += ' - ...';
      } else if (title.lastAirDate.isNotEmpty) {
        text += ' - ${title.lastAirDate.substring(0, 4)}';
      }
    }

    return text;
  }

  String _duration(TmdbTitle title) {
    String text = title.duration.isNotEmpty
        ? title.duration
        : AppLocalizations.of(context)!.unknownDuration;

    if (title.isSerie && title.numberOfSeasons > 0) {
      text +=
          ' - ${AppLocalizations.of(context)!.seasonsCount(title.numberOfSeasons)}';
    }
    return text;
  }

  Text _description(TmdbTitle title) {
    return Text(
      title.overview.isEmpty
          ? AppLocalizations.of(context)!.missingDescription
          : title.overview,
    );
  }

  Widget _providers(TmdbTitle title) {
    List<Widget> providers = [];

    if (title.providers.flatrate.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.flatrateProviders,
        title.providers.flatrate,
      ));
      providers.add(const SizedBox(width: 50));
    }

    if (title.providers.rent.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.rentProviders,
        title.providers.rent,
      ));
      providers.add(const SizedBox(width: 50));
    }

    if (title.providers.buy.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.buyProviders,
        title.providers.buy,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: providers),
    );
  }

  Widget _providersByType(String typeName, List<TmdbProvider> providers) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        typeName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      _providersRow(providers),
    ]);
  }

  Widget _providersRow(List<TmdbProvider> providers) {
    if (providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: (providers as List?)
              ?.map<Widget>((provider) => _providerLogo(provider))
              .toList() ??
          [],
    );
  }

  Widget _providerLogo(TmdbProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Tooltip(
        message: provider.name,
        child: SizedBox(
          width: 30,
          height: 30,
          child: CachedNetworkImage(
            imageUrl: provider.logoPath,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) {
              return SvgPicture.asset(
                'assets/movie.svg',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _personChip(BuildContext context, TmdbPerson tmdbPerson) {
    final clampedScale =
        MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(clampedScale),
      ),
      child: PersonChip(
        person: tmdbPerson,
        tmdbListService: widget._tmdbListService,
      ),
    );
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

  Widget _castAndCrew(TmdbTitle title, String type) {
    if (type == PersonAttributes.cast && title.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    if (type == PersonAttributes.crew && title.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    List<TmdbPerson> people;
    if (type == PersonAttributes.cast) {
      people = title.cast;
    } else {
      people = title.crew;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type == PersonAttributes.cast
                    ? AppLocalizations.of(context)!.cast
                    : AppLocalizations.of(context)!.crew,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TitlePeopleList(
                            title: title,
                            type: type,
                            tmdbListService: widget._tmdbListService,
                          )),
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: people
                .map((person) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _personChip(context, person)))
                .take(20)
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _recommended(TmdbTitle title) {
    if (title.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recommended,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: title.recommendations
                .map(
                  (titleRecommended) => FutureBuilder(
                    future: TmdbTitleService().updateTitleDetails(
                      TmdbTitle.fromMap(title: titleRecommended),
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
