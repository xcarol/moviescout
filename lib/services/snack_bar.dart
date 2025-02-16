import 'package:flutter/material.dart';

class SnackMessage {
  static void showSnackBar(var context, String message) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          scaffold.hideCurrentSnackBar();
        },
      ),
      duration: Duration(days: 1),
    ));
  }
}
