import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/services/snack_bar.dart';

class TitleList extends StatefulWidget {
  final List titles;

  const TitleList({
    super.key,
    required this.titles,
  });

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  late List<int> watchlistTitles = List.empty();
  late int updatingTitleId = 0;

  @override
  void initState() {
    super.initState();
    updateWatchlist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return cardBuilder(widget.titles[index]);
        },
      ),
    );
  }

  cardBuilder(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titlePoster(index['poster_path']),
            const SizedBox(width: 10),
            titleCard(index),
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

  titleCard(index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(index['title'] ?? '',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(index['overview'] ?? '',
              maxLines: 3, overflow: TextOverflow.ellipsis),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              watchlistText(index['id']),
              const SizedBox(width: 8),
              watchlistButton(index['id']),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Text watchlistText(titleId) {
    final bool isInWatchlist = watchlistTitles.contains(titleId);
    return Text(
      isInWatchlist
          ? AppLocalizations.of(context)!.removeFromWatchlist
          : AppLocalizations.of(context)!.addToWatchlist,
    );
  }

  IconButton watchlistButton(titleId) {
    if (GoogleService.instance.currentUser == null) {
      return IconButton(
        icon: const Icon(Icons.highlight_off),
        onPressed: () {
          SnackMessage.showSnackBar(
              context, AppLocalizations.of(context)!.signInToWatchlist);
        },
      );
    }

    if (updatingTitleId == titleId) {
      return IconButton(
        icon: const Icon(Icons.hourglass_empty),
        onPressed: () {},
      );
    }

    final bool isInWatchlist = watchlistTitles.contains(titleId);
    return IconButton(
      color: isInWatchlist ? Colors.red : Colors.green,
      icon: Icon(isInWatchlist ? Icons.close_sharp : Icons.add_sharp),
      onPressed: () {
        setState(() {
          updatingTitleId = titleId;
        });
        GoogleService.instance
            .updateWatchlistTitle(context, titleId, !isInWatchlist)
            .then((value) async {
          await updateWatchlist();
          setState(() {
            updatingTitleId = 0;
          });
        });
      },
    );
  }

  updateWatchlist() async {
    final watchlist = await GoogleService.instance.readWatchlistTitles(context);
    setState(() {
      watchlistTitles = watchlist;
    });
  }
}
