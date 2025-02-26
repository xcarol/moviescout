import 'package:flutter/material.dart';
import 'package:moviescout/services/google.dart';
import 'package:moviescout/widgets/title_card.dart';

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
          final bool isInWatchlist = GoogleService.instance.userWatchlist
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
                GoogleService.instance
                    .updateWatchlistTitle(context, title, !isInWatchlist)
                    .then((value) async {
                  setState(() {
                    updatingTitle = {};
                  });
                });
              });
        },
      ),
    );
  }
}
