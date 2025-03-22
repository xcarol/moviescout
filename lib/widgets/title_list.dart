import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:provider/provider.dart';

class TitleList extends StatefulWidget {
  final List titles;

  const TitleList({
    super.key,
    required this.titles,
  });

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  int updatingTitleId = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        key: PageStorageKey('TitleListView'),
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          final TmdbTitle title = widget.titles[index];
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
              });
        },
      ),
    );
  }
}
