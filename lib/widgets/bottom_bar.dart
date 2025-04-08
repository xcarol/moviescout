import 'package:flutter/material.dart';
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
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Watchlist',
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: currentIndex == BottomBarIndex.indexWatchlist
                    ? Theme.of(context).colorScheme.primary
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
                tooltip: 'Rateslist',
                icon: Icon(
                  Icons.rate_review_outlined,
                  color: currentIndex == BottomBarIndex.indexRateslist
                      ? Theme.of(context).colorScheme.primary
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
                tooltip: 'Search',
                icon: Icon(
                  Icons.search,
                  color: currentIndex == BottomBarIndex.indexSearch
                      ? Theme.of(context).colorScheme.primary
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
      ),
    );
  }
}
