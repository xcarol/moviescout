import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/settings/nlu_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class NluSettingsScreen extends StatelessWidget {
  const NluSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nluSettingsTitle),
      ),
      body: Consumer<NluService>(
        builder: (context, nluService, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                l10n.nluSettingsDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nluSettingsStatus(nluService.assetsDownloaded
                            ? l10n.nluSettingsStatusDownloaded
                            : l10n.nluSettingsStatusNotDownloaded),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.nluSettingsFilesCount(
                          nluService.downloadedFilesCount,
                          nluService.totalFilesCount)),
                      const SizedBox(height: 16),
                      if (nluService.isDownloading)
                        _buildDownloadingState(l10n, nluService)
                      else if (nluService.assetsDownloaded)
                        _buildDeleteButton(context, l10n, nluService)
                      else
                        _buildDownloadButton(context, l10n, nluService),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.nluSettingsUpdateConfig,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.nluSettingsAutoUpdate),
                subtitle: Text(l10n.nluSettingsAutoUpdateSubtitle),
                value: nluService.autoUpdate,
                onChanged: (value) {
                  nluService.setAutoUpdate(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, NluService nluService, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.nluSettingsDeleteFiles),
        content: Text(l10n.nluSettingsDeleteConfirmation),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              nluService.deleteAssets();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadingState(AppLocalizations l10n, NluService nluService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${l10n.nluSettingsDownloading} ${(nluService.downloadProgress * 100).toInt()}%'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: nluService.downloadProgress),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: () {
              nluService.cancelDownload();
            },
            icon: const Icon(Icons.cancel),
            label: Text(l10n.nluSettingsCancelDownload),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(
      BuildContext context, AppLocalizations l10n, NluService nluService) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          _showDeleteConfirmation(context, nluService, l10n);
        },
        icon: const Icon(Icons.delete),
        label: Text(l10n.nluSettingsDeleteFiles),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
      BuildContext context, AppLocalizations l10n, NluService nluService) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          nluService.downloadAssets();
        },
        icon: const Icon(Icons.download),
        label: Text(l10n.nluSettingsDownloadNow),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
