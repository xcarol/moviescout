import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        return body();
      },
    );
  }

  Widget body() {
    return Consumer<TmdbWatchlistService>(
      builder: (context, watchlistService, child) {
        if (watchlistService.titles.isEmpty) {
          return emptyBody();
        } else {
          return watchlistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.messageEmptyList,
          ),
          Text(
            AppLocalizations.of(context)!.messageEmptyList2,
          ),
          Text(
            AppLocalizations.of(context)!.messageEmptyList3,
          ),
        ],
      ),
    );
  }

  Widget watchlistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(
          titles:
              Provider.of<TmdbWatchlistService>(context, listen: false).titles,
          listProvider:
              Provider.of<TmdbWatchlistService>(context, listen: false),
        ),
      ],
    );
  }
}
