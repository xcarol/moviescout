import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.appTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: searchTitle,
            tooltip: AppLocalizations.of(context)!.search,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.messageEmptyList,
                ),
                Text(
                  AppLocalizations.of(context)!.messageEmptyList2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  searchTitle() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  }
}
