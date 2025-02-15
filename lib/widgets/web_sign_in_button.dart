import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

typedef HandleSignInFn = Future<void> Function();

Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return web.renderButton(
    configuration: GSIButtonConfiguration(
      type: GSIButtonType.icon,
    ),
  );
}
