import 'package:flutter/material.dart';
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
  late List favoriteTitles = List.empty();

  @override
  void initState() async {
    super.initState();
    _controller = TextEditingController();
    favoriteTitles = await GoogleService.instance.readFavoriteTitles(context);
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

  cardBuilder(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 150,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${index['poster_path']}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(index['title'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(index['overview'] ?? '',
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      favoriteButton(index['id']),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isFavoriteTitle(BuildContext context, titleId) async {
    return GoogleService.instance.isFavoriteTitle(context, titleId);
  }

  FutureBuilder<bool> favoriteButton(titleId) {
    return FutureBuilder<bool>(
      future: isFavoriteTitle(context, titleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (GoogleService.instance.currentUser == null) {
            return IconButton(
              icon: const Icon(Icons.highlight_off),
              onPressed: () {
                SnackMessage.showSnackBar(
                    context, AppLocalizations.of(context)!.signInToFavorite);
              },
            );
          }
          return IconButton(
            icon: Icon(snapshot.data! ? Icons.cancel : Icons.add_circle),
            onPressed: () {
              GoogleService.instance
                  .updateFavoriteTitle(context, titleId, !snapshot.data!);
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
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
