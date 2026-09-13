import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/widgets/lists/item_list.dart';
import 'package:provider/provider.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late Future<void> _init;
  late WatchlistService _watchlistService;
  late Widget _watchlistWidget;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);

    _watchlistService = Provider.of<WatchlistService>(context, listen: false);
    _watchlistWidget = ItemList(
      _watchlistService,
      key: ValueKey('watchlist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchlistService.syncFromServer(
        accountId: userService.accountId,
        sessionId: userService.sessionId,
        locale: Localizations.localeOf(context),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        return body();
      },
    );
  }

  Widget body() {
    return Selector<WatchlistService, bool>(
      selector: (_, service) => service.listIsEmpty && !service.isLoading.value,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, isEmpty, child) {
        if (isEmpty) {
          return emptyBody();
        } else {
          return watchlistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    List<Widget> children = [];

    final isTmdbLoggedIn =
        Provider.of<TmdbUserService>(context, listen: false).isUserLoggedIn;
    final isGoogleLoggedIn =
        Provider.of<SupabaseAuthService>(context, listen: false).isLoggedIn;
    if (isTmdbLoggedIn || isGoogleLoggedIn) {
      children.add(
        Text(
          AppLocalizations.of(context)!.messageEmptyList,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      children.add(
        Text(
          AppLocalizations.of(context)!.messageEmptySearch,
          textAlign: TextAlign.center,
        ),
      );
      children.add(
        const SizedBox(height: 20.0),
      );
      children.add(
        Text(
          AppLocalizations.of(context)!.messageEmptyOptions,
          textAlign: TextAlign.center,
        ),
      );
      children.add(
        const SizedBox(height: 10.0),
      );
      children.add(
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: Text(AppLocalizations.of(context)!.messageEmptyTmdb),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget watchlistBody() {
    return _watchlistWidget;
  }
}
