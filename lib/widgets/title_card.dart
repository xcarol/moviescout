import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/network_image_cache.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 160.0;

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final bool isUpdatingWatchlist;
  final BuildContext context;
  final void Function(bool) onWatchlistPressed;

  const TitleCard({
    super.key,
    required this.context,
    required TmdbTitle title,
    required this.isUpdatingWatchlist,
    required this.onWatchlistPressed,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    if (_title.id == 0) {
      return SizedBox(
          height: CARD_HEIGHT,
          child: Center(child: CircularProgressIndicator()));
    }

    return SizedBox(
      height: CARD_HEIGHT,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TitleDetails(
                        title: TmdbTitle(title: _title.map),
                      )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: _titlePoster(_title.posterPath),
                ),
                const SizedBox(width: 10),
                _titleCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleRating() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    if (_title.voteAverage == 0.0) {
      return const SizedBox();
    }

    List<Widget> children = [
      Icon(Icons.star, color: Theme.of(context).colorScheme.onSurface),
      const SizedBox(width: 5),
      Text(_title.voteAverage.toStringAsFixed(2)),
    ];

    TmdbRateslistService rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: true);

    TmdbTitle userRatedTitle = rateslistService.titles.isNotEmpty
        ? rateslistService.titles.firstWhere((title) => title.id == _title.id,
            orElse: () => TmdbTitle(title: {}))
        : TmdbTitle(title: {});

    if (userRatedTitle.id > 0) {
      children.addAll([
        const SizedBox(width: 20),
        Icon(Icons.star, color: customColors.ratedTitle),
        const SizedBox(width: 5),
        Text(
          userRatedTitle.rating.toStringAsFixed(2),
          style: TextStyle(color: customColors.ratedTitle),
        ),
      ]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: children,
        ),
      ],
    );
  }

  Widget _titlePoster(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return AspectRatio(
        aspectRatio: 2 / 3,
        child: SvgPicture.asset(
          'assets/movie.svg',
          fit: BoxFit.contain,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: NetworkImageCache(
        posterPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/movie.svg',
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  _titleCard() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleHeader(),
            const SizedBox(height: 5),
            Row(
              children: [
                _titleDate(),
                const Text(' - '),
                if (_title.duration.isNotEmpty)
                  _titleDuration()
                else
                  _titleType(),
              ],
            ),
            const SizedBox(height: 5),
            _titleRating(),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_titleBottomRow()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _titleHeader() {
    return Text(
      _title.name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _titleDate() {
    String text = '';

    if (_title.isMovie) {
      String releaseDate = _title.releaseDate;
      text = releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : '';
    } else if (_title.isSerie) {
      String firstAirDate = _title.firstAirDate;
      dynamic nextEpisodeToAir = _title.nextEpisodeToAir;
      String lastAirDate = _title.lastAirDate;

      text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

      if (nextEpisodeToAir.isNotEmpty) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    }

    return Text(text);
  }

  Text _titleDuration() {
    return Text(_title.duration);
  }

  Text _titleType() {
    return Text(_title.mediaType == 'movie'
        ? AppLocalizations.of(context)!.movie
        : AppLocalizations.of(context)!.tvShow);
  }

  Row _titleBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: _providers(),
        ),
        Row(
          children: [
            watchlistButton(context, _title),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget _providers() {
    if (_title.providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _title.providers.flatrate
            .map<Widget>((provider) => _providerLogo(provider))
            .toList(),
      ),
    );
  }

  Widget _providerLogo(provider) {
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
