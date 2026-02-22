import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class WatchlistLogsScreen extends StatefulWidget {
  const WatchlistLogsScreen({super.key});

  @override
  State<WatchlistLogsScreen> createState() => _WatchlistLogsScreenState();
}

class _WatchlistLogsScreenState extends State<WatchlistLogsScreen> {
  List<String> _logs = [];
  bool _debugShowLastUpdate = false;
  String _lastBackgroundRunHeader = 'none';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadState() {
    final prefs = PreferencesService().prefs;
    final String? lastRunStr = prefs.getString(AppConstants.lastBackgroundRun);
    String formattedDate = 'none';
    if (lastRunStr != null) {
      try {
        final DateTime lastRun = DateTime.parse(lastRunStr).toLocal();
        formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(lastRun);
      } catch (_) {
        formattedDate = 'error';
      }
    }

    setState(() {
      _logs = prefs.getStringList(AppConstants.watchlistUpdateLogs) ?? [];
      _debugShowLastUpdate =
          prefs.getBool(AppConstants.debugShowLastUpdate) ?? false;
      _lastBackgroundRunHeader = formattedDate;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _clearLogs() async {
    await PreferencesService().prefs.remove(AppConstants.watchlistUpdateLogs);
    _loadState();
  }

  Future<void> _toggleDebugShowLastUpdate(bool value) async {
    await PreferencesService()
        .prefs
        .setBool(AppConstants.debugShowLastUpdate, value);
    setState(() {
      _debugShowLastUpdate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Update Logs'),
        actions: [
          if (_logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear logs',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Logs'),
                    content:
                        const Text('Are you sure you want to delete all logs?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _clearLogs();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Última execució:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_lastBackgroundRunHeader),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mostrar LastUpdate (Debug)'),
                  subtitle:
                      const Text('Mostra data d\'actualització a les fitxes'),
                  value: _debugShowLastUpdate,
                  onChanged: _toggleDebugShowLastUpdate,
                ),
              ],
            ),
          ),
          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs available yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 80),
                    itemCount: _logs.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 32),
                    itemBuilder: (context, index) {
                      return SelectableText(
                        _logs[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
