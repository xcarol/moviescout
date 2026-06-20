import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/text_filter_widget.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  bool _providersChanged = false;
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
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    final map = providerService.providers;

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Theme.of(context)
                  .extension<TitleListTheme>()
                  ?.controlPanelBackground,
              child: TextFilterWidget(
                controller: _textFilterController,
                focusNode: _focusNode,
                hintText: AppLocalizations.of(context)!.searchProvider,
                height: 36,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                onChanged: (String value) {
                  setState(() {
                    _applyLocalFilter(value);
                  });
                },
              ),
            ),
            Expanded(child: _body(context, providerService)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, TmdbProviderService providerService) {
    if (_sortedProviders.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noProvidersAvailable),
      );
    }

    if (_filteredProviders.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noProvidersAvailable),
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
