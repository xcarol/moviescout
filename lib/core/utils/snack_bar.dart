import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/main.dart';

class SnackMessage {
  static void showSnackBar(
    String message, {
    BuildContext? context,
    Duration duration = AppDurations.snackBarInfo,
  }) {
    final scaffold =
        (context != null ? ScaffoldMessenger.maybeOf(context) : null) ??
            scaffoldMessengerKey.currentState;

    if (scaffold == null) {
      debugPrint(
          'SnackMessage: ScaffoldMessenger is null, cannot show "$message"');
      return;
    }

    scaffold.clearSnackBars();
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          scaffold.hideCurrentSnackBar();
        },
      ),
      duration: duration,
    ));
  }

  static void showErrorSnackBar(
    String message, {
    BuildContext? context,
    Duration duration = AppDurations.snackBarInfo,
  }) {
    final scaffold =
        (context != null ? ScaffoldMessenger.maybeOf(context) : null) ??
            scaffoldMessengerKey.currentState;

    if (scaffold == null) {
      debugPrint(
          'SnackMessage: ScaffoldMessenger is null, cannot show "$message"');
      return;
    }

    final colorScheme = context != null ? Theme.of(context).colorScheme : null;

    scaffold.clearSnackBars();
    scaffold.showSnackBar(SnackBar(
      backgroundColor: colorScheme?.errorContainer,
      content: Text(
        message,
        style: colorScheme != null
            ? TextStyle(color: colorScheme.onErrorContainer)
            : null,
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: colorScheme?.onErrorContainer,
        onPressed: () {
          scaffold.hideCurrentSnackBar();
        },
      ),
      duration: duration,
    ));
  }

  static void showActionSnackBar({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    BuildContext? context,
    bool showCloseIcon = true,
    Duration duration = AppDurations.snackBarAction,
  }) {
    final scaffold =
        (context != null ? ScaffoldMessenger.maybeOf(context) : null) ??
            scaffoldMessengerKey.currentState;

    if (scaffold == null) {
      debugPrint(
          'SnackMessage: ScaffoldMessenger is null, cannot show "$message"');
      return;
    }

    scaffold.clearSnackBars();
    scaffold.showSnackBar(SnackBar(
      content: Builder(
        builder: (innerContext) {
          final theme = Theme.of(innerContext);
          final colorScheme = theme.colorScheme;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  foregroundColor: colorScheme.primary,
                ),
                onPressed: () {
                  scaffold.hideCurrentSnackBar();
                  onAction();
                },
                child: Text(actionLabel),
              ),
              if (showCloseIcon) ...[
                const SizedBox(width: AppSpacing.xxs),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: AppSizes.compactActionConstraints,
                  icon: Icon(
                    Icons.close,
                    size: AppSizes.iconSm,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    scaffold.hideCurrentSnackBar();
                  },
                ),
              ],
            ],
          );
        },
      ),
      duration: duration,
    ));
  }
}
