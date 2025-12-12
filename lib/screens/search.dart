import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/search_history_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
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
  final TmdbSearchService _searchService = TmdbSearchService('searchProvider');
  final SearchHistoryService _historyService = SearchHistoryService();
  late Widget _searchWidget;
  String _previousText = '';

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final String _searchGroupId = 'search_overlay_group';
  List<String> _overlaySuggestions = [];

  @override
  void initState() {
    super.initState();
    _searchWidget = TitleList(
      _searchService,
      key: ValueKey('watchlist'),
    );
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    _historyService.load();
    _searchService.clearListSync();
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      // Only show if we have text
      if (_controller.text.isNotEmpty) {
        _showOverlay();
      }
    }
    // Do NOT remove overlay here on focus loss.
    // This allows interactions with the overlay (which causes focus loss) to complete.
    // We handle closing via TapRegion.
  }

  void _onSearchChanged() {
    final text = _controller.text;

    // Manage overlay
    if (text.isNotEmpty && _searchFocusNode.hasFocus) {
      _showOverlay();
    } else {
      // If we cleared the text, remove overlay
      if (text.isEmpty) {
        _removeOverlay();
      }
    }

    if (text == _previousText) return;

    if (text.isNotEmpty && text.length > _previousText.length) {
      final suggestions = _historyService.getSuggestions(text);
      if (suggestions.isNotEmpty) {
        final bestMatch = suggestions.first;
        if (bestMatch.toLowerCase().startsWith(text.toLowerCase()) &&
            bestMatch.length > text.length) {
          // Identify the casing of the user's input to preserve it if we wanted,
          // but typically autocomplete completes with the stored casing.
          // We must respect the case of the stored history item.

          _controller.value = TextEditingValue(
            text: bestMatch,
            selection: TextSelection(
              baseOffset: text.length,
              extentOffset: bestMatch.length,
            ),
          );
          // Update _previousText to the new value to avoid re-triggering logic loop
          // although strict equality check at start handles it too.
        }
      }
    }
    _previousText = _controller.text;
  }

  void _showOverlay() {
    final text = _controller.text;
    final suggestions = _historyService.getSuggestions(text);
    // Filter out if the only suggestion is exactly what is typed (case insensitive check)
    _overlaySuggestions = suggestions
        .where((s) => s.toLowerCase() != text.toLowerCase())
        .take(5)
        .toList();

    if (_overlaySuggestions.isEmpty) {
      _removeOverlay();
      return;
    }

    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width -
              32, // Adjust based on padding (16*2)
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0.0, 60.0), // Height of search box approx
            child: TapRegion(
              groupId: _searchGroupId,
              child: Material(
                elevation: 4.0,
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _overlaySuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _overlaySuggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(suggestion),
                      onTap: () {
                        _controller.text = suggestion;
                        _removeOverlay();
                        searchTitle(context, suggestion);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
    return ChangeNotifierProvider.value(
      value: _searchService,
      child: GestureDetector(
        onTap: () {
          // If we tap strictly on the background column, close overlay and unfocus
          _removeOverlay();
          _searchFocusNode.unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TapRegion(
              groupId: _searchGroupId,
              onTapOutside: (event) {
                // Close overlay and unfocus if tapping outside both searchbox and overlay
                _removeOverlay();
                _searchFocusNode.unfocus();
              },
              child: CompositedTransformTarget(
                link: _layerLink,
                child: searchBox(),
              ),
            ),
            searchResults(),
          ],
        ),
      ),
    );
  }

  _resetTitle({bool clearText = false}) {
    if (clearText) {
      _controller.clear();
      _previousText = '';
      _removeOverlay();
    }
    _searchService.clearListSync();
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
        child: Row(
          children: [
            Expanded(
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
                    onPressed: () => _resetTitle(clearText: true),
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
                onSubmitted: (title) {
                  searchTitle(context, title);
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => searchTitle(context, _controller.text),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchResults() {
    return Consumer<TmdbSearchService>(
      builder: (context, listService, _) {
        return _searchWidget;
      },
    );
  }

  void searchTitle(BuildContext context, String title) async {
    final term = title;

    if (term.isNotEmpty) {
      // Add to history without awaiting to not block UI
      _historyService.add(term);
    }

    try {
      _resetTitle();
      await _searchService.retrieveSearchlist(
          anonymousAccountId, term, Localizations.localeOf(context));
    } catch (error) {
      if (mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    }
  }
}
