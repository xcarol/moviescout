import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<CustomColors>();

    return Scaffold(
      // backgroundColor: colorScheme.onPrimaryContainer,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.genres),
      ),
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
                    // color: colorScheme.primary,
                  ),
                ),
                // activeThumbColor: colorScheme.onPrimary,
                // activeTrackColor: colorScheme.primary,
                // inactiveThumbColor: colorScheme.primary,
                // inactiveTrackColor: colorScheme.onPrimary,
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
                color: customColors!.dividerColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
