import 'dart:ui';
import 'package:moviescout/utils/url_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/utils/api_constants.dart';

class MediaCarousel extends StatefulWidget {
  final List<String> images;
  final String backdropPath;
  final String posterPath;
  final String mediaType;
  final bool isLoading;
  final double aspectRatio;

  const MediaCarousel({
    required this.images,
    required this.backdropPath,
    required this.posterPath,
    required this.mediaType,
    this.isLoading = false,
    this.aspectRatio = 16 / 9,
    super.key,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  late int _currentPage;
  static const int infiniteBase = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: infiniteBase);
    _currentPage = infiniteBase;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    if (images.isEmpty) {
      return _buildFallbackBanner();
    }

    final totalItems = images.length;

    return _buildCarousel(context, totalItems, images);
  }

  Widget _buildCarousel(
      BuildContext context, int totalItems, List<String> images) {
    return RepaintBoundary(
        child: AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenCarousel(
                images: images,
                initialPage: _pageController.hasClients
                    ? _pageController.page?.round() ?? infiniteBase
                    : infiniteBase,
                infiniteBase: infiniteBase,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            _CarouselBase(
              pageController: _pageController,
              totalItems: totalItems,
              currentPage: _currentPage,
              infiniteBase: infiniteBase,
              showNavButtons: false,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, realIndex) {
                return _buildImage(images[realIndex]);
              },
            ),
            if (widget.isLoading)
              const Positioned(
                top: 10,
                right: 10,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Widget _buildFallbackBanner() {
    final image = widget.backdropPath.isNotEmpty
        ? widget.backdropPath
        : widget.posterPath;
    final mediaType = widget.mediaType;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: image.isNotEmpty
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenCarousel(
                      images: [image],
                      initialPage: 0,
                      infiniteBase: 0,
                    ),
                  ),
                );
              },
              child: _buildImage(image),
            )
          : _buildPlaceholder(mediaType),
    );
  }

  Widget _buildPlaceholder(String mediaType) {
    if (mediaType == ApiConstants.person) {
      return Image.asset(
        'assets/person.png',
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      mediaType == ApiConstants.movie
          ? 'assets/movie_poster.png'
          : 'assets/tvshow_poster.png',
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildImage(String path) {
    return _buildImageFromUrl(
        UrlConstants.tmdbImageOriginalTemplate.replaceFirst('{PATH}', path));
  }

  Widget _buildImageFromUrl(String url) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            color: colorScheme.surface.withValues(alpha: 0.4),
            colorBlendMode: BlendMode.darken,
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
        ),
        CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            color: colorScheme.surface.withValues(alpha: 0.1),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }
}

class FullScreenCarousel extends StatefulWidget {
  final List<String> images;
  final int initialPage;
  final int infiniteBase;

  const FullScreenCarousel({
    super.key,
    required this.images,
    required this.initialPage,
    required this.infiniteBase,
  });

  @override
  State<FullScreenCarousel> createState() => FullScreenCarouselState();
}

class FullScreenCarouselState extends State<FullScreenCarousel> {
  late PageController _pageController;
  late int _currentPage;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getRealIndex(int index, int total) {
    if (total <= 0) return 0;
    return ((((index - widget.infiniteBase) % total) + total) % total).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.images.length;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      extendBodyBehindAppBar: true,
      body: _CarouselBase(
        pageController: _pageController,
        totalItems: totalItems,
        currentPage: _currentPage,
        infiniteBase: widget.infiniteBase,
        showNavButtons: false,
        isZoomed: _isZoomed,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            _isZoomed = false;
          });
        },
        itemBuilder: (context, realIndex) {
          final path = widget.images[realIndex];
          final url = UrlConstants.tmdbImageOriginalTemplate
              .replaceFirst('{PATH}', path);
          final isCurrent =
              realIndex == _getRealIndex(_currentPage, totalItems);
          return _ZoomableImage(
            key: ValueKey('$path-$realIndex'),
            imageUrl: url,
            isActive: isCurrent,
            onZoomChanged: (isZoomed) {
              if (isCurrent && _isZoomed != isZoomed) {
                setState(() {
                  _isZoomed = isZoomed;
                });
              }
            },
          );
        },
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final bool isActive;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomableImage({
    super.key,
    required this.imageUrl,
    required this.isActive,
    required this.onZoomChanged,
  });

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;
  Offset? _doubleTapPosition;
  bool _isZoomed = false;
  static const double _zoomThreshold = 1.01;
  static const double _doubleTapScale = 2.5;
  static const double _maxScale = 4.0;
  static const double _minScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(_handleAnimationTick);
  }

  @override
  void didUpdateWidget(covariant _ZoomableImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && oldWidget.isActive) {
      _resetZoom();
    }
  }

  void _handleAnimationTick() {
    if (_animation != null) {
      _transformationController.value = _animation!.value;
    }
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final isZoomed = scale > _zoomThreshold;
    if (isZoomed != _isZoomed) {
      _isZoomed = isZoomed;
      if (mounted) {
        widget.onZoomChanged(isZoomed);
      }
    }
  }

  void _resetZoom() {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _transformationController.value = Matrix4.identity();
    if (_isZoomed) {
      _isZoomed = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onZoomChanged(false);
        }
      });
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void _handleDoubleTap(BoxConstraints constraints) {
    if (_animationController.isAnimating) return;

    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final isZoomed = currentScale > _zoomThreshold;

    if (isZoomed) {
      _animateTransform(Matrix4.identity());
    } else {
      final position = _doubleTapPosition ??
          Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

      final double tx = -position.dx * (_doubleTapScale - 1);
      final double ty = -position.dy * (_doubleTapScale - 1);

      final minTx = -(_doubleTapScale - 1) * constraints.maxWidth;
      final minTy = -(_doubleTapScale - 1) * constraints.maxHeight;

      final clampedTx = tx.clamp(minTx, 0.0);
      final clampedTy = ty.clamp(minTy, 0.0);

      final targetMatrix = Matrix4(
        _doubleTapScale,
        0,
        0,
        0,
        0,
        _doubleTapScale,
        0,
        0,
        0,
        0,
        1,
        0,
        clampedTx,
        clampedTy,
        0,
        1,
      );

      _animateTransform(targetMatrix);
    }
  }

  void _animateTransform(Matrix4 targetMatrix) {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward(from: 0);
  }

  void _handleInteractionStart(ScaleStartDetails details) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale <= _zoomThreshold) {
      _transformationController.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _animationController.removeListener(_handleAnimationTick);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: () => _handleDoubleTap(constraints),
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: _minScale,
            maxScale: _maxScale,
            panEnabled: _isZoomed,
            scaleEnabled: true,
            onInteractionStart: _handleInteractionStart,
            onInteractionEnd: _handleInteractionEnd,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: colorScheme.error),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CarouselBase extends StatelessWidget {
  final PageController pageController;
  final int totalItems;
  final int currentPage;
  final int infiniteBase;
  final bool showNavButtons;
  final bool isZoomed;
  final Widget Function(BuildContext, int realIndex) itemBuilder;
  final ValueChanged<int> onPageChanged;

  const _CarouselBase({
    required this.pageController,
    required this.totalItems,
    required this.currentPage,
    this.infiniteBase = 0,
    this.showNavButtons = false,
    this.isZoomed = false,
    required this.itemBuilder,
    required this.onPageChanged,
  });

  int _getRealIndex(int index, int total) {
    if (total <= 0) return 0;
    return ((((index - infiniteBase) % total) + total) % total).toInt();
  }

  Widget _buildDotIndicators(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 10,
      right: 10,
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalItems, (index) {
              final realCurrentPage = _getRealIndex(currentPage, totalItems);
              final colorScheme = Theme.of(context).colorScheme;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: realCurrentPage == index ? 16 : 8,
                decoration: BoxDecoration(
                  color: realCurrentPage == index
                      ? colorScheme.primary
                      : colorScheme.onPrimary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, {required bool isLeft}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      left: isLeft ? 10 : null,
      right: !isLeft ? 10 : null,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(isLeft ? Icons.chevron_left : Icons.chevron_right,
                size: 30),
            color: colorScheme.onSurface,
            onPressed: () {
              if (isLeft) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: pageController,
          physics: (totalItems == 1 || isZoomed)
              ? const NeverScrollableScrollPhysics()
              : null,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            final realIndex = _getRealIndex(index, totalItems);
            return itemBuilder(context, realIndex);
          },
        ),
        if (showNavButtons && totalItems > 1 && !isZoomed)
          _buildNavButton(context, isLeft: true),
        if (showNavButtons && totalItems > 1 && !isZoomed)
          _buildNavButton(context, isLeft: false),
        if (totalItems > 1 && !isZoomed) _buildDotIndicators(context),
      ],
    );
  }
}
