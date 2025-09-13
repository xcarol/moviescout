import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
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
  late String _selectedTypePreferencesName;
  late String _filterByProvidersPreferencesName;
  String _selectedType = '';
  late List<String> _titleTypes;
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

    _showFiltersPreferencesName = '${widget.listService.listName}_ShowFilters';
    _showFilters =
        PreferencesService().prefs.getBool(_showFiltersPreferencesName) ??
            false;

    _selectedTypePreferencesName =
        '${widget.listService.listName}_SelectedType';
    _selectedType =
        PreferencesService().prefs.getString(_selectedTypePreferencesName) ??
            '';

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

    _retrieveUserProviders();

    widget.listService.addListener(_onTitlesUpdated);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.listService.loadedTitleCount == 0 &&
          !widget.listService.isLoading) {
        widget.listService.setFilters(
          text: _textFilterController.text,
          type: _titleTypeToOption(_selectedType),
          genres: _selectedGenres,
          filterByProviders: _filterByProviders,
          providerList: _providersList,
        );
      }
    });
  }

  @override
  void dispose() {
    widget.listService.removeListener(_onTitlesUpdated);
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
    _initilizeControlLocalizations();
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

  void _onTitlesUpdated() async {
    final genres = await widget.listService.getListGenres();
    if (!mounted) return;
    setState(() {
      _genresList = genres;
    });
  }

  void _retrieveUserProviders() {
    _providersList = TmdbProviderService()
        .providers
        .keys
        .where((id) =>
            TmdbProviderService()
                .providers[id]![TmdbProvider.providerEnabled] ==
            'true')
        .map((id) =>
            TmdbProviderService().providers[id]![TmdbProvider.providerName]!)
        .toList();

    if (_providersList.isNotEmpty) {
      _providersList.sort((a, b) => a.compareTo(b));
    }
  }

  Widget _titleList() {
    return ChangeNotifierProvider<TmdbListService>.value(
      value: widget.listService,
      child: Consumer<TmdbListService>(
        builder: (context, service, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              final metrics = scrollInfo.metrics;
              final currentScroll = metrics.pixels;

              final itemHeight = TitleCard.cardHeight;
              final firstVisibleIndex = (currentScroll / itemHeight).floor();
              final visibleItemCount =
                  (metrics.viewportDimension / itemHeight).ceil();
              final lastVisibleIndex = firstVisibleIndex + visibleItemCount;

              if (!service.isLoading &&
                  service.hasMore &&
                  lastVisibleIndex >= service.loadedTitleCount - 3) {
                service.loadNextPage();
              }
              return false;
            },
            child: Flexible(
              child: ListView.builder(
                key: const PageStorageKey('TitleListView'),
                shrinkWrap: true,
                itemCount: service.loadedTitleCount,
                itemBuilder: (context, index) {
                  final title = service.getItem(index);
                  if (title == null) {
                    return SizedBox.shrink();
                  }
                  final clampedScale = MediaQuery.of(context)
                      .textScaler
                      .scale(1.0)
                      .clamp(1.0, 1.3);

                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(clampedScale),
                    ),
                    child: Column(
                      children: [
                        TitleCard(
                          title: title,
                          tmdbListService: widget.listService,
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _controlPanel() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          TitleListControlPanel(
            textFilterChanged: (newTextFilter) {
              setState(() {
                widget.listService.setTextFilter(newTextFilter);
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
                widget.listService.setGenresFilter(_selectedGenres);
              });
              PreferencesService().prefs.setStringList(
                  _selectedGenresPreferencesName, _selectedGenres);
            },
            filterByProviders: _filterByProviders,
            providersChanged: (bool providersChanged) {
              setState(() {
                _filterByProviders = providersChanged;
                widget.listService
                    .setProvidersFilter(_filterByProviders, _providersList);
              });
              PreferencesService().prefs.setBool(
                  _filterByProvidersPreferencesName, _filterByProviders);
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
      ),
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

  String _titleTypeToOption(String type) {
    String selectedType = '';

    if (type == AppLocalizations.of(context)!.movies) {
      selectedType = 'movie';
    } else if (type == AppLocalizations.of(context)!.tvshows) {
      selectedType = 'tv';
    }

    return selectedType;
  }

  Widget _typeSelector() {
    return DropdownSelector(
      selectedOption: _selectedType,
      options: _titleTypes,
      onSelected: (value) => setState(() {
        _selectedType = value;
        widget.listService.setTypeFilter(_titleTypeToOption(value));
        PreferencesService()
            .prefs
            .setString(_selectedTypePreferencesName, _selectedType);
      }),
      arrowIcon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _sortNameToOption(BuildContext context, String name) {
    if (name == AppLocalizations.of(context)!.sortAlphabetically) {
      return SortOption.alphabetically;
    } else if (name == AppLocalizations.of(context)!.sortRating) {
      return SortOption.rating;
    } else if (name == AppLocalizations.of(context)!.sortUserRating) {
      return SortOption.userRating;
    } else if (name == AppLocalizations.of(context)!.sortReleaseDate) {
      return SortOption.releaseDate;
    } else if (name == AppLocalizations.of(context)!.sortRuntime) {
      return SortOption.runtime;
    } else {
      return SortOption.alphabetically;
    }
  }

  Widget _sortSelector() {
    return DropdownSelector(
      selectedOption: _selectedSort,
      options: _titleSorts,
      onSelected: (value) => setState(() {
        _selectedSort = value;
        widget.listService
            .setSort(_sortNameToOption(context, value), _isSortAsc);
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
          widget.listService
              .setSort(_sortNameToOption(context, _selectedSort), _isSortAsc);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = widget.listService.selectedTitleCount;
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Divider(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            _infoLine(itemCount),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            if (_showFilters) _controlPanel(),
            _titleList(),
          ],
        ),
      ),
    );
  }
}
