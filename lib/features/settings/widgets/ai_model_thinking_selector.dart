import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';

class AiModelThinkingSelector extends StatelessWidget {
  final String? selectedModel;
  final String? selectedThinkingLevel;
  final void Function(String model, String thinkingLevel) onChanged;
  final VoidCallback onRefresh;
  final Color? borderColor;
  final Color? textColor;

  const AiModelThinkingSelector({
    super.key,
    required this.selectedModel,
    required this.selectedThinkingLevel,
    required this.onChanged,
    required this.onRefresh,
    this.borderColor,
    this.textColor,
  });

  static const List<String> thinkingOptions = ['low', 'medium', 'high'];

  static String thinkingDisplayLabel(String level, AppLocalizations l10n) {
    switch (level) {
      case 'low':
        return l10n.aiThinkingLow;
      case 'medium':
        return l10n.aiThinkingMedium;
      case 'high':
        return l10n.aiThinkingHigh;
      default:
        return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AiService().currentProvider;
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBorderColor = borderColor ?? colorScheme.secondary;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;

    final models = provider.selectableModels;
    final effectiveModel =
        (selectedModel != null && models.contains(selectedModel))
            ? selectedModel!
            : provider.selectedModel;

    final modelLabels = <String, String>{
      for (final m in models) m: provider.modelDisplayLabel(m, l10n),
    };
    final selectedModelLabel = modelLabels[effectiveModel] ?? effectiveModel;

    final defaultThinking = provider.defaultThinkingLevelForModel(
      effectiveModel,
    );
    final rawThinking = selectedThinkingLevel ?? provider.selectedThinkingLevel;
    final effectiveThinking = thinkingOptions.contains(rawThinking)
        ? rawThinking
        : (thinkingOptions.contains(defaultThinking) ? defaultThinking : 'low');

    final border = Border.all(color: effectiveBorderColor);
    final borderRadius = AppRadius.borderXs;
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: effectiveTextColor,
        );
    final arrowIcon = Icon(Icons.arrow_drop_down, color: effectiveTextColor);

    final modelDropdown = DropdownSelector(
      border: border,
      borderRadius: borderRadius,
      textStyle: textStyle,
      arrowIcon: arrowIcon,
      leading: Icon(
        Icons.smart_toy_outlined,
        size: AppSizes.iconSubtle,
        color: effectiveTextColor,
      ),
      selectedOption: selectedModelLabel,
      options: modelLabels.values.toList(),
      maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
      isExpanded: true,
      onSelected: (label) async {
        final newModel = modelLabels.entries
            .firstWhere(
              (e) => e.value == label,
              orElse: () => MapEntry(label, label),
            )
            .key;
        final isCustom = !provider.availableModels.contains(newModel);
        await AiService().saveSelectedModel(newModel, isCustom: isCustom);
        final newDefaultThinking = provider.defaultThinkingLevelForModel(
          newModel,
        );
        onChanged(newModel, newDefaultThinking);
      },
    );

    final thinkingLabels = <String, String>{
      for (final t in thinkingOptions) t: thinkingDisplayLabel(t, l10n),
    };
    final selectedThinkingLabel =
        thinkingLabels[effectiveThinking] ?? effectiveThinking;

    final thinkingDropdown = DropdownSelector(
      border: border,
      borderRadius: borderRadius,
      textStyle: textStyle,
      arrowIcon: arrowIcon,
      leading: Icon(
        Icons.psychology_outlined,
        size: AppSizes.iconSubtle,
        color: effectiveTextColor,
      ),
      selectedOption: selectedThinkingLabel,
      options: thinkingLabels.values.toList(),
      maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
      isExpanded: true,
      onSelected: (label) async {
        final newThinking = thinkingLabels.entries
            .firstWhere(
              (e) => e.value == label,
              orElse: () => MapEntry(label, label),
            )
            .key;
        await AiService().saveSelectedThinkingLevel(newThinking);
        onChanged(effectiveModel, newThinking);
      },
    );

    final refreshButton = InkWell(
      borderRadius: borderRadius,
      onTap: onRefresh,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.micro),
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
        ),
        child: Icon(
          Icons.refresh,
          size: AppSizes.iconMd,
          color: effectiveTextColor,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppBreakpoints.inlineDropdown) {
          return Row(
            children: [
              Expanded(flex: 3, child: modelDropdown),
              const SizedBox(width: AppSpacing.xs),
              Expanded(flex: 2, child: thinkingDropdown),
              const SizedBox(width: AppSpacing.xs),
              refreshButton,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            modelDropdown,
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(child: thinkingDropdown),
                const SizedBox(width: AppSpacing.xs),
                refreshButton,
              ],
            ),
          ],
        );
      },
    );
  }
}
