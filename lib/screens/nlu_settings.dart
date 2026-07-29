import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/settings/nlu_service.dart';

class NluSettingsScreen extends StatelessWidget {
  const NluSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerca Intel·ligent (IA)'),
      ),
      body: Consumer<NluService>(
        builder: (context, nluService, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'La cerca intel·ligent permet cercar pel·lícules utilitzant llenguatge natural. '
                'Per poder fer-ho de forma privada i sense connexió, cal descarregar uns fitxers.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estat: ${nluService.assetsDownloaded ? "Descarregats" : "No descarregats"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('Mida ocupada: ${nluService.downloadedSize}'),
                      const SizedBox(height: 16),
                      if (nluService.isDownloading) ...[
                        const Text('Descarregant...'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: nluService.downloadProgress),
                      ] else if (nluService.assetsDownloaded) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteConfirmation(context, nluService);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Eliminar fitxers'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              nluService.downloadAssets();
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Descarregar ara (120 MB)'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Configuració de descàrregues',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Només per Wi-Fi'),
                subtitle: const Text('Evita utilitzar dades mòbils per les descàrregues'),
                value: nluService.wifiOnly,
                onChanged: (value) {
                  nluService.setWifiOnly(value);
                },
              ),
              SwitchListTile(
                title: const Text('Actualitzacions automàtiques'),
                subtitle: const Text('Comprova i descarrega nous títols automàticament en segon pla'),
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

  void _showDeleteConfirmation(BuildContext context, NluService nluService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar fitxers'),
        content: const Text('Estàs segur que vols eliminar els fitxers de la cerca intel·ligent? Això desactivarà la funcionalitat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel·la'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nluService.deleteAssets();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
