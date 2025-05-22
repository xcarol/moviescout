import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NetworkImageCache extends StatelessWidget {
  const NetworkImageCache(this.imageUrl,
      {super.key, this.fit, this.errorBuilder});

  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  Future<dynamic> _loadImage(String imageUrl) async {
    final fileName = imageUrl.split('/').last;
    final dir = await getApplicationCacheDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else if (imageUrl.isNotEmpty) {
      return _downloadImage(imageUrl, filePath);
    }

    return null;
  }

  Future<dynamic> _downloadImage(String url, String savePath) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadImage(imageUrl),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final imageFile = snapshot.data;
            return imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: fit,
                    errorBuilder: errorBuilder,
                  )
                : Image.network(
                    imageUrl,
                    fit: fit,
                    errorBuilder: errorBuilder,
                  );
          }
        });
  }
}
