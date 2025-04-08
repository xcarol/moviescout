import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Provider.of<TmdbUserService>(context, listen: false)
              .setup()
              .then((_) {
            if (context.mounted) {
              return Provider.of<TmdbWatchlistService>(context, listen: false)
                  .retrieveWatchlist(
                      Provider.of<TmdbUserService>(context, listen: false)
                          .accountId);
            } else {
              return null;
            }
          }),
        ]),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Scaffold();
          }
          return Scaffold(
            appBar: MainAppBar(
              context: context,
              title: AppLocalizations.of(context)!.appTitle,
            ),
            drawer: AppDrawer(),
            body: Center(child: body()),
          );
        });
  }

  Widget body() {
    return ListenableBuilder(
      listenable: Provider.of<TmdbWatchlistService>(context, listen: false),
      builder: (BuildContext context, Widget? child) {
        if (Provider.of<TmdbWatchlistService>(context, listen: false)
            .watchlist
            .isEmpty) {
          return emptyBody();
        } else {
          return watchlistBody();
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
      future: TmdbTitleService().getTitlesDetails(
          Provider.of<TmdbWatchlistService>(context, listen: false).watchlist),
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
