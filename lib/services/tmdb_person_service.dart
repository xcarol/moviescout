import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbPersonService extends TmdbBaseService {
  Future<dynamic> _retrievePersonDetailsByLocale(
    int id,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbPersonDetailsEndpoint
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

  Future<TmdbPerson> updatePersonDetails(TmdbPerson person,
      {bool force = false}) async {
    if (!force && isUpToDate(person)) {
      return person;
    }

    final result = await _retrievePersonDetailsByLocale(
      person.tmdbId,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      ErrorService.log(
        'Failed to retrieve person details for ${person.tmdbId} - ${result.statusCode} - ${result.body}',
        userMessage: 'Failed to retrieve person details',
      );
      return person;
    }

    final Map personMap = person.toMap();

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

    personMap['last_updated'] = DateTime.now().toIso8601String();

    return TmdbPerson.fromMap(person: personMap);
  }
}
