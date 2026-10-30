import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_lists/discoverlist_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/widgets/lists/item_list.dart';
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
  late WatchlistService _watchlistService;
  late RateslistService _rateslistService;

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
    _watchlistService = Provider.of<WatchlistService>(context, listen: false);
    _rateslistService = Provider.of<RateslistService>(context, listen: false);
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    _discoverlistService
        .setEnabledProviderIds(providerService.enabledProviderIds);

    _removeListeners();
    _addListeners();
    _discoverlistService.setRefreshPaused(widget.isActive);

    _discoverlistWidget = ItemList(
      _discoverlistService,
      key: ValueKey('discoverlist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDiscoverList();
    });
  }

  void _onWatchlistLoading() {
    if (!_watchlistService.isLoading.value) {
      _updateDiscoverList();
    }
  }

  void _onRateslistLoading() {
    if (!_rateslistService.isLoading.value) {
      _updateDiscoverList();
    }
  }

  void _updateDiscoverList({bool forceUpdate = false}) async {
    if (!mounted || _discoverlistService.isLoading.value) {
      return;
    }

    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    _discoverlistService
        .setEnabledProviderIds(providerService.enabledProviderIds);

    if (!forceUpdate) {
      final titleCount = await _discoverlistService.countTitles();
      if (!mounted || titleCount > 0) {
        return;
      }
    }

    _discoverlistService.retrieveDiscoverlist(
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
    return _discoverlistWidget;
  }
}
