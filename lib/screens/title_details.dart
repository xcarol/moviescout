import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

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
      future: TmdbTitleService().getTitleDetails(
        widget._title,
        Localizations.localeOf(context),
      ),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Scaffold(
            appBar: MainAppBar(
              context: context,
              title: appTitle,
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _back,
                  tooltip: AppLocalizations.of(context)!.back,
                ),
              ],
            ),
            drawer: AppDrawer(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _detailsBody(snapshot.data!),
            ),
          );
        }
      },
    );
  }

  _back() async {
    Navigator.pop(context);
  }

  _detailsBody(TmdbTitle title) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: _banner(title.backdropPath),
          ),
          const SizedBox(height: 20),
          _details(title),
        ],
      ),
    );
  }

  _details(TmdbTitle title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _releaseDates(title),
            Text(' - '),
            _duration(title),
          ],
        ),
        const SizedBox(height: 10),
        _rating(title),
        const SizedBox(height: 10),
        _genres(title),
        const SizedBox(height: 10),
        _descrition(title),
        const SizedBox(height: 30),
        _providers(title),
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
            Icon(Icons.star),
            const SizedBox(width: 5),
            Text(title.voteAverage.toStringAsFixed(2)),
          ],
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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

  Widget _banner(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) {
      return AspectRatio(
        aspectRatio: 3 / 2,
        child: SvgPicture.asset(
          'assets/movie.svg',
          fit: BoxFit.cover,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Image.network(
        backdropPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/movie.svg',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Text _releaseDates(TmdbTitle title) {
    String text;

    if (title.isMovie) {
      text = _movieDate(title);
    } else {
      text = _tvShowDates(title);
    }

    return Text(text);
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

  Text _duration(TmdbTitle title) {
    return Text(title.duration);
  }

  Text _descrition(TmdbTitle title) {
    return Text(
      title.overview.isEmpty
          ? AppLocalizations.of(context)!.missingDescription
          : title.overview,
    );
  }

  Column _providers(TmdbTitle title) {
    List<Widget> providers = [];

    if (title.providers.flatrate.isNotEmpty) {
      providers += _providersByType(
        AppLocalizations.of(context)!.flatrateProviders,
        title.providers.flatrate,
      );
    }

    if (title.providers.rent.isNotEmpty) {
      providers += _providersByType(
        AppLocalizations.of(context)!.rentProviders,
        title.providers.rent,
      );
    }

    if (title.providers.buy.isNotEmpty) {
      providers += _providersByType(
        AppLocalizations.of(context)!.buyProviders,
        title.providers.buy,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: providers,
    );
  }

  List<Widget> _providersByType(String typeName, List<TmdbProvider> providers) {
    return [
      Text(
        typeName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: _providersRow(providers),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  Widget _providersRow(List<TmdbProvider> providers) {
    if (providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: (providers as List?)
                ?.map<Widget>((provider) => _providerLogo(provider))
                .toList() ??
            [],
      ),
    );
  }

  Widget _providerLogo(TmdbProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Image.network(
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
