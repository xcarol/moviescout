import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MediaCarousel extends StatefulWidget {
  final TmdbTitle title;

  const MediaCarousel({required this.title, super.key});

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  String? _playingVideoKey;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final totalItems = widget.title.images.length + widget.title.videos.length;
    // Start at a high number that is a multiple of totalItems to stay on the "first" item
    final initialPage = totalItems > 1 ? 1000 * totalItems : 0;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _playVideo(String key) {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      _controller?.dispose();

      _controller = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      setState(() {
        _playingVideoKey = key;
      });
    } else {
      final url = Uri.parse('https://www.youtube.com/watch?v=$key');
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.title.images;
    final videos = widget.title.videos;

    if (images.isEmpty && videos.isEmpty) {
      return _buildFallbackBanner();
    }

    final totalItems = images.length + videos.length;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildSizedBoxConstraints(
          height: MediaQuery.of(context).size.width * 9 / 16,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              final realIndex = index % totalItems;
              setState(() {
                _currentPage = realIndex;
                if (_playingVideoKey != null) {
                  _playingVideoKey = null;
                  _controller?.dispose();
                  _controller = null;
                }
              });
            },
            itemBuilder: (context, index) {
              final realIndex = index % totalItems;
              if (realIndex < images.length) {
                return _buildImage(images[realIndex]);
              } else {
                return _buildVideo(videos[realIndex - images.length]);
              }
            },
          ),
        ),
        if (totalItems > 1)
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalItems, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildSizedBoxConstraints(
      {required double height, required Widget child}) {
    return SizedBox(height: height, width: double.infinity, child: child);
  }

  Widget _buildFallbackBanner() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 9 / 16;
    final image = widget.title.backdropPath.isNotEmpty
        ? widget.title.backdropPath
        : widget.title.posterPath;
    final isMovie = widget.title.isMovie;

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: image.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.fill,
              errorWidget: (context, error, stackTrace) =>
                  _buildPlaceholder(isMovie),
            )
          : _buildPlaceholder(isMovie),
    );
  }

  Widget _buildPlaceholder(bool isMovie) {
    return Image.asset(
      isMovie ? 'assets/movie_poster.png' : 'assets/tvshow_poster.png',
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildImage(String path) {
    final url = 'https://image.tmdb.org/t/p/original$path';

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildVideo(Map<String, dynamic> video) {
    final key = video['key'] as String;
    final name = video['name'] as String;

    if (_playingVideoKey == key && _controller != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          onEnded: (meta) {
            setState(() {
              _playingVideoKey = null;
            });
            _controller?.dispose();
            _controller = null;
          },
        ),
        builder: (context, player) {
          return player;
        },
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: 'https://img.youtube.com/vi/$key/0.jpg',
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(color: Colors.black),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            ),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.play_arrow_rounded,
                  size: 56, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => _playVideo(key),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
