import 'package:flutter/material.dart';

class ImportStepTile extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final String pendingText;
  final String activeText;
  final String completedText;
  final Widget? subtitle;

  const ImportStepTile({
    super.key,
    required this.isActive,
    required this.isCompleted,
    required this.pendingText,
    required this.activeText,
    required this.completedText,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget leading;
    Color? textColor;

    if (isCompleted) {
      leading = Icon(Icons.check_circle, color: theme.colorScheme.primary);
      textColor = theme.textTheme.bodyMedium?.color;
    } else if (isActive) {
      leading = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
      textColor = theme.colorScheme.primary;
    } else {
      leading = Icon(Icons.radio_button_unchecked, color: theme.disabledColor);
      textColor = theme.disabledColor;
    }

    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Center(child: leading),
      ),
      title: Text(
        isCompleted
            ? completedText
            : isActive
                ? activeText
                : pendingText,
        style: TextStyle(
          color: textColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: subtitle,
    );
  }
}
