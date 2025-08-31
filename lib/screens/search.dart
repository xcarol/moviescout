import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/widgets/title_list.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FocusNode _searchFocusNode = FocusNode();
  late TextEditingController _controller;
  final TmdbListService _listService = TmdbListService('searchProvider');
  late String _currentSearchTerm;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _listService.clearListSync();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        searchBox(),
        searchResults(),
      ],
    );
  }

  _resetTitle() {
    _controller.clear();
    setState(() {
      _listService.clearList();
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
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: textColor.withValues(alpha: 0.5),
          ),
        ),
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
              onPressed: _resetTitle,
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
      ),
    );
  }

  Widget searchResults() {
    return ChangeNotifierProvider.value(
      value: _listService,
      child: Consumer<TmdbListService>(
        builder: (context, listService, _) {
          return TitleList(listService);
        },
      ),
    );
  }

  void searchTitle(BuildContext context, String title) async {
    _currentSearchTerm = title;
    final term = title;

    try {
      final result = await TmdbSearchService()
          .searchTitle(term, Localizations.localeOf(context));

      if (_currentSearchTerm != term) {
        return;
      }

      await TmdbTitleService().updateTitles(result);

      if (_currentSearchTerm == term) {
        await _listService.setLocalTitles(result);
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      if (mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    }
  }
}
