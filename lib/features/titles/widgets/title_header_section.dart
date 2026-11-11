import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
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
        final bannerHeight = math.min(
          constraints.maxWidth / AppSizes.aspectRatioBackdrop,
          AppBreakpoints.maxBannerHeight,
        );
        final topOffset = bannerHeight - AppSizes.headerPosterOverlap;
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
                  constraints: const BoxConstraints(
                    minHeight: AppSizes.headerInfoMinHeight,
                  ),
                  padding: const EdgeInsets.only(
                    left: AppSizes.headerInfoLeftPadding,
                    right: AppSpacing.md,
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleLine(context),
                          _dateAndDuration(context),
                          _primaryCreator(context),
                        ],
                      ),
                      _genres(context),
                    ],
                  ),
                ),
                Padding(
                  padding: AppSpacing.screenHorizontal,
                  child: Column(
                    children: [
                      _tagLine(context),
                      const SizedBox(height: AppSpacing.xs),
                      _actionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: AppSpacing.xs,
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
                      width: AppSizes.headerPosterBorderWidth,
                    ),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: AppCachedImage(
                    imageUrl: title.posterPath.isNotEmpty
                        ? UrlConstants.tmdbImageW500Template
                            .replaceFirst('{PATH}', title.posterPath)
                        : null,
                    width: AppSizes.headerPosterWidth,
                    height: AppSizes.headerPosterHeight,
                    borderRadius: AppRadius.borderXs,
                    type: AppImageType.poster,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _titleLine(BuildContext context) {
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
                style: Theme.of(context).textTheme.titleMedium,
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        if (title.certification.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.xs),
          _certificationBadge(context),
        ],
      ],
    );
  }

  Widget _certificationBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.micro,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: AppOpacity.half),
        ),
        borderRadius: AppRadius.borderXs,
      ),
      child: Text(
        title.certification,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
      padding: const EdgeInsets.only(top: AppSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          ClickableNames(
            people: people,
            tmdbListService: tmdbListService,
            useEllipsis: true,
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
        const SizedBox(width: AppSpacing.xs),
        pinButton(context, title),
        const SizedBox(width: AppSpacing.xs),
        notifyButton(context, title),
        const SizedBox(width: AppSpacing.xs),
        commentButton(context, title),
        const Spacer(),
        TrailerButtons(videos: title.videos),
      ],
    );
  }
}
