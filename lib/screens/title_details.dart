import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
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
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  @override
  Widget build(BuildContext context) {
    String appTitle = widget._title.name;

    return FutureBuilder(
      future: TmdbTitleService().updateTitleDetails(widget._title),
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
            child: _detailsBody(snapshot.data as TmdbTitle),
          ),
        );
      },
    );
  }

  _detailsBody(TmdbTitle title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _banner(title),
        const SizedBox(height: 20),
        _details(title),
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    AppLocalizations.of(context)!.originaTitle,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  Text(title.originalName),
                ]),
                const SizedBox(width: 20),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    AppLocalizations.of(context)!.originalLanguage,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  Text(title.originalLanguage),
                ]),
                const SizedBox(width: 20),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    AppLocalizations.of(context)!.originCountry,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  Text(title.originCountry),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _externalLinks(TmdbTitle title) {
    List<Widget> links = [];

    links.add(
      GestureDetector(
        onTap: () {
          launchUrlString(
            'https://www.themoviedb.org/${title.mediaType}/${title.tmdbId}',
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
      links.add(const SizedBox(width: 20));
      links.add(
        GestureDetector(
          onTap: () {
            launchUrlString('https://www.imdb.com/title/${title.imdbId}');
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
          const Divider(),
          _externalLinks(title),
          const Divider(),
          const SizedBox(height: 10),
          _providers(title),
          const SizedBox(height: 30),
          _recommended(title),
          const SizedBox(height: 30),
          _cast(title),
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
        Text('${_releaseDates(title)} - ${_duration(title)}'),
        watchlistButton(context, title),
      ],
    );
  }

  Widget _rating(TmdbTitle title) {
    if (title.voteAverage == 0) {
      if (title.firstAirDate.isNotEmpty &&
          DateTime.parse(title.firstAirDate).isAfter(DateTime.now())) {
        return Text(AppLocalizations.of(context)!.notReleasedYet);
      }

      return const SizedBox();
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
            Text(title.voteAverage.toStringAsFixed(2)),
          ],
        ),
        Consumer<TmdbRateslistService>(
          builder: (context, ratingService, child) {
            final titleRating = ratingService.getRating(title.tmdbId);

            return Row(
              children: [
                Icon(Icons.star,
                    color: Theme.of(context)
                        .extension<CustomColors>()!
                        .ratedTitle),
                const SizedBox(width: 5),
                if (ratingService.contains(title))
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '$titleRating',
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()!
                            .ratedTitle,
                      ),
                    ),
                  ),
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
                        onSubmit: (int rating) {
                          Provider.of<TmdbRateslistService>(context,
                                  listen: false)
                              .updateTitleRate(
                            Provider.of<TmdbUserService>(context, listen: false)
                                .accountId,
                            Provider.of<TmdbUserService>(context, listen: false)
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

  Widget _banner(TmdbTitle title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 9 / 16;

    String image =
        title.backdropPath.isNotEmpty ? title.backdropPath : title.posterPath;
    bool isMovie = title.isMovie;

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.fill,
        errorWidget: (context, error, stackTrace) {
          return Image.asset(
            isMovie ? 'assets/movie_poster.png' : 'assets/tvshow_poster.png',
            fit: BoxFit.fitWidth,
          );
        },
      ),
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

    if (title.isOnAir) {
      text += ' - ...';
    } else if (title.lastAirDate.isNotEmpty) {
      text += ' - ${title.lastAirDate.substring(0, 4)}';
    }

    return text;
  }

  String _duration(TmdbTitle title) {
    return title.duration.isNotEmpty
        ? title.duration
        : AppLocalizations.of(context)!.unknownDuration;
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
      child: PersonChip(person: tmdbPerson),
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

  Widget _cast(TmdbTitle title) {
    if (title.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.credits,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: title.cast
                .map((person) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _personChip(context, person)))
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
