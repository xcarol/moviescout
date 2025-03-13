import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://api.themoviedb.org/3/';

class TmdbBaseService {
  dynamic body(response) {
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String query) async {
    try {
      final apiKey = dotenv.env['TMDB_API_KEY'];

      Uri uri = Uri.parse('$_baseUrl$query');

      // Running in a browser http.get doesn't return a resonse for a non valid (2xx) server response.
      // It sends an exception instead. Use android for debugging.
      return http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      });
    } catch (error) {
      final message = 'TmdbBaseService get Error: ${error.toString()}';
      if (Platform.isAndroid) {
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: ([message])));
      }
      throw HttpException(message);
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final apiKey = dotenv.env['TMDB_API_KEY'];
      final uri = Uri.parse('$_baseUrl/$endpoint');

      return http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      );
    } catch (error) {
      final message = 'TmdbBaseService post Error: ${error.toString()}';
      if (Platform.isAndroid) {
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: ([message])));
      }
      throw HttpException(message);
    }
  }

  Future<dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final apiKey = dotenv.env['TMDB_API_KEY'];
      final uri = Uri.parse('$_baseUrl/$endpoint');

      return http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      );
    } catch (error) {
      final message = 'TmdbBaseService delete Error: ${error.toString()}';
      if (Platform.isAndroid) {
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: ([message])));
      }
      throw HttpException(message);
    }
  }
}
