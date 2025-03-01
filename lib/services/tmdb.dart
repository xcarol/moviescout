import 'dart:io';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String _tmdbSearch =
    'https://api.themoviedb.org/3/search/multi?query={SEARCH}&page=1&language={LOCALE}';

const String _tmdbImages =
    'https://api.themoviedb.org/3/{MEDIA_TYPE}/{ID}/images';

const String _tmdbDetails =
    'https://api.themoviedb.org/3/{MEDIA_TYPE}/{ID}?language={LOCALE}';

const String _tmdbProviders =
    'https://api.themoviedb.org/3/{MEDIA_TYPE}/{ID}/watch/providers';

const String _tmdbFindByID =
    'https://api.themoviedb.org/3/find/{ID}?language={LOCALE}&external_source=imdb_id';

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
    return _titlesList(json.decode(result), locale);
  }

  Future<List> _titlesList(Map response, Locale locale) async {
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

  Future<dynamic> searchImdbTitles(
    List imdbIds,
    Locale locale,
  ) async {
    List titles = [];
    List notFound = [];

    if (imdbIds.isEmpty) {
      return [];
    }

    for (int count = 0; count < imdbIds.length; count += 1) {
      final id = imdbIds[count];

      Uri searchUri = Uri.parse(
        _tmdbFindByID.replaceFirst('{ID}', id).replaceFirst(
            '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
      );

      final response = await tmdbRequest(searchUri);
      List titlesFromId = _fromImdbIdToTitle(json.decode(response));
      if (titlesFromId.isEmpty) {
        notFound.add(id);
      }
      titles.addAll(titlesFromId);
    }

    return {}
      ..['titles'] = titles
      ..['notFound'] = notFound;
  }

  List _fromImdbIdToTitle(Map response) {
    List titles = [];
    for (var key in response.keys) {
      if (key == 'movie_results') {
        for (var movie in response[key]) {
          titles.add(movie);
        }
      }
      if (key == 'tv_results') {
        for (var tv in response[key]) {
          titles.add(tv);
        }
      }
    }
    return titles;
  }

  String getCountryCode() {
    return PlatformDispatcher.instance.locale.countryCode ?? "US";
  }

  getTitleProviders(int titleId, String mediaType) async {
    Uri detailtUri = Uri.parse(
      _tmdbProviders
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', titleId.toString()),
    );

    final result = await tmdbRequest(detailtUri);
    return json.decode(result)['results'][getCountryCode()];
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
    if (title['last_updated'] != null &&
        DateTime.now()
                .difference(DateTime.parse(title['last_updated']))
                .inDays <
            DateTime.daysPerWeek) {
      return title;
    }

    String mediaType = title['media_type'] ?? '';
    if (mediaType == '') {
      mediaType = title['title'] != null ? 'movie' : 'tv';
    }

    Uri searchUri = Uri.parse(
      _tmdbDetails
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', title['id'].toString())
          .replaceFirst(
              '{LOCALE}', '${locale.languageCode}-${locale.countryCode}'),
    );

    final result = await tmdbRequest(searchUri);
    final titleDetails = json.decode(result);

    titleDetails['providers'] = await getTitleProviders(title['id'], mediaType);
    titleDetails['last_updated'] = DateTime.now().toIso8601String();

    return titleDetails;
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
