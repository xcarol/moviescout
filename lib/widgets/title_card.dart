import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/cached_network_image.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const double CARD_HEIGHT = 160.0;

class TitleCard extends StatelessWidget {
  final TmdbTitle _title;
  final bool isUpdatingWatchlist;
  final bool isInWatchlist;
  final BuildContext context;
  final VoidCallback onWatchlistPressed;

  const TitleCard({
    super.key,
    required this.context,
    required TmdbTitle title,
    required this.isUpdatingWatchlist,
    required this.isInWatchlist,
    required this.onWatchlistPressed,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT,
      child: Card(
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
                  child: titlePoster(_title.posterPath),
                ),
                const SizedBox(width: 10),
                titleCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleRating() {
    if (_title.voteAverage == 0.0) {
      return const SizedBox();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.star),
            const SizedBox(width: 5),
            Text(_title.voteAverage.toStringAsFixed(2)),
          ],
        ),
      ],
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

  titleCard() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleHeader(),
            const SizedBox(height: 5),
            Row(
              children: [
                titleDate(),
                const Text(' - '),
                if (_title.duration.isNotEmpty)
                  titleDuration()
                else
                  titleType(),
              ],
            ),
            const SizedBox(height: 5),
            titleRating(),
            const SizedBox(height: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [titleBottomRow()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text titleHeader() {
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

  Text titleDate() {
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

  Text titleDuration() {
    return Text(_title.duration);
  }

  Text titleType() {
    return Text(_title.mediaType == 'movie'
        ? AppLocalizations.of(context)!.movie
        : AppLocalizations.of(context)!.tvShow);
  }

  Row titleBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: providers(),
        ),
        Row(
          children: [
            watchlistButton(),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget providers() {
    if (_title.providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _title.providers.flatrate
            .map<Widget>((provider) => providerLogo(provider))
            .toList(),
      ),
    );
  }

  Widget providerLogo(provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 30,
        height: 30,
        child: CachedNetworkImage(
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

  IconButton watchlistButton() {
    if (Provider.of<TmdbUserService>(context, listen: false).user == null) {
      return IconButton(
        icon: const Icon(Icons.highlight_off),
        onPressed: () {
          SnackMessage.showSnackBar(
              AppLocalizations.of(context)!.signInToWatchlist);
        },
      );
    }

    if (isUpdatingWatchlist) {
      return IconButton(
        icon: const Icon(Icons.hourglass_empty),
        onPressed: () {},
      );
    }

    return IconButton(
      color: isInWatchlist ? Colors.red : Colors.green,
      icon: Icon(isInWatchlist ? Icons.close_sharp : Icons.add_sharp),
      onPressed: onWatchlistPressed,
    );
  }
}
