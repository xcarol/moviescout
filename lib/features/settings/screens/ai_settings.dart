import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/features/settings/widgets/ai_model_thinking_selector.dart';
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
  late String _selectedThinkingDropdown;

  @override
  void initState() {
    super.initState();
    _loadProviderState();
  }

  void _loadProviderState() {
    final provider = AiService().currentProvider;
    final currentKey = provider.apiKey;
    _apiKeyController.text = currentKey;
    _hasSavedKey = currentKey.trim().isNotEmpty;
    _obscureText = true;

    final currentModel = provider.selectedModel;
    if (!provider.isCustomModel &&
        provider.availableModels.contains(currentModel)) {
      _selectedModelDropdown = currentModel;
      _customModelController.clear();
    } else {
      _selectedModelDropdown = AppConstants.aiModelCustom;
      _customModelController.text = currentModel;
    }

    final currentThinking = provider.selectedThinkingLevel;
    _selectedThinkingDropdown =
        AiModelThinkingSelector.thinkingOptions.contains(currentThinking)
            ? currentThinking
            : AppConstants.aiThinkingLevel;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _customModelController.dispose();
    super.dispose();
  }

  Future<void> _onProviderSelected(Set<String> selection) async {
    if (selection.isEmpty) return;
    final newProviderId = selection.first;
    if (newProviderId == AiService().currentProvider.id) return;
    await AiService().setSelectedProvider(newProviderId);
    setState(() {
      _loadProviderState();
    });
  }

  Future<void> _openProviderKeys() async {
    final uri = Uri.parse(AiService().currentProvider.keysUrl);
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
    final provider = AiService().currentProvider;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: AppSizes.iconDialog,
        ),
        title: Text(l10n.aiDeleteConfirmTitle),
        content: Text(provider.deleteConfirmMessage(l10n)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
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
      await AiService().saveSelectedModel(newModel, isCustom: false);
      setState(() {
        final currentThinking = AiService().selectedThinkingLevel;
        _selectedThinkingDropdown =
            AiModelThinkingSelector.thinkingOptions.contains(currentThinking)
                ? currentThinking
                : AppConstants.aiThinkingLevel;
      });
    }
  }

  Future<void> _onThinkingSelected(String? newThinking) async {
    if (newThinking == null) return;
    await AiService().saveSelectedThinkingLevel(newThinking);
    setState(() {
      _selectedThinkingDropdown = newThinking;
    });
  }

  bool get _canSaveCustomModel {
    final customModel = _customModelController.text.trim();
    return customModel.isNotEmpty &&
        (customModel != AiService().selectedModel ||
            !AiService().currentProvider.isCustomModel);
  }

  Future<void> _saveCustomModel() async {
    final customModel = _customModelController.text.trim();
    if (!_canSaveCustomModel) return;
    await AiService().saveSelectedModel(customModel, isCustom: true);
    setState(() {
      final currentThinking = AiService().selectedThinkingLevel;
      _selectedThinkingDropdown =
          AiModelThinkingSelector.thinkingOptions.contains(currentThinking)
              ? currentThinking
              : AppConstants.aiThinkingLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = AiService().currentProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiSettingsTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.aiSettingsSubtitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    provider.description(l10n),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.aiProviderLabel,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<String>(
                    segments: AiService()
                        .providers
                        .map(
                          (p) => ButtonSegment<String>(
                            value: p.id,
                            icon: Icon(p.icon),
                            label: Text(p.name),
                          ),
                        )
                        .toList(),
                    selected: {provider.id},
                    onSelectionChanged: _onProviderSelected,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton.icon(
                    onPressed: _openProviderKeys,
                    icon: const Icon(Icons.open_in_new),
                    label: Text(provider.getApiKeyButtonLabel(l10n)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    provider.apiKeyLabel(l10n),
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _apiKeyController,
                    readOnly: _hasSavedKey,
                    obscureText: _obscureText,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: provider.apiKeyHint(l10n),
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _hasSavedKey ||
                                  _apiKeyController.text.trim().isEmpty
                              ? null
                              : _saveKey,
                          icon: const Icon(Icons.save),
                          label: Text(l10n.aiSaveKeyButton),
                        ),
                      ),
                      if (_hasSavedKey) ...[
                        const SizedBox(width: AppSpacing.xs),
                        FilledButton.tonalIcon(
                          onPressed: _confirmClearKey,
                          icon: const Icon(Icons.delete_outline),
                          label: Text(l10n.aiDeleteKeyButton),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: AppSpacing.xxl),
                  Text(
                    l10n.aiModelLabel,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.aiModelHelper,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    key: ValueKey('${provider.id}_$_selectedModelDropdown'),
                    initialValue: _selectedModelDropdown,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.smart_toy_outlined),
                    ),
                    isExpanded: true,
                    items: [
                      ...provider.availableModels.map(
                        (model) => DropdownMenuItem(
                          value: model,
                          child: Text(provider.modelDisplayLabel(model, l10n)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.aiModelCustom,
                        child: Text(l10n.aiModelCustomLabel),
                      ),
                    ],
                    onChanged: _hasSavedKey ? _onModelSelected : null,
                  ),
                  if (_selectedModelDropdown == AppConstants.aiModelCustom) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customModelController,
                            enabled: _hasSavedKey,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: provider.customModelHint(l10n),
                              prefixIcon: const Icon(Icons.tune),
                            ),
                            onSubmitted: _hasSavedKey && _canSaveCustomModel
                                ? (_) => _saveCustomModel()
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        FilledButton.icon(
                          onPressed: _hasSavedKey && _canSaveCustomModel
                              ? _saveCustomModel
                              : null,
                          icon: const Icon(Icons.save),
                          label: Text(l10n.save),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.aiThinkingLabel,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.aiThinkingHelper,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    key: ValueKey(
                      '${provider.id}_${_selectedModelDropdown}_$_selectedThinkingDropdown',
                    ),
                    initialValue: _selectedThinkingDropdown,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.psychology_outlined),
                    ),
                    isExpanded: true,
                    items: AiModelThinkingSelector.thinkingOptions
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(
                              AiModelThinkingSelector.thinkingDisplayLabel(
                                level,
                                l10n,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _hasSavedKey ? _onThinkingSelected : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
