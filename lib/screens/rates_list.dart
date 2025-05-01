import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/bottom_bar.dart';
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
    await rateslistService.retrieveRates(userService.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Consumer<TmdbRateslistService>(
          builder: (context, rateslistService, _) {
            return Scaffold(
              appBar: MainAppBar(
                context: context,
                title: AppLocalizations.of(context)!.rateslistTitle,
              ),
              drawer: AppDrawer(),
              body: Center(child: body()),
              bottomNavigationBar:
                  BottomBar(currentIndex: BottomBarIndex.indexRateslist),
            );
          },
        );
      },
    );
  }

  Widget body() {
    return Consumer<TmdbRateslistService>(
      builder: (context, rateslistService, child) {
        if (rateslistService.titles.isEmpty) {
          return emptyBody();
        } else {
          return rateslistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.emptyRates,
            ),
          ],
        ),
      ],
    );
  }

  Widget rateslistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(
          titles:
              Provider.of<TmdbRateslistService>(context, listen: false).titles,
          listProvider:
              Provider.of<TmdbRateslistService>(context, listen: false),
        ),
      ],
    );
  }
}
