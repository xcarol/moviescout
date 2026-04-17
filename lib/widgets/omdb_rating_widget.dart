import 'package:flutter/material.dart';

class OmdbRatingWidget extends StatelessWidget {
  final Map<String, dynamic> rating;

  const OmdbRatingWidget({super.key, required this.rating});

  String _normalizeValue(String source, String value) {
    if (source == 'Internet Movie Database' && value.contains('/')) {
      double? num = double.tryParse(value.split('/')[0]);
      if (num != null) return num.toStringAsFixed(1);
    } else if (source == 'Rotten Tomatoes' && value.contains('%')) {
      String clean = value.replaceAll('%', '');
      double? num = double.tryParse(clean);
      if (num != null) {
        return (num / 10).toStringAsFixed(1);
      }
    } else if (source == 'Metacritic' && value.contains('/')) {
      String numStr = value.split('/')[0];
      double? num = double.tryParse(numStr);
      if (num != null) {
        return (num / 10).toStringAsFixed(1);
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    String source = rating['Source'] ?? '';
    String value = _normalizeValue(source, rating['Value'] ?? '');
    String? logoPath;

    if (source == 'Internet Movie Database') {
      logoPath = 'assets/imdb-logo.png';
    } else if (source == 'Rotten Tomatoes') {
      logoPath = 'assets/rotten-logo.png';
    } else if (source == 'Metacritic') {
      logoPath = 'assets/metacritic-logo.png';
    }

    if (logoPath == null) {
      return Text('$source: $value');
    }

    return Tooltip(
      message: source,
      child: Row(
        children: [
          Image.asset(logoPath, height: 16),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }
}
