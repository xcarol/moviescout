import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiVersion { v3, v4 }

const String _baseUrlv4 = 'https://api.themoviedb.org/4/';
const String _baseUrlv3 = 'https://api.themoviedb.org/3/';

const int _maxRequestsCount = 40;
const int _initialDelayMs = 200;
const int _maxDelayMs = 5000;

const String anonymousAccountId = 'anonymousAccountId';

class TmdbBaseService {
  static int _requestCount = 0;

  static Locale _empowerMonirizedLanguages() {
    final systemLocale = PlatformDispatcher.instance.locale;

    Locale appLocale;
    if (systemLocale.languageCode == 'ca' && systemLocale.countryCode == null) {
      appLocale = const Locale('ca', 'ES');
    } else {
      appLocale = systemLocale;
    }

    return appLocale;
  }

  dynamic body(http.Response response) {
    return jsonDecode(response.body);
  }

  String getCountryCode() {
    return _empowerMonirizedLanguages().countryCode ?? "US";
  }

  String getLanguageCode() {
    return _empowerMonirizedLanguages().languageCode;
  }

  Future<dynamic> get(
    String query, {
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
    final String baseUrl = version == ApiVersion.v3 ? _baseUrlv3 : _baseUrlv4;
    final token = accessToken.isEmpty || version == ApiVersion.v3
        ? dotenv.env['TMDB_API_RAT']
        : accessToken;
    final uri = Uri.parse('$baseUrl$query');

    const Duration initialDelay = Duration(milliseconds: _initialDelayMs);
    const Duration maxDelay = Duration(milliseconds: _maxDelayMs);
    Duration delay = initialDelay;

    Duration updatedDelay() =>
        (delay * 2).compareTo(maxDelay) < 0 ? delay * 2 : maxDelay;

    while (_requestCount >= _maxRequestsCount) {
      await Future.delayed(initialDelay);
    }

    _requestCount++;

    int retryCount = 0;
    const int maxRetries = 5;

    while (retryCount < maxRetries) {
      try {
        // Running in a browser http.get doesn't return a response for a non valid (2xx) server response.
        // It sends an exception instead. Use android for debugging.
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 429) {
          debugPrint(
            'TmdbBaseService get Rate limit exceeded. Retrying in ${delay.inSeconds} seconds...',
          );
          await Future.delayed(delay);
          delay = updatedDelay();
          retryCount++;
          continue;
        }

        _requestCount--;
        return response;
      } on http.ClientException {
        debugPrint(
            'ClientException: retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
        delay = updatedDelay();
        retryCount++;
      } on SocketException {
        debugPrint(
            'SocketException: retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
        delay = updatedDelay();
        retryCount++;
      } on HandshakeException {
        debugPrint(
            'HandshakeException: retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
        delay = updatedDelay();
        retryCount++;
      } catch (error) {
        _requestCount--;
        if (Platform.isAndroid) {
          final message = 'TmdbBaseService get Error: ${error.toString()}';
          FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: message),
          );
        } else {
          debugPrint('TmdbBaseService get Error: ${error.toString()}');
        }
        rethrow;
      }
    }
    _requestCount--;
    throw HttpException(
        'TmdbBaseService get failed after $maxRetries retries for $uri');
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
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

  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
    try {
      final String baseUrl = version == ApiVersion.v3 ? _baseUrlv3 : _baseUrlv4;
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env['TMDB_API_RAT']
          : accessToken;
      final uri = Uri.parse('$baseUrl/$endpoint');

      return http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
    } catch (error) {
      final message = 'TmdbBaseService put Error: ${error.toString()}';
      if (Platform.isAndroid) {
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: ([message])));
      }
      throw HttpException(message);
    }
  }

  Future<dynamic> delete(
    String endpoint,
    Map<String, dynamic> body, {
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
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
