import 'package:flutter/material.dart';

class MainAppBar extends AppBar {
  MainAppBar({
    super.key,
    required BuildContext context,
    required String title,
    List<Widget> actions = const [],
  }) : super(
          title: Text(title),
          actions: [...actions, const SizedBox(width: 20)],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        );
}
