import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_controls.dart';
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
  late String selectedType;
  late List<String> titleTypes;
  late String selectedSort;
  late List<String> titleSorts;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    selectedType = AppLocalizations.of(context)!.allTypes;
    titleTypes = [
      AppLocalizations.of(context)!.allTypes,
      AppLocalizations.of(context)!.movies,
      AppLocalizations.of(context)!.tvshows,
    ];
    selectedSort = AppLocalizations.of(context)!.sortAlphabetically;
    titleSorts = [
      AppLocalizations.of(context)!.sortAlphabetically,
      AppLocalizations.of(context)!.sortRating,
      AppLocalizations.of(context)!.sortReleaseDate,
      AppLocalizations.of(context)!.sortRuntime,
    ];
  }

  Widget titleList() {
    List<TmdbTitle> filteredTitles = widget.titles;
    if (selectedType != AppLocalizations.of(context)!.allTypes) {
      filteredTitles = widget.titles
          .where((title) =>
              (title.mediaType == 'movie' &&
                  selectedType == AppLocalizations.of(context)!.movies) ||
              (title.mediaType == 'tv' &&
                  selectedType == AppLocalizations.of(context)!.tvshows))
          .toList();
    }

    List<TmdbTitle> sortedTitles = filteredTitles;
    if (selectedSort == AppLocalizations.of(context)!.sortAlphabetically) {
      sortedTitles.sort((a, b) => a.name.compareTo(b.name));
    } else if (selectedSort == AppLocalizations.of(context)!.sortRating) {
      sortedTitles.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    } else if (selectedSort == AppLocalizations.of(context)!.sortReleaseDate) {
      sortedTitles.sort((a, b) {
        if (a.mediaType == 'movie') {
          return b.releaseDate.compareTo(a.releaseDate);
        } else {
          return b.firstAirDate.compareTo(a.firstAirDate);
        }
      });
    } else if (selectedSort == AppLocalizations.of(context)!.sortRuntime) {
      sortedTitles.sort((a, b) {
        if (a.mediaType == 'movie') {
          return b.runtime.compareTo(a.runtime);
        } else {
          return b.numberOfEpisodes.compareTo(a.numberOfEpisodes);
        }
      });
    }

    return Expanded(
      child: ListView.builder(
        key: PageStorageKey('TitleListView'),
        itemCount: sortedTitles.length,
        itemBuilder: (context, index) {
          final TmdbTitle title = sortedTitles[index];
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleListControls(
              selectedType: selectedType,
              listTypes: titleTypes,
              typeChanged: (typeChanged) {
                setState(() {
                  selectedType = typeChanged;
                });
              },
              selectedSort: selectedSort,
              listSorts: titleSorts,
              sortChanged: (sortChanged) {
                setState(() {
                  selectedSort = sortChanged;
                });
              }),
          titleList(),
        ],
      ),
    );
  }
}
