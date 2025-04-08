import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/bottom_bar.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class RatesList extends StatefulWidget {
  const RatesList({super.key});

  @override
  State<RatesList> createState() => _RatesListState();
}

class _RatesListState extends State<RatesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Provider.of<TmdbUserService>(context, listen: false)
              .setup()
              .then((_) {
            if (context.mounted) {
              return Provider.of<TmdbRateslistService>(context, listen: false)
                  .retrieveRateslist(
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
            bottomNavigationBar:
                BottomBar(currentIndex: BottomBarIndex.indexRateslist),
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
          return rateslistBody();
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
              AppLocalizations.of(context)!.emptyRates,
            ),
          ],
        ),
      ],
    );
  }

  Widget rateslistBody() {
    return FutureBuilder(
      future: TmdbTitleService().getTitlesDetails(
          Provider.of<TmdbRateslistService>(context, listen: false).rateslist),
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
