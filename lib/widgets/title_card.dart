import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
double CARD_HEIGHT = 250.0;

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
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titlePoster(title['poster_path']),
              const SizedBox(width: 10),
              titleCard(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleRating(title) {
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

  Widget titleGenres(title) {
    List<Widget> genres = [];
    title['genres'].forEach((genre) {
      genres.add(Chip(
        label: Text(genre['name']),
        padding: EdgeInsets.all(5),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ));
      genres.add(const SizedBox(width: 5));
    });
    return Flexible(
      child: Align(
        alignment: Alignment.centerRight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: genres,
          ),
        ),
      ),
    );
  }

  Widget titlePoster(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return SizedBox(
        width: 110,
        height: 150,
        child: SvgPicture.asset(
          'assets/movie.svg',
          fit: BoxFit.cover,
        ),
      );
    }

    return SizedBox(
      width: 110,
      height: 150,
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

  titleCard(title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleHeader(title),
          const SizedBox(height: 5),
          Row(
            children: [
              titleRating(title),
              const SizedBox(width: 20),
              titleGenres(title),
            ],
          ),
          const SizedBox(height: 5),
          titleBody(title),
          const SizedBox(height: 5),
          titleBottomRow(title),
        ],
      ),
    );
  }

  Text titleHeader(title) {
    String text;

    if (title['title'] != null) {
      text = movieTitleDetails(title);
    } else {
      text = tvShowTitleDetails(title);
    }

    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  String movieTitleDetails(title) {
    String text = title['title'] ?? '';
    String releaseDate = title['release_date'] ?? '';
    text += releaseDate.isNotEmpty ? ' - ${releaseDate.substring(0, 4)}' : '';
    return text;
  }

  String tvShowTitleDetails(title) {
    try {
      String text = title['name'] ?? '';
      String firstAirDate = title['first_air_date'] ?? '';
      dynamic nextEpisodeToAir = title['next_episode_to_air'] ??
          ''; // Can be a String or a Map with next episode details
      String lastAirDate = title['last_air_date'] ?? '';

      text +=
          firstAirDate.isNotEmpty ? ' - ${firstAirDate.substring(0, 4)}' : '';

      if (nextEpisodeToAir.isNotEmpty) {
        text += ' - ...';
      } else if (lastAirDate.isNotEmpty) {
        text += ' - ${lastAirDate.substring(0, 4)}';
      }

      return text;
    } catch (e) {
      return 'Error: $e in tvShowTitleDetails for titleId ${title['id']}';
    }
  }

  Text titleBody(title) {
    try {
      return Text(
        title['overview'] == null || title['overview'].isEmpty
            ? AppLocalizations.of(context)!.missingDescription
            : title['overview'],
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      );
    } catch (e) {
      return Text('Error: $e in titleBody for titleId ${title['id']}');
    }
  }

  Row titleBottomRow(title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: providers(title),
        ),
        Row(
          children: [
            watchlistButton(title),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget providers(title) {
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

  IconButton watchlistButton(title) {
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
