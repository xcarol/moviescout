import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MediaCarousel extends StatefulWidget {
  final TmdbTitle title;

  const MediaCarousel({
    required this.title,
    super.key,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final totalItems = widget.title.images.length + widget.title.videos.length;
    final initialPage = totalItems > 1 ? 1000 * totalItems : 0;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.title.images;

    final allVideos = widget.title.videos;
    final tmdbVideos = allVideos
        .where((v) => v[TmdbTitleFields.isSearchResult] != true)
        .toList()
        .reversed;
    final ytVideos = allVideos
        .where((v) => v[TmdbTitleFields.isSearchResult] == true)
        .toList();

    final videos = [...tmdbVideos, ...ytVideos];

    if (images.isEmpty && videos.isEmpty) {
      return _buildFallbackBanner();
    }

    final totalItems = images.length + videos.length;

    return _buildCarousel(context, totalItems, images, videos);
  }

  Widget _buildCarousel(BuildContext context, int totalItems,
      List<String> images, List<Map<String, dynamic>> videos) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            key: const PageStorageKey('media_carousel_page_view'),
            controller: _pageController,
            onPageChanged: (index) {
              final realIndex = index % totalItems;
              if (realIndex != _currentPage) {
                setState(() {
                  _currentPage = realIndex;
                });
              }
            },
            itemBuilder: (context, index) {
              final realIndex = index % totalItems;
              if (realIndex < images.length) {
                return _buildImage(images[realIndex]);
              } else {
                return VideoPlayerItem(
                  video: videos[realIndex - images.length],
                  isCurrentPage: realIndex == _currentPage,
                );
              }
            },
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
      ),
    );
  }

  Widget _buildFallbackBanner() {
    final image = widget.title.backdropPath.isNotEmpty
        ? widget.title.backdropPath
        : widget.title.posterPath;
    final isMovie = widget.title.isMovie;

    return AspectRatio(
      aspectRatio: 16 / 9,
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
}

class VideoPlayerItem extends StatefulWidget {
  final Map<String, dynamic> video;
  final bool isCurrentPage;

  const VideoPlayerItem({
    required this.video,
    required this.isCurrentPage,
    super.key,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;
  ScrollPosition? _scrollPosition;
  Orientation? _lastOrientation;

  @override
  bool get wantKeepAlive => _isPlaying;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_onScroll);
    try {
      // Specifically look for the vertical scrollable (the screen)
      // instead of the horizontal PageView.
      _scrollPosition =
          Scrollable.maybeOf(context, axis: Axis.vertical)?.position;
      _scrollPosition?.addListener(_onScroll);
    } catch (_) {}
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pause if we swipe away, but keep the player in the tree
    if (!widget.isCurrentPage && _isPlaying) {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isPlaying || _controller == null || !mounted) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final offset = renderObject.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.of(context).size.height;
      // Stop video if it's 80% out of view at the top OR entirely out at the bottom
      if (offset < -renderObject.size.height * 0.8 || offset > screenHeight) {
        _stopPlayback();
      }
    }
  }

  void _stopPlayback() {
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _controller?.dispose();
        _controller = null;
      });
      updateKeepAlive();
    }
  }

  void _startPlayback() async {
    final key = widget.video['key'] as String;

    if (!kIsWeb && Platform.isLinux) {
      final url = Uri.parse('https://www.youtube.com/watch?v=$key');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
      return;
    }

    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          useHybridComposition: true,
          disableDragSeek: true,
          // Hide the default fullscreen button to force using our custom one
          // which correctly handles the navigation and orientation.
        ),
      );
      _isPlaying = true;
    });
    updateKeepAlive();
  }

  void _enterFullScreen({bool isAuto = false}) {
    if (_controller == null) return;

    final currentPosition = _controller!.value.position;
    _controller!.pause();

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => FullScreenPlayer(
          videoId: widget.video['key'] as String,
          startAt: currentPosition,
          isAuto: isAuto,
        ),
      ),
    )
        .then((resumePosition) {
      if (mounted) {
        if (resumePosition != null && resumePosition is Duration) {
          _controller?.seekTo(resumePosition);
        }
        _controller?.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final key = widget.video['key'] as String;
    final name = widget.video['name'] as String;
    final isSearch = widget.video[TmdbTitleFields.isSearchResult] == true;
    final currentOrientation = MediaQuery.of(context).orientation;

    if (_isPlaying &&
        _lastOrientation == Orientation.portrait &&
        currentOrientation == Orientation.landscape) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _enterFullScreen(isAuto: true);
      });
    }
    _lastOrientation = currentOrientation;

    if (_isPlaying && _controller != null) {
      return Stack(
        children: [
          YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            onEnded: (meta) => _stopPlayback(),
            // Ensure we don't show the package's internal fullscreen button
            bottomActions: [
              const SizedBox(width: 14.0),
              CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              PlaybackSpeedButton(),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 32),
              onPressed: () => _enterFullScreen(isAuto: false),
            ),
          ),
          if (isSearch)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.youtubeSearch,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
        if (isSearch)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.youtubeSearch,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
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
              onPressed: _startPlayback,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 8,
          right: 8,
          child: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
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

class FullScreenPlayer extends StatefulWidget {
  final String videoId;
  final Duration startAt;
  final bool isAuto;

  const FullScreenPlayer({
    required this.videoId,
    required this.startAt,
    this.isAuto = false,
    super.key,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        startAt: widget.startAt.inSeconds,
        useHybridComposition: true,
      ),
    );

    if (!widget.isAuto) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAuto &&
        MediaQuery.of(context).orientation == Orientation.portrait) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop(_controller.value.position);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onEnded: (meta) =>
                  Navigator.of(context).pop(_controller.value.position),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                onPressed: () =>
                    Navigator.of(context).pop(_controller.value.position),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
