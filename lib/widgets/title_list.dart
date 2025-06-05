import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';

class TitleList extends StatefulWidget {
  final List<TmdbTitle> titles;
  final TmdbListService listProvider;

  const TitleList({
    super.key,
    required this.titles,
    required this.listProvider,
  });

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  final FocusNode _searchFocusNode = FocusNode();
  int _updatingTitleId = 0;
  bool _isSortAsc = true;
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
      localizations.sortReleaseDate,
      localizations.sortRuntime,
    ];
  }

  void _retrieveGenresFromTitles() {
    _genresList = widget.titles
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
          b.rating.compareTo(a.rating),
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
    return dateA.compareTo(dateB);
  }

  int _compareRuntimes(TmdbTitle a, TmdbTitle b) {
    if (a.mediaType == 'movie' && b.mediaType == 'movie') {
      return a.runtime.compareTo(b.runtime);
    } else if (a.mediaType == 'movie') {
      return -1;
    } else if (b.mediaType == 'movie') {
      return 1;
    } else {
      return a.numberOfEpisodes.compareTo(b.numberOfEpisodes);
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
    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: false);

    return Flexible(
      child: ListView.builder(
        key: const PageStorageKey('TitleListView'),
        shrinkWrap: true,
        itemCount: titles.length,
        itemBuilder: (context, index) {
          final TmdbTitle title = titles[index];

          return FutureBuilder<TmdbTitle>(
            future: widget.listProvider.updateTitleDetails(
              userService.accountId,
              title,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  !snapshot.hasData) {
                return TitleCard(
                    context: context,
                    title: TmdbTitle(title: {}),
                    isUpdatingWatchlist: false,
                    onWatchlistPressed: (isInWatchlist) {});
              }

              final updatedTitle = snapshot.data!;

              return TitleCard(
                context: context,
                title: updatedTitle,
                isUpdatingWatchlist: _updatingTitleId == updatedTitle.id,
                onWatchlistPressed: (isInWatchlist) {
                  setState(() {
                    _updatingTitleId = updatedTitle.id;
                  });
                  Provider.of<TmdbWatchlistService>(context, listen: false)
                      .updateWatchlistTitle(
                    userService.accountId,
                    userService.sessionId,
                    updatedTitle,
                    !isInWatchlist,
                  )
                      .then((value) async {
                    setState(() {
                      _updatingTitleId = 0;
                    });
                  }).catchError((error) {
                    setState(() {
                      _updatingTitleId = 0;
                    });
                    SnackMessage.showSnackBar(error.toString());
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _controlPanel() {
    return TitleListControlPanel(
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
    );
  }

  Widget _infoLine(int count) {
    String sortBy = _selectedSort;
    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );

    String titleCountText = '$count ${AppLocalizations.of(context)!.titles}';

    if (_selectedType == AppLocalizations.of(context)!.tvshows) {
      titleCountText = '$count ${AppLocalizations.of(context)!.tvshows}';
    } else if (_selectedType == AppLocalizations.of(context)!.movies) {
      titleCountText = '$count ${AppLocalizations.of(context)!.movies}';
    }
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleCountText,
            style: textStyle,
          ),
          Row(
            children: [
              Text(
                sortBy,
                style: textStyle,
              ),
              _isSortAsc
                  ? Icon(
                      Icons.arrow_drop_up,
                      color: textStyle.color,
                    )
                  : Icon(
                      Icons.arrow_drop_down,
                      color: textStyle.color,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  List<TmdbTitle> _filterTitles() {
    List<TmdbTitle> titles = widget.titles;

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
    List<Widget> children = List.empty(growable: true);

    if (widget.titles.isNotEmpty) {
      List<TmdbTitle> filteredTitles = _filterTitles();
      children = [
        _controlPanel(),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        _infoLine(filteredTitles.length),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        _titleList(filteredTitles),
      ];
    }

    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
