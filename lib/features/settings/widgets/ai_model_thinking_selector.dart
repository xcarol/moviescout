import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';

class AiModelThinkingSelector extends StatelessWidget {
  final String? selectedModel;
  final String? selectedThinkingLevel;
  final void Function(String model, String thinkingLevel) onChanged;
  final VoidCallback onRefresh;
  final bool showApplyTranslation;
  final VoidCallback? onApplyTranslation;
  final String? applyTranslationTooltip;
  final Color? borderColor;
  final Color? textColor;

  const AiModelThinkingSelector({
    super.key,
    required this.selectedModel,
    required this.selectedThinkingLevel,
    required this.onChanged,
    required this.onRefresh,
    this.showApplyTranslation = false,
    this.onApplyTranslation,
    this.applyTranslationTooltip,
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
    final borderRadius = BorderRadius.circular(4);
    final textStyle = TextStyle(fontSize: 16, color: effectiveTextColor);
    final arrowIcon = Icon(Icons.arrow_drop_down, color: effectiveTextColor);

    const dropdownPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    );

    final modelDropdown = DropdownSelector(
      border: border,
      borderRadius: borderRadius,
      padding: dropdownPadding,
      textStyle: textStyle,
      arrowIcon: arrowIcon,
      leading: Icon(
        Icons.smart_toy_outlined,
        size: 20,
        color: effectiveTextColor,
      ),
      selectedOption: selectedModelLabel,
      options: modelLabels.values.toList(),
      maxMenuHeight: 300,
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
      padding: dropdownPadding,
      textStyle: textStyle,
      arrowIcon: arrowIcon,
      leading: Icon(
        Icons.psychology_outlined,
        size: 20,
        color: effectiveTextColor,
      ),
      selectedOption: selectedThinkingLabel,
      options: thinkingLabels.values.toList(),
      maxMenuHeight: 300,
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

    final refreshButton = _buildActionButton(
      icon: Icons.refresh,
      borderColor: effectiveBorderColor,
      iconColor: effectiveTextColor,
      borderRadius: borderRadius,
      onTap: onRefresh,
    );

    final applyButton = showApplyTranslation
        ? _buildActionButton(
            icon: Icons.open_in_browser,
            borderColor: onApplyTranslation != null
                ? effectiveBorderColor
                : colorScheme.outlineVariant,
            iconColor: onApplyTranslation != null
                ? effectiveTextColor
                : colorScheme.onSurfaceVariant,
            borderRadius: borderRadius,
            tooltip: applyTranslationTooltip,
            onTap: onApplyTranslation,
          )
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 350.0) {
          return Row(
            children: [
              Expanded(flex: 3, child: modelDropdown),
              AppSpacing.gapSm,
              Expanded(flex: 2, child: thinkingDropdown),
              AppSpacing.gapSm,
              refreshButton,
              if (applyButton != null) ...[
                AppSpacing.gapSm,
                applyButton,
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            modelDropdown,
            AppSpacing.gapSm,
            Row(
              children: [
                Expanded(child: thinkingDropdown),
                AppSpacing.gapSm,
                refreshButton,
                if (applyButton != null) ...[
                  AppSpacing.gapSm,
                  applyButton,
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color borderColor,
    required Color iconColor,
    required BorderRadius borderRadius,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    final button = InkWell(
      borderRadius: AppRadius.borderXs,
      onTap: onTap,
      child: Container(
        padding: AppSpacing.edgeInsetsAllXs,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: borderRadius,
        ),
        child: Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
      ),
    );

    if (tooltip == null || tooltip.isEmpty) {
      return button;
    }

    return Tooltip(
      message: tooltip,
      child: button,
    );
  }
}
