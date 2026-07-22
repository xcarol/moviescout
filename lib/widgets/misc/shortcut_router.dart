import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/screens/season_details.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ShortcutRouter extends StatefulWidget {
  final Uri uri;
  const ShortcutRouter({super.key, required this.uri});

  @override
  State<ShortcutRouter> createState() => _ShortcutRouterState();
}

class _ShortcutRouterState extends State<ShortcutRouter> {
  Widget? _content;
  bool _invalidUrl = false;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _loadContent(widget.uri);
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      if (!mounted) return;
      if (uri.queryParameters['shortcut'] == 'true') {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        _loadContent(uri);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadContent(Uri uri) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_shortcut_uri', uri.toString());

    if (!mounted) return;

    final watchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      final type = segments[0];
      final idClean = segments[1].split('-').first;
      final tmdbId = int.tryParse(idClean);

      if (tmdbId != null) {
        if (type == ApiConstants.movie || type == ApiConstants.tv) {
          if (type == ApiConstants.tv &&
              segments.length >= 4 &&
              segments[2] == 'season') {
            final seasonNumber = int.tryParse(segments[3]);
            if (seasonNumber != null) {
              final repository = TmdbTitleRepository();
              final existingTitle =
                  await repository.getTitleGlobal(tmdbId, type);
              final title = existingTitle ??
                  TmdbTitle.fromMap(title: {
                    TmdbTitleFields.id: tmdbId,
                    TmdbTitleFields.mediaType: type,
                  });
              if (!mounted) return;
              setState(() {
                _content = SeasonDetails(
                  title: title,
                  seasonNumber: seasonNumber,
                  tmdbListService: watchlistService,
                );
              });
              return;
            }
          }

          final repository = TmdbTitleRepository();
          final existingTitle = await repository.getTitleGlobal(tmdbId, type);
          final title = existingTitle ??
              TmdbTitle.fromMap(title: {
                TmdbTitleFields.id: tmdbId,
                TmdbTitleFields.mediaType: type,
              });

          if (!mounted) return;
          setState(() {
            _content = TitleDetails(
              title: title,
              tmdbListService: watchlistService,
            );
          });
          return;
        } else if (type == ApiConstants.person) {
          if (!mounted) return;
          setState(() {
            _content = PersonDetails(
              person: TmdbPerson.fromMap(person: {
                PersonAttributes.id: tmdbId,
              }),
              tmdbListService: watchlistService,
            );
          });
          return;
        }
      }
    }

    setState(() {
      _invalidUrl = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidUrl) {
      return const Scaffold(
        body: Center(child: Text('Invalid Shortcut URL')),
      );
    }

    if (_content == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: _content!,
    );
  }
}
