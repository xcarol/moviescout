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
      duration: const Duration(minutes: 1),
    ));
  }
}
