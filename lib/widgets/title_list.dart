import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';

class TitleList extends StatefulWidget {
  final TmdbListService listService;

  const TitleList(this.listService, {super.key});

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSortAsc = true;
  late bool _showFilters;
  late String _showFiltersPreferencesName;
  String _selectedType = '';
  late List<String> _titleTypes;
  late String _textFilter;
  String _selectedSort = '';
  late List<String> _titleSorts;
  List<String> _selectedGenres = [];
  List<String> _genresList = [];
  late TextEditingController _textFilterController;

  @override
  void initState() {
    super.initState();
    _textFilterController = TextEditingController();
    _showFiltersPreferencesName = '${widget.listService.listName}_ShowFilters';
    _showFilters =
        PreferencesService().prefs.getBool(_showFiltersPreferencesName) ?? true;
  }

  @override
  void dispose() {
    _textFilterController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && _searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
    _textFilter = _textFilterController.text;
    _initilizeControlLocalizations();
    _retrieveGenresFromTitles();
  }

  void _initilizeControlLocalizations() {
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
      if (widget.listService.userRatingAvailable) localizations.sortUserRating,
      localizations.sortReleaseDate,
      localizations.sortRuntime,
    ];
  }

  void _retrieveGenresFromTitles() {
    _genresList = widget.listService.titles
        .expand((title) => title.genres)
        .map((genre) => genre.name)
        .toSet()
        .toList();
  }

  List<TmdbTitle> _sortTitles(List<TmdbTitle> titles) {
    final ascending = _isSortAsc ? 1 : -1;
    final titlesToSort = titles;

    final sortFunctions = {
      AppLocalizations.of(context)!.sortAlphabetically:
          (TmdbTitle a, TmdbTitle b) => a.name.compareTo(b.name),
      AppLocalizations.of(context)!.sortRating: (TmdbTitle a, TmdbTitle b) =>
          b.voteAverage.compareTo(a.voteAverage),
      AppLocalizations.of(context)!.sortUserRating:
          (TmdbTitle a, TmdbTitle b) => b.rating.compareTo(a.rating),
      AppLocalizations.of(context)!.sortReleaseDate:
          (TmdbTitle a, TmdbTitle b) => _compareReleaseDates(a, b),
      AppLocalizations.of(context)!.sortRuntime: (TmdbTitle a, TmdbTitle b) =>
          _compareRuntimes(a, b),
    };

    titlesToSort.sort(
        (a, b) => ascending * (sortFunctions[_selectedSort]?.call(a, b) ?? 0));

    return titlesToSort;
  }

  int _compareReleaseDates(TmdbTitle a, TmdbTitle b) {
    final dateA = a.mediaType == 'movie' ? a.releaseDate : a.firstAirDate;
    final dateB = b.mediaType == 'movie' ? b.releaseDate : b.firstAirDate;
    return dateB.compareTo(dateA);
  }

  int _compareRuntimes(TmdbTitle a, TmdbTitle b) {
    if (a.mediaType == 'movie' && b.mediaType == 'movie') {
      return b.runtime.compareTo(a.runtime);
    } else if (a.mediaType == 'movie') {
      return -1;
    } else if (b.mediaType == 'movie') {
      return 1;
    } else {
      return b.numberOfEpisodes.compareTo(a.numberOfEpisodes);
    }
  }

  List<TmdbTitle> _filterGenres(List<TmdbTitle> titles) {
    if (_selectedGenres.isEmpty) {
      return titles;
    }

    return titles
        .where((title) =>
            title.genres.any((genre) => _selectedGenres.contains(genre.name)))
        .toList();
  }

  Widget _titleList(List<TmdbTitle> titles) {
    return ChangeNotifierProvider.value(
      value: widget.listService,
      child: Flexible(
        child: ListView.builder(
          key: const PageStorageKey('TitleListView'),
          shrinkWrap: true,
          itemCount: titles.length,
          itemBuilder: (context, index) {
            final TmdbTitle title = titles[index];
            return Selector<TmdbListService, TmdbTitle?>(
              selector: (_, service) => service.titles.firstWhere(
                (title) => title.id == title.id,
                orElse: () => title,
              ),
              builder: (_, tmdbTitle, __) {
                return TitleCard(
                  title: title,
                  tmdbListService: widget.listService,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _controlPanel() {
    return Column(
      children: [
        TitleListControlPanel(
          selectedType: _selectedType,
          typesList: _titleTypes,
          typeChanged: (typeChanged) {
            setState(() {
              _selectedType = typeChanged;
            });
          },
          textFilterChanged: (newTextFilter) {
            setState(() {
              _textFilter = newTextFilter;
            });
          },
          textFilterController: _textFilterController,
          selectedGenres: _selectedGenres.toList(),
          genresList: _genresList,
          genresChanged: (List<String> genresChanged) {
            setState(() {
              _selectedGenres = genresChanged.toList();
            });
          },
          selectedSort: _selectedSort,
          sortsList: _titleSorts,
          sortChanged: (sortChanged) {
            setState(() {
              _selectedSort = sortChanged;
            });
          },
          swapSort: () {
            setState(() {
              _isSortAsc = !_isSortAsc;
            });
          },
          focusNode: _searchFocusNode,
        ),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _infoLine(int count) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          _typeSelector(),
          const Spacer(),
          Row(
            children: [
              _sortSelector(),
              _swapSortButton(context),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                    PreferencesService()
                        .prefs
                        .setBool(_showFiltersPreferencesName, _showFilters);
                  });
                },
                icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuBuilder(String key, MenuController controller, String title,
      Iterable<Widget> menuChildren, Icon arrowIcon) {
    return MenuAnchor(
      key: Key(key),
      controller: controller,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                arrowIcon,
              ],
            ),
          ),
        );
      },
      menuChildren: menuChildren.toList(),
    );
  }

  Widget _typeSelector() {
    MenuController controller = MenuController();
    return _menuBuilder(
      '_typeSelector',
      controller,
      _selectedType,
      _titleTypes.map((String option) {
        return ListTile(
          title: Text(option),
          selected: _selectedType == option,
          selectedColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            setState(() {
              _selectedType = option;
            });
            controller.close();
          },
        );
      }),
      Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _sortSelector() {
    MenuController controller = MenuController();
    return _menuBuilder(
      '_sortSelector',
      controller,
      _selectedSort,
      _titleSorts.map((String option) {
        bool isSelected = _selectedSort == option;
        return ListTile(
          title: Text(option),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            setState(() {
              _selectedSort = option;
            });
            controller.close();
          },
        );
      }),
      _isSortAsc
          ? Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(
              Icons.arrow_drop_up,
              color: Theme.of(context).colorScheme.primary,
            ),
    );
  }

  Widget _swapSortButton(BuildContext context) {
    return IconButton(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(Icons.swap_vert),
      onPressed: () {
        setState(() {
          _isSortAsc = !_isSortAsc;
        });
      },
    );
  }

  List<TmdbTitle> _filterTitles() {
    List<TmdbTitle> titles = widget.listService.titles;

    if (_selectedType != AppLocalizations.of(context)!.allTypes) {
      titles = titles
          .where((title) =>
              (title.mediaType == 'movie' &&
                  _selectedType == AppLocalizations.of(context)!.movies) ||
              (title.mediaType == 'tv' &&
                  _selectedType == AppLocalizations.of(context)!.tvshows))
          .toList();
    }

    if (_textFilter.isNotEmpty) {
      titles = titles
          .where((title) =>
              title.name.toLowerCase().contains(_textFilter.toLowerCase()))
          .toList();
    }

    titles = _filterGenres(titles);
    titles = _sortTitles(titles);

    return titles;
  }

  @override
  Widget build(BuildContext context) {
    List<TmdbTitle> filteredTitles = _filterTitles();
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Divider(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            _infoLine(filteredTitles.length),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            if (_showFilters) _controlPanel(),
            _titleList(filteredTitles),
          ],
        ),
      ),
    );
  }
}
