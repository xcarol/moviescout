import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _tmdbSearch =
    'https://api.themoviedb.org/3/search/movie?query={SEARCH}&page=1&language={LOCALE}';

class TmdbService {
  Future<dynamic> searchMovie(
    String search,
    Locale locale,
  ) async {
    if (search.trim().isEmpty || search.trim().length < 3) {
      return [];
    }

    Uri searchUri = Uri.parse(
      _tmdbSearch.replaceFirst('{SEARCH}', search).replaceFirst(
          '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );

    const apiKey =
        '';

    final response = await http.get(searchUri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Exception exception = Exception(
        [
          'searchMovie',
          'Error: ${response.statusCode} for the request of the search :[${searchUri.toString()}]',
        ],
      );
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: exception));
      throw exception;
    }
  }
}
