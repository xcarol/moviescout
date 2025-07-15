import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/widgets/title_list.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FocusNode _searchFocusNode = FocusNode();
  late TextEditingController _controller;
  late List<TmdbTitle> searchTitles = List.empty();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && _searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TmdbTitleService().updateTitles(searchTitles),
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            searchBox(),
            searchResults(),
          ],
        );
      },
    );
  }

  resetTitle() {
    _controller.clear();
    setState(() {
      searchTitles = List.empty();
    });
  }

  Widget searchBox() {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onPrimary;
    final borderColor = colorScheme.onPrimary;

    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: TextField(
        controller: _controller,
        focusNode: _searchFocusNode,
        style: TextStyle(color: textColor),
        cursorColor: borderColor,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: TextStyle(color: textColor),
          suffixIconColor: textColor,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: resetTitle,
            tooltip: AppLocalizations.of(context)!.search,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
        ),
        onChanged: (title) {
          searchTitle(context, title);
        },
      ),
    );
  }

  Widget searchResults() {
    return TitleList(TmdbListService('searchProvider', titles: searchTitles));
  }

  void searchTitle(BuildContext context, String title) async {
    try {
      final result = await TmdbSearchService()
          .searchTitle(title, Localizations.localeOf(context));
      setState(() {
        searchTitles = result;
      });
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    }
  }
}
