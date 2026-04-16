import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/error_service.dart';

class OmdbService {
  static const String _baseUrl = 'https://www.omdbapi.com/';

  Future<List<Map<String, dynamic>>> getRatings(String imdbId) async {
    if (imdbId.isEmpty) return [];

    final apiKey = dotenv.env['OMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      if (kDebugMode) {
        print('OMDB_API_KEY is not set in .env');
      }
      return [];
    }

    final uri = Uri.parse('$_baseUrl?i=$imdbId&apikey=$apiKey');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['Response'] == 'True' && data['Ratings'] is List) {
          return List<Map<String, dynamic>>.from(data['Ratings']);
        }
      } else {
        ErrorService.log(
            'OMDB API returned ${response.statusCode} for imdbId $imdbId',
            showSnackBar: false);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error fetching OMDB ratings: $e',
        stackTrace: stackTrace,
        showSnackBar: false,
      );
    }

    return [];
  }
}
