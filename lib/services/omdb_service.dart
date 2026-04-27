import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class OmdbService {
  static const String _baseUrl = 'https://www.omdbapi.com/';

  static final Map<String, List<Map<String, dynamic>>> _cache = {};
  
  Future<List<Map<String, dynamic>>> getRatings(String imdbId) async {
    if (imdbId.isEmpty) return [];
    if (_cache.containsKey(imdbId)) return _cache[imdbId]!;

    final apiKey = dotenv.env[AppConstants.omdbApiKey];
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
          final ratings = List<Map<String, dynamic>>.from(data['Ratings']);
          _cache[imdbId] = ratings;
          return ratings;
        }
      } else {
        ErrorService.log(
            'OMDB API returned ${response.statusCode} for imdbId $imdbId',
            showSnackBar: false,
            reportToCrashlytics: response.statusCode == 401 ? true : false);
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
