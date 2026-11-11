import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;
  final bool isDestructive;
  final bool enabled;

  const SettingsTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onInfoTap,
    this.isDestructive = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>();
    final destructiveColor =
        customColors?.destructiveAction ?? theme.colorScheme.error;

    final iconColor = isDestructive
        ? destructiveColor
        : enabled
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
      color: isDestructive
          ? destructiveColor
          : enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant
                  .withValues(alpha: AppOpacity.half),
    );

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDestructive
          ? destructiveColor.withValues(alpha: AppOpacity.chipBadge)
          : enabled
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

    Widget? effectiveTrailing = trailing;
    if (effectiveTrailing == null && onTap != null && !isDestructive) {
      effectiveTrailing = Icon(
        Icons.chevron_right,
        size: AppSizes.iconMd,
        color: enabled
            ? theme.colorScheme.onSurfaceVariant
                .withValues(alpha: AppOpacity.disabled)
            : theme.colorScheme.onSurfaceVariant
                .withValues(alpha: AppOpacity.scrimLight),
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: titleWidget,
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      trailing: effectiveTrailing,
      onTap: enabled ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
    );
  }
}
