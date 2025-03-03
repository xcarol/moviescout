import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/services/tmdb.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return ListenableBuilder(
      listenable: GoogleService.instance,
      builder: (BuildContext context, Widget? child) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          if (GoogleService.instance.userWatchlist.isEmpty) {
            return emptyBody();
          } else {
            return watchlistBody();
          }
        } else {
          return const SizedBox
              .shrink(); // Draw nothing if not currently visible
        }
      },
    );
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
    return FutureBuilder(
      future: TmdbService().getTitlesDetails(
          GoogleService.instance.userWatchlist,
          Localizations.localeOf(context)),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleList(titles: snapshot.data!),
            ],
          );
        }
      },
    );
  }

  searchTitle() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  }
}
