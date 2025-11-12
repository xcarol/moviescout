import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class RatesList extends StatefulWidget {
  const RatesList({super.key});

  @override
  State<RatesList> createState() => _RatesListState();
}

class _RatesListState extends State<RatesList> {
  late Future<void> _init;
  late TmdbRateslistService _rateslistService;
  late Widget _rateslistWidget;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);

    _rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);
    _rateslistWidget = TitleList(
      _rateslistService,
      key: ValueKey('rateslist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rateslistService.retrieveRateslist(
        userService.accountId,
        userService.sessionId,
        Localizations.localeOf(context),
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
    return Selector<TmdbRateslistService, bool>(
      selector: (_, service) => service.listIsEmpty && !service.isLoading.value,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, isEmpty, child) {
        if (isEmpty) {
          return emptyBody();
        } else {
          return rateslistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.emptyRates,
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget rateslistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_rateslistWidget],
    );
  }
}
