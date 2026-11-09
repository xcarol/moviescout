import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_drawer.dart';
import 'package:moviescout/core/widgets/double_back_exit_wrapper.dart';
import 'package:moviescout/features/auth/screens/user_search_delegate.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/discovery/screens/discover_list.dart';
import 'package:moviescout/features/discovery/screens/search.dart';
import 'package:moviescout/features/discovery/services/discover_promotion_manager.dart';
import 'package:moviescout/features/watchlist/screens/following_list.dart';
import 'package:moviescout/features/watchlist/screens/rates_list.dart';
import 'package:moviescout/features/watchlist/screens/watch_list.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  bool _showDiscoverBadge = false;

  bool? _wasLoggedIn;

  @override
  void initState() {
    super.initState();
    _showDiscoverBadge = DiscoverPromotionManager.shouldShowTabBadge;
  }

  void _clearDiscoverBadge() {
    if (_showDiscoverBadge) {
      setState(() {
        _showDiscoverBadge = false;
      });
    }
    DiscoverPromotionManager.markDiscoverTabVisited();
  }

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

    final authService = Provider.of<SupabaseAuthService>(context, listen: true);
    final appSettings = Provider.of<AppService>(context, listen: true);

    final isLoggedIn = authService.isLoggedIn;
    final activeTabs = _getActiveTabs(appSettings.showCommunityTab);

    if (_wasLoggedIn != isLoggedIn) {
      _wasLoggedIn = isLoggedIn;
      _currentIndex = _getDefaultIndex(activeTabs);
    } else if (_currentIndex >= activeTabs.length) {
      _currentIndex = activeTabs.length - 1;
    }

    if (activeTabs[_currentIndex] == _NavTab.discover) {
      _clearDiscoverBadge();
    }
  }

  void _onDestinationSelected(int newIndex, List<_NavTab> activeTabs) {
    setState(() {
      _currentIndex = newIndex;
    });
    if (activeTabs[newIndex] == _NavTab.discover) {
      _clearDiscoverBadge();
    }
  }

  Widget _getIconForTab(_NavTab tab, CustomColors customColors) {
    switch (tab) {
      case _NavTab.watchlist:
        return const Icon(Icons.remove_red_eye);
      case _NavTab.rateslist:
        return const Icon(Icons.rate_review);
      case _NavTab.discover:
        return Badge(
          isLabelVisible: _showDiscoverBadge,
          backgroundColor: customColors.badgeColor,
          smallSize: AppSizes.badgeDotSize,
          child: const Icon(Symbols.wand_stars),
        );
      case _NavTab.following:
        return const Icon(Icons.people_alt_outlined);
      case _NavTab.search:
        return const Icon(Icons.search);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final appSettings = Provider.of<AppService>(context);
    final authService = Provider.of<SupabaseAuthService>(context);
    final activeTabs = _getActiveTabs(appSettings.showCommunityTab);

    if (_currentIndex >= activeTabs.length) {
      _currentIndex = activeTabs.length - 1;
    }

    final defaultIndex = _getDefaultIndex(activeTabs);

    final tabContent = IndexedStack(
      index: _currentIndex,
      children: activeTabs.map((tab) {
        switch (tab) {
          case _NavTab.watchlist:
            return WatchList(
              onExploreDiscover: () {
                final discoverIndex = activeTabs.indexOf(_NavTab.discover);
                if (discoverIndex >= 0) {
                  setState(() {
                    _currentIndex = discoverIndex;
                  });
                  _clearDiscoverBadge();
                }
              },
            );
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
    );

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= AppBreakpoints.compact;
          final isExpandedRail = constraints.maxWidth >= AppBreakpoints.medium;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                _getTitleForTab(activeTabs[_currentIndex], context),
              ),
              actions: [
                if (activeTabs[_currentIndex] == _NavTab.following &&
                    authService.isLoggedIn &&
                    authService.isPublicProfile)
                  IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: AppLocalizations.of(context)!.searchUsers,
                    onPressed: () {
                      final followingService =
                          Provider.of<UserFollowingService>(context,
                              listen: false);
                      final loc = AppLocalizations.of(context)!;
                      showSearch(
                        context: context,
                        delegate: UserSearchDelegate(
                          followingService,
                          searchFieldLabel: loc.searchUsersPlaceholder,
                        ),
                      );
                    },
                  ),
              ],
            ),
            drawer: const AppDrawer(),
            body: isWide
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (newIndex) =>
                            _onDestinationSelected(newIndex, activeTabs),
                        labelType: isExpandedRail
                            ? NavigationRailLabelType.all
                            : NavigationRailLabelType.selected,
                        destinations: activeTabs.map((tab) {
                          final label = _getTitleForTab(tab, context);
                          return NavigationRailDestination(
                            icon: _getIconForTab(tab, customColors),
                            label: Text(label),
                          );
                        }).toList(),
                      ),
                      VerticalDivider(
                        width: AppSizes.borderWidthRegular,
                        thickness: AppSizes.borderWidthRegular,
                        color: customColors.dividerColor,
                      ),
                      Expanded(child: tabContent),
                    ],
                  )
                : tabContent,
            bottomNavigationBar: isWide
                ? null
                : BottomNavigationBar(
                    currentIndex: _currentIndex,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    onTap: (newIndex) =>
                        _onDestinationSelected(newIndex, activeTabs),
                    items: activeTabs.map((tab) {
                      return BottomNavigationBarItem(
                        icon: _getIconForTab(tab, customColors),
                        label: '',
                        tooltip: _getTitleForTab(tab, context),
                        backgroundColor:
                            customColors.bottomNavigationBarBackground,
                      );
                    }).toList(),
                  ),
          );
        },
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
        return l10n.searchTitle;
    }
  }
}
