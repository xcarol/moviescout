import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class TitleListController with ChangeNotifier {
  final TmdbListService listService;
  late final TextEditingController textFilterController;
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  bool _isSortAsc = true;
  bool _showFilters = false;
  String _selectedType = '';
  String _selectedSort = '';
  List<String> _selectedGenres = [];
  bool _filterByProviders = false;
  List<int> _providerListIds = [];
  List<String> _titleTypes = [];
  List<String> _titleSorts = [];

  // Preference Keys
  late final String _showFiltersPreferencesName;
  late final String _textFilterPreferencesName;
  late final String _selectedGenresPreferencesName;
  late final String _selectedTypePreferencesName;
  late final String _selectedSortPreferencesName;
  late final String _filterByProvidersPreferencesName;
  late final String _sortPreferencesName;

  TitleListController(this.listService) {
    textFilterController = TextEditingController();
    _initPreferencesNames();
    _loadPreferences();
    listService.addListener(_onListServiceChanged);
  }

  // Getters
  bool get isSortAsc => _isSortAsc;
  bool get showFilters => _showFilters;
  String get selectedType => _selectedType;
  String get selectedSort => _selectedSort;
  List<String> get selectedGenres => _selectedGenres;
  bool get filterByProviders => _filterByProviders;
  List<int> get providerListIds => _providerListIds;
  List<String> get titleTypes => _titleTypes;
  List<String> get titleSorts => _titleSorts;

  @override
  void dispose() {
    listService.removeListener(_onListServiceChanged);
    textFilterController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void initializeControlLocalizations(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_selectedType.isEmpty) {
      _selectedType = localizations.allTypes;
    }
    _titleTypes = [
      localizations.allTypes,
      localizations.movies,
      localizations.tvshows,
    ];
    if (_selectedSort.isEmpty) {
      _selectedSort = localizations.sortAlphabetically;
    }
    _titleSorts = [
      localizations.sortAlphabetically,
      localizations.sortRating,
      if (listService.userRatingAvailable) localizations.sortUserRating,
      if (listService.userRatedDateAvailable) localizations.sortDateRated,
      localizations.sortReleaseDate,
      localizations.sortRuntime,
      localizations.sortAddedOrder,
    ];
    notifyListeners();
  }

  void onScrollNotification(ScrollNotification scrollInfo, double itemHeight) {
    final metrics = scrollInfo.metrics;
    final currentScroll = metrics.pixels;

    final firstVisibleIndex = (currentScroll / itemHeight).floor();
    final visibleItemCount = (metrics.viewportDimension / itemHeight).ceil();
    final lastVisibleIndex = firstVisibleIndex + visibleItemCount;

    if (!listService.isLoading.value &&
        listService.hasMore &&
        lastVisibleIndex >= listService.loadedTitleCount - 3) {
      listService.loadNextPage();
    }
  }

  void setFilterByProviders(bool value) {
    _filterByProviders = value;
    PreferencesService()
        .prefs
        .setBool(_filterByProvidersPreferencesName, value);
    listService.setProvidersFilter(_filterByProviders, _providerListIds);
    notifyListeners();
  }

  void setGenres(List<String> genres) {
    _selectedGenres = genres;
    PreferencesService()
        .prefs
        .setStringList(_selectedGenresPreferencesName, _selectedGenres);
    listService.setGenresFilter(_selectedGenres);
    notifyListeners();
  }

  void setProviderListIds(List<int> providerIds) {
    _providerListIds = providerIds;

    setupFilters();
  }

  Future<void> setupFilters() async {
    try {
      await listService.setFilters(
        text: textFilterController.text,
        type: _titleTypeToOption(_selectedType),
        genres: _selectedGenres,
        filterByProviders: _filterByProviders,
        providerListIds: _providerListIds,
      );
    } catch (_) {}
  }

  void setSelectedSort(BuildContext context, String value) {
    _selectedSort = value;
    PreferencesService()
        .prefs
        .setString(_selectedSortPreferencesName, _selectedSort);
    listService.setSort(_sortNameToOption(context, value), _isSortAsc);
    notifyListeners();
  }

  void setSelectedType(BuildContext context, String value) {
    final localizations = AppLocalizations.of(context);

    _selectedType = value;
    PreferencesService()
        .prefs
        .setString(_selectedTypePreferencesName, _selectedType);

    listService.setTypeFilter(_titleTypeToOption(value, localizations));
    notifyListeners();
  }

  void setTextFilter(String value) {
    PreferencesService().prefs.setString(_textFilterPreferencesName, value);
    listService.setTextFilter(value);
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
    PreferencesService()
        .prefs
        .setBool(_showFiltersPreferencesName, _showFilters);
    notifyListeners();
  }

  void toggleSortDirection(BuildContext context) {
    _isSortAsc = !_isSortAsc;
    PreferencesService().prefs.setBool(_sortPreferencesName, _isSortAsc);
    listService.setSort(_sortNameToOption(context, _selectedSort), _isSortAsc);
    notifyListeners();
  }

  // Private Methods
  void _initPreferencesNames() {
    _textFilterPreferencesName = '${listService.listName}_TextFilter';
    _showFiltersPreferencesName = '${listService.listName}_ShowFilters';
    _selectedTypePreferencesName = '${listService.listName}_SelectedType';
    _selectedGenresPreferencesName = '${listService.listName}_SelectedGenres';
    _filterByProvidersPreferencesName =
        '${listService.listName}_FilterByProviders';
    _sortPreferencesName = '${listService.listName}_Sort';
    _selectedSortPreferencesName = '${listService.listName}_SelectedSort';
  }

  void _loadPreferences() {
    final prefs = PreferencesService().prefs;
    textFilterController.text =
        prefs.getString(_textFilterPreferencesName) ?? '';
    _showFilters = prefs.getBool(_showFiltersPreferencesName) ?? false;
    _selectedType = prefs.getString(_selectedTypePreferencesName) ?? '';
    _selectedGenres = prefs.getStringList(_selectedGenresPreferencesName) ?? [];
    _filterByProviders =
        prefs.getBool(_filterByProvidersPreferencesName) ?? false;
    _isSortAsc = prefs.getBool(_sortPreferencesName) ?? true;
    _selectedSort = prefs.getString(_selectedSortPreferencesName) ?? '';
  }

  void _onListServiceChanged() {
    notifyListeners();
  }

  String _sortNameToOption(BuildContext context, String name) {
    final localizations = AppLocalizations.of(context)!;
    if (name == localizations.sortAlphabetically) {
      return SortOption.alphabetically;
    } else if (name == localizations.sortRating) {
      return SortOption.rating;
    } else if (name == localizations.sortUserRating) {
      return SortOption.userRating;
    } else if (name == localizations.sortDateRated) {
      return SortOption.dateRated;
    } else if (name == localizations.sortReleaseDate) {
      return SortOption.releaseDate;
    } else if (name == localizations.sortRuntime) {
      return SortOption.runtime;
    } else if (name == localizations.sortAddedOrder) {
      return SortOption.addedOrder;
    } else {
      return SortOption.alphabetically;
    }
  }

  String _titleTypeToOption(String type, [AppLocalizations? localizations]) {
    if (localizations == null) return '';

    if (type == localizations.movies) {
      return 'movie';
    } else if (type == localizations.tvshows) {
      return 'tv';
    }
    return '';
  }
}
