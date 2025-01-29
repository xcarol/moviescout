import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/tmdb.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.messageEmptyList,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchMovie,
        tooltip: 'Fot-li!',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  searchMovie() async {
    final Movies = await TmdbService().searchMovie('club lucha', Localizations.localeOf(context));
    print(Movies);
  }
}
