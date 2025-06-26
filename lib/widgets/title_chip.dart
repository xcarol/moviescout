import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/network_image_cache.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const double POSTER_HEIGHT = 100.0;
// ignore: constant_identifier_names
const double CARD_HEIGHT = 280.0;
// ignore: constant_identifier_names
const double CARD_WIDTH = 200.0;

class TitleChip extends StatelessWidget {
  final TmdbTitle _title;

  const TitleChip({
    super.key,
    required TmdbTitle title,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    TmdbTitle tmdbTitle = _title;

    return SizedBox(
      height: CARD_HEIGHT,
      width: CARD_WIDTH,
      child: Card(
        elevation: 4,
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
          child: Column(
            children: [
              SizedBox(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: _titlePoster(tmdbTitle),
                ),
              ),
              _titleDetails(context, tmdbTitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRating(BuildContext context, TmdbTitle tmdbTitle) {
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

    return Selector<TmdbRateslistService, TmdbTitle?>(
      selector: (_, rateslistService) => rateslistService.titles.firstWhere(
        (t) => t.id == tmdbTitle.id,
        orElse: () => TmdbTitle(title: {}),
      ),
      shouldRebuild: (prev, next) => prev?.rating != next?.rating,
      builder: (context, ratedTitle, _) {
        if (ratedTitle != null && ratedTitle.id > 0) {
          children.addAll([
            const SizedBox(width: 20),
            Icon(Icons.star, color: customColors.ratedTitle),
            const SizedBox(width: 5),
            Text(
              ratedTitle.rating.toStringAsFixed(0),
              style: TextStyle(color: customColors.ratedTitle),
            ),
          ]);
        }
        children.add(
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                watchlistButton(context, tmdbTitle),
              ],
            ),
          ),
        );

        return Row(children: children);
      },
    );
  }

  Widget _titlePoster(TmdbTitle title) {
    final double aspectRatio = 16 / 9;
    final String fallbackPoster =
        title.isMovie ? 'assets/movie_poster.png' : 'assets/serie_poster.png';

    final Widget imageWidget = title.backdropPath.isEmpty
        ? Image.asset(
            fallbackPoster,
            fit: BoxFit.contain,
          )
        : NetworkImageCache(
            title.backdropPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                fallbackPoster,
                fit: BoxFit.contain,
              );
            },
          );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: SizedBox.expand(
        child: imageWidget,
      ),
    );
  }

  Widget _titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleHeader(tmdbTitle.name),
            const SizedBox(height: 5),
            _titleRating(context, tmdbTitle),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: _providers(tmdbTitle)),
                  const SizedBox(height: 5),
                  Text(
                    '${_titleDate(tmdbTitle)} - ${tmdbTitle.duration}',
                  ),
                ],
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
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _titleDate(TmdbTitle tmdbTitle) {
    String text = '';

    if (tmdbTitle.isMovie) {
      text = tmdbTitle.releaseDate.isNotEmpty
          ? tmdbTitle.releaseDate.substring(0, 4)
          : '';
    } else if (tmdbTitle.isSerie) {
      final firstAirDate = tmdbTitle.firstAirDate;
      final nextEpisodeToAir = tmdbTitle.nextEpisodeToAir;
      final lastAirDate = tmdbTitle.lastAirDate;

      text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

      if (nextEpisodeToAir.isNotEmpty) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    }

    return text;
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
