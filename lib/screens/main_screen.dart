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

  bool? _wasLoggedIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: true);

    if (_wasLoggedIn != userService.isUserLoggedIn) {
      _wasLoggedIn = userService.isUserLoggedIn;
      if (userService.isUserLoggedIn) {
        _currentIndex = 0;
      } else {
        _currentIndex = 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

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
          iconTheme: IconThemeData(color: customColors.appBarText),
          title: Text(
            _getTitleForIndex(_currentIndex, context),
            style: TextStyle(color: customColors.appBarText),
          ),
          backgroundColor: customColors.appBarBackground,
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
          selectedItemColor: customColors.navigationBarSelected,
          unselectedItemColor: customColors.navigationBarNotSelected,
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
              backgroundColor: customColors.bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: '',
              tooltip: AppLocalizations.of(context)!.rateslistTitle,
              backgroundColor: customColors.bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.wand_stars),
              label: '',
              tooltip: AppLocalizations.of(context)!.discoverlistTitle,
              backgroundColor: customColors.bottomNavigationBarBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              tooltip: AppLocalizations.of(context)!.search,
              backgroundColor: customColors.bottomNavigationBarBackground,
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
