import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class TitlePeopleList extends StatefulWidget {
  final TmdbTitle title;
  const TitlePeopleList({super.key, required this.title});

  @override
  State<TitlePeopleList> createState() => _TitlePeopleListState();
}

class _TitlePeopleListState extends State<TitlePeopleList> {
  late Widget _personlistWidget;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _personlistWidget = const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: '${widget.title.name} ${AppLocalizations.of(context)!.cast}',
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: body(),
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_personlistWidget],
    );
  }
}
