import 'package:flutter/material.dart';

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
      color: enabled
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    );

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: enabled
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

    return SwitchListTile(
      secondary: isSubOption
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: leadingWidget,
            )
          : leadingWidget,
      title: titleWidget,
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.only(
        left: isSubOption ? 24.0 : 16.0,
        right: 16.0,
        top: 2.0,
        bottom: 2.0,
      ),
    );
  }
}
