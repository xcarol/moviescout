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

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    await userService.setup();

    if (mounted) {
      final discoverlistService =
          Provider.of<TmdbDiscoverlistService>(context, listen: false);

      await discoverlistService.retrieveDiscoverlist(
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
    return Consumer<TmdbDiscoverlistService>(
      builder: (context, discoverlistService, child) {
        if (discoverlistService.listIsEmpty) {
          return emptyBody();
        } else {
          return discoverlistBody();
        }
      },
    );
  }

  Widget emptyBody() {
    List<Widget> children = [];

    if (Provider.of<TmdbUserService>(context, listen: false).isUserLoggedIn &&
        Provider.of<TmdbDiscoverlistService>(context, listen: false).isLoading) {
      children.add(const CircularProgressIndicator());
    } else {
      children.add(Text(AppLocalizations.of(context)!.emptyDiscover,
          textAlign: TextAlign.center));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget discoverlistBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleList(Provider.of<TmdbDiscoverlistService>(context, listen: false)),
      ],
    );
  }
}
