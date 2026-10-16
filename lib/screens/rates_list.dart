import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/widgets/lists/item_list.dart';
import 'package:moviescout/widgets/layout/custom_refresh_builder.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:provider/provider.dart';

class RatesList extends StatefulWidget {
  const RatesList({super.key});

  @override
  State<RatesList> createState() => _RatesListState();
}

class _RatesListState extends State<RatesList> {
  late Future<void> _init;
  late RateslistService _rateslistService;
  late Widget _rateslistWidget;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    _rateslistService = Provider.of<RateslistService>(context, listen: false);
    _rateslistWidget = ItemList(
      _rateslistService,
      key: ValueKey('rateslist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rateslistService.syncFromServer(
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
    final rateslistService =
        Provider.of<RateslistService>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: rateslistService.isLoading,
      builder: (context, isLoading, child) {
        return Selector<RateslistService, bool>(
          selector: (_, service) => service.listIsEmpty && !isLoading,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, isEmpty, child) {
            if (isEmpty) {
              return emptyBody();
            } else {
              return rateslistBody();
            }
          },
        );
      },
    );
  }

  Widget emptyBody() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        await _rateslistService.syncFromServer(
          locale: Localizations.localeOf(context),
          forceUpdate: true,
        );
        if (!_rateslistService.hasLoadedItems) {
          await _rateslistService.filterItems();
        }
      },
      builder: customRefreshBuilder,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.emptyRates,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rateslistBody() {
    return _rateslistWidget;
  }
}
