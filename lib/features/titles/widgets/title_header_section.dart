import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/features/titles/widgets/comment_button.dart';
import 'package:moviescout/features/notifications/widgets/notify_button.dart';
import 'package:moviescout/features/watchlist/widgets/pin_button.dart';
import 'package:moviescout/features/titles/widgets/trailer_buttons.dart';
import 'package:moviescout/features/watchlist/widgets/watchlist_button.dart';
import 'package:moviescout/core/widgets/media_carousel.dart';
import 'package:moviescout/core/widgets/clickable_names.dart';

class TitleHeaderSection extends StatelessWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;
  final bool isUpdating;

  const TitleHeaderSection({
    super.key,
    required this.title,
    required this.tmdbListService,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topOffset = (constraints.maxWidth * 9 / 16) - 28;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaCarousel(
                  images: title.images,
                  backdropPath: title.backdropPath,
                  posterPath: title.posterPath,
                  mediaType:
                      title.isMovie ? ApiConstants.movie : ApiConstants.tv,
                  isLoading: isUpdating,
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.only(
                    left: 144,
                    right: 5,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleLine(),
                          _dateAndDuration(context),
                          _primaryCreator(context),
                        ],
                      ),
                      _genres(context),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      _tagLine(context),
                      const SizedBox(height: 6),
                      _actionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 8,
              top: topOffset,
              child: GestureDetector(
                onTap: () {
                  if (title.posterPath.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenCarousel(
                          images: [title.posterPath],
                          initialPage: 0,
                          infiniteBase: 0,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 4,
                    ),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 170,
                    child: AppPosterImage(
                      imageUrl: title.posterPath.isNotEmpty
                          ? UrlConstants.tmdbImageW500Template
                              .replaceFirst('{PATH}', title.posterPath)
                          : null,
                      fallbackType: title.isMovie
                          ? PosterFallbackType.movie
                          : PosterFallbackType.tvShow,
                      customFallbackAsset: title.isMovie
                          ? 'assets/movie_poster.png'
                          : 'assets/tvshow_poster.png',
                      aspectRatio: null,
                      fit: BoxFit.cover,
                      fallbackFit: BoxFit.cover,
                      memCacheWidth: 240,
                      memCacheHeight: 340,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _titleLine() {
    if (title.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateAndDuration(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${_releaseDates()} - ${_duration(context)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (title.certification.isNotEmpty) ...[
          const SizedBox(width: 8),
          _certificationBadge(context),
        ],
      ],
    );
  }

  Widget _certificationBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: 0.5),
        ),
        borderRadius: AppRadius.borderXs,
      ),
      child: Text(
        title.certification,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _primaryCreator(BuildContext context) {
    if (title.creditsJson == null) return const SizedBox.shrink();

    String label = '';
    List<TmdbPerson> people = [];

    final directors = title.crew
        .where((c) => c.job.split(', ').contains(CrewJobs.director))
        .toList();
    final creators = title.crew.where((c) {
      final jobs = c.job.split(', ');
      return jobs.contains(CrewJobs.executiveProducer) ||
          jobs.contains(CrewJobs.creator);
    }).toList();
    final writers = title.crew.where((c) {
      final jobs = c.job.split(', ');
      return jobs.contains(CrewJobs.writer) ||
          jobs.contains(CrewJobs.screenplay) ||
          jobs.contains(CrewJobs.author);
    }).toList();

    if (directors.isNotEmpty) {
      label = AppLocalizations.of(context)!.director;
      people = [directors.first];
    } else if (creators.isNotEmpty) {
      label = AppLocalizations.of(context)!.creator;
      people = [creators.first];
    } else if (writers.isNotEmpty) {
      label = AppLocalizations.of(context)!.writer;
      people = [writers.first];
    }

    if (people.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              ClickableNames(
                people: people,
                tmdbListService: tmdbListService,
                useEllipsis: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genres(BuildContext context) {
    if (title.genres.isEmpty) {
      return const SizedBox.shrink();
    }

    final String genresText = title.genres.map((g) => g.name).join(', ');

    return Text(
      genresText,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  String _releaseDates() {
    if (title.isMovie) {
      return title.releaseDate.isNotEmpty
          ? title.releaseDate.substring(0, 4)
          : '';
    }

    String text =
        title.firstAirDate.isNotEmpty ? title.firstAirDate.substring(0, 4) : '';

    if (!title.isMiniSerie) {
      if (title.isOnAir) {
        text += ' - ...';
      } else if (title.lastAirDate.isNotEmpty) {
        text += ' - ${title.lastAirDate.substring(0, 4)}';
      }
    } else if (title.isOnAir) {
      text += ' - ...';
    }

    return text;
  }

  String _duration(BuildContext context) {
    String text = title.duration.isNotEmpty
        ? title.duration
        : AppLocalizations.of(context)!.unknownDuration;

    if (title.isSerie && title.numberOfSeasons > 0) {
      text +=
          ' - ${AppLocalizations.of(context)!.seasonsCount(title.numberOfSeasons)}';
    }
    return text;
  }

  Widget _tagLine(BuildContext context) {
    if (title.tagline.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: Text(
            title.tagline,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        watchlistButton(context, title),
        const SizedBox(width: 8),
        pinButton(context, title),
        const SizedBox(width: 8),
        notifyButton(context, title),
        const SizedBox(width: 8),
        commentButton(context, title),
        const Spacer(),
        TrailerButtons(videos: title.videos),
      ],
    );
  }
}
