import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _tmdbSearch =
    'https://api.themoviedb.org/3/search/multi?query={SEARCH}&page=1&language={LOCALE}';

class TmdbService {
  Future<dynamic> searchTitle(
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
      return getTitles(json.decode(response.body));
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

  List getTitles(Map response) {
    List titles = [];
    for (int count = 0;
        count < response['results'].length && count < 10;
        count += 1) {
      final title = response['results'][count];
      titles.add({
        'id': title['id'],
        'title': title['title'] ?? title['name'],
        'poster_path': title['poster_path'],
        'overview': title['overview'], 
        'release_date': title['release_date'],
      });
    }
    return titles;
  }
}
