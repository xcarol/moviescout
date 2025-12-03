import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/discoverlist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
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
  late Widget _discoverlistWidget;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);

    _discoverlistService =
        Provider.of<TmdbDiscoverlistService>(context, listen: false);
    _discoverlistWidget = TitleList(
      _discoverlistService,
      key: ValueKey('discoverlist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _discoverlistService.retrieveDiscoverlist(
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
