import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<int> watchlistTitles = List.empty();

  @override
  void initState() {
    super.initState();
    loadWatchlistTitles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.appTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: searchTitle,
            tooltip: AppLocalizations.of(context)!.search,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(child: homeBody()),
    );
  }

  Widget homeBody() {
    if (watchlistTitles.isEmpty) {
      return emptyBody();
    } else {
      return watchlistBody();
    }
  }

  Widget emptyBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.messageEmptyList,
            ),
            Text(
              AppLocalizations.of(context)!.messageEmptyList2,
            ),
          ],
        ),
      ],
    );
  }

  Widget watchlistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(titles: watchlistTitles),
      ],
    );
  }

  searchTitle() async {
    loadWatchlistTitles();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  }

  void loadWatchlistTitles() async {
    List<int> titles =
        await GoogleService.instance.readWatchlistTitles(context);
    setState(() {
      watchlistTitles = titles;
    });
  }
}
