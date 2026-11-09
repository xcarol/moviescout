import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/features/discovery/models/discovery_options.dart';
import 'package:moviescout/features/discovery/services/discoverlist_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class DiscoveryControlPanel extends StatelessWidget {
  final TmdbDiscoverlistService discoverlistService;

  const DiscoveryControlPanel({
    super.key,
    required this.discoverlistService,
  });

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final l10n = AppLocalizations.of(context)!;
    final options = discoverlistService.options;
    final locale = Localizations.localeOf(context);

    return Container(
      color: titleTheme.controlPanelBackground,
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        right: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildResetButton(context, l10n, locale),
              _buildProvidersSelector(
                  context, titleTheme, l10n, options, locale),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildThemeSelector(
                    context, titleTheme, l10n, options, locale),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _buildModeSelector(
                    context, titleTheme, l10n, options, locale),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _buildEpochSelector(
                    context, titleTheme, l10n, options, locale),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _buildDurationSelector(
                    context, titleTheme, l10n, options, locale),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required TitleListTheme titleTheme,
    required bool isActive,
    required String currentLabel,
    required List<String> labels,
    required ValueChanged<String> onSelected,
    double? maxMenuHeight,
  }) {
    final theme = Theme.of(context);
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;

    return DropdownSelector(
      selectedOption: currentLabel,
      options: labels,
      isExpanded: true,
      buttonBackgroundColor: backgroundColor,
      border: Border.all(
        color: isActive ? backgroundColor : theme.colorScheme.outline,
      ),
      borderRadius: AppRadius.borderSm,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: foregroundColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      arrowIcon: Icon(
        Icons.arrow_drop_down,
        color: foregroundColor,
        size: AppSizes.iconMd,
      ),
      maxMenuHeight: maxMenuHeight,
      onSelected: onSelected,
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final isActive = options.theme != DiscoveryTheme.any;
    final themeOptions = DiscoveryTheme.values;
    final labels = themeOptions.map((t) {
      final def = DiscoveryOptions.themes[t]!;
      return '${def.emoji} ${DiscoveryOptions.getThemeLabel(context, t)}';
    }).toList();

    final currentDef = DiscoveryOptions.themes[options.theme]!;
    final currentLabel =
        '${currentDef.emoji} ${DiscoveryOptions.getThemeLabel(context, options.theme)}';

    return _buildDropdown(
      context: context,
      titleTheme: titleTheme,
      isActive: isActive,
      currentLabel: currentLabel,
      labels: labels,
      maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
      onSelected: (selectedLabel) {
        final index = labels.indexOf(selectedLabel);
        if (index != -1) {
          final selectedTheme = themeOptions[index];
          discoverlistService.updateDiscoveryOptions(
            options.copyWith(theme: selectedTheme),
            locale,
          );
        }
      },
    );
  }

  Widget _buildModeSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final isActive = options.mode != DiscoveryMode.forYou;
    final modeOptions = DiscoveryMode.values;
    final labels = modeOptions
        .map((m) => DiscoveryOptions.getModeLabel(context, m))
        .toList();
    final currentLabel = DiscoveryOptions.getModeLabel(context, options.mode);

    return _buildDropdown(
      context: context,
      titleTheme: titleTheme,
      isActive: isActive,
      currentLabel: currentLabel,
      labels: labels,
      onSelected: (selectedLabel) {
        final index = labels.indexOf(selectedLabel);
        if (index != -1) {
          final selectedMode = modeOptions[index];
          discoverlistService.updateDiscoveryOptions(
            options.copyWith(mode: selectedMode),
            locale,
          );
        }
      },
    );
  }

  Widget _buildEpochSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final isActive = options.epoch != DiscoveryEpoch.all;
    final epochOptions = DiscoveryEpoch.values;
    final labels = epochOptions
        .map((e) => DiscoveryOptions.getEpochLabel(context, e))
        .toList();
    final currentLabel = DiscoveryOptions.getEpochLabel(context, options.epoch);

    return _buildDropdown(
      context: context,
      titleTheme: titleTheme,
      isActive: isActive,
      currentLabel: currentLabel,
      labels: labels,
      onSelected: (selectedLabel) {
        final index = labels.indexOf(selectedLabel);
        if (index != -1) {
          final selectedEpoch = epochOptions[index];
          discoverlistService.updateDiscoveryOptions(
            options.copyWith(epoch: selectedEpoch),
            locale,
          );
        }
      },
    );
  }

  Widget _buildDurationSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final isActive = options.duration != DiscoveryDuration.any;
    final durationOptions = DiscoveryDuration.values;
    final labels = durationOptions
        .map((d) => DiscoveryOptions.getDurationLabel(context, d))
        .toList();
    final currentLabel =
        DiscoveryOptions.getDurationLabel(context, options.duration);

    return _buildDropdown(
      context: context,
      titleTheme: titleTheme,
      isActive: isActive,
      currentLabel: currentLabel,
      labels: labels,
      onSelected: (selectedLabel) {
        final index = labels.indexOf(selectedLabel);
        if (index != -1) {
          final selectedDuration = durationOptions[index];
          discoverlistService.updateDiscoveryOptions(
            options.copyWith(duration: selectedDuration),
            locale,
          );
        }
      },
    );
  }

  void _promptConfigureProviders(BuildContext context, AppLocalizations l10n) {
    SnackMessage.showActionSnackBar(
      message: l10n.noProvidersSelectedPrompt,
      actionLabel: l10n.settings,
      onAction: () {
        context.toProviders();
      },
      context: context,
    );
  }

  Widget _buildProvidersSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final hasProviders = discoverlistService.enabledProviderIds.isNotEmpty;
    final isActive = hasProviders && options.filterByProviders;
    final activeColor = titleTheme.controlPanelActiveFilterBackground;
    final inactiveColor = titleTheme.controlPanelInactiveFilterForeground;

    return Tooltip(
      message: l10n.discoveryFilterByYourProviders,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: AppSizes.compactActionConstraints,
            icon: Icon(
              Icons.tv,
              size: AppSizes.iconMd,
              color: isActive ? activeColor : inactiveColor,
            ),
            onPressed: () {
              if (!hasProviders) {
                _promptConfigureProviders(context, l10n);
                return;
              }
              discoverlistService.updateDiscoveryOptions(
                options.copyWith(filterByProviders: !isActive),
                locale,
              );
            },
          ),
          const SizedBox(width: AppSpacing.xxs),
          Switch(
            value: isActive,
            onChanged: (bool value) {
              if (!hasProviders) {
                _promptConfigureProviders(context, l10n);
                return;
              }
              discoverlistService.updateDiscoveryOptions(
                options.copyWith(filterByProviders: value),
                locale,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(
    BuildContext context,
    AppLocalizations l10n,
    Locale locale,
  ) {
    final hasFilters = discoverlistService.anyFilterActive;
    final activeColor = Theme.of(context).colorScheme.primary;
    final disabledColor = Theme.of(context).disabledColor;

    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: AppSizes.suffixIconConstraints,
      icon: Icon(
        hasFilters ? Icons.filter_alt_off : Icons.filter_alt,
        size: AppSizes.iconMd,
        color: hasFilters ? activeColor : disabledColor,
      ),
      tooltip: l10n.discoveryResetFilters,
      onPressed: hasFilters
          ? () {
              discoverlistService.updateDiscoveryOptions(
                const DiscoveryOptions(),
                locale,
              );
            }
          : null,
    );
  }
}
