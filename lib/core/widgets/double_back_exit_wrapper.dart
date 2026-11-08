import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class DoubleBackExitWrapper extends StatefulWidget {
  final Widget child;

  /// Called when the user presses the back button.
  /// Returns [true] if the child widget has already handled the action (e.g. changing tabs).
  /// Returns [false] if it should proceed to validate the double click to exit the app.
  final bool Function() onPopHandled;

  const DoubleBackExitWrapper({
    super.key,
    required this.child,
    required this.onPopHandled,
  });

  @override
  State<DoubleBackExitWrapper> createState() => _DoubleBackExitWrapperState();
}

class _DoubleBackExitWrapperState extends State<DoubleBackExitWrapper> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (widget.onPopHandled()) {
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          final defaultScheme = Theme.of(context).colorScheme;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.zero,
              duration: const Duration(seconds: 2),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: defaultScheme.secondary.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.pressBackAgainToExit,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: defaultScheme.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          );
          return;
        }

        SystemNavigator.pop();
      },
      child: widget.child,
    );
  }
}
