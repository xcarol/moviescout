import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_genre.dart';
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
  int _updatingTitleId = 0;
  bool _isSortAsc = true;
  final FocusNode _searchFocusNode = FocusNode();
  late String selectedType;
  late List<String> titleTypes;
  late String textFilter;
  late String selectedSort;
  late List<String> titleSorts;
  late List<String> selectedGenres;
  late List<String> genresList;
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
    selectedType = AppLocalizations.of(context)!.allTypes;
    titleTypes = [
      AppLocalizations.of(context)!.allTypes,
      AppLocalizations.of(context)!.movies,
      AppLocalizations.of(context)!.tvshows,
    ];
    textFilter = _textFilterController.text;
    selectedGenres = [];
    genresList = [];
    for (TmdbTitle title in widget.titles) {
      for (TmdbGenre genre in title.genres) {
        if (!genresList.contains(genre.name)) {
          genresList.add(genre.name);
        }
      }
    }
    selectedSort = AppLocalizations.of(context)!.sortAlphabetically;
    titleSorts = [
      AppLocalizations.of(context)!.sortAlphabetically,
      AppLocalizations.of(context)!.sortRating,
      AppLocalizations.of(context)!.sortReleaseDate,
      AppLocalizations.of(context)!.sortRuntime,
    ];
  }

  List<TmdbTitle> _sortTitles(List<TmdbTitle> titles) {
    final ascending = _isSortAsc ? 1 : -1;
    final titlesToSort = titles;

    final sortFunctions = {
      AppLocalizations.of(context)!.sortAlphabetically:
          (TmdbTitle a, TmdbTitle b) => a.name.compareTo(b.name),
      AppLocalizations.of(context)!.sortRating: (TmdbTitle a, TmdbTitle b) =>
          b.voteAverage.compareTo(a.voteAverage),
      AppLocalizations.of(context)!.sortReleaseDate:
          (TmdbTitle a, TmdbTitle b) => _compareReleaseDates(a, b),
      AppLocalizations.of(context)!.sortRuntime: (TmdbTitle a, TmdbTitle b) =>
          _compareRuntimes(a, b),
    };

    titlesToSort.sort(
        (a, b) => ascending * (sortFunctions[selectedSort]?.call(a, b) ?? 0));

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
    if (selectedGenres.isEmpty) {
      return titles;
    }

    return titles
        .where((title) =>
            title.genres.any((genre) => selectedGenres.contains(genre.name)))
        .toList();
  }

  Widget _titleList(List<TmdbTitle> titles) {
    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: false);

    return Expanded(
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
              TmdbUserService userService =
                  Provider.of<TmdbUserService>(context, listen: false);

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
      selectedType: selectedType,
      typesList: titleTypes,
      typeChanged: (typeChanged) {
        setState(() {
          selectedType = typeChanged;
        });
      },
      textFilterChanged: (newTextFilter) {
        setState(() {
          textFilter = newTextFilter;
        });
      },
      textFilterController: _textFilterController,
      selectedGenres: selectedGenres.toList(),
      genresList: genresList,
      genresChanged: (List<String> genresChanged) {
        setState(() {
          selectedGenres = genresChanged.toList();
        });
      },
      selectedSort: selectedSort,
      sortsList: titleSorts,
      sortChanged: (sortChanged) {
        setState(() {
          selectedSort = sortChanged;
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
    String sortBy = selectedSort;
    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );

    String titleCountText = '$count ${AppLocalizations.of(context)!.titles}';

    if (selectedType == AppLocalizations.of(context)!.tvshows) {
      titleCountText = '$count ${AppLocalizations.of(context)!.tvshows}';
    } else if (selectedType == AppLocalizations.of(context)!.movies) {
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

    if (selectedType != AppLocalizations.of(context)!.allTypes) {
      titles = titles
          .where((title) =>
              (title.mediaType == 'movie' &&
                  selectedType == AppLocalizations.of(context)!.movies) ||
              (title.mediaType == 'tv' &&
                  selectedType == AppLocalizations.of(context)!.tvshows))
          .toList();
    }

    if (textFilter.isNotEmpty) {
      titles = titles
          .where((title) =>
              title.name.toLowerCase().contains(textFilter.toLowerCase()))
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
