import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:moviescout/services/settings/app_settings_service.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/screens/discover_list.dart';
import 'package:moviescout/screens/following_list.dart';
import 'package:moviescout/screens/rates_list.dart';
import 'package:moviescout/screens/watch_list.dart';
import 'package:moviescout/widgets/layout/app_drawer.dart';
import 'package:moviescout/widgets/misc/double_back_exit_wrapper.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'search.dart';

enum _NavTab {
  watchlist,
  rateslist,
  discover,
  following,
  search,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  bool? _wasLoggedIn;

  List<_NavTab> _getActiveTabs(bool showCommunity) {
    return [
      _NavTab.watchlist,
      _NavTab.rateslist,
      _NavTab.discover,
      if (showCommunity) _NavTab.following,
      _NavTab.search,
    ];
  }

  int _getDefaultIndex(List<_NavTab> activeTabs) {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final target =
        authService.isLoggedIn ? _NavTab.watchlist : _NavTab.discover;
    final index = activeTabs.indexOf(target);
    return index >= 0 ? index : 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SupabaseAuthService authService =
        Provider.of<SupabaseAuthService>(context, listen: true);
    final appSettings = Provider.of<AppSettingsService>(context, listen: true);

    bool isLoggedIn = authService.isLoggedIn;
    final activeTabs = _getActiveTabs(appSettings.showCommunityTab);

    if (_wasLoggedIn != isLoggedIn) {
      _wasLoggedIn = isLoggedIn;
      _currentIndex = _getDefaultIndex(activeTabs);
    } else if (_currentIndex >= activeTabs.length) {
      _currentIndex = activeTabs.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final appSettings = Provider.of<AppSettingsService>(context);
    final activeTabs = _getActiveTabs(appSettings.showCommunityTab);

    if (_currentIndex >= activeTabs.length) {
      _currentIndex = activeTabs.length - 1;
    }

    final defaultIndex = _getDefaultIndex(activeTabs);

    return DoubleBackExitWrapper(
      onPopHandled: () {
        if (_currentIndex != defaultIndex) {
          setState(() {
            _currentIndex = defaultIndex;
          });
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: customColors.appBarText),
          title: Text(
            _getTitleForTab(activeTabs[_currentIndex], context),
            style: TextStyle(color: customColors.appBarText),
          ),
          backgroundColor: customColors.appBarBackground,
        ),
        drawer: const AppDrawer(),
        body: Column(children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: activeTabs.map((tab) {
                switch (tab) {
                  case _NavTab.watchlist:
                    return const WatchList();
                  case _NavTab.rateslist:
                    return const RatesList();
                  case _NavTab.discover:
                    return DiscoverList(
                      isActive: activeTabs[_currentIndex] == _NavTab.discover,
                    );
                  case _NavTab.following:
                    return const FollowingList();
                  case _NavTab.search:
                    return const Search();
                }
              }).toList(),
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
          items: activeTabs.map((tab) {
            switch (tab) {
              case _NavTab.watchlist:
                return BottomNavigationBarItem(
                  icon: const Icon(Icons.remove_red_eye),
                  label: '',
                  tooltip: AppLocalizations.of(context)!.watchlistTitle,
                  backgroundColor: customColors.bottomNavigationBarBackground,
                );
              case _NavTab.rateslist:
                return BottomNavigationBarItem(
                  icon: const Icon(Icons.rate_review),
                  label: '',
                  tooltip: AppLocalizations.of(context)!.rateslistTitle,
                  backgroundColor: customColors.bottomNavigationBarBackground,
                );
              case _NavTab.discover:
                return BottomNavigationBarItem(
                  icon: const Icon(Symbols.wand_stars),
                  label: '',
                  tooltip: AppLocalizations.of(context)!.discoverlistTitle,
                  backgroundColor: customColors.bottomNavigationBarBackground,
                );
              case _NavTab.following:
                return BottomNavigationBarItem(
                  icon: const Icon(Icons.people_alt_outlined),
                  label: '',
                  tooltip: AppLocalizations.of(context)!.followingTab,
                  backgroundColor: customColors.bottomNavigationBarBackground,
                );
              case _NavTab.search:
                return BottomNavigationBarItem(
                  icon: const Icon(Icons.search),
                  label: '',
                  tooltip: AppLocalizations.of(context)!.search,
                  backgroundColor: customColors.bottomNavigationBarBackground,
                );
            }
          }).toList(),
        ),
      ),
    );
  }

  String _getTitleForTab(_NavTab tab, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (tab) {
      case _NavTab.watchlist:
        return l10n.watchlistTitle;
      case _NavTab.rateslist:
        return l10n.rateslistTitle;
      case _NavTab.discover:
        return l10n.discoverlistTitle;
      case _NavTab.following:
        return l10n.followingTab;
      case _NavTab.search:
        return l10n.search;
    }
  }
}
