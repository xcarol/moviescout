import 'dart:io';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String _tmdbTypeMovie = 'movie';
const String _tmdbTypeTv = 'tv';

const String _tmdbSearch =
    'https://api.themoviedb.org/3/search/multi?query={SEARCH}&page=1&language={LOCALE}';

const String _tmdbImages =
    'https://api.themoviedb.org/3/{MEDIA_TYPE}/{ID}/images';

const String _tmdbDetails =
    'https://api.themoviedb.org/3/{MEDIA_TYPE}/{ID}?language={LOCALE}';

class TmdbService {
  Future<String> tmdbRequest(Uri uri) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];

    // http.get doesn't return a resonse for a non valid (2xx) server response.
    // it sends an exception instead. Use android for debugging.
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      final message =
          'tmbRequest Error. Status code: ${response.statusCode}. Message: ${response.reasonPhrase}. Uri: ${uri.toString()}';
      if (Platform.isAndroid) {
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: ([message])));
      }

      throw HttpException(message);
    }
  }

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

    final result = await tmdbRequest(searchUri);
    return titlesList(json.decode(result), locale);
  }

  Future<List> titlesList(Map response, Locale locale) async {
    List titles = [];
    final totalResults = response['total_results'] ?? 0;
    for (int count = 0; count < totalResults && count < 10; count += 1) {
      final title = response['results'][count];
      final details = await getImages(title['id'], title['media_type']);
      final poster = getPoster(details);
      titles.add({
        'id': title['id'],
        'title': title['title'] ?? title['name'],
        'poster_path': poster,
        'overview': title['overview'],
        'release_date': title['release_date'],
        'media_type': title['media_type'],
        'genre_ids': title['genre_ids'],
        'vote_average': title['vote_average'],
      });
    }
    return titles;
  }

  Future<dynamic> getTitlesDetails(
    List titles,
    Locale locale,
  ) async {
    for (int count = 0; count < titles.length; count += 1) {
      final title = titles[count];
      final details = await getTitleDetails(title, locale);
      titles[count] = details;
    }
    return titles;
  }

  Future<dynamic> getTitleDetails(
    Map title,
    Locale locale,
  ) async {
    Uri searchUri = Uri.parse(
      _tmdbDetails.replaceFirst('{MEDIA_TYPE}', title['media_type'])
      .replaceFirst('{ID}', title['id'])
      .replaceFirst('{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );

    final result = await tmdbRequest(searchUri);
    return json.decode(result);
  }
  
  getPoster(Map details) {
    if (details['posters'] != null && details['posters'].length > 0) {
      return details['posters'][0]['file_path'];
    } else if (details['logos'] != null && details['logos'].length > 0) {
      return details['logos'][0]['file_path'];
    } else if (details['backdrops'] != null &&
        details['backdrops'].length > 0) {
      return details['backdrops'][0]['file_path'];
    } else {
      return '';
    }
  }

  getImages(int titleId, String mediaType) async {
    Uri detailtUri = Uri.parse(
      _tmdbImages
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', titleId.toString()),
    );

    final result = await tmdbRequest(detailtUri);
    return json.decode(result);
  }
}
