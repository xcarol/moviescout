import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/screens/search.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/services/google.dart';

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
            onPressed: searchMovie,
            tooltip: AppLocalizations.of(context)!.search,
          ),
        ],
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
        onPressed: loquin,
        tooltip: 'Fot-li!',
        child: const Icon(Icons.add),
      ),
    );
  }

  searchMovie() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  }

  loquin() async {
    User? user = await signInWithGoogle();
    if (user != null) {
      print("Sessió iniciada amb: ${user.displayName}");
    } else {
      print("Error en iniciar sessió.");
    }
  }
}
