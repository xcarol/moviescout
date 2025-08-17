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

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);

    await userService.setup();

    if (mounted) {
      await rateslistService.retrieveRateslist(
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
    return Consumer<TmdbRateslistService>(
      builder: (context, rateslistService, child) {
        if (rateslistService.isEmpty) {
          return emptyBody();
        } else {
          return rateslistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    List<Widget> children = [];

    if (Provider.of<TmdbUserService>(context, listen: false).isUserLoggedIn &&
        Provider.of<TmdbRateslistService>(context, listen: false).isLoading) {
      children.add(const CircularProgressIndicator());
    } else {
      children.add(Text(AppLocalizations.of(context)!.emptyRates,
          textAlign: TextAlign.center));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget rateslistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(Provider.of<TmdbRateslistService>(context, listen: false)),
      ],
    );
  }
}
