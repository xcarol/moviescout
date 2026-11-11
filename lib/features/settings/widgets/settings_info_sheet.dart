import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class SettingsInfoItem {
  final IconData icon;
  final String title;
  final String description;

  const SettingsInfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class SettingsInfoSheet extends StatelessWidget {
  final IconData headerIcon;
  final String title;
  final String? subtitle;
  final List<SettingsInfoItem> items;
  final String? note;
  final String closeButtonLabel;

  const SettingsInfoSheet({
    super.key,
    required this.headerIcon,
    required this.title,
    this.subtitle,
    required this.items,
    this.note,
    this.closeButtonLabel = 'Entesos',
  });

  static Future<void> show({
    required BuildContext context,
    required IconData headerIcon,
    required String title,
    String? subtitle,
    required List<SettingsInfoItem> items,
    String? note,
    String? closeButtonLabel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      builder: (context) => SettingsInfoSheet(
        headerIcon: headerIcon,
        title: title,
        subtitle: subtitle,
        items: items,
        note: note,
        closeButtonLabel: closeButtonLabel ?? 'Entesos',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.xs,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: AppSizes.infoSheetHeaderBoxSize,
                    height: AppSizes.infoSheetHeaderBoxSize,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Icon(
                      headerIcon,
                      size: AppSizes.iconLg,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.micro),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              for (int i = 0; i < items.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.micro),
                      child: Icon(
                        items[i].icon,
                        size: AppSizes.iconMd,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: '${items[i].title}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: items[i].description,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < items.length - 1) const SizedBox(height: AppSpacing.md),
              ],
              if (note != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: AppOpacity.half),
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(
                      color: colorScheme.outlineVariant
                          .withValues(alpha: AppOpacity.backdropOverlay),
                      width: AppSizes.borderWidthRegular,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: AppSizes.iconSubtle,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(closeButtonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
