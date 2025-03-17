import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
double CARD_HEIGHT = 160.0;

class TitleCard extends StatelessWidget {
  final Map title;
  final bool isUpdating;
  final bool isInWatchlist;
  final BuildContext context;
  final VoidCallback onPressed;

  const TitleCard({
    super.key,
    required this.context,
    required this.title,
    required this.isUpdating,
    required this.isInWatchlist,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT,
      child: Card(
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
                child: titlePoster(title['poster_path']),
              ),
              const SizedBox(width: 10),
              titleCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleRating() {
    if (title['vote_average'] == null) {
      return const SizedBox();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.star),
            const SizedBox(width: 5),
            Text((title['vote_average'] as double).toStringAsFixed(2)),
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
          fit: BoxFit.cover,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Image.network(
        'https://image.tmdb.org/t/p/w500$posterPath',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset(
            'assets/movie.svg',
            fit: BoxFit.cover,
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
                Text(' '),
                titleDuration(),
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
    String text;

    if (title['title'] != null) {
      text = title['title'] ?? '';
    } else {
      text = title['name'] ?? '';
    }

    return Text(
      text,
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

    try {
      if (title['title'] != null) {
        String releaseDate = title['release_date'] ?? '';
        text = releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : '';
      } else if (title['name'] != null) {
        String firstAirDate = title['first_air_date'] ?? '';
        dynamic nextEpisodeToAir = title['next_episode_to_air'] ??
            ''; // Can be a String or a Map with next episode details
        String lastAirDate = title['last_air_date'] ?? '';

        text += firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : '';

        if (nextEpisodeToAir.isNotEmpty) {
          text += ' - ...';
        } else if (lastAirDate.isNotEmpty) {
          text += ' - ${lastAirDate.substring(0, 4)}';
        }
      }
    } catch (error) {
      text = 'Error: $error in titleDate';
    }

    return Text(text);
  }

  Text titleDuration() {
    String text = '';
    try {
      if (title['title'] != null && title['runtime'] != null) {
        int runtime = title['runtime'];
        int hours = (runtime / 60).floor().toInt();
        int minutes = runtime - hours * 60;
        if (hours > 0) {
          text = '${hours}h ';
        }
        text += '${minutes}m';
      } else if (title['name'] != null && title['number_of_episodes'] != null) {
        text = '${title['number_of_episodes']}eps';
      }
    } catch (error) {
      text = 'Error: $error in titleDuration';
    }

    return Text(text);
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
    try {
      if (title['providers'] == null) {
        return const SizedBox.shrink();
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: (title['providers']['flatrate'] as List?)
                  ?.map<Widget>((provider) => providerLogo(provider))
                  .toList() ??
              [],
        ),
      );
    } catch (e) {
      return Text(
        'Error: $e in providers for titleId ${title['id']}',
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget providerLogo(provider) {
    try {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Image.network(
            'https://image.tmdb.org/t/p/w92${provider['logo_path']}',
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
    } catch (e) {
      return Text('Error: $e in providerLogo for provider $provider');
    }
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

    if (isUpdating) {
      return IconButton(
        icon: const Icon(Icons.hourglass_empty),
        onPressed: () {},
      );
    }

    return IconButton(
      color: isInWatchlist ? Colors.red : Colors.green,
      icon: Icon(isInWatchlist ? Icons.close_sharp : Icons.add_sharp),
      onPressed: onPressed,
    );
  }
}
