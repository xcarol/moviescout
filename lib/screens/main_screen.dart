import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/screens/discover_list.dart';
import 'package:moviescout/screens/rates_list.dart';
import 'package:moviescout/screens/watch_list.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'search.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: true);

    if (userService.isUserLoggedIn == true) {
      _currentIndex = 0;
    } else {
      _currentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).extension<CustomColors>()!.appBarText,
          ),
          title: Text(
            _getTitleForIndex(_currentIndex, context),
            style: TextStyle(
              color: Theme.of(context).extension<CustomColors>()!.appBarText,
            ),
          ),
          backgroundColor:
              Theme.of(context).extension<CustomColors>()!.appBarBackground,
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                WatchList(),
                RatesList(),
                DiscoverList(isActive: _currentIndex == 2),
                Search(),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context)
              .extension<CustomColors>()!
              .navigationBarSelected,
          unselectedItemColor: Theme.of(context)
              .extension<CustomColors>()!
              .navigationBarNotSelected,
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye),
              label: '',
              tooltip: AppLocalizations.of(context)!.watchlistTitle,
              backgroundColor: Theme.of(context)
                  .extension<CustomColors>()!
                  .bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: '',
              tooltip: AppLocalizations.of(context)!.rateslistTitle,
              backgroundColor: Theme.of(context)
                  .extension<CustomColors>()!
                  .bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.wand_stars),
              label: '',
              tooltip: AppLocalizations.of(context)!.discoverlistTitle,
              backgroundColor: Theme.of(context)
                  .extension<CustomColors>()!
                  .bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              tooltip: AppLocalizations.of(context)!.search,
              backgroundColor: Theme.of(context)
                  .extension<CustomColors>()!
                  .bottomNavigationBarBackground,
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleForIndex(int index, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return l10n.watchlistTitle;
      case 1:
        return l10n.rateslistTitle;
      case 2:
        return l10n.discoverlistTitle;
      case 3:
        return l10n.search;
      default:
        return '';
    }
  }
}
