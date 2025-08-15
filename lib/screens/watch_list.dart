import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late Future<void> _init;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    await userService.setup();

    if (mounted) {
      final watchlistService =
          Provider.of<TmdbWatchlistService>(context, listen: false);

      await watchlistService.retrieveWatchlist(
        userService.accountId,
        userService.sessionId,
        Localizations.localeOf(context),
      );
    }
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
    return Consumer<TmdbWatchlistService>(
      builder: (context, watchlistService, child) {
        if (watchlistService.isEmpty) {
          return emptyBody();
        } else {
          return watchlistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    List<Widget> children = [];

    if (Provider.of<TmdbUserService>(context, listen: false).isUserLoggedIn) {
      if (Provider.of<TmdbWatchlistService>(context, listen: false).isLoading) {
        children.add(const CircularProgressIndicator());
      } else {
        children.add(
          Text(
            AppLocalizations.of(context)!.messageEmptyList,
            textAlign: TextAlign.center,
          ),
        );
      }
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(Provider.of<TmdbWatchlistService>(context, listen: false)),
      ],
    );
  }
}
