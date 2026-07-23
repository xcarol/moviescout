import 'package:moviescout/utils/url_constants.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              showNavButtons: true,
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
      return SvgPicture.asset(
        'assets/person.svg',
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
        showNavButtons: true,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, realIndex) {
          final path = widget.images[realIndex];
          final url = UrlConstants.tmdbImageOriginalTemplate
              .replaceFirst('{PATH}', path);
          return InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CarouselBase extends StatelessWidget {
  final PageController pageController;
  final int totalItems;
  final int currentPage;
  final int infiniteBase;
  final bool showNavButtons;
  final Widget Function(BuildContext, int realIndex) itemBuilder;
  final ValueChanged<int> onPageChanged;

  const _CarouselBase({
    required this.pageController,
    required this.totalItems,
    required this.currentPage,
    this.infiniteBase = 0,
    this.showNavButtons = false,
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
          physics:
              totalItems == 1 ? const NeverScrollableScrollPhysics() : null,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            final realIndex = _getRealIndex(index, totalItems);
            return itemBuilder(context, realIndex);
          },
        ),
        if (showNavButtons && totalItems > 1)
          _buildNavButton(context, isLeft: true),
        if (showNavButtons && totalItems > 1)
          _buildNavButton(context, isLeft: false),
        if (totalItems > 1) _buildDotIndicators(context),
      ],
    );
  }
}
