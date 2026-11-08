import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/services/search_history_service.dart';
import 'package:moviescout/features/discovery/services/search_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/core/widgets/item_list.dart';
import 'package:moviescout/features/titles/repositories/local_title_repository.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/features/settings/widgets/ai_model_thinking_selector.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FocusNode _searchFocusNode = FocusNode();
  late TextEditingController _controller;
  late SearchService _searchService;
  late TmdbTitleListService _titleListServiceSupport;
  final SearchHistoryService _historyService = SearchHistoryService();
  late Widget _searchWidget;
  String _previousText = '';
  String _lastSearchedText = '';
  bool? _lastSearchedAiMode;
  Timer? _debounce;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final String _searchGroupId = 'search_overlay_group';
  final double _searchHorizontalPadding = 8.0;
  final double _searchVerticalPadding = 16.0;
  final double _overlayHeightOffset = 65.0;
  List<String> _overlaySuggestions = [];
  bool _isAiMode = false;
  String? _selectedAiModel;
  String? _selectedThinkingLevel;

  StateSetter? _overlaySetState;

  @override
  void initState() {
    super.initState();
    _titleListServiceSupport = TmdbTitleListService(
      AppConstants.searchList,
      LocalTitleRepository.instance,
    );
    _searchService = SearchService(
      AppConstants.searchList,
      LocalTitleRepository.instance,
    );
    _searchWidget = ItemList(
      _searchService,
      titleListServiceSupport: _titleListServiceSupport,
      key: const ValueKey('search'),
    );

    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    _historyService.load();
    _searchService.clearList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _controller.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _searchFocusNode.dispose();
    _titleListServiceSupport.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _onSearchChanged() {
    final text = _controller.text;

    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    }

    if (text == _previousText) return;

    if (text.isNotEmpty && text.length > _previousText.length) {
      final suggestions = _historyService.getSuggestions(text);
      if (suggestions.isNotEmpty) {
        final bestMatch = suggestions.first;
        if (bestMatch.toLowerCase().startsWith(text.toLowerCase()) &&
            bestMatch.length > text.length) {
          _controller.value = TextEditingValue(
            text: bestMatch,
            selection: TextSelection(
              baseOffset: text.length,
              extentOffset: bestMatch.length,
            ),
          );
        }
      }
    }
    _previousText = _controller.text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (text.length >= 3) {
      if (!_isAiMode) {
        _debounce = Timer(const Duration(milliseconds: 300), () {
          if (mounted) {
            searchTitle(_controller.text);
          }
        });
      }
    } else if (text.isEmpty) {
      _resetLastSearch();
      _resetTitle();
    }
  }

  void _showOverlay() {
    final text = _controller.text.trim();
    final suggestions = _historyService.getSuggestions(text);
    _overlaySuggestions = text.isEmpty
        ? suggestions.take(5).toList()
        : suggestions
            .where((s) => s.toLowerCase() != text.toLowerCase())
            .take(5)
            .toList();

    if (_overlaySuggestions.isEmpty) {
      _removeOverlay();
      return;
    }

    if (_overlayEntry != null) {
      _overlaySetState?.call(() {});
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width:
              MediaQuery.sizeOf(context).width - _searchHorizontalPadding * 2,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(_searchHorizontalPadding, _overlayHeightOffset),
            child: TapRegion(
              groupId: _searchGroupId,
              child: StatefulBuilder(
                builder: (context, setOverlayState) {
                  _overlaySetState = setOverlayState;
                  return Material(
                    elevation: 4.0,
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
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () async {
                              await _historyService.delete(suggestion);
                              if (mounted) {
                                _showOverlay();
                              }
                            },
                          ),
                          onTap: () {
                            _controller.text = suggestion;
                            _removeOverlay();
                            searchTitle(suggestion);
                          },
                        );
                      },
                    ),
                  );
                },
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
    _overlaySetState = null;
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
          _removeOverlay();
          _searchFocusNode.unfocus();
        },
        child: Column(
          children: <Widget>[
            TapRegion(
              groupId: _searchGroupId,
              onTapOutside: (event) {
                _removeOverlay();
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

  void _resetLastSearch() {
    _lastSearchedText = '';
    _lastSearchedAiMode = null;
  }

  Future<void> _resetTitle({bool clearText = false}) async {
    if (clearText) {
      _controller.clear();
      _previousText = '';
      _resetLastSearch();
      _removeOverlay();
    }
    await _searchService.clearList();
  }

  Widget searchBox() {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onSurface;
    final borderColor = colorScheme.onSurface;

    return Container(
      color: colorScheme.secondary,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _searchHorizontalPadding,
        vertical: _searchVerticalPadding,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: textColor.withValues(alpha: 0.5),
            selectionHandleColor: textColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _searchFocusNode,
                    style: TextStyle(color: textColor),
                    cursorColor: borderColor,
                    minLines: _isAiMode ? 2 : 1,
                    maxLines: _isAiMode ? 2 : 1,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: _isAiMode
                          ? AppLocalizations.of(context)!.searchAiHint
                          : AppLocalizations.of(context)!.searchBarHint,
                      hintStyle: TextStyle(color: textColor),
                      suffixIconColor: textColor,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () async =>
                                await _resetTitle(clearText: true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.auto_awesome,
                              color: _isAiMode
                                  ? colorScheme.tertiary
                                  : textColor.withValues(alpha: 0.5),
                              size: 24,
                            ),
                            tooltip:
                                AppLocalizations.of(context)!.searchAiTooltip,
                            onPressed: () {
                              if (!AiService().hasApiKey) {
                                context.toAiSettings().then((_) {
                                  if (AiService().hasApiKey) {
                                    setState(() {
                                      _isAiMode = true;
                                      _resetLastSearch();
                                    });
                                  }
                                });
                              } else {
                                setState(() {
                                  _isAiMode = !_isAiMode;
                                  _resetLastSearch();
                                });
                              }
                            },
                          ),
                        ],
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
                      searchTitle(title);
                    },
                  ),
                ),
              ],
            ),
            if (_isAiMode) ...[
              const SizedBox(height: 8),
              AiModelThinkingSelector(
                selectedModel: _selectedAiModel,
                selectedThinkingLevel: _selectedThinkingLevel,
                borderColor: borderColor,
                textColor: textColor,
                onChanged: (model, thinkingLevel) {
                  setState(() {
                    _selectedAiModel = model;
                    _selectedThinkingLevel = thinkingLevel;
                    _resetLastSearch();
                  });
                },
                onRefresh: () {
                  _resetLastSearch();
                  searchTitle(_controller.text);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget searchResults() {
    return Expanded(child: _searchWidget);
  }

  void searchTitle(String title) async {
    final term = title.trim();
    if (term.isEmpty) return;

    _removeOverlay();

    final locale = Localizations.localeOf(context);

    await _historyService.add(term);

    if (!mounted) return;

    if (term == _lastSearchedText && _lastSearchedAiMode == _isAiMode) return;

    _lastSearchedText = term;
    _lastSearchedAiMode = _isAiMode;

    await _resetTitle();
    try {
      if (_isAiMode) {
        await _searchService.retrieveAiSearchlist(
          term,
          locale,
          model: _selectedAiModel,
          thinkingLevel: _selectedThinkingLevel,
        );
      } else {
        await _searchService.retrieveSearchlist(term, locale);
      }
    } on TimeoutException catch (e, stackTrace) {
      _resetLastSearch();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: _isAiMode ? 'AI search timeout' : 'Search timeout',
      );
      if (mounted) {
        SnackMessage.showSnackBar(
          _isAiMode
              ? AppLocalizations.of(context)!.aiSearchTimeout
              : AppLocalizations.of(context)!.searchTimeout,
          context: context,
        );
      }
    } on AiRateLimitException catch (e, stackTrace) {
      _resetLastSearch();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'AI search rate limited: ${e.rawMessage}',
      );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final msg = e.retrySeconds != null && e.retrySeconds! > 0
            ? l10n.aiRateLimitWithSeconds(e.retrySeconds!)
            : l10n.aiRateLimitGeneric;
        SnackMessage.showSnackBar(msg, context: context);
      }
    } on AiApiException catch (e, stackTrace) {
      _resetLastSearch();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'AI API error (${e.statusCode}): ${e.message}',
      );
      if (mounted) {
        SnackMessage.showSnackBar(e.message, context: context);
      }
    } catch (e, stackTrace) {
      _resetLastSearch();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: _isAiMode ? 'AI search error: $e' : 'Search error',
      );
      if (_isAiMode && mounted) {
        final l10n = AppLocalizations.of(context)!;
        final isKeyMissing = e.toString().contains('not configured');
        SnackMessage.showSnackBar(
          isKeyMissing ? l10n.aiStatusNotConfigured : l10n.aiSearchError,
          context: context,
        );
      }
    }
    await _titleListServiceSupport.updateListGenres();
    _searchService.listGenres.value = _titleListServiceSupport.listGenres.value;
  }
}
