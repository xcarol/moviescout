import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/screens/discover_list.dart';
import 'package:moviescout/screens/rates_list.dart';
import 'package:moviescout/screens/watch_list.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
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
        appBar: MainAppBar(
          context: context,
          title: _getTitleForIndex(_currentIndex, context),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                WatchList(),
                RatesList(),
                DiscoverList(),
                Search(),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).extension<CustomColors>()!.selected,
          unselectedItemColor:
              Theme.of(context).extension<CustomColors>()!.notSelected,
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
              icon: Icon(Icons.remove_red_eye_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.wand_stars),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
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
