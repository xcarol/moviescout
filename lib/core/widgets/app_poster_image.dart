import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/services/custom_cache_manager.dart';

enum PosterFallbackType {
  movie,
  tvShow,
  person,
  user,
  account,
  backdrop,
  provider,
}

class AppPosterImage extends StatelessWidget {
  final String? imageUrl;
  final PosterFallbackType fallbackType;
  final String? customFallbackAsset;
  final double? aspectRatio;
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
        return 'assets/tvshow.png';
      case PosterFallbackType.person:
        return 'assets/person.png';
      case PosterFallbackType.user:
        return 'assets/user.png';
      case PosterFallbackType.account:
        return 'assets/account.png';
      case PosterFallbackType.backdrop:
        return 'assets/backdrop-placeholder.png';
      case PosterFallbackType.provider:
        return 'assets/provider-placeholder.png';
    }
  }

  Widget _buildFallback() {
    final image = Image.asset(
      _fallbackAsset,
      fit: fallbackFit,
    );
    if (aspectRatio != null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: image,
      );
    }
    return image;
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

    final int defaultMemCacheWidth =
        (aspectRatio != null && aspectRatio == 16 / 9) ? 320 : 200;
    final int defaultMemCacheHeight =
        (aspectRatio != null && aspectRatio == 16 / 9) ? 180 : 300;

    Widget content = CachedNetworkImage(
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
    );

    Widget imageWidget = aspectRatio != null
        ? AspectRatio(
            aspectRatio: aspectRatio!,
            child: content,
          )
        : content;

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}
