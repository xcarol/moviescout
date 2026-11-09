import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class AppCacheManager {
  static const key = 'customCacheKey';
  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      fileService: HttpFileService(),
    ),
  );
}

enum AppImageType {
  poster,
  backdrop,
  avatar,
  logo,
  custom,
}

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final AppImageType type;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final bool isCircular;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final IconData? fallbackIcon;
  final double? fallbackIconSize;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.type = AppImageType.poster,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircular = false,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fallbackIcon,
    this.fallbackIconSize,
  });

  IconData get _defaultIcon {
    if (fallbackIcon != null) return fallbackIcon!;
    switch (type) {
      case AppImageType.poster:
      case AppImageType.backdrop:
        return Icons.movie_outlined;
      case AppImageType.avatar:
        return Icons.person_outline;
      case AppImageType.logo:
        return Icons.tv_outlined;
      case AppImageType.custom:
        return Icons.image_outlined;
    }
  }

  Widget _buildFallback(BuildContext context, {bool isLoading = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIconSize = fallbackIconSize ??
        ((width != null && width! < AppSizes.avatarLg)
            ? AppSizes.iconMd
            : AppSizes.iconXl);

    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        _defaultIcon,
        size: effectiveIconSize,
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: isLoading ? 0.25 : 0.45,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    Widget content;

    if (url.isEmpty) {
      content = _buildFallback(context);
    } else if (kIsWeb && type == AppImageType.avatar) {
      content = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    } else {
      content = CachedNetworkImage(
        imageUrl: url,
        cacheManager: AppCacheManager.instance,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: AppDurations.fast,
        placeholder: (context, _) => _buildFallback(context, isLoading: true),
        errorWidget: (context, _, __) => _buildFallback(context),
      );
    }

    if (aspectRatio != null) {
      content = AspectRatio(
        aspectRatio: aspectRatio!,
        child: content,
      );
    }

    if (isCircular) {
      return ClipOval(child: content);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }
}
