import 'package:flutter/material.dart';
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
  Map updatingTitle = {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          final title = widget.titles[index];
          final bool isInWatchlist =
              Provider.of<TmdbWatchlistService>(context, listen: false)
                  .userWatchlist
                  .any((t) => t['id'] == title['id']);
          return TitleCard(
              context: context,
              title: title,
              isUpdating: updatingTitle == title,
              isInWatchlist: isInWatchlist,
              onPressed: () {
                setState(() {
                  updatingTitle = title;
                });
                // TmdbTitleService()
                //     .updateWatchlistTitle(context, title, !isInWatchlist)
                //     .then((value) async {
                //   setState(() {
                //     updatingTitle = {};
                //   });
                // });
              });
        },
      ),
    );
  }
}
