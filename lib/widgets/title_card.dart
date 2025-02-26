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
          Text(title['title'] ?? title['name'] ?? '',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(title['overview'] ?? '',
              maxLines: 3, overflow: TextOverflow.ellipsis),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              watchlistText(title),
              const SizedBox(width: 8),
              watchlistButton(title),
              const SizedBox(width: 8),
            ],
          ),
        ],
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