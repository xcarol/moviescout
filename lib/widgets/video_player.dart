import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:moviescout/services/video_player_service.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:simple_pip_mode/pip_widget.dart';

class FloatingVideoPlayerWidget extends StatefulWidget {
  const FloatingVideoPlayerWidget({super.key});

  @override
  State<FloatingVideoPlayerWidget> createState() =>
      _FloatingVideoPlayerWidgetState();
}

class _FloatingVideoPlayerWidgetState extends State<FloatingVideoPlayerWidget> {
  YoutubePlayerController? _controller;
  String? _currentVideoId;

  double _x = 16.0;
  double _y = 100.0;
  final double _playerWidth = 300.0;
  final double _playerHeight = 300.0 * (9 / 16);

  @override
  void initState() {
    super.initState();
    VideoPlayerService().addListener(_onPlayerStateChanged);
    _onPlayerStateChanged(); // Initial check

    if (Platform.isAndroid) {
      SimplePip().setAutoPipMode(aspectRatio: const (16, 9));
    }
  }

  @override
  void dispose() {
    VideoPlayerService().removeListener(_onPlayerStateChanged);
    _controller?.close();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (Platform.isAndroid) {
      SimplePip().setAutoPipMode(autoEnter: false);
    }
    super.dispose();
  }

  void _onPlayerStateChanged() {
    final videoId = VideoPlayerService().videoId;
    if (videoId != _currentVideoId) {
      if (videoId == null) {
        _controller?.close();
        _controller = null;
        _currentVideoId = null;
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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

        _controller!.setFullScreenListener((isFullScreen) {
          if (isFullScreen) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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

    return PipWidget(
      pipBuilder: (context) {
        // When in PiP mode, the video fills the whole PiP window
        return Positioned.fill(
          child: Container(
            color: Colors.black,
            child: YoutubePlayer(controller: _controller!),
          ),
        );
      },
      builder: (context) {
        // Normal floating window when not in PiP mode
        return Positioned(
          left: _x,
          top: _y,
          child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            color: Colors.black,
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

                        final size = MediaQuery.of(context).size;
                        if (_x < 0) _x = 0;
                        if (_y < MediaQuery.of(context).padding.top) {
                          _y = MediaQuery.of(context).padding.top;
                        }
                        if (_x > size.width - _playerWidth) {
                          _x = size.width - _playerWidth;
                        }
                        if (_y >
                            size.height -
                                _playerHeight -
                                30 -
                                MediaQuery.of(context).padding.bottom) {
                          _y = size.height -
                              _playerHeight -
                              30 -
                              MediaQuery.of(context).padding.bottom;
                        }
                      });
                    },
                    child: Container(
                      height: 30,
                      color: Colors.grey.shade900,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(Icons.drag_handle,
                              color: Colors.white54, size: 20),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            icon: const Icon(Icons.close, color: Colors.white),
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
      },
    );
  }
}
