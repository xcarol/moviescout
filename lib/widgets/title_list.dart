import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_genre.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';

class TitleList extends StatefulWidget {
  final List<TmdbTitle> titles;

  const TitleList({
    super.key,
    required this.titles,
  });

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  int updatingTitleId = 0;
  bool isSortAsc = true;
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
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    selectedType = AppLocalizations.of(context)!.allTypes;
    titleTypes = [
      AppLocalizations.of(context)!.allTypes,
      AppLocalizations.of(context)!.movies,
      AppLocalizations.of(context)!.tvshows,
    ];
    textFilter = '';
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

  void _sortTitles(List<TmdbTitle> titles) {
    final ascending = isSortAsc ? 1 : -1;

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

    titles.sort(
        (a, b) => ascending * (sortFunctions[selectedSort]?.call(a, b) ?? 0));
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

  Widget _titleList() {
    List<TmdbTitle> titles = widget.titles;

    if (selectedType != AppLocalizations.of(context)!.allTypes) {
      titles = widget.titles
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

    _sortTitles(titles);
    titles = _filterGenres(titles);

    return Expanded(
      child: ListView.builder(
        key: PageStorageKey('TitleListView'),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          final TmdbTitle title = titles[index];
          final bool isInWatchlist =
              Provider.of<TmdbWatchlistService>(context, listen: false)
                  .userWatchlist
                  .any((t) => t.id == title.id);
          return TitleCard(
            context: context,
            title: title,
            isUpdating: updatingTitleId == title.id,
            isInWatchlist: isInWatchlist,
            onPressed: () {
              setState(() {
                updatingTitleId = title.id;
              });
              Provider.of<TmdbWatchlistService>(context, listen: false)
                  .updateWatchlistTitle(
                      Provider.of<TmdbUserService>(context, listen: false)
                          .accountId,
                      title,
                      !isInWatchlist)
                  .then((value) async {
                setState(() {
                  updatingTitleId = 0;
                });
              }).catchError((error) {
                setState(() {
                  updatingTitleId = 0;
                });
                SnackMessage.showSnackBar(error.toString());
              });
            },
          );
        },
      ),
    );
  }

  Widget _listControlPanel() {
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
          isSortAsc = !isSortAsc;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.titles.isNotEmpty) _listControlPanel(),
          if (widget.titles.isNotEmpty) const Divider(),
          if (widget.titles.isNotEmpty) _titleList(),
        ],
      ),
    );
  }
}
