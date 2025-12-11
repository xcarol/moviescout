import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/discoverlist_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class DiscoverList extends StatefulWidget {
  const DiscoverList({super.key});

  @override
  State<DiscoverList> createState() => _DiscoverListState();
}

class _DiscoverListState extends State<DiscoverList> {
  late Future<void> _init;
  late TmdbDiscoverlistService _discoverlistService;
  late TmdbWatchlistService _watchlistService;
  late TmdbRateslistService _rateslistService;
  late Widget _discoverlistWidget;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  @override
  void dispose() {
    _watchlistService.isLoading.removeListener(_onWatchlistLoading);
    _rateslistService.isLoading.removeListener(_onRateslistLoading);
    super.dispose();
  }

  Future<void> _loadData() async {
    _discoverlistService =
        Provider.of<TmdbDiscoverlistService>(context, listen: false);
    _watchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    _rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);

    _watchlistService.isLoading.addListener(_onWatchlistLoading);
    _rateslistService.isLoading.addListener(_onRateslistLoading);

    _discoverlistWidget = TitleList(
      _discoverlistService,
      key: ValueKey('discoverlist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDiscoverList();
    });
  }

  void _onWatchlistLoading() {
    if (!_watchlistService.isLoading.value) {
      _updateDiscoverList(forceUpdate: true);
    }
  }

  void _onRateslistLoading() {
    if (!_rateslistService.isLoading.value) {
      _updateDiscoverList(forceUpdate: true);
    }
  }

  void _updateDiscoverList({bool forceUpdate = false}) {
    if (!mounted) return;

    final userService = Provider.of<TmdbUserService>(context, listen: false);
    _discoverlistService.retrieveDiscoverlist(
      userService.accountId,
      userService.sessionId,
      Localizations.localeOf(context),
      forceUpdate: forceUpdate,
    );
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
    return Selector<TmdbDiscoverlistService, bool>(
      selector: (_, service) => service.listIsEmpty && !service.isLoading.value,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, isEmpty, child) {
        if (isEmpty) {
          return emptyBody();
        } else {
          return discoverlistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.emptyDiscover,
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget discoverlistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_discoverlistWidget],
    );
  }
}
