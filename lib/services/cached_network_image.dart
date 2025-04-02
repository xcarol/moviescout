import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CachedNetworkImage extends StatefulWidget {
  const CachedNetworkImage(this.imageUrl,
      {super.key, this.fit, this.errorBuilder});

  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<CachedNetworkImage> createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final fileName =
        widget.imageUrl.split('/').last;
    final dir = await getApplicationCacheDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      setState(() => _imageFile = file);
    } else {
      await _downloadImage(widget.imageUrl, filePath);
    }
  }

  Future<void> _downloadImage(String url, String savePath) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      setState(() => _imageFile = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile != null
        ? Image.file(
            _imageFile!,
            fit: widget.fit,
            errorBuilder: widget.errorBuilder,
          )
        : Image.network(
            widget.imageUrl,
            fit: widget.fit,
            errorBuilder: widget.errorBuilder,
          );
  }
}
