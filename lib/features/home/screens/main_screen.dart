import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import "package:moviescout/features/auth/services/supabase_auth_service.dart";
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/features/discovery/services/discover_promotion_manager.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/features/discovery/screens/discover_list.dart';
import 'package:moviescout/features/watchlist/screens/following_list.dart';
import 'package:moviescout/features/watchlist/screens/rates_list.dart';
import 'package:moviescout/features/auth/screens/user_search_delegate.dart';
import 'package:moviescout/features/watchlist/screens/watch_list.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/core/widgets/app_drawer.dart';
import 'package:moviescout/core/widgets/double_back_exit_wrapper.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/features/discovery/screens/search.dart';

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

    SupabaseAuthService authService =
        Provider.of<SupabaseAuthService>(context, listen: true);
    final appSettings = Provider.of<AppService>(context, listen: true);

    bool isLoggedIn = authService.isLoggedIn;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen =
            constraints.maxWidth > AppBreakpoints.largeScreenMinWidth;

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
            appBar: _buildAppBar(
              context,
              activeTabs[_currentIndex],
              authService,
              customColors,
            ),
            drawer: const AppDrawer(),
            body: _buildBody(isLargeScreen, activeTabs, customColors),
            bottomNavigationBar: isLargeScreen
                ? null
                : _buildBottomNavigationBar(activeTabs, customColors),
          ),
        );
      },
    );
  }

  void _onTabSelected(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
    final activeTabs = _getActiveTabs(
        Provider.of<AppService>(context, listen: false).showCommunityTab);
    if (newIndex < activeTabs.length &&
        activeTabs[newIndex] == _NavTab.discover) {
      _clearDiscoverBadge();
    }
  }

  AppBar _buildAppBar(
    BuildContext context,
    _NavTab currentTab,
    SupabaseAuthService authService,
    CustomColors customColors,
  ) {
    return AppBar(
      iconTheme: IconThemeData(color: customColors.appBarText),
      title: Text(
        _getTitleForTab(currentTab, context),
        style: TextStyle(color: customColors.appBarText),
      ),
      backgroundColor: customColors.appBarBackground,
      actions: [
        if (currentTab == _NavTab.following &&
            authService.isLoggedIn &&
            authService.isPublicProfile)
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context)!.searchUsers,
            onPressed: () {
              final followingService =
                  Provider.of<UserFollowingService>(context, listen: false);
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
    );
  }

  Widget _buildBody(
    bool isLargeScreen,
    List<_NavTab> activeTabs,
    CustomColors customColors,
  ) {
    final indexedStack = _buildIndexedStack(activeTabs);
    if (isLargeScreen) {
      return Row(
        children: [
          _buildNavigationRail(activeTabs, customColors),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: indexedStack),
        ],
      );
    }
    return Column(
      children: [
        Expanded(child: indexedStack),
      ],
    );
  }

  Widget _buildNavigationRail(
    List<_NavTab> activeTabs,
    CustomColors customColors,
  ) {
    return NavigationRail(
      backgroundColor: customColors.bottomNavigationBarBackground,
      selectedIndex: _currentIndex,
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      indicatorColor: customColors.navigationBarSelected.withValues(alpha: 0.2),
      selectedIconTheme: IconThemeData(
        color: customColors.navigationBarSelected,
      ),
      unselectedIconTheme: IconThemeData(
        color: customColors.navigationBarNotSelected,
      ),
      selectedLabelTextStyle: TextStyle(
        color: customColors.navigationBarSelected,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: customColors.navigationBarNotSelected,
        fontSize: 12,
      ),
      onDestinationSelected: _onTabSelected,
      destinations: activeTabs
          .map((tab) => _buildRailDestination(tab, context, customColors))
          .toList(),
    );
  }

  Widget _buildIndexedStack(List<_NavTab> activeTabs) {
    return IndexedStack(
      index: _currentIndex,
      children: activeTabs.map((tab) {
        switch (tab) {
          case _NavTab.watchlist:
            return WatchList(
              onExploreDiscover: () {
                final discoverIndex = activeTabs.indexOf(_NavTab.discover);
                if (discoverIndex >= 0) {
                  _onTabSelected(discoverIndex);
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
  }

  BottomNavigationBar _buildBottomNavigationBar(
    List<_NavTab> activeTabs,
    CustomColors customColors,
  ) {
    return BottomNavigationBar(
      selectedItemColor: customColors.navigationBarSelected,
      unselectedItemColor: customColors.navigationBarNotSelected,
      currentIndex: _currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onTabSelected,
      items: activeTabs
          .map((tab) => _buildBottomNavItem(tab, context, customColors))
          .toList(),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    _NavTab tab,
    BuildContext context,
    CustomColors customColors,
  ) {
    final title = _getTitleForTab(tab, context);
    switch (tab) {
      case _NavTab.watchlist:
        return BottomNavigationBarItem(
          icon: const Icon(Icons.remove_red_eye),
          label: '',
          tooltip: title,
          backgroundColor: customColors.bottomNavigationBarBackground,
        );
      case _NavTab.rateslist:
        return BottomNavigationBarItem(
          icon: const Icon(Icons.rate_review),
          label: '',
          tooltip: title,
          backgroundColor: customColors.bottomNavigationBarBackground,
        );
      case _NavTab.discover:
        return BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: _showDiscoverBadge,
            backgroundColor: customColors.badgeColor,
            smallSize: 8,
            child: const Icon(Symbols.wand_stars),
          ),
          label: '',
          tooltip: title,
          backgroundColor: customColors.bottomNavigationBarBackground,
        );
      case _NavTab.following:
        return BottomNavigationBarItem(
          icon: const Icon(Icons.people_alt_outlined),
          label: '',
          tooltip: title,
          backgroundColor: customColors.bottomNavigationBarBackground,
        );
      case _NavTab.search:
        return BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: '',
          tooltip: title,
          backgroundColor: customColors.bottomNavigationBarBackground,
        );
    }
  }

  NavigationRailDestination _buildRailDestination(
    _NavTab tab,
    BuildContext context,
    CustomColors customColors,
  ) {
    final title = _getTitleForTab(tab, context);
    switch (tab) {
      case _NavTab.watchlist:
        return NavigationRailDestination(
          icon: const Icon(Icons.remove_red_eye),
          label: Text(title),
        );
      case _NavTab.rateslist:
        return NavigationRailDestination(
          icon: const Icon(Icons.rate_review),
          label: Text(title),
        );
      case _NavTab.discover:
        return NavigationRailDestination(
          icon: Badge(
            isLabelVisible: _showDiscoverBadge,
            backgroundColor: customColors.badgeColor,
            smallSize: 8,
            child: const Icon(Symbols.wand_stars),
          ),
          label: Text(title),
        );
      case _NavTab.following:
        return NavigationRailDestination(
          icon: const Icon(Icons.people_alt_outlined),
          label: Text(title),
        );
      case _NavTab.search:
        return NavigationRailDestination(
          icon: const Icon(Icons.search),
          label: Text(title),
        );
    }
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
