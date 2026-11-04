import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/api/ai_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _customModelController = TextEditingController();
  bool _obscureText = true;
  bool _hasSavedKey = false;
  late String _selectedModelDropdown;

  @override
  void initState() {
    super.initState();
    final currentKey = AiService().apiKey;
    _apiKeyController.text = currentKey;
    _hasSavedKey = currentKey.trim().isNotEmpty;

    final currentModel = AiService().selectedModel;
    if (AppConstants.availableAiModels.contains(currentModel)) {
      _selectedModelDropdown = currentModel;
    } else {
      _selectedModelDropdown = AppConstants.aiModelCustom;
      _customModelController.text = currentModel;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _customModelController.dispose();
    super.dispose();
  }

  Future<void> _openOpenRouter() async {
    final uri = Uri.parse(UrlConstants.openRouterKeysUrl);
    await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }

  Future<void> _saveKey() async {
    final key = _apiKeyController.text.trim();
    await AiService().saveApiKey(key);
    setState(() {
      _hasSavedKey = key.isNotEmpty;
    });
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      SnackMessage.showSnackBar(
        key.isNotEmpty ? l10n.aiKeySaved : l10n.aiKeyCleared,
      );
    }
  }

  Future<void> _clearKey() async {
    _apiKeyController.clear();
    await AiService().saveApiKey('');
    setState(() {
      _hasSavedKey = false;
    });
    if (mounted) {
      SnackMessage.showSnackBar(AppLocalizations.of(context)!.aiKeyCleared);
    }
  }

  Future<void> _confirmClearKey() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.onError,
          size: 28,
        ),
        title: Text(l10n.aiDeleteConfirmTitle),
        content: Text(l10n.aiDeleteConfirmMessage),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _clearKey();
    }
  }

  Future<void> _onModelSelected(String? newModel) async {
    if (newModel == null) return;
    setState(() {
      _selectedModelDropdown = newModel;
    });

    if (newModel != AppConstants.aiModelCustom) {
      await AiService().saveSelectedModel(newModel);
    }
  }

  bool get _canSaveCustomModel {
    final customModel = _customModelController.text.trim();
    return customModel.isNotEmpty && customModel != AiService().selectedModel;
  }

  Future<void> _saveCustomModel() async {
    final customModel = _customModelController.text.trim();
    if (!_canSaveCustomModel) return;
    await AiService().saveSelectedModel(customModel);
    setState(() {});
  }

  String _modelLabel(String model, AppLocalizations l10n) {
    switch (model) {
      case AppConstants.aiModelFree:
        return l10n.aiModelFreeLabel;
      case AppConstants.aiModelAuto:
        return l10n.aiModelAutoLabel;
      default:
        return model;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiSettingsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.aiSettingsSubtitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.aiSettingsDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _openOpenRouter,
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.aiGetApiKeyButton),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aiApiKeyLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              readOnly: _hasSavedKey,
              obscureText: _obscureText,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.aiApiKeyHint,
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    if (_apiKeyController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _hasSavedKey
                            ? null
                            : () {
                                setState(() {
                                  _apiKeyController.clear();
                                });
                              },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        _hasSavedKey || _apiKeyController.text.trim().isEmpty
                            ? null
                            : _saveKey,
                    icon: const Icon(Icons.save),
                    label: Text(l10n.aiSaveKeyButton),
                  ),
                ),
                if (_hasSavedKey) ...[
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _confirmClearKey,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.aiDeleteKeyButton),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  _hasSavedKey ? Icons.check_circle : Icons.info_outline,
                  color: _hasSavedKey ? Colors.green : colorScheme.outline,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _hasSavedKey
                      ? l10n.aiStatusConfigured
                      : l10n.aiStatusNotConfigured,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _hasSavedKey ? Colors.green : colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 48),
            Text(
              l10n.aiModelLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.aiModelHelper,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedModelDropdown,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.psychology_outlined),
              ),
              isExpanded: true,
              items: [
                ...AppConstants.availableAiModels.map(
                  (model) => DropdownMenuItem(
                    value: model,
                    child: Text(_modelLabel(model, l10n)),
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.aiModelCustom,
                  child: Text(l10n.aiModelCustomLabel),
                ),
              ],
              onChanged: _onModelSelected,
            ),
            if (_selectedModelDropdown == AppConstants.aiModelCustom) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customModelController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: l10n.aiModelCustomHint,
                        prefixIcon: const Icon(Icons.tune),
                      ),
                      onSubmitted: _canSaveCustomModel
                          ? (_) => _saveCustomModel()
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _canSaveCustomModel ? _saveCustomModel : null,
                    icon: const Icon(Icons.save),
                    label: Text(l10n.save),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
