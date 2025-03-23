import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/title_list.dart';

class ImportIMDB extends StatefulWidget {
  const ImportIMDB({super.key});

  @override
  State<ImportIMDB> createState() => _ImportIMDBState();
}

class _ImportIMDBState extends State<ImportIMDB> {
  late TextEditingController _titlesController;
  late TextEditingController _notFoundTitlesController;
  late List<TmdbTitle> imdbTitles = List.empty();
  late List notFoundTitles = List.empty();
  Future<bool> isLoading = Future.value(false);

  @override
  void initState() {
    super.initState();
    _titlesController = TextEditingController();
    _notFoundTitlesController = TextEditingController();
  }

  @override
  void dispose() {
    _titlesController.dispose();
    _notFoundTitlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.imdbImport,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            importBox(),
            if (notFoundTitles.isNotEmpty) importNotFoundBox(),
            importResults(),
          ],
        ),
      ),
    );
  }

  resetText() {
    _titlesController.clear();
    setState(() {
      imdbTitles = List.empty();
      notFoundTitles = List.empty();
      isLoading = Future.value(false);
    });
  }

  importBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        minLines: 3,
        maxLines: 3,
        controller: _titlesController,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.imdbImportHint,
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  importTitles(context, _titlesController.text);
                },
                tooltip: AppLocalizations.of(context)!.imdbImportHint,
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  resetText();
                },
                tooltip: AppLocalizations.of(context)!.imdbImportHint,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onSubmitted: (String value) {
          importTitles(context, value);
        },
      ),
    );
  }

  importNotFoundBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        readOnly: true,
        minLines: 3,
        maxLines: 3,
        controller: _notFoundTitlesController,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.imdbImportNotFound,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  importResults() {
    return FutureBuilder(
      future: isLoading,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return TitleList(titles: imdbTitles);
        }
      },
    );
  }

  importTitles(BuildContext context, String titlesIds) async {
    try {
      setState(() {
        isLoading = Future.value(true);
      });
      final result = await TmdbSearchService().searchImdbTitles(
          titlesIds.split(RegExp(r'\r?\n')), Localizations.localeOf(context));
      setState(() {
        imdbTitles = result['titles'];
        notFoundTitles = result['notFound'];
        _notFoundTitlesController.text = notFoundTitles.join('\n');
      });
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    } finally {
      setState(() {
        isLoading = Future.value(false);
      });
    }
  }
}
