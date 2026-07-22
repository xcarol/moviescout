import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/widgets/list_info_line.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/widgets/title_list_controller.dart';

class SearchListInfoLine extends StatelessWidget {
  final TitleListController controller;
  final TmdbSearchService searchService;
  final VoidCallback? onFilterChanged;

  const SearchListInfoLine({
    super.key,
    required this.controller,
    required this.searchService,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final anyFilterActive = controller.selectedGenres.isNotEmpty ||
        controller.filterByProviders ||
        controller.textFilterController.text.isNotEmpty;

    return ListInfoLine(
      leadingWidgets: _buildTypeAndCountWidgets(context),
      isLoading: searchService.isLoading,
      sortSelector: _sortSelector(context),
      onSwapSort: () => controller.toggleSortDirection(),
      onToggleFilters: () => controller.toggleFilters(),
      showFilters: controller.showFilters,
      anyFilterActive: anyFilterActive,
    );
  }

  List<Widget> _buildTypeAndCountWidgets(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;
    final typeOption = searchService.selectedType;

    final textColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterForeground
        : titleTheme.infoLineActiveFilterForeground;
    final backgroundColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterBackground
        : titleTheme.infoLineActiveFilterBackground;

    final options = [
      localizations.results,
      localizations.movies,
      localizations.tvshows,
      localizations.cast,
    ];

    String selectedLabel = localizations.results;
    if (typeOption == ApiConstants.movie) selectedLabel = localizations.movies;
    if (typeOption == ApiConstants.tv) selectedLabel = localizations.tvshows;
    if (typeOption == ApiConstants.person) selectedLabel = localizations.cast;

    return [
      DropdownSelector(
        backgroundColor: backgroundColor,
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        borderRadius: BorderRadius.circular(5),
        leading: Text(
          searchService.selectedItemCount.value.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        selectedOption: selectedLabel,
        options: options,
        onSelected: (value) {
          String type = '';
          if (value == localizations.movies) type = ApiConstants.movie;
          if (value == localizations.tvshows) type = ApiConstants.tv;
          if (value == localizations.cast) type = ApiConstants.person;
          searchService.setTypeFilter(type);
          onFilterChanged?.call();
        },
        arrowIcon: Icon(
          Icons.arrow_drop_down,
          color: textColor,
        ),
      ),
    ];
  }

  Widget _sortSelector(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DropdownSelector(
      selectedOption: controller.getSelectedSortLabel(localizations),
      options: controller.titleSorts,
      onSelected: (value) => controller.setSelectedSort(context, value),
      arrowIcon: controller.isSortAsc
          ? Icon(Icons.arrow_drop_down)
          : Icon(Icons.arrow_drop_up),
    );
  }
}
