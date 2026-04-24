import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late TmdbListService _tmdbListService;
  
  bool _isInitialized = false;
  String? _lastNavigatedId;
  String? _lastNavigatedType;
  DateTime? _lastNavigatedTime;

  void init(TmdbListService tmdbListService) {
    _tmdbListService = tmdbListService;
    _isInitialized = true;

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
    if (uri.scheme == 'moviescout') return;

    String? type;
    String? id;

    if (uri.host == ApiConstants.tmdbHost ||
        uri.host == ApiConstants.tmdbHostAlternative) {
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        type = segments[0];
        id = segments[1];
      }
    }

    if (type != null && id != null) {
      unawaited(_navigate(type, id));
    }
  }

  void navigateTo(String type, int tmdbId) {
    unawaited(_navigate(type, tmdbId.toString()));
  }

  Future<void> _navigate(String type, String id) async {
    while (!_isInitialized || navigatorKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final idClean = id.split('-').first;
    final tmdbId = int.tryParse(idClean);
    if (tmdbId == null) return;

    // Prevent duplicate navigations to the same title within a short timeframe
    // (Resolves double pushes caused by redundant cold start notification handling)
    if (_lastNavigatedId == idClean && 
        _lastNavigatedType == type && 
        _lastNavigatedTime != null && 
        DateTime.now().difference(_lastNavigatedTime!).inMilliseconds < 1500) {
      return;
    }

    _lastNavigatedId = idClean;
    _lastNavigatedType = type;
    _lastNavigatedTime = DateTime.now();

    if (type == ApiConstants.movie || type == ApiConstants.tv) {
      final repository = TmdbTitleRepository();
      final existingTitle = await repository.getTitleGlobal(tmdbId, type);

      final title = existingTitle ??
          TmdbTitle.fromMap(title: {
            TmdbTitleFields.id: tmdbId,
            TmdbTitleFields.mediaType: type,
          });

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => TitleDetails(
            title: title,
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
