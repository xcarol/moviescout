import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/screens/discover_list.dart';
import 'package:moviescout/screens/rates_list.dart';
import 'package:moviescout/screens/watch_list.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/widgets/layout/app_drawer.dart';
import 'package:moviescout/widgets/misc/double_back_exit_wrapper.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/migration_screen.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMigrationPrompt();
    });
  }

  void _checkMigrationPrompt() {
    if (!mounted) return;

    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);

    if (userService.isUserLoggedIn && !authService.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MigrationScreen()),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: true);
    SupabaseAuthService authService =
        Provider.of<SupabaseAuthService>(context, listen: true);

    bool isLoggedIn = userService.isUserLoggedIn || authService.isLoggedIn;

    if (_wasLoggedIn != isLoggedIn) {
      _wasLoggedIn = isLoggedIn;
      if (isLoggedIn) {
        _currentIndex = 0;
      } else {
        _currentIndex = 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return DoubleBackExitWrapper(
      onPopHandled: () {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return true;
        }
        return false;
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
