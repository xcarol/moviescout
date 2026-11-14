import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_spacing.dart';

class AppErrorView extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? imageAsset;
  final IconData? icon;
  final double imageHeight;

  const AppErrorView({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
    this.imageAsset = 'assets/error-network.png',
    this.icon,
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
                icon ?? Icons.error_outline_rounded,
                size: 56.0,
                color: colorScheme.error,
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
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(retryLabel ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
