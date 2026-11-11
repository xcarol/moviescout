import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onInfoTap;
  final bool enabled;
  final bool isSubOption;

  const SettingsSwitchTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.onInfoTap,
    this.enabled = true,
    this.isSubOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = enabled
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.onSurfaceVariant
            .withValues(alpha: AppOpacity.backdropOverlay);

    Widget? leadingWidget = leading;
    if (leadingWidget == null && icon != null) {
      leadingWidget = Icon(
        icon,
        size: AppSizes.iconLg,
        color: iconColor,
      );
    }

    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
      color: enabled
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant
              .withValues(alpha: AppOpacity.half),
    );

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: enabled
          ? theme.colorScheme.onSurfaceVariant
          : theme.colorScheme.onSurfaceVariant
              .withValues(alpha: AppOpacity.backdropOverlay),
    );

    Widget titleWidget = Text(title, style: titleStyle);
    if (onInfoTap != null) {
      titleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(title, style: titleStyle)),
          const SizedBox(width: AppSpacing.xxs),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: AppSizes.iconSubtle,
              color: theme.colorScheme.onSurfaceVariant
                  .withValues(alpha: AppOpacity.subtle),
            ),
            padding: EdgeInsets.zero,
            constraints: AppSizes.compactActionConstraints,
            visualDensity: VisualDensity.compact,
            onPressed: onInfoTap,
          ),
        ],
      );
    }

    return SwitchListTile(
      secondary: isSubOption
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: leadingWidget,
            )
          : leadingWidget,
      title: titleWidget,
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.only(
        left: isSubOption ? AppSpacing.lg : AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.micro,
        bottom: AppSpacing.micro,
      ),
    );
  }
}
