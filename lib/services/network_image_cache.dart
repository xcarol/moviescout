import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class _ImageCacheManager {
  static final _ImageCacheManager _instance = _ImageCacheManager._internal();
  factory _ImageCacheManager() => _instance;
  _ImageCacheManager._internal();

  final Map<String, Future<dynamic>> _loadingFutures = {};
  final Map<String, dynamic> _cachedResults = {};
  final List<String> _accessOrder = [];
  static const int _maxCacheSize = 500;

  Future<dynamic> loadImage(String imageUrl) async {
    if (_cachedResults.containsKey(imageUrl)) {
      _updateAccessOrder(imageUrl);
      return Future.value(_cachedResults[imageUrl]);
    }

    if (_loadingFutures.containsKey(imageUrl)) {
      return _loadingFutures[imageUrl]!;
    }

    final future = _loadImage(imageUrl);
    _loadingFutures[imageUrl] = future;

    try {
      final result = await future;
      _addToCache(imageUrl, result);
      return result;
    } finally {
      _loadingFutures.remove(imageUrl);
    }
  }

  void _updateAccessOrder(String imageUrl) {
    _accessOrder.remove(imageUrl);
    _accessOrder.add(imageUrl);
  }

  void _addToCache(String imageUrl, dynamic result) {
    if (_cachedResults.length >= _maxCacheSize &&
        !_cachedResults.containsKey(imageUrl)) {
      final oldest = _accessOrder.removeAt(0);
      _cachedResults.remove(oldest);
    }

    _cachedResults[imageUrl] = result;
    _updateAccessOrder(imageUrl);
  }

  Future<dynamic> _loadImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;

    final fileName = imageUrl.split('/').last;
    final dir = await getApplicationCacheDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else {
      return _downloadImage(imageUrl, filePath);
    }
  }

  Future<dynamic> _downloadImage(String url, String savePath) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  void clearCache() {
    _cachedResults.clear();
    _loadingFutures.clear();
    _accessOrder.clear();
  }

  int get cacheSize => _cachedResults.length;
}

class NetworkImageCache extends StatelessWidget {
  NetworkImageCache(this.imageUrl, {this.fit, this.errorBuilder})
      : super(key: ValueKey(imageUrl));

  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  static final _cacheManager = _ImageCacheManager();

  static void clearCache() {
    _cacheManager.clearCache();
  }

  Widget _fadeIn(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value,
          child: widget,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageFuture = _cacheManager.loadImage(imageUrl);

    return RepaintBoundary(
      child: FutureBuilder(
        future: imageFuture,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 600)),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              },
            );
          } else {
            final imageFile = snapshot.data;
            return imageFile != null
                ? _fadeIn(Image.file(
                    imageFile!,
                    fit: fit,
                    errorBuilder: errorBuilder,
                  ))
                : _fadeIn(Image.network(
                    imageUrl,
                    fit: fit,
                    errorBuilder: errorBuilder,
                  ));
          }
        },
      ),
    );
  }
}
