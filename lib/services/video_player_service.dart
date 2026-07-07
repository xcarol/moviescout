import 'package:flutter/material.dart';
import 'package:moviescout/widgets/video_player.dart';
import 'package:moviescout/services/deep_link_service.dart';

class VideoPlayerService extends ChangeNotifier {
  static final VideoPlayerService _instance = VideoPlayerService._internal();
  factory VideoPlayerService() => _instance;
  VideoPlayerService._internal();

  String? _videoId;
  String? get videoId => _videoId;

  OverlayEntry? _overlayEntry;

  void playVideo(String videoId) {
    _videoId = videoId;

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => const FloatingVideoPlayerWidget(),
      );

      final overlayState = DeepLinkService().navigatorKey.currentState?.overlay;
      if (overlayState != null) {
        overlayState.insert(_overlayEntry!);
      }
    }

    notifyListeners();
  }

  void closeVideo() {
    _videoId = null;
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    notifyListeners();
  }
}
