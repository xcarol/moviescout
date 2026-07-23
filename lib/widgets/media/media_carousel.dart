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
  int _currentPage = 0;
  static const int _infiniteBase = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _infiniteBase);
    _currentPage = 0;
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

  int _getRealIndex(int index, int total) {
    if (total <= 0) return 0;
    return ((((index - _infiniteBase) % total) + total) % total).toInt();
  }

  Widget _buildCarousel(
      BuildContext context, int totalItems, List<String> images) {
    return RepaintBoundary(
        child: AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        children: [
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
          PageView.builder(
            controller: _pageController,
            physics:
                totalItems == 1 ? const NeverScrollableScrollPhysics() : null,
            onPageChanged: (index) {
              final realIndex = _getRealIndex(index, totalItems);
              if (realIndex != _currentPage) {
                setState(() {
                  _currentPage = realIndex;
                });
              }
            },
            itemBuilder: (context, index) {
              final realIndex = _getRealIndex(index, totalItems);
              return _buildImage(images[realIndex]);
            },
          ),
          if (totalItems > 1)
            Positioned(
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
                      final colorScheme = Theme.of(context).colorScheme;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 16 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.onPrimary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
        ],
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
          ? _buildImageFromUrl(image)
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
