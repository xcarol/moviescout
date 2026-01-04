import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class PersonSortOption {
  static const name = 'name';
  static const department = 'department';
  static const job = 'job';
  static const original = 'original';
}

class PersonListController with ChangeNotifier {
  final List<TmdbPerson> fullList;
  List<TmdbPerson> _filteredList = [];

  late final TextEditingController textFilterController;
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  final String type;
  bool _isSortAsc = true;
  bool _showFilters = false;
  String _selectedSort = PersonSortOption.original;
  List<String> _personSorts = [];

  PersonListController(this.fullList, this.type) {
    textFilterController = TextEditingController();
    _filteredList = List.from(fullList);
    _applyFilters();
  }

  List<TmdbPerson> get items => _filteredList;
  int get itemCount => _filteredList.length;
  bool get isSortAsc => _isSortAsc;
  bool get showFilters => _showFilters;
  String get selectedSort => _selectedSort;
  List<String> get personSorts => _personSorts;

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
    _applyFilters();
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
    _applyFilters();
    notifyListeners();
  }

  void toggleSortDirection() {
    _isSortAsc = !_isSortAsc;
    _applyFilters();
    notifyListeners();
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void setTextFilter(String value) {
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    final text = textFilterController.text.toLowerCase();
    _filteredList = fullList.where((p) {
      return p.name.toLowerCase().contains(text) ||
          p.originalName.toLowerCase().contains(text) ||
          p.character.toLowerCase().contains(text);
    }).toList();

    _filteredList.sort((a, b) {
      int result = 0;
      if (_selectedSort == PersonSortOption.name) {
        result = a.name.compareTo(b.name);
      } else if (_selectedSort == PersonSortOption.department) {
        result = a.knownForDepartment.compareTo(b.knownForDepartment);
      } else if (_selectedSort == PersonSortOption.job) {
        result = a.job.compareTo(b.job);
      } else if (_selectedSort == PersonSortOption.original) {
        result = fullList.indexOf(a).compareTo(fullList.indexOf(b));
      }

      if (result == 0 && _selectedSort != PersonSortOption.original) {
        result = a.name.compareTo(b.name);
      }
      return _isSortAsc ? result : -result;
    });
  }

  @override
  void dispose() {
    textFilterController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
