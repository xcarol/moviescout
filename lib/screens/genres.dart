import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/models/title_list_theme.dart';

class GenresScreen extends StatefulWidget {
  final List<String> genresList;
  final List<String> selectedGenres;
  final void Function(List<String>) onGenresChanged;

  const GenresScreen({
    super.key,
    required this.genresList,
    required this.selectedGenres,
    required this.onGenresChanged,
  });

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  late List<String> _tempSelectedGenres;

  @override
  void initState() {
    super.initState();
    _tempSelectedGenres = List.from(widget.selectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return Scaffold(
      backgroundColor: titleTheme.listBackground,
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.genres,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: widget.genresList.length,
        itemBuilder: (context, index) {
          final genre = widget.genresList[index];
          final isSelected = _tempSelectedGenres.contains(genre);

          return Column(
            children: [
              SwitchListTile(
                title: Text(
                  genre,
                  style: TextStyle(
                    color: titleTheme.controlPanelBackground,
                  ),
                ),
                activeThumbColor: titleTheme.controlPanelActiveFilterBackground,
                activeTrackColor: titleTheme.controlPanelActiveFilterForeground,
                inactiveThumbColor:
                    titleTheme.controlPanelInactiveFilterBackground,
                inactiveTrackColor:
                    titleTheme.controlPanelInactiveFilterForeground,
                value: isSelected,
                onChanged: (bool value) {
                  setState(() {
                    if (value) {
                      _tempSelectedGenres.add(genre);
                    } else {
                      _tempSelectedGenres.remove(genre);
                    }
                  });
                  widget.onGenresChanged(_tempSelectedGenres);
                },
              ),
              Divider(
                height: 1,
                color: titleTheme.listDividerColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
