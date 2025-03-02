import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/services/snack_bar.dart';

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
    return Card(
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
    );
  }

  Widget titlePoster(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return SizedBox(
        width: 110,
        height: 150,
        child: SvgPicture.asset(
          'lib/assets/movie.svg',
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
            'lib/assets/movie.svg',
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
          titleBody(title),
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
    String text = title['name'] ?? '';
    String firstAirDate = title['first_air_date'] ?? '';
    String nextEpisodeToAir = title['next_episode_to_air'] ?? '';
    String lastAirDate = title['last_air_date'] ?? '';

    text += firstAirDate.isNotEmpty ? ' - ${firstAirDate.substring(0, 4)}' : '';

    if (nextEpisodeToAir.isNotEmpty) {
      text += ' - ...';
    } else if (lastAirDate.isNotEmpty) {
      text += ' - ${lastAirDate.substring(0, 4)}';
    }

    return text;
  }

  Text titleBody(title) {
    return Text(
      title['overview'] == null || title['overview'].isEmpty
          ? AppLocalizations.of(context)!.missingDescription
          : title['overview'],
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Row titleBottomRow(title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: providers(title),
        ),
        Row(
          children: [
            watchlistText(title),
            const SizedBox(width: 8),
            watchlistButton(title),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget providers(title) {
    if (title['providers'] == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: (title['providers']['flatrate'] as List?)
              ?.map<Widget>((provider) => providerLogo(provider))
              .toList() ??
          [],
    );
  }

  Widget providerLogo(provider) {
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
              'lib/assets/movie.svg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Text watchlistText(title) {
    final bool isInWatchlist =
        GoogleService.instance.userWatchlist.any((t) => t['id'] == title['id']);
    return Text(
      isInWatchlist
          ? AppLocalizations.of(context)!.removeFromWatchlist
          : AppLocalizations.of(context)!.addToWatchlist,
    );
  }

  IconButton watchlistButton(title) {
    if (GoogleService.instance.currentUser == null) {
      return IconButton(
        icon: const Icon(Icons.highlight_off),
        onPressed: () {
          SnackMessage.showSnackBar(
              context, AppLocalizations.of(context)!.signInToWatchlist);
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
