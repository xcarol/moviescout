import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/screens/season_details.dart';
import 'package:moviescout/screens/collection_details.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/utils/api_constants.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late TmdbTitleListService _tmdbListService;

  Route? _externalRoute;
  bool _isShortcut = false;

  bool get isExternalRouteActive =>
      _externalRoute != null && _externalRoute!.isActive;

  bool get isExternalRouteAtTop =>
      _externalRoute != null &&
      _externalRoute!.isActive &&
      _externalRoute!.isCurrent;

  bool get isShortcut => _isShortcut;
  bool get isShortcutActive => isExternalRouteActive && _isShortcut;
  bool get isShortcutAtTop => isExternalRouteAtTop && _isShortcut;

  bool _isInitialized = false;
  String? _lastNavigatedId;
  String? _lastNavigatedType;
  DateTime? _lastNavigatedTime;

  void init(TmdbTitleListService tmdbListService) {
    _tmdbListService = tmdbListService;
    _isInitialized = true;

    _shortcutChannel.setMethodCallHandler((call) async {
      if (call.method == 'resetToHome') {
        if (isExternalRouteActive) {
          navigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
      }
    });

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

    navigatorKey.currentState?.popUntil((route) => route.isFirst);

    String? type;
    String? id;
    int? seasonNumber;

    if (uri.host == ApiConstants.moviescoutHost) {
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        type = segments[0];
        id = segments[1];
        if (type == ApiConstants.tv &&
            segments.length >= 4 &&
            segments[2] == 'season') {
          seasonNumber = int.tryParse(segments[3]);
        }
      }
    }

    final isShortcut = uri.queryParameters['shortcut'] == 'true';

    if (type != null && id != null) {
      unawaited(_navigate(
        type,
        id,
        seasonNumber: seasonNumber,
        isExternal: true,
        isShortcut: isShortcut,
      ));
    }
  }

  void navigateTo(String type, int tmdbId) {
    unawaited(_navigate(type, tmdbId.toString()));
  }

  void _pushRoute(
    Widget child, {
    required bool isExternal,
    required bool isShortcut,
  }) {
    final route = MaterialPageRoute(
      builder: (context) => isShortcut
          ? PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) return;
                DeepLinkService.moveToBackground();
              },
              child: child,
            )
          : child,
    );
    if (isExternal) {
      _externalRoute = route;
      _isShortcut = isShortcut;
      route.popped.then((_) {
        if (_externalRoute == route) {
          _externalRoute = null;
          _isShortcut = false;
        }
      });
    }
    navigatorKey.currentState?.push(route);
  }

  Future<void> _navigate(
    String type,
    String id, {
    int? seasonNumber,
    bool isExternal = false,
    bool isShortcut = false,
  }) async {
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
      final repository = LocalTitleRepository();
      final existingTitle = await repository.getTitleGlobal(tmdbId, type);

      final title = existingTitle ??
          TmdbTitle.fromMap(title: {
            TmdbTitleFields.id: tmdbId,
            TmdbTitleFields.mediaType: type,
          });

      if (type == ApiConstants.tv && seasonNumber != null) {
        _pushRoute(
          SeasonDetails(
            title: title,
            seasonNumber: seasonNumber,
            tmdbListService: _tmdbListService,
          ),
          isExternal: isExternal,
          isShortcut: isShortcut,
        );
      } else {
        _pushRoute(
          TitleDetails(
            title: title,
            tmdbListService: _tmdbListService,
          ),
          isExternal: isExternal,
          isShortcut: isShortcut,
        );
      }
    } else if (type == ApiConstants.person) {
      _pushRoute(
        PersonDetails(
          person: TmdbPerson.fromMap(person: {
            PersonAttributes.id: tmdbId,
          }),
          tmdbListService: _tmdbListService,
        ),
        isExternal: isExternal,
        isShortcut: isShortcut,
      );
    } else if (type == ApiConstants.collection) {
      _pushRoute(
        CollectionDetails(
          collection: TmdbCollection.fromMap(collection: {
            'id': tmdbId,
          }),
          tmdbListService: _tmdbListService,
        ),
        isExternal: isExternal,
        isShortcut: isShortcut,
      );
    }
  }

  static const MethodChannel _shortcutChannel =
      MethodChannel('com.xicra.moviescout/shortcut');

  static Future<void> moveToBackground() async {
    try {
      await _shortcutChannel.invokeMethod('moveToBackground');
    } catch (_) {
      await SystemNavigator.pop();
    }
  }
}
