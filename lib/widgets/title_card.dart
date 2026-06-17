import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:moviescout/widgets/pin_button.dart';
import 'package:moviescout/widgets/notify_button.dart';
import 'package:provider/provider.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      fileService: HttpFileService(),
    ),
  );
}

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final TmdbTitleListService _tmdbListService;

  static double cardHeight = 160.0;

  const TitleCard({
    super.key,
    required TmdbTitle title,
    required TmdbTitleListService tmdbListService,
  })  : _title = title,
        _tmdbListService = tmdbListService;

  TmdbTitleListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TmdbTitle?>(
      future:
          _tmdbListService.getTitleByTmdbId(_title.tmdbId, _title.mediaType),
      builder: (context, snapshot) {
        final tmdbTitle = snapshot.data ?? _title;

        return RepaintBoundary(
          child: SizedBox(
            height: cardHeight,
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TitleDetails(
                              title: tmdbTitle,
                              tmdbListService: tmdbListService,
                            )),
                  );
                },
                child: Row(
                  children: [
                    titlePoster(tmdbTitle.posterPath),
                    const SizedBox(width: 10),
                    _titleDetails(context, tmdbTitle),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titleRating(BuildContext context, TmdbTitle tmdbTitle,
      {bool isCompact = false}) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final double iconTextSpacing = isCompact ? 2.0 : 5.0;
    final double betweenSpacing = isCompact ? 8.0 : 20.0;

    if (tmdbTitle.voteAverage == 0.0) {
      return const SizedBox();
    }

    List<Widget> children = [];
    if (tmdbTitle.voteAverage > 0) {
      children.addAll([
        Icon(
          Icons.star,
          color: customColors.ratedTitle,
        ),
        SizedBox(width: iconTextSpacing),
        Text(tmdbTitle.voteAverage.toStringAsFixed(2)),
      ]);
    }
    _debugShowLastUpdates(context, children, tmdbTitle);

    return Consumer<TmdbRateslistService>(
      builder: (context, rateslistService, _) {
        return FutureBuilder<TmdbTitle?>(
          future: rateslistService.getTitleByTmdbId(
              tmdbTitle.tmdbId, tmdbTitle.mediaType),
          builder: (context, snapshot) {
            final ratedTitle = snapshot.data;
            final ratingChildren = List<Widget>.from(children);

            if (ratedTitle != null && ratedTitle.tmdbId > 0) {
              if (ratingChildren.isNotEmpty) {
                ratingChildren.add(SizedBox(width: betweenSpacing));
              }
              if (ratedTitle.rating == AppConstants.seenRating) {
                ratingChildren.add(
                  Icon(
                    Icons.check,
                    color: customColors.userRatedTitle,
                  ),
                );
                if (!isCompact) {
                  ratingChildren.add(
                    Text(AppLocalizations.of(context)!.seen),
                  );
                }
              } else {
                ratingChildren.addAll([
                  Icon(
                    Icons.star,
                    color: customColors.userRatedTitle,
                  ),
                  SizedBox(width: iconTextSpacing),
                  Text(ratedTitle.rating.toStringAsFixed(0)),
                ]);
              }
            }

            if (ratingChildren.isEmpty) {
              return SizedBox(height: IconTheme.of(context).size ?? 24.0);
            }

            return Row(children: ratingChildren);
          },
        );
      },
    );
  }

  Widget titlePoster(String? posterPath) {
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
      child: CachedNetworkImage(
        imageUrl: posterPath,
        cacheManager: CustomCacheManager.instance,
        fit: BoxFit.cover,
        memCacheHeight: 300,
        memCacheWidth: 200,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        cacheKey: posterPath,
        errorWidget: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/movie.svg',
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  Widget _titleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleHeader(tmdbTitle.name),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    titleSubtitle(context, tmdbTitle),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            titleRating(context, tmdbTitle),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_titleBottomRow(context, tmdbTitle)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text titleHeader(String name, {int maxLines = 1}) {
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



  Row _titleBottomRow(BuildContext context, TmdbTitle tmdbTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: providers(tmdbTitle)),
        Row(
          children: [
            notifyButton(context, tmdbTitle),
            const SizedBox(width: 8),
            pinButton(context, tmdbTitle),
            const SizedBox(width: 8),
            watchlistButton(context, tmdbTitle),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget providers(TmdbTitle tmdbTitle) {
    if (tmdbTitle.providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      key: ValueKey(tmdbTitle.tmdbId),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tmdbTitle.providers.flatrate
            .map<Widget>((provider) => _providerLogo(provider))
            .toList(),
      ),
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
            memCacheHeight: 30,
            memCacheWidth: 30,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            placeholderFadeInDuration: Duration.zero,
            cacheKey: provider.logoPath,
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

  void _debugShowLastUpdates(
      BuildContext context, List<Widget> children, TmdbTitle tmdbTitle) {
    if (_tmdbListService.listName == AppConstants.watchlist &&
        (PreferencesService().prefs.getBool(AppConstants.debugShowLastUpdate) ??
            false)) {
      children.add(const SizedBox(width: 5));
      children.add(
        Flexible(
          child: GestureDetector(
            onTap: () async {
              tmdbTitle.lastUpdated = DateTime.parse(tmdbTitle.lastUpdated)
                  .subtract(const Duration(days: 1))
                  .toIso8601String();
              tmdbTitle.lastProvidersUpdate =
                  DateTime.parse(tmdbTitle.lastProvidersUpdate)
                      .subtract(const Duration(days: 1))
                      .toIso8601String();
              await Provider.of<TmdbTitleListService>(context, listen: false)
                  .debugUpdateTitleLastUpdate(tmdbTitle);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text(
                  '[lastUpdated: ${DateFormat('dd-MM-yyyyTHH:mm').format(DateTime.parse(tmdbTitle.lastUpdated))}]',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  '[lastProvidersUpdate: ${DateFormat('dd-MM-yyyyTHH:mm').format(DateTime.parse(tmdbTitle.lastProvidersUpdate))}]',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ]),
            ),
          ),
        ),
      );

      if (tmdbTitle.isSerie) {
        children.add(const SizedBox(width: 5));
        children.add(
          GestureDetector(
            onTap: () async {
              tmdbTitle.lastNotifiedSeason = tmdbTitle.lastNotifiedSeason - 1;
              await Provider.of<TmdbTitleListService>(context, listen: false)
                  .debugUpdateTitleLastUpdate(tmdbTitle);
            },
            child: Text(
              '[${tmdbTitle.lastNotifiedSeason}]',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        );
      }
    }
  }
}

String titleDate(TmdbTitle tmdbTitle) {
  String text = '';

  if (tmdbTitle.isMovie) {
    text = tmdbTitle.releaseDate.isNotEmpty
        ? tmdbTitle.releaseDate.substring(0, 4)
        : '';
  } else if (tmdbTitle.isSerie) {
    final firstAirDate = tmdbTitle.firstAirDate;
    final isOnAir = tmdbTitle.isOnAir;
    final lastAirDate = tmdbTitle.lastAirDate;

    text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

    if (!tmdbTitle.isMiniSerie) {
      if (isOnAir) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    } else if (isOnAir) {
      text += ' - ...';
    }
  }

  return text;
}

String titleType(BuildContext context, String mediaType) {
  return mediaType == ApiConstants.movie
      ? AppLocalizations.of(context)!.movie
      : AppLocalizations.of(context)!.tvShow;
}

String titleSubtitle(BuildContext context, TmdbTitle tmdbTitle) {
  final date = titleDate(tmdbTitle);
  String typeOrDuration = tmdbTitle.duration;
  if (typeOrDuration.isEmpty) {
    typeOrDuration = titleType(context, tmdbTitle.mediaType);
  }

  if (date.isNotEmpty && typeOrDuration.isNotEmpty) {
    return '$date - $typeOrDuration';
  } else if (date.isNotEmpty) {
    return date;
  } else {
    return typeOrDuration;
  }
}

