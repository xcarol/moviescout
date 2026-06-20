import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/genres.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/text_filter_widget.dart';

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
          TextFilterWidget(
            controller: textFilterController,
            focusNode: focusNode,
            hintText: AppLocalizations.of(context)!.search,
            onChanged: (String value) {
              textFilterChanged(value);
            },
          ),
          const SizedBox(height: 5),
          if (ratingFilter != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ratingFilter!],
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
          activeThumbColor: titleTheme.controlPanelActiveFilterBackground,
          inactiveThumbColor: titleTheme.controlPanelInactiveFilterForeground,
          value: filterByProviders,
          onChanged: (value) {
            providersChanged(value);
          },
        ),
      ],
    );
  }
}
