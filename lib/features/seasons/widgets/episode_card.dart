import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/core/utils/date_formatter.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';

class EpisodeCard extends StatelessWidget {
  final TmdbEpisode _episode;
  final TmdbTitle _title;
  final int seasonNumber;
  final TmdbTitleListService tmdbListService;
  final int? totalEpisodes;

  static double cardHeight = 122.0;

  const EpisodeCard({
    super.key,
    required TmdbTitle title,
    required this.seasonNumber,
    required TmdbEpisode episode,
    required this.tmdbListService,
    this.totalEpisodes,
  })  : _title = title,
        _episode = episode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(),
          child: InkWell(
            onTap: () {
              context.toEpisodeDetails(
                title: _title,
                seasonNumber: seasonNumber,
                episodeNumber: _episode.episodeNumber,
                tmdbListService: tmdbListService,
                initialEpisode: _episode,
                totalEpisodes: totalEpisodes ?? 0,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: episodeThumbnail(_episode.stillPath),
                ),
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
    return AppPosterImage(
      imageUrl: stillPath,
      aspectRatio: 16 / 9,
      fallbackType: PosterFallbackType.tvShow,
      memCacheWidth: 320,
      memCacheHeight: 180,
      fit: BoxFit.cover,
    );
  }

  Widget _episodeDetails(BuildContext context, TmdbEpisode episode) {
    final textColor = Theme.of(
      context,
    ).colorScheme.onSurfaceVariant;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          episodeHeader('${episode.episodeNumber}. ${episode.name}'),
          const SizedBox(height: 5),
          Text(
            DateFormatter.formatDate(context, episode.airDate),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor),
          ),
          if (episode.runtime > 0) ...[
            const SizedBox(height: 5),
            Text(
              '${episode.runtime} min',
              style: TextStyle(color: textColor),
            ),
          ],
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
          color: Theme.of(context).extension<CustomColors>()!.ratedTitle,
        ),
        const SizedBox(width: 5),
        Text(episode.voteAverage.toStringAsFixed(2)),
      ],
    );
  }
}
