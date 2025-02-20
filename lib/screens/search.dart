import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/services/tmdb.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  late List searchTitles = List.empty();
  late List<int> watchlistTitles = List.empty();
  late int updatingTitleId = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadWatchlistTitles();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.searchTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: back,
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            searchBox(),
            searchResults(),
          ],
        ),
      ),
    );
  }

  back() async {
    Navigator.pop(context);
  }

  resetTitle() {
    _controller.clear();
    setState(() {
      searchTitles = List.empty();
    });
  }

  searchBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.search,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              resetTitle();
            },
            tooltip: AppLocalizations.of(context)!.search,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (title) {
          searchTitle(context, title);
        },
      ),
    );
  }

  searchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: searchTitles.length,
        itemBuilder: (context, index) {
          return cardBuilder(searchTitles[index]);
        },
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

  Future<bool> isTitleInWatchList(BuildContext context, titleId) async {
    return GoogleService.instance.isTitleInWatchlist(context, titleId);
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

  void loadWatchlistTitles() async {
    List<int> titles =
        await GoogleService.instance.readWatchlistTitles(context);
    setState(() {
      watchlistTitles = titles;
    });
  }

  updateWatchlist() async {
    final watchlist = await GoogleService.instance.readWatchlistTitles(context);
    setState(() {
      watchlistTitles = watchlist;
    });
  }

  searchTitle(BuildContext context, title) async {
    try {
      final result = await TmdbService()
          .searchTitle(title, Localizations.localeOf(context));
      setState(() {
        searchTitles = result;
      });
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(context, error.toString());
      }
    }
  }
}
