import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';

class GenresScreen extends StatefulWidget {
  final List<String> genresList;
  final List<String> selectedGenres;
  final bool excludeGenres;
  final void Function(List<String>, bool) onGenresChanged;

  const GenresScreen({
    super.key,
    required this.genresList,
    required this.selectedGenres,
    required this.excludeGenres,
    required this.onGenresChanged,
  });

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  late List<String> _tempSelectedGenres;
  late bool _tempExcludeGenres;

  @override
  void initState() {
    super.initState();
    _tempSelectedGenres = List.from(widget.selectedGenres);
    _tempExcludeGenres = widget.excludeGenres;
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.genres),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: AppLocalizations.of(context)!.none,
            onPressed: () {
              setState(() {
                _tempSelectedGenres.clear();
              });
              widget.onGenresChanged(_tempSelectedGenres, _tempExcludeGenres);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(
                  value: false,
                  label: Text(AppLocalizations.of(context)!.includeGenres),
                  icon: const Icon(Icons.check_circle_outline),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(AppLocalizations.of(context)!.excludeGenres),
                  icon: const Icon(Icons.block),
                ),
              ],
              selected: {_tempExcludeGenres},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _tempExcludeGenres = newSelection.first;
                });
                widget.onGenresChanged(_tempSelectedGenres, _tempExcludeGenres);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.genresList.length,
              itemBuilder: (context, index) {
                final genre = widget.genresList[index];
                final isSelected = _tempSelectedGenres.contains(genre);

                return Column(
                  children: [
                    SwitchListTile(
                      title: Text(genre),
                      value: isSelected,
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            _tempSelectedGenres.add(genre);
                          } else {
                            _tempSelectedGenres.remove(genre);
                          }
                        });
                        widget.onGenresChanged(
                            _tempSelectedGenres, _tempExcludeGenres);
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
          ),
        ],
      ),
    );
  }
}
