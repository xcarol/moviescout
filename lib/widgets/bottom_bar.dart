import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/rates_list.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/screens/watch_list.dart';

enum BottomBarIndex {
  indexWatchlist,
  indexRateslist,
  indexSearch,
}

class BottomBar extends StatelessWidget {
  final BottomBarIndex currentIndex;

  const BottomBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            tooltip: AppLocalizations.of(context)!.watchlistTitle,
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: currentIndex == BottomBarIndex.indexWatchlist
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != BottomBarIndex.indexWatchlist) {}
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WatchList()),
              );
            },
          ),
          IconButton(
              tooltip: AppLocalizations.of(context)!.rateslistTitle,
              icon: Icon(
                Icons.rate_review_outlined,
                color: currentIndex == BottomBarIndex.indexRateslist
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey,
              ),
              onPressed: () {
                if (currentIndex != BottomBarIndex.indexRateslist) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RatesList()),
                  );
                }
              }),
          IconButton(
              tooltip: AppLocalizations.of(context)!.searchTitle,
              icon: Icon(
                Icons.search,
                color: currentIndex == BottomBarIndex.indexSearch
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey,
              ),
              onPressed: () {
                if (currentIndex != BottomBarIndex.indexSearch) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search()),
                  );
                }
              }),
        ],
      ),
    );
  }
}
