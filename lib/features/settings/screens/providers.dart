import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/models/tmdb_provider.dart';
import 'package:moviescout/features/settings/services/tmdb_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';
import 'package:moviescout/core/widgets/text_filter_widget.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  bool _providersChanged = false;
  String? _lastCountryCode;
  List<MapEntry<int, Map<String, String>>> _sortedProviders = [];
  List<MapEntry<int, Map<String, String>>> _filteredProviders = [];

  final TextEditingController _textFilterController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _normalize(String s) => removeDiacritics(s.toLowerCase());

  @override
  void dispose() {
    _textFilterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applyLocalFilter([String? filterText]) {
    final text = filterText ?? _textFilterController.text;
    final query = _normalize(text);

    if (query.isEmpty) {
      _filteredProviders = _sortedProviders;
    } else {
      _filteredProviders = _sortedProviders.where((entry) {
        final providerName = entry.value[TmdbProvider.providerName] ?? '';
        return _normalize(providerName).contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<TmdbProviderService>(context);
    final map = providerService.providers;
    final countryCode = providerService.getCountryCode();

    if (_lastCountryCode != countryCode) {
      _lastCountryCode = countryCode;
      _sortedProviders = [];
      _filteredProviders = [];
    }

    if (_sortedProviders.isEmpty && map.isNotEmpty) {
      _sortedProviders = map.entries.where((entry) {
        String providerName = entry.value[TmdbProvider.providerName] ?? '';
        String logoPath = entry.value[TmdbProvider.logoPathName] ?? '';
        return providerName.isNotEmpty && logoPath.isNotEmpty;
      }).toList()
        ..sort((a, b) {
          final aName = a.value[TmdbProvider.providerName] ?? '';
          final bName = b.value[TmdbProvider.providerName] ?? '';
          return _normalize(aName).compareTo(_normalize(bName));
        });
      _applyLocalFilter();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_providersChanged && didPop) {
          providerService.applyProvidersFilter();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.providersTitle),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              color: Theme.of(context)
                  .extension<TitleListTheme>()
                  ?.controlPanelBackground,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppBreakpoints.maxContentWidth,
                  ),
                  child: TextFilterWidget(
                    controller: _textFilterController,
                    focusNode: _focusNode,
                    hintText: AppLocalizations.of(context)!.searchProvider,
                    height: AppSizes.filterControlHeight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _applyLocalFilter(value);
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppBreakpoints.maxContentWidth,
                  ),
                  child: _body(context, providerService),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, TmdbProviderService providerService) {
    if (providerService.isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_sortedProviders.isEmpty || _filteredProviders.isEmpty) {
      return AppEmptyState(
        icon: Icons.tv_off_outlined,
        message: AppLocalizations.of(context)!.noProvidersAvailable,
      );
    }

    return ListView.builder(
      itemCount: _filteredProviders.length,
      itemBuilder: (context, index) {
        final provider = _filteredProviders[index];
        return SwitchListTile(
          title: Text(provider.value[TmdbProvider.providerName] ?? ''),
          value: provider.value[TmdbProvider.providerEnabled] == 'true',
          onChanged: (value) => setState(() {
            providerService.toggleProvider(provider.key, value);
            _providersChanged = true;
          }),
        );
      },
    );
  }
}
