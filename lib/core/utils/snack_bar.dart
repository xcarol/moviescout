import 'package:flutter/material.dart';
import 'package:moviescout/main.dart';

class SnackMessage {
  static void showSnackBar(String message, {BuildContext? context}) {
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
      duration: const Duration(seconds: 4),
    ));
  }

  static void showActionSnackBar({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    BuildContext? context,
    bool showCloseIcon = true,
    Duration duration = const Duration(seconds: 8),
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
          final colorScheme = Theme.of(innerContext).colorScheme;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    // color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: colorScheme.primary,
                ),
                onPressed: () {
                  scaffold.hideCurrentSnackBar();
                  onAction();
                },
                child: Text(actionLabel),
              ),
              if (showCloseIcon) ...[
                const SizedBox(width: 2),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                  icon: Icon(
                    Icons.close,
                    size: 18,
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
