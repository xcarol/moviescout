import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/discoverlist_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class DiscoverList extends StatefulWidget {
  final bool isActive;
  const DiscoverList({super.key, required this.isActive});

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
    _removeListeners();
    _discoverlistService.setRefreshPaused(false);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DiscoverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _discoverlistService.setRefreshPaused(widget.isActive);

      if (!widget.isActive) {
        if (_discoverlistService.retrievePending) {
          _discoverlistService.clearPendingFlags();
          _updateDiscoverList(forceUpdate: true);
        } else if (_discoverlistService.refreshPending) {
          _discoverlistService.clearPendingFlags();
          _discoverlistService.refresh();
        }
      }
    }
  }

  void _addListeners() {
    _watchlistService.isLoading.addListener(_onWatchlistLoading);
    _rateslistService.isLoading.addListener(_onRateslistLoading);
  }

  void _removeListeners() {
    _watchlistService.isLoading.removeListener(_onWatchlistLoading);
    _rateslistService.isLoading.removeListener(_onRateslistLoading);
  }

  Future<void> _loadData() async {
    _discoverlistService =
        Provider.of<TmdbDiscoverlistService>(context, listen: false);
    _watchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    _rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);

    _removeListeners();
    _addListeners();
    _discoverlistService.setRefreshPaused(widget.isActive);

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
        return RefreshIndicator(
          onRefresh: () async {
            _updateDiscoverList(forceUpdate: true);
            while (_discoverlistService.isLoading.value) {
              await Future.delayed(const Duration(milliseconds: 100));
            }
          },
          child: isEmpty ? emptyBody() : discoverlistBody(),
        );
      },
    );
  }

  Widget emptyBody() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Center(
          child: Text(AppLocalizations.of(context)!.emptyList,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget discoverlistBody() {
    return Column(
      children: <Widget>[_discoverlistWidget],
    );
  }
}
