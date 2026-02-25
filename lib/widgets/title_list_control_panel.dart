import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/genres.dart';
import 'package:moviescout/models/title_list_theme.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class TitleListControlPanel extends StatelessWidget {
  final Function textFilterChanged;
  final TextEditingController textFilterController;
  final List<String> selectedGenres;
  final List<String> genresList;
  final Function genresChanged;
  final bool filterByProviders;
  final Function providersChanged;
  final FocusNode focusNode;
  final Widget? ratingFilter;

  const TitleListControlPanel({
    super.key,
    required this.textFilterChanged,
    required this.textFilterController,
    required this.selectedGenres,
    required this.genresList,
    required this.genresChanged,
    required this.filterByProviders,
    required this.providersChanged,
    required this.focusNode,
    this.ratingFilter,
  });

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _genresSelector(context, genresChanged),
              _providersSelector(context, filterByProviders),
            ],
          ),
          _textFilter(context, AppLocalizations.of(context)!.search),
          if (ratingFilter != null)
            Container(
              color: titleTheme.controlPanelForeground.withValues(alpha: 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ratingFilter!],
              ),
            ),
        ],
      ),
    );
  }

  Widget _genresSelector(BuildContext context, Function genresChanged) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final foregroundColor = selectedGenres.isNotEmpty
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;
    final backgroundColor = selectedGenres.isNotEmpty
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenresScreen(
              genresList: genresList,
              selectedGenres: selectedGenres,
              onGenresChanged: (newGenres) => genresChanged(newGenres),
            ),
          ),
        );
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: titleTheme.controlPanelForeground,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.genres,
              style: TextStyle(
                fontSize: 16,
                color: foregroundColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: foregroundColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _providersSelector(BuildContext context, bool filterByProviders) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.filterByProviders,
          style: TextStyle(
            fontSize: 16,
            color: titleTheme.controlPanelForeground,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          activeThumbColor: titleTheme.controlPanelForeground,
          value: filterByProviders,
          onChanged: (value) {
            providersChanged(value);
          },
        ),
      ],
    );
  }

  Widget _textFilter(BuildContext context, String hintText) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return SizedBox(
      height: 26,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: titleTheme.searchSelectionColor,
            selectionHandleColor: titleTheme.searchCursorColor,
          ),
        ),
        child: TextField(
          controller: textFilterController,
          focusNode: focusNode,
          style: TextStyle(
              color: titleTheme.controlPanelForeground,
              fontSize: 14,
              fontWeight: textFilterController.text.isEmpty
                  ? FontWeight.normal
                  : FontWeight.bold),
          cursorColor: titleTheme.searchCursorColor,
          cursorHeight: 16,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(color: titleTheme.searchHintColor),
            suffixIconColor: titleTheme.controlPanelForeground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            suffixIcon: GestureDetector(
              child: Icon(Icons.clear),
              onTap: () {
                textFilterChanged('');
                textFilterController.clear();
              },
            ),
          ),
          onChanged: (String value) {
            textFilterChanged(value);
          },
        ),
      ),
    );
  }
}
