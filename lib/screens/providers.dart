import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  bool _providersChanged = false;
  List<MapEntry<int, Map<String, String>>> _sortedProviders = [];

  String _normalize(String s) => removeDiacritics(s.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    final map = providerService.providers;

    if (_sortedProviders.isEmpty) {
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
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_providersChanged && didPop) {
          providerService.applyProvidersFilter();
        }
      },
      child: Scaffold(
        appBar: MainAppBar(
          context: context,
          title: AppLocalizations.of(context)!.providersTitle,
        ),
        drawer: AppDrawer(),
        body: Center(child: _body(context, providerService)),
      ),
    );
  }

  Widget _body(BuildContext context, TmdbProviderService providerService) {
    if (_sortedProviders.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noProvidersAvailable),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _sortedProviders
            .map(
              (provider) => SwitchListTile(
                title: Text(provider.value[TmdbProvider.providerName] ?? ''),
                activeThumbColor: Theme.of(context).colorScheme.primary,
                value: provider.value[TmdbProvider.providerEnabled] == 'true',
                onChanged: (value) => setState(() {
                  providerService.toggleProvider(provider.key, value);
                  _providersChanged = true;
                }),
              ),
            )
            .toList(),
      ),
    );
  }
}
