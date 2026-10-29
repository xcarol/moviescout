import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';

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
        customColors?.destructiveAction ?? Colors.redAccent;

    final iconColor = isDestructive
        ? destructiveColor
        : enabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.38);

    Widget? leadingWidget = leading;
    if (leadingWidget == null && icon != null) {
      leadingWidget = Icon(
        icon,
        size: 24,
        color: iconColor,
      );
    }

    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
      color: isDestructive
          ? destructiveColor
          : enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    );

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDestructive
          ? destructiveColor.withValues(alpha: 0.8)
          : enabled
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
    );

    Widget titleWidget = Text(title, style: titleStyle);
    if (onInfoTap != null) {
      titleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(title, style: titleStyle)),
          const SizedBox(width: 4.0),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
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
        size: 20,
        color: enabled
            ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: titleWidget,
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      trailing: effectiveTrailing,
      onTap: enabled ? onTap : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }
}
