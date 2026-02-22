import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/widgets/watchlist_button.dart';
import 'package:moviescout/widgets/pin_button.dart';
import 'package:provider/provider.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final TmdbListService _tmdbListService;

  static double cardHeight = 160.0;

  const TitleCard({
    super.key,
    required TmdbTitle title,
    required TmdbListService tmdbListService,
  })  : _title = title,
        _tmdbListService = tmdbListService;

  TmdbListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    TmdbTitle tmdbTitle = _title;

    if (_title.listName != _tmdbListService.listName) {
      tmdbTitle =
          _tmdbListService.getTitleByTmdbId(_title.tmdbId, _title.mediaType) ??
              _title;
    }

    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(),
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
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: titlePoster(tmdbTitle.posterPath),
                  ),
                  const SizedBox(width: 10),
                  _titleDetails(context, tmdbTitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleRating(BuildContext context, TmdbTitle tmdbTitle,
      {List<Widget>? extraWidgets}) {
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

    // 302-debug-notifications
    if (_tmdbListService.listName == AppConstants.watchlist &&
        (PreferencesService().prefs.getBool(AppConstants.debugShowLastUpdate) ??
            false)) {
      children.add(const SizedBox(width: 5));
      children.add(
        GestureDetector(
          onTap: () async {
            tmdbTitle.lastUpdated = DateTime.parse(tmdbTitle.lastUpdated)
                .subtract(const Duration(days: 1))
                .toIso8601String();
            await Provider.of<TmdbTitleRepository>(context, listen: false)
                .saveTitle(tmdbTitle);
            if (context.mounted) {
              Provider.of<TmdbListService>(context, listen: false)
                  .debugUpdateTitleLastUpdate(tmdbTitle);
            }
          },
          child: Text(
            '[${DateFormat('dd-MM-yyyyTHH:mm').format(DateTime.parse(tmdbTitle.lastUpdated))}]',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      );

      if (tmdbTitle.isSerie) {
        children.add(const SizedBox(width: 5));
        children.add(
          Text(
            '[${tmdbTitle.lastNotifiedSeason}]',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        );
      }
    }

    return Selector<TmdbRateslistService, TmdbTitle?>(
      selector: (_, rateslistService) => rateslistService.getTitleByTmdbId(
          tmdbTitle.tmdbId, tmdbTitle.mediaType),
      shouldRebuild: (prev, next) => prev?.rating != next?.rating,
      builder: (context, ratedTitle, _) {
        if (ratedTitle != null && ratedTitle.tmdbId > 0) {
          children.add(const SizedBox(width: 20));
          if (ratedTitle.rating == AppConstants.seenRating) {
            children.add(
              Text(
                AppLocalizations.of(context)!.seen,
                style: TextStyle(color: customColors.ratedTitle),
              ),
            );
          } else {
            children.addAll([
              Icon(Icons.star, color: customColors.ratedTitle),
              const SizedBox(width: 5),
              Text(
                ratedTitle.rating.toStringAsFixed(0),
                style: TextStyle(color: customColors.ratedTitle),
              ),
            ]);
          }
        }

        if (extraWidgets != null) {
          children.addAll(extraWidgets);
        }

        return Row(children: children);
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleHeader(tmdbTitle.name),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(titleDate(tmdbTitle), overflow: TextOverflow.ellipsis),
                const Text(' - '),
                tmdbTitle.duration.isNotEmpty
                    ? Text(tmdbTitle.duration)
                    : Text(_titleType(context, tmdbTitle.mediaType)),
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

      if (isOnAir) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }
    }

    return text;
  }

  String _titleType(BuildContext context, String mediaType) {
    return mediaType == ApiConstants.movie
        ? AppLocalizations.of(context)!.movie
        : AppLocalizations.of(context)!.tvShow;
  }

  Row _titleBottomRow(BuildContext context, TmdbTitle tmdbTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: providers(tmdbTitle)),
        Row(
          children: [
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
      controller: ScrollController(keepScrollOffset: false),
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
}
