import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';

// TODO: Delete when the promo ends
class DiscoverPromoCard extends StatelessWidget {
  final VoidCallback onExplore;
  final VoidCallback onDismiss;

  const DiscoverPromoCard({
    super.key,
    required this.onExplore,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: AppOpacity.disabled),
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: AppOpacity.half),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: AppSpacing.chipPadding,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: AppOpacity.tint),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.wand_stars,
              color: colorScheme.primary,
              size: AppSizes.iconLg,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.discoverPromoTitle,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.micro),
                Text(
                  l10n.discoverPromoSubtitle,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      textStyle: theme.textTheme.labelMedium,
                    ),
                    onPressed: onExplore,
                    child: Text(l10n.discoverPromoExplore),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: AppSizes.compactActionConstraints,
            icon: Icon(
              Icons.close,
              size: AppSizes.iconSm,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}
