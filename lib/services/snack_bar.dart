import 'package:flutter/material.dart';
import 'package:moviescout/main.dart';

class SnackMessage {
  static void showSnackBar(String message) {
    final scaffold = scaffoldMessengerKey.currentState;

    scaffold?.showSnackBar(SnackBar(
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
