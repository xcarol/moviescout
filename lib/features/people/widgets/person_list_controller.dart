import 'package:flutter/material.dart';
import 'package:moviescout/features/people/services/tmdb_person_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';

class PersonListController with ChangeNotifier {
  final TmdbPersonListService listService;
  late final TextEditingController textFilterController;
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  final String type;
  bool _showFilters = false;
  bool _isSortAsc = true;
  String _selectedSort = PersonSortOption.original;
  List<String> _personSorts = [];
  bool _isGridView = false;

  PersonListController(this.listService, this.type) {
    textFilterController = TextEditingController();
    listService.addListener(_onListServiceChanged);
    _isGridView =
        PreferencesService().prefs.getBool(AppConstants.personListIsGridView) ??
            false;
  }

  bool get showFilters => _showFilters;
  bool get isSortAsc => _isSortAsc;
  String get selectedSort => _selectedSort;
  List<String> get personSorts => _personSorts;
  bool get isGridView => _isGridView;

  int get itemCount => listService.selectedItemCount.value ?? 0;

  void initializeControlLocalizations(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (type == PersonAttributes.cast) {
      _personSorts = [
        localizations.cast,
        localizations.sortAlphabetically,
      ];
    } else {
      _personSorts = [
        localizations.cast,
        localizations.sortAlphabetically,
        localizations.job,
        localizations.department,
      ];
    }
    notifyListeners();
  }

  String getSelectedSortLabel(AppLocalizations localizations) {
    switch (_selectedSort) {
      case PersonSortOption.name:
        return localizations.sortAlphabetically;
      case PersonSortOption.department:
        return localizations.department;
      case PersonSortOption.job:
        return localizations.job;
      case PersonSortOption.original:
        return localizations.cast;
      default:
        return localizations.sortAlphabetically;
    }
  }

  void setSelectedSort(BuildContext context, String localizedValue) {
    final localizations = AppLocalizations.of(context)!;
    if (localizedValue == localizations.sortAlphabetically) {
      _selectedSort = PersonSortOption.name;
    } else if (localizedValue == localizations.department) {
      _selectedSort = PersonSortOption.department;
    } else if (localizedValue == localizations.job) {
      _selectedSort = PersonSortOption.job;
    } else if (localizedValue == localizations.cast) {
      _selectedSort = PersonSortOption.original;
    }
    listService.setSort(_selectedSort, _isSortAsc);
    _scrollToTop();
    notifyListeners();
  }

  void toggleSortDirection() {
    _isSortAsc = !_isSortAsc;
    listService.setSort(_selectedSort, _isSortAsc);
    _scrollToTop();
    notifyListeners();
  }

  void onScrollNotification(ScrollNotification scrollInfo) {
    final metrics = scrollInfo.metrics;

    final bool isNearEnd = metrics.pixels > 0 && metrics.extentAfter < 500;
    final bool contentUnderfilled = listService.loadedItemCount > 0 &&
        metrics.maxScrollExtent < 100 &&
        metrics.viewportDimension > 0;

    if ((isNearEnd || contentUnderfilled) &&
        !listService.isLoading.value &&
        listService.hasMore) {
      listService.loadNextPage();
    }
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void toggleGridView() {
    _isGridView = !_isGridView;
    PreferencesService()
        .prefs
        .setBool(AppConstants.personListIsGridView, _isGridView);
    notifyListeners();
  }

  void setTextFilter(String value) {
    listService.setTextFilter(value);
    _scrollToTop();
  }

  void _onListServiceChanged() {
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!listService.isLoading.value &&
          listService.hasMore &&
          listService.loadedItemCount > 0 &&
          scrollController.hasClients &&
          scrollController.position.maxScrollExtent < 100) {
        listService.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    listService.removeListener(_onListServiceChanged);
    textFilterController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }
  }
}
