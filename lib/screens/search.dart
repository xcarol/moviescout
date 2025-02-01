import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/services/tmdb.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  late List titles = List.empty();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
      titles = List.empty();
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
          searchTitle(title);
        },
      ),
    );
  }

  searchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return cardBuilder(titles[index]);
        },
      ),
    );
  }

  cardBuilder(index) {
    return Card(
      child: ListTile(
        leading: index['poster_path'] != '' && index['poster_path'] != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w500${index['poster_path']}',
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.movie_creation),
        title: Text(index['title'] ?? ''),
        subtitle: Text(index['overview'] ?? ''),
      ),
    );
  }

  searchTitle(title) async {
    final result =
        await TmdbService().searchTitle(title, Localizations.localeOf(context));
    setState(() {
      titles = result;
    });
  }
}
