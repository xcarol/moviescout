import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_spacing.dart';

class AppEmptyState extends StatelessWidget {
  final String? imageAsset;
  final IconData? icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customAction;
  final double iconSize;
  final double imageHeight;

  const AppEmptyState({
    super.key,
    this.imageAsset,
    this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.customAction,
    this.iconSize = 56.0,
    this.imageHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageAsset != null && imageAsset!.isNotEmpty)
              Image.asset(
                imageAsset!,
                height: imageHeight,
                fit: BoxFit.contain,
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: iconSize,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (customAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              customAction!,
            ] else if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
