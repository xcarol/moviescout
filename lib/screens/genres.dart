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
    final hasFilters = _tempSelectedGenres.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.genres),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<bool>(
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
                    widget.onGenresChanged(
                        _tempSelectedGenres, _tempExcludeGenres);
                  },
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton.outlined(
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    icon: Icon(
                      size: 18,
                      hasFilters ? Icons.filter_alt_off : Icons.filter_alt,
                      color: hasFilters
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
                    tooltip: AppLocalizations.of(context)!.none,
                    onPressed: hasFilters
                        ? () {
                            setState(() {
                              _tempSelectedGenres.clear();
                            });
                            widget.onGenresChanged(
                                _tempSelectedGenres, _tempExcludeGenres);
                          }
                        : null,
                  ),
                ),
              ],
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
