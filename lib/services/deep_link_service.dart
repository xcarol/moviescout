import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late TmdbListService _tmdbListService;

  void init(TmdbListService tmdbListService) {
    _tmdbListService = tmdbListService;

    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  void _handleDeepLink(Uri uri) {
    String? type;
    String? id;

    if (uri.host == ApiConstants.tmdbHost ||
        uri.host == ApiConstants.tmdbHostAlternative) {
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        type = segments[0];
        id = segments[1];
      }
    } else if (uri.scheme == AppConstants.deepLinkScheme) {
      final segments = uri.pathSegments;

      if (uri.host == ApiConstants.movie ||
          uri.host == ApiConstants.tv ||
          uri.host == ApiConstants.person) {
        type = uri.host;
        id = segments.isNotEmpty ? segments[0] : null;
      } else if (segments.isNotEmpty) {
        type = segments[0];
        id = segments.length > 1 ? segments[1] : null;
      }
    }

    if (type != null && id != null) {
      _navigate(type, id);
    }
  }

  void _navigate(String type, String id) {
    final idClean = id.split('-').first;
    final tmdbId = int.tryParse(idClean);
    if (tmdbId == null) return;

    if (type == ApiConstants.movie || type == ApiConstants.tv) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => TitleDetails(
            title: TmdbTitle.fromMap(title: {
              TmdbTitleFields.id: tmdbId,
              TmdbTitleFields.mediaType: type,
            }),
            tmdbListService: _tmdbListService,
          ),
        ),
      );
    } else if (type == ApiConstants.person) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => PersonDetails(
            person: TmdbPerson.fromMap(person: {
              PersonAttributes.id: tmdbId,
            }),
            tmdbListService: _tmdbListService,
          ),
        ),
      );
    }
  }
}
