import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/services/custom_cache_manager.dart';

enum PosterFallbackType {
  movie,
  tvShow,
  person,
  user,
}

class AppPosterImage extends StatelessWidget {
  final String? imageUrl;
  final PosterFallbackType fallbackType;
  final String? customFallbackAsset;
  final double aspectRatio;
  final BoxFit fit;
  final BoxFit fallbackFit;
  final BorderRadius? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const AppPosterImage({
    super.key,
    required this.imageUrl,
    this.fallbackType = PosterFallbackType.movie,
    this.customFallbackAsset,
    this.aspectRatio = 2 / 3,
    this.fit = BoxFit.cover,
    this.fallbackFit = BoxFit.contain,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  String get _fallbackAsset {
    if (customFallbackAsset != null && customFallbackAsset!.isNotEmpty) {
      return customFallbackAsset!;
    }
    switch (fallbackType) {
      case PosterFallbackType.movie:
        return 'assets/movie.png';
      case PosterFallbackType.tvShow:
        return 'assets/tvshow_poster.png';
      case PosterFallbackType.person:
        return 'assets/person.png';
      case PosterFallbackType.user:
        return 'assets/user.png';
    }
  }

  Widget _buildFallback() {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Image.asset(
        _fallbackAsset,
        fit: fallbackFit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      final fallbackWidget = _buildFallback();
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: fallbackWidget);
      }
      return fallbackWidget;
    }

    final int defaultMemCacheWidth = aspectRatio == 16 / 9 ? 320 : 200;
    final int defaultMemCacheHeight = aspectRatio == 16 / 9 ? 180 : 300;

    Widget imageWidget = AspectRatio(
      aspectRatio: aspectRatio,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        cacheManager: CustomCacheManager.instance,
        fit: fit,
        memCacheWidth: memCacheWidth ?? defaultMemCacheWidth,
        memCacheHeight: memCacheHeight ?? defaultMemCacheHeight,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholderFadeInDuration: const Duration(milliseconds: 100),
        cacheKey: imageUrl,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        errorWidget: (context, error, stackTrace) => _buildFallback(),
      ),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}
