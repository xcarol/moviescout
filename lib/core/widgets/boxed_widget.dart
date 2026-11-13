import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_radius.dart';

class BoxedWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  const BoxedWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 4,
      borderRadius: AppRadius.borderSm,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
