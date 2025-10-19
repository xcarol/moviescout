import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.providersTitle,
      ),
      drawer: AppDrawer(),
      body: Center(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    List<Widget> providerWidgets = [];

    for (var provider in TmdbProviderService().providers.entries) {
      String providerName = provider.value[TmdbProvider.providerName] ?? '';
      String logoPath = provider.value[TmdbProvider.logoPathName] ?? '';

      if (providerName.isNotEmpty && logoPath.isNotEmpty) {
        providerWidgets.add(
          SwitchListTile(
            title: Text(providerName),
            activeThumbColor: Theme.of(context).colorScheme.primary,
            value: provider.value[TmdbProvider.providerEnabled] == 'true',
            onChanged: (value) => setState(() {
              TmdbProviderService().toggleProvider(provider.key, value);
            }),
          ),
        );
      }
    }

    String norm(String s) => removeDiacritics(s.toLowerCase());

    providerWidgets.sort((a, b) {
      if (a is SwitchListTile && b is SwitchListTile) {
        final at = (a.title as Text).data ?? '';
        final bt = (b.title as Text).data ?? '';
        return norm(at).compareTo(norm(bt));
      }
      return 0;
    });

    if (providerWidgets.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noProvidersAvailable),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: providerWidgets,
      ),
    );
  }
}
