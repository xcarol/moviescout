import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/genres.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/inputs_and_filters/text_filter_widget.dart';
import 'package:moviescout/widgets/lists/list_controller.dart';
import 'package:moviescout/widgets/inputs_and_filters/rating_filter_tabs.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';

class ListControlPanel extends StatelessWidget {
  final ListController controller;
  final TmdbBaseListService listService;
  final bool showRatingFilter;

  const ListControlPanel({
    super.key,
    required this.controller,
    required this.listService,
    this.showRatingFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listService.listGenres,
      builder: (context, genres, child) {
        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
        return Container(
          color: titleTheme.controlPanelBackground,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _genresSelector(context, genres),
                        _providersSelector(context),
                      ],
                    ),
                    TextFilterWidget(
                      controller: controller.textFilterController,
                      focusNode: controller.searchFocusNode,
                      hintText: AppLocalizations.of(context)!.search,
                      onChanged: (String value) {
                        controller.setTextFilter(value);
                      },
                    ),
                    const SizedBox(height: 5),
                    if (showRatingFilter)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [RatingFilterTabs(controller: controller)],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _genresSelector(BuildContext context, List<String> genresList) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final selectedGenres = controller.selectedGenres.toList();
    final excludeGenres = controller.excludeGenres;
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
              excludeGenres: excludeGenres,
              onGenresChanged: (genres, exclude) {
                controller.setGenres(genres, exclude);
              },
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

  Widget _providersSelector(BuildContext context) {
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
          value: controller.filterByProviders,
          onChanged: (value) {
            controller.setFilterByProviders(value);
          },
        ),
      ],
    );
  }
}
