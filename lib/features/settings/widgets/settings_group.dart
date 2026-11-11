import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';

class SettingsGroup extends StatelessWidget {
  final String? title;
  final String? footer;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  const SettingsGroup({
    super.key,
    this.title,
    this.footer,
    required this.children,
    this.margin = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>();
    final dividerColor = customColors?.dividerColor
            .withValues(alpha: AppOpacity.surfaceSubtle) ??
        theme.dividerColor.withValues(alpha: AppOpacity.surfaceSubtle);

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.xs,
                top: AppSpacing.xxs,
              ),
              child: Text(
                title!,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderLg,
            ),
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: AppOpacity.surfaceSubtle),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: AppSizes.borderWidthRegular,
                      thickness: AppSizes.borderWidthThin,
                      indent: AppSizes.settingsDividerIndent,
                      endIndent: AppSpacing.md,
                      color: dividerColor,
                    ),
                  children[i],
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                top: AppSpacing.xs,
              ),
              child: Text(
                footer!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
