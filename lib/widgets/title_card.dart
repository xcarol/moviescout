import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/network_image_cache.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 160.0;

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final TmdbListService _tmdbListService;
  final BuildContext context;
  final void Function(bool) onWatchlistPressed;

  const TitleCard({
    super.key,
    required this.context,
    required TmdbTitle title,
    required TmdbListService tmdbListService,
    required this.onWatchlistPressed,
  }) : _title = title, _tmdbListService = tmdbListService;

  @override
  Widget build(BuildContext context) {
    TmdbTitle tmdbTitle = _tmdbListService.titles.firstWhere(
      (title) => title.id == _title.id,
      orElse: () => _title,
    );

    return SizedBox(
      height: CARD_HEIGHT,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TitleDetails(
                        title: TmdbTitle(title: tmdbTitle.map),
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
                  child: _titlePoster(tmdbTitle.posterPath),
                ),
                const SizedBox(width: 10),
                _titleCard(tmdbTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleRating(TmdbTitle tmdbTitle) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    if (tmdbTitle.voteAverage == 0.0) {
      return const SizedBox();
    }

    List<Widget> children = [
      Icon(
        Icons.star,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      const SizedBox(width: 5),
      Text(tmdbTitle.voteAverage.toStringAsFixed(2)),
    ];

    TmdbRateslistService rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: true);

    TmdbTitle userRatedTitle = rateslistService.titles.isNotEmpty
        ? rateslistService.titles.firstWhere((title) => title.id == tmdbTitle.id,
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

  _titleCard(TmdbTitle tmdbTitle) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleHeader(tmdbTitle.name),
            const SizedBox(height: 5),
            Row(
              children: [
                _titleDate(tmdbTitle),
                const Text(' - '),
                if (tmdbTitle.duration.isNotEmpty)
                  _titleDuration(tmdbTitle.duration)
                else
                  _titleType(tmdbTitle.mediaType),
              ],
            ),
            const SizedBox(height: 5),
            _titleRating(tmdbTitle),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_titleBottomRow(tmdbTitle)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _titleHeader(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _titleDate(TmdbTitle tmdbTitle) {
    String text = '';

    if (tmdbTitle.isMovie) {
      String releaseDate = tmdbTitle.releaseDate;
      text = releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : '';
    } else if (tmdbTitle.isSerie) {
      String firstAirDate = tmdbTitle.firstAirDate;
      dynamic nextEpisodeToAir = tmdbTitle.nextEpisodeToAir;
      String lastAirDate = tmdbTitle.lastAirDate;

      text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

      if (nextEpisodeToAir.isNotEmpty) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    }

    return Text(text);
  }

  Text _titleDuration(String duration) {
    return Text(duration);
  }

  Text _titleType(String mediaType) {
    return Text(mediaType == 'movie'
        ? AppLocalizations.of(context)!.movie
        : AppLocalizations.of(context)!.tvShow);
  }

  Row _titleBottomRow(TmdbTitle tmdbTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: _providers(tmdbTitle),
        ),
        Row(
          children: [
            watchlistButton(context, tmdbTitle),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget _providers(TmdbTitle tmdbTitle) {
    if (tmdbTitle.providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tmdbTitle.providers.flatrate
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
