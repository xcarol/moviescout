import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class SeasonDetails extends StatefulWidget {
  final int tmdbId;
  final int seasonNumber;

  const SeasonDetails({
    super.key,
    required this.tmdbId,
    required this.seasonNumber,
  });

  @override
  State<SeasonDetails> createState() => _SeasonDetailsState();
}

class _SeasonDetailsState extends State<SeasonDetails> {
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: Obtenir les dades de la temporada quan s'implementi el service
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = '${AppLocalizations.of(context)?.season ?? 'Temporada'} ${widget.seasonNumber}';

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: appTitle,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Pròximament: Fitxa de la temporada ${widget.seasonNumber} per al títol ${widget.tmdbId}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
    );
  }
}
