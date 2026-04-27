import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/widgets/title_card.dart';

class EpisodeCard extends StatelessWidget {
  final TmdbEpisode _episode;

  static double cardHeight = 120.0;

  const EpisodeCard({
    super.key,
    required TmdbEpisode episode,
  }) : _episode = episode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                episodeThumbnail(_episode.stillPath),
                const SizedBox(width: 10),
                _episodeDetails(context, _episode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget episodeThumbnail(String? stillPath) {
    if (stillPath == null || stillPath.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: SvgPicture.asset(
          'assets/tvshow.svg',
          fit: BoxFit.contain,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: stillPath,
        cacheManager: CustomCacheManager.instance,
        fit: BoxFit.cover,
        memCacheHeight: 180,
        memCacheWidth: 320,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        cacheKey: stillPath,
        errorWidget: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/tvshow.svg',
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  Widget _episodeDetails(BuildContext context, TmdbEpisode episode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          episodeHeader('${episode.episodeNumber}. ${episode.name}'),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(episode.airDate, overflow: TextOverflow.ellipsis),
              if (episode.runtime > 0) ...[
                const Text(' - '),
                Text('${episode.runtime} min'),
              ],
            ],
          ),
          const SizedBox(height: 5),
          episodeRating(context, episode),
        ],
      ),
    );
  }

  Text episodeHeader(String name, {int maxLines = 2}) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget episodeRating(BuildContext context, TmdbEpisode episode) {
    if (episode.voteAverage == 0.0) {
      return const SizedBox();
    }

    return Row(
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 5),
        Text(episode.voteAverage.toStringAsFixed(2)),
      ],
    );
  }
}
