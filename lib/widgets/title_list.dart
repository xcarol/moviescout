import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
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
  late String _textFilterPreferencesName;
  late String _selectedGenresPreferencesName;
  late String _filterByProvidersPreferencesName;
  String _selectedType = '';
  late List<String> _titleTypes;
  late String _textFilter;
  String _selectedSort = '';
  late List<String> _titleSorts;
  List<String> _selectedGenres = [];
  List<String> _genresList = [];
  late bool _filterByProviders = false;
  List<String> _providersList = [];
  late TextEditingController _textFilterController;

  @override
  void initState() {
    super.initState();
    _textFilterController = TextEditingController();

    _textFilterPreferencesName = '${widget.listService.listName}_TextFilter';
    _textFilterController.text =
        PreferencesService().prefs.getString(_textFilterPreferencesName) ?? '';
    _textFilter = _textFilterController.text;

    _showFiltersPreferencesName = '${widget.listService.listName}_ShowFilters';
    _showFilters =
        PreferencesService().prefs.getBool(_showFiltersPreferencesName) ??
            false;

    _selectedGenresPreferencesName =
        '${widget.listService.listName}_SelectedGenres';
    _selectedGenres = PreferencesService()
            .prefs
            .getStringList(_selectedGenresPreferencesName) ??
        [];

    _filterByProvidersPreferencesName =
        '${widget.listService.listName}_FilterByProviders';
    _filterByProviders =
        PreferencesService().prefs.getBool(_filterByProvidersPreferencesName) ??
            false;
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
    _retrieveUserProviders();
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

  void _retrieveUserProviders() {
    _providersList = TmdbProviderService()
        .providers
        .keys
        .where(
            (id) => TmdbProviderService().providers[id]!['enabled'] == 'true')
        .map((id) => TmdbProviderService().providers[id]!['name']!)
        .toList();

    if (_providersList.isNotEmpty) {
      _providersList.sort((a, b) => a.compareTo(b));
    }
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

  List<TmdbTitle> _filterProviders(List<TmdbTitle> titles) {
    if (!_filterByProviders) {
      return titles;
    }

    return titles
        .where((title) => title.providers
            .any((provider) => _providersList.contains(provider.name)))
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
                final clampedScale = MediaQuery.of(context)
                    .textScaler
                    .scale(1.0)
                    .clamp(1.0, 1.3);

                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(clampedScale),
                  ),
                  child: TitleCard(
                    title: title,
                    tmdbListService: widget.listService,
                  ),
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
          textFilterChanged: (newTextFilter) {
            setState(() {
              _textFilter = newTextFilter;
            });
            PreferencesService()
                .prefs
                .setString(_textFilterPreferencesName, newTextFilter);
          },
          textFilterController: _textFilterController,
          selectedGenres: _selectedGenres.toList(),
          genresList: _genresList,
          genresChanged: (List<String> genresChanged) {
            setState(() {
              _selectedGenres = genresChanged.toList();
            });
            PreferencesService()
                .prefs
                .setStringList(_selectedGenresPreferencesName, _selectedGenres);
          },
          filterByProviders: _filterByProviders,
          providersChanged: (bool providersChanged) {
            setState(() {
              _filterByProviders = providersChanged;
            });
            PreferencesService()
                .prefs
                .setBool(_filterByProvidersPreferencesName, _filterByProviders);
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
          const SizedBox(width: 8),
          if (widget.listService.isLoading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
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

  Widget _typeSelector() {
    return DropdownSelector(
      selectedOption: _selectedType,
      options: _titleTypes,
      onSelected: (value) => setState(() {
        _selectedType = value;
      }),
      arrowIcon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _sortSelector() {
    return DropdownSelector(
      selectedOption: _selectedSort,
      options: _titleSorts,
      onSelected: (value) => setState(() {
        _selectedSort = value;
      }),
      arrowIcon: _isSortAsc
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
    titles = _filterProviders(titles);
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
