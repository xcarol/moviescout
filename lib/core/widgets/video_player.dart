import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/services/video_player_service.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FloatingVideoPlayerWidget extends StatefulWidget {
  const FloatingVideoPlayerWidget({super.key});

  @override
  State<FloatingVideoPlayerWidget> createState() =>
      _FloatingVideoPlayerWidgetState();
}

class _FloatingVideoPlayerWidgetState extends State<FloatingVideoPlayerWidget> {
  YoutubePlayerController? _controller;
  String? _currentVideoId;

  double _x = AppSizes.floatingPlayerInitialX;
  double _y = AppSizes.floatingPlayerInitialY;
  final double _playerWidth = AppSizes.floatingPlayerWidth;
  final double _playerHeight =
      AppSizes.floatingPlayerWidth / AppSizes.aspectRatioBackdrop;

  @override
  void initState() {
    super.initState();
    VideoPlayerService().addListener(_onPlayerStateChanged);
    _onPlayerStateChanged();
    _enableAutoPip();
  }

  Future<void> _enableAutoPip() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final isAvailable = await SimplePip.isAutoPipAvailable;
        if (isAvailable) {
          await SimplePip().setAutoPipMode(aspectRatio: const (16, 9));
        }
      } catch (e, stackTrace) {
        ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
      }
    }
  }

  @override
  void dispose() {
    VideoPlayerService().removeListener(_onPlayerStateChanged);
    _controller?.close();
    SystemChrome.setPreferredOrientations(const []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _disableAutoPip();
    super.dispose();
  }

  Future<void> _disableAutoPip() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final isAvailable = await SimplePip.isAutoPipAvailable;
        if (isAvailable) {
          await SimplePip().setAutoPipMode(autoEnter: false);
        }
      } catch (e, stackTrace) {
        ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
      }
    }
  }

  Future<void> _onPlayerStateChanged() async {
    final videoId = VideoPlayerService().videoId;
    if (videoId != _currentVideoId) {
      if (videoId == null) {
        _controller?.close();
        _controller = null;
        _currentVideoId = null;
        await SystemChrome.setPreferredOrientations(const []);
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        if (mounted) setState(() {});
      } else {
        _controller?.close();
        _currentVideoId = videoId;

        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: true,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );

        _controller!.setFullScreenListener((isFullScreen) async {
          if (isFullScreen) {
            await SystemChrome.setPreferredOrientations(const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            await SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.immersiveSticky);
          } else {
            await SystemChrome.setPreferredOrientations(const []);
            await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }
        });

        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _currentVideoId == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    Widget floatingWindow(BuildContext context) {
      return Positioned(
        left: _x,
        top: _y,
        child: Material(
          elevation: AppSizes.floatingPlayerElevation,
          borderRadius: AppRadius.borderMd,
          clipBehavior: Clip.antiAlias,
          color: colorScheme.surfaceContainerHighest,
          child: SizedBox(
            width: _playerWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _x += details.delta.dx;
                      _y += details.delta.dy;

                      final mediaQuery = MediaQuery.of(context);
                      final size = mediaQuery.size;
                      if (_x < 0) _x = 0;
                      if (_y < mediaQuery.padding.top) {
                        _y = mediaQuery.padding.top;
                      }
                      if (_x > size.width - _playerWidth) {
                        _x = size.width - _playerWidth;
                      }
                      final maxTop = size.height -
                          _playerHeight -
                          AppSizes.floatingPlayerHeaderHeight -
                          mediaQuery.padding.bottom;
                      if (_y > maxTop) {
                        _y = maxTop;
                      }
                    });
                  },
                  child: Container(
                    height: AppSizes.floatingPlayerHeaderHeight,
                    color: colorScheme.surfaceContainerHigh,
                    child: Row(
                      children: [
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.drag_handle,
                          color: colorScheme.onSurfaceVariant,
                          size: AppSizes.iconMd,
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: AppSizes.iconMd,
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.onSurface,
                          ),
                          onPressed: () {
                            VideoPlayerService().closeVideo();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _playerHeight,
                  child: YoutubePlayer(
                    controller: _controller!,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return PipWidget(
        pipBuilder: (context) {
          return Positioned.fill(
            child: ColoredBox(
              color: colorScheme.surface,
              child: YoutubePlayer(controller: _controller!),
            ),
          );
        },
        builder: floatingWindow,
      );
    }

    return floatingWindow(context);
  }
}
