import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class BoxedWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  const BoxedWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs,
      vertical: AppSpacing.xxs,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHigh,
      elevation: AppSizes.elevationSubtle,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderXs,
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: AppSizes.borderWidthThin,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.borderXs,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
