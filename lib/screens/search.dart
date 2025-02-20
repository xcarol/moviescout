import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/services/tmdb.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  late List searchTitles = List.empty();

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
    return TitleList(titles: searchTitles);
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
