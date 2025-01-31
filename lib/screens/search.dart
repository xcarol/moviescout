import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/widgets/app_bar.dart';
import 'package:moviescout/services/tmdb.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  late String _searchText;

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
          SizedBox(
            width: 300,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchTitle,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: searchTitle,
                  tooltip: AppLocalizations.of(context)!.search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => _searchText = value,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: back,
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Search',
            ),
          ],
        ),
      ),
    );
  }

  back() async {
    Navigator.pop(context);
  }

  searchTitle() async {
    final Movies = await TmdbService()
        .searchMovie(_searchText, Localizations.localeOf(context));
    print(Movies);
  }
}
