import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/network_image_cache.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/rate_form.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TitleDetails extends StatefulWidget {
  final TmdbTitle _title;
  const TitleDetails({super.key, required TmdbTitle title}) : _title = title;

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
        _banner(
            title.backdropPath.isNotEmpty
                ? title.backdropPath
                : title.posterPath,
            title.isMovie),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: _details(title),
        ),
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
        const SizedBox(width: 8),
        if (title.imdbId.isNotEmpty)
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
      ],
    );
  }

  Widget _details(TmdbTitle title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoLine(title),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_releaseDates(title)} - ${_duration(title)}'),
            watchlistButton(context, title),
          ],
        ),
        const SizedBox(height: 10),
        _rating(title),
        const SizedBox(height: 10),
        _genres(title),
        const SizedBox(height: 10),
        _description(title),
        const SizedBox(height: 30),
        _providers(title),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _rating(TmdbTitle title) {
    if (title.voteAverage == 0) {
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
            final titleRating = ratingService.getRating(title.id);

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

  Widget _banner(String image, bool isMovie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 9 / 16;

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: NetworkImageCache(
        image,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
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

    if (title.nextEpisodeToAir.isNotEmpty) {
      text += ' - ...';
    } else if (title.lastAirDate.isNotEmpty) {
      text += ' - ${title.lastAirDate.substring(0, 4)}';
    }

    return text;
  }

  String _duration(TmdbTitle title) {
    return title.duration;
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
      child: SizedBox(
        width: 30,
        height: 30,
        child: NetworkImageCache(
          provider.logoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return SvgPicture.asset(
              'assets/movie.svg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
