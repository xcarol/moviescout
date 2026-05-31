import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_person_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';

class PersonSortOption {
  static const name = 'name';
  static const department = 'department';
  static const job = 'job';
  static const original = 'original';
}

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

  PersonListController(this.listService, this.type) {
    textFilterController = TextEditingController();
    listService.addListener(_onListServiceChanged);
  }

  bool get showFilters => _showFilters;
  bool get isSortAsc => _isSortAsc;
  String get selectedSort => _selectedSort;
  List<String> get personSorts => _personSorts;
  
  int get itemCount => listService.selectedItemCount.value;

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
    notifyListeners();
  }

  void toggleSortDirection() {
    _isSortAsc = !_isSortAsc;
    listService.setSort(_selectedSort, _isSortAsc);
    notifyListeners();
  }

  void onScrollNotification(ScrollNotification scrollInfo, double itemHeight) {
    final metrics = scrollInfo.metrics;
    final currentScroll = metrics.pixels;

    final firstVisibleIndex = (currentScroll / itemHeight).floor();
    final visibleItemCount = (metrics.viewportDimension / itemHeight).ceil();
    final lastVisibleIndex = firstVisibleIndex + visibleItemCount;

    if (currentScroll > 0 &&
        !listService.isLoading.value &&
        listService.hasMore &&
        lastVisibleIndex >= listService.loadedItemCount - 3) {
      listService.loadNextPage();
    }
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void setTextFilter(String value) {
    listService.setTextFilter(value);
  }

  void _onListServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    listService.removeListener(_onListServiceChanged);
    textFilterController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
