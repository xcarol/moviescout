import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiVersion { v3, v4 }

const String _baseUrlv4 = 'https://api.themoviedb.org/4/';
const String _baseUrlv3 = 'https://api.themoviedb.org/3/';

class TmdbBaseService {
  String accessToken = '';

  dynamic body(response) {
    return jsonDecode(response.body);
  }

  String getCountryCode() {
    return PlatformDispatcher.instance.locale.countryCode ?? "US";
  }

  String getLanguageCode() {
    return PlatformDispatcher.instance.locale.languageCode;
  }

  Future<dynamic> get(String query,
      {ApiVersion version = ApiVersion.v3}) async {
    final String baseUrl = version == ApiVersion.v3 ? _baseUrlv3 : _baseUrlv4;
    final token = accessToken.isEmpty || version == ApiVersion.v3
        ? dotenv.env['TMDB_API_RAT']
        : accessToken;
    final uri = Uri.parse('$baseUrl$query');

    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 2);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        // Running in a browser http.get doesn't return a resonse for a non valid (2xx) server response.
        // It sends an exception instead. Use android for debugging.
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 429 && attempt < maxRetries - 1) {
          await Future.delayed(retryDelay);
          continue;
        }

        return response;
      } on HandshakeException catch (e) {
        debugPrint('TmdbBaseService get HandshakeException: $e');
        if (attempt < maxRetries - 1) {
          await Future.delayed(retryDelay);
          continue;
        }
      } catch (error) {
        if (Platform.isAndroid) {
          final message = 'TmdbBaseService get Error: ${error.toString()}';
          FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: message),
          );
        }
        rethrow;
      }
    }

    throw HttpException('TmdbBaseService get Error: Too many retries');
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {ApiVersion version = ApiVersion.v3}) async {
    try {
      final String baseUrl = version == ApiVersion.v3 ? _baseUrlv3 : _baseUrlv4;
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env['TMDB_API_RAT']
          : accessToken;
      final uri = Uri.parse('$baseUrl/$endpoint');

      return http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
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

  Future<dynamic> delete(String endpoint, Map<String, dynamic> body,
      {ApiVersion version = ApiVersion.v3}) async {
    try {
      final String baseUrl = version == ApiVersion.v3 ? _baseUrlv3 : _baseUrlv4;
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env['TMDB_API_RAT']
          : accessToken;
      final uri = Uri.parse('$baseUrl/$endpoint');

      return http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
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
