import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/discovery_options.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/services/tmdb_lists/discoverlist_service.dart';
import 'package:moviescout/widgets/inputs_and_filters/drop_down_selector.dart';

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
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildResetButton(context, l10n, locale),
              if (discoverlistService.enabledProviderIds.isNotEmpty)
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
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeSelector(
                    context, titleTheme, l10n, options, locale),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildEpochSelector(
                    context, titleTheme, l10n, options, locale),
              ),
              const SizedBox(width: 8),
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

  Widget _buildThemeSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    final isActive = options.theme != DiscoveryTheme.any;
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;

    final themeOptions = DiscoveryTheme.values;
    final labels = themeOptions.map((t) {
      final def = DiscoveryOptions.themes[t]!;
      return '${def.emoji} ${DiscoveryOptions.getThemeLabel(context, t)}';
    }).toList();

    final currentDef = DiscoveryOptions.themes[options.theme]!;
    final currentLabel =
        '${currentDef.emoji} ${DiscoveryOptions.getThemeLabel(context, options.theme)}';

    return DropdownSelector(
      selectedOption: currentLabel,
      options: labels,
      isExpanded: true,
      buttonBackgroundColor: backgroundColor,
      border: Border.all(color: titleTheme.controlPanelForeground),
      borderRadius: BorderRadius.circular(5),
      textStyle: TextStyle(
        fontSize: 14,
        color: foregroundColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      arrowIcon: Icon(Icons.arrow_drop_down, color: foregroundColor, size: 20),
      maxMenuHeight: 320,
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
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;

    final modeOptions = DiscoveryMode.values;
    final labels = modeOptions
        .map((m) => DiscoveryOptions.getModeLabel(context, m))
        .toList();
    final currentLabel = DiscoveryOptions.getModeLabel(context, options.mode);

    return DropdownSelector(
      selectedOption: currentLabel,
      options: labels,
      isExpanded: true,
      buttonBackgroundColor: backgroundColor,
      border: Border.all(color: titleTheme.controlPanelForeground),
      borderRadius: BorderRadius.circular(5),
      textStyle: TextStyle(
        fontSize: 14,
        color: foregroundColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      arrowIcon: Icon(Icons.arrow_drop_down, color: foregroundColor, size: 20),
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
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;

    final epochOptions = DiscoveryEpoch.values;
    final labels = epochOptions
        .map((e) => DiscoveryOptions.getEpochLabel(context, e))
        .toList();
    final currentLabel = DiscoveryOptions.getEpochLabel(context, options.epoch);

    return DropdownSelector(
      selectedOption: currentLabel,
      options: labels,
      isExpanded: true,
      buttonBackgroundColor: backgroundColor,
      border: Border.all(color: titleTheme.controlPanelForeground),
      borderRadius: BorderRadius.circular(5),
      textStyle: TextStyle(
        fontSize: 14,
        color: foregroundColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      arrowIcon: Icon(Icons.arrow_drop_down, color: foregroundColor, size: 20),
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
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;

    final durationOptions = DiscoveryDuration.values;
    final labels = durationOptions
        .map((d) => DiscoveryOptions.getDurationLabel(context, d))
        .toList();
    final currentLabel =
        DiscoveryOptions.getDurationLabel(context, options.duration);

    return DropdownSelector(
      selectedOption: currentLabel,
      options: labels,
      isExpanded: true,
      buttonBackgroundColor: backgroundColor,
      border: Border.all(color: titleTheme.controlPanelForeground),
      borderRadius: BorderRadius.circular(5),
      textStyle: TextStyle(
        fontSize: 14,
        color: foregroundColor,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      arrowIcon: Icon(Icons.arrow_drop_down, color: foregroundColor, size: 20),
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

  Widget _buildProvidersSelector(
    BuildContext context,
    TitleListTheme titleTheme,
    AppLocalizations l10n,
    DiscoveryOptions options,
    Locale locale,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.filterByProviders,
          style: TextStyle(
            fontSize: 14,
            color: titleTheme.controlPanelForeground,
          ),
        ),
        const SizedBox(width: 4),
        Switch(
          activeThumbColor: titleTheme.controlPanelActiveFilterBackground,
          inactiveThumbColor: titleTheme.controlPanelInactiveFilterForeground,
          value: options.filterByProviders,
          onChanged: (value) {
            discoverlistService.updateDiscoveryOptions(
              options.copyWith(filterByProviders: value),
              locale,
            );
          },
        ),
      ],
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
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      icon: Icon(
        hasFilters ? Icons.filter_alt_off : Icons.filter_alt,
        size: 20,
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
