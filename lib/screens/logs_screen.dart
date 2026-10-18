import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/main.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen>
    with WidgetsBindingObserver, RouteAware {
  List<String> _logs = [];
  String _lastBackgroundRunHeader = 'none';
  final ScrollController _scrollController = ScrollController();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadState();
    }
  }

  @override
  void didUpdateWidget(covariant LogsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadState();
  }

  Future<void> _loadState() async {
    await PreferencesService().refresh();
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

    if (mounted) {
      setState(() {
        _logs = (prefs.getStringList(AppConstants.updateLogs) ?? [])
            .reversed
            .toList();
        _lastBackgroundRunHeader = formattedDate;
      });
    }
  }

  Future<void> _clearLogs() async {
    await PreferencesService().prefs.remove(AppConstants.updateLogs);
    _loadState();
  }

  Future<void> _shareLogs(BuildContext buttonContext) async {
    if (_logs.isEmpty || _isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      XFile xFile;
      if (kIsWeb) {
        final String logText = _logs.join('\n\n---\n\n');
        xFile = XFile.fromData(
          utf8.encode(logText),
          mimeType: 'text/plain',
          name: 'moviescout_logs.txt',
        );
      } else {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/moviescout_logs.txt');
        final sink = file.openWrite();
        try {
          for (var i = 0; i < _logs.length; i++) {
            if (i > 0) sink.write('\n\n---\n\n');
            sink.write(_logs[i]);
          }
          await sink.flush();
        } finally {
          await sink.close();
        }
        xFile = XFile(file.path);
      }

      if (!buttonContext.mounted) return;
      final box = buttonContext.findRenderObject() as RenderBox?;
      final origin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          subject: 'App Logs',
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting logs: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          if (_logs.isNotEmpty) ...[
            Builder(
              builder: (buttonContext) {
                return IconButton(
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.share),
                  tooltip: 'Share logs',
                  onPressed:
                      _isSharing ? null : () => _shareLogs(buttonContext),
                );
              },
            ),
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
                      FilledButton.tonal(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          _clearLogs();
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
              ],
            ),
          ),
          Expanded(
            child: _logs.isEmpty
                ? Center(
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
