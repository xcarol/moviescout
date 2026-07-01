import 'package:moviescout/utils/url_constants.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/region_service.dart';
import 'package:moviescout/services/app_lifecycle_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/utils/app_constants.dart';

enum ApiVersion { v3, v4 }

const int _maxRequestsCount = 40;
const int _initialDelayMs = 200;
const int _maxDelayMs = 5000;

const String anonymousAccountId = 'anonymousAccountId';

class TmdbBaseService {
  static int _requestCount = 0;

  dynamic body(http.Response response) {
    return jsonDecode(response.body);
  }

  String getCountryCode() {
    return RegionService().currentRegion ??
        LanguageService().locale.countryCode ??
        "US";
  }

  String getLanguageCode() {
    return LanguageService().locale.languageCode;
  }

  Uri _buildUri(ApiVersion version, String endpoint) {
    final String baseUrl = version == ApiVersion.v3
        ? UrlConstants.tmdbApiV3Url
        : UrlConstants.tmdbApiV4Url;
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$cleanBase$cleanEndpoint');
  }

  Future<Duration> _handleRetry(
      String exceptionName, Duration delay, Duration maxDelay) async {
    debugPrint('$exceptionName: retrying in ${delay.inSeconds} seconds...');
    await AppLifecycleService.instance.waitUntilResumed();
    await Future.delayed(delay);
    return (delay * 2).compareTo(maxDelay) < 0 ? delay * 2 : maxDelay;
  }

  Future<dynamic> get(
    String query, {
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
    final token = accessToken.isEmpty || version == ApiVersion.v3
        ? dotenv.env[AppConstants.tmdbApiRat]
        : accessToken;
    final uri = _buildUri(version, query);

    const Duration initialDelay = Duration(milliseconds: _initialDelayMs);
    const Duration maxDelay = Duration(milliseconds: _maxDelayMs);
    Duration delay = initialDelay;

    while (_requestCount >= _maxRequestsCount) {
      await Future.delayed(initialDelay);
    }

    _requestCount++;

    int retryCount = 0;
    const int maxRetries = 20;

    while (retryCount < maxRetries) {
      try {
        // Running in a browser http.get doesn't return a response for a non valid (2xx) server response.
        // It sends an exception instead. Use android for debugging.
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }).timeout(const Duration(seconds: 10));

        if (response.statusCode == 429) {
          delay = await _handleRetry(
              'TmdbBaseService get Rate limit exceeded', delay, maxDelay);
          retryCount++;
          continue;
        }

        _requestCount--;
        return response;
      } on http.ClientException {
        delay = await _handleRetry('ClientException', delay, maxDelay);
        retryCount++;
      } on HandshakeException {
        delay = await _handleRetry('HandshakeException', delay, maxDelay);
        retryCount++;
      } on SocketException {
        delay = await _handleRetry('SocketException', delay, maxDelay);
        retryCount++;
      } on TimeoutException {
        delay = await _handleRetry('TimeoutException', delay, maxDelay);
        retryCount++;
      } catch (error, stackTrace) {
        _requestCount--;
        ErrorService.log(
          error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }
    _requestCount--;

    SnackMessage.showSnackBar(
      'TmdbBaseService get failed after $maxRetries retries for $uri',
    );

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
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env[AppConstants.tmdbApiRat]
          : accessToken;
      final uri = _buildUri(version, endpoint);

      return await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
    } catch (error, stackTrace) {
      final message = 'TmdbBaseService post Error: ${error.toString()}';
      ErrorService.log(
        error,
        stackTrace: stackTrace,
      );
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
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env[AppConstants.tmdbApiRat]
          : accessToken;
      final uri = _buildUri(version, endpoint);

      return await http
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
    } catch (error, stackTrace) {
      final message = 'TmdbBaseService put Error: ${error.toString()}';
      ErrorService.log(
        error,
        stackTrace: stackTrace,
      );
      throw HttpException(message);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    ApiVersion version = ApiVersion.v3,
    String accessToken = '',
  }) async {
    try {
      final token = accessToken.isEmpty || version == ApiVersion.v3
          ? dotenv.env[AppConstants.tmdbApiRat]
          : accessToken;
      final uri = _buildUri(version, endpoint);

      return await http
          .delete(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));
    } catch (error, stackTrace) {
      final message = 'TmdbBaseService delete Error: ${error.toString()}';
      ErrorService.log(
        error,
        stackTrace: stackTrace,
      );
      throw HttpException(message);
    }
  }
}
