import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String _tmdbRoot = 'https://api.themoviedb.org/3';

class TmdbBaseService {
  Future<String> tmdbQuery(String query) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];

    Uri uri = Uri.parse('$_tmdbRoot$query');

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
}
