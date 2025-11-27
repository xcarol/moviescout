import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

const String _tmdbDetails =
    '/person/{ID}?append_to_response=combined_credits&language={LOCALE}';

class TmdbPersonService extends TmdbBaseService {
  Future<dynamic> _retrievePersonDetailsByLocale(
    int id,
    String locale,
  ) async {
    return get(
      _tmdbDetails
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  static bool isUpToDate(TmdbPerson person) {
    return DateTime.now()
            .difference(
              DateTime.parse(person.lastUpdated),
            )
            .inDays <
        DateTime.daysPerWeek;
  }

  Future<TmdbPerson> updatePersonDetails(TmdbPerson person) async {
    if (isUpToDate(person)) {
      return person;
    }

    final result = await _retrievePersonDetailsByLocale(
      person.tmdbId,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        FirebaseCrashlytics.instance.recordError(
          Exception(
            'Failed to retrieve person details for ${person.tmdbId} - ${result.statusCode} - ${result.body}',
          ),
          null,
          reason: 'TmdbPersonService.updatePersonDetails',
        );
      } else {
        SnackMessage.showSnackBar(
          'Failed to retrieve person details for ${person.tmdbId} - ${result.statusCode} - ${result.body}',
        );
      }
      return person;
    }

    final Map personMap = person.map;

    personMap.addAll(body(result));

    if (personMap['biography'].isEmpty) {
      final result = await _retrievePersonDetailsByLocale(
        person.tmdbId,
        getCountryCode().toLowerCase(),
      );

      if (result.statusCode == 200) {
        final details = body(result);
        if (details['biography'].isNotEmpty) {
          personMap['biography'] = details['biography'];
        }
      }
    }

    if (personMap['biography'].isEmpty) {
      final result = await _retrievePersonDetailsByLocale(
        person.tmdbId,
        'en-US',
      );

      if (result.statusCode == 200) {
        final details = body(result);
        if (details['biography'].isNotEmpty) {
          personMap['biography'] = details['biography'];
        }
      }
    }

    personMap['tmdbJson'] = jsonEncode(personMap);
    personMap['last_updated'] = DateTime.now().toIso8601String();

    return TmdbPerson.fromMap(person: personMap);
  }
}
