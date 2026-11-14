import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/core/services/cloud_database_service.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/save_logs.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/repositories/cloud_title_repository.dart';

class _PendingNotificationSync {
  final int tmdbId;
  final String mediaType;
  final String name;
  final String? posterPathSuffix;
  final double voteAverage;
  final bool notifyNewSeasons;
  final int lastNotifiedSeason;
  final bool addedToWatchlist;
  final bool isInRateslist;

  const _PendingNotificationSync({
    required this.tmdbId,
    required this.mediaType,
    required this.name,
    required this.posterPathSuffix,
    required this.voteAverage,
    required this.notifyNewSeasons,
    required this.lastNotifiedSeason,
    required this.addedToWatchlist,
    required this.isInRateslist,
  });

  String get dedupKey => '${mediaType}_$tmdbId';

  String get versionKey =>
      '${mediaType}_${tmdbId}_${lastNotifiedSeason}_${notifyNewSeasons}_${addedToWatchlist}_$isInRateslist';

  Map<String, dynamic> toJson() => {
        'tmdbId': tmdbId,
        'mediaType': mediaType,
        'name': name,
        'posterPathSuffix': posterPathSuffix,
        'voteAverage': voteAverage,
        'notifyNewSeasons': notifyNewSeasons,
        'lastNotifiedSeason': lastNotifiedSeason,
        'addedToWatchlist': addedToWatchlist,
        'isInRateslist': isInRateslist,
      };

  factory _PendingNotificationSync.fromJson(Map<String, dynamic> json) {
    return _PendingNotificationSync(
      tmdbId: (json['tmdbId'] as num).toInt(),
      mediaType: json['mediaType'] as String,
      name: json['name'] as String? ?? '',
      posterPathSuffix: json['posterPathSuffix'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble() ?? 0.0,
      notifyNewSeasons: json['notifyNewSeasons'] as bool? ?? false,
      lastNotifiedSeason: (json['lastNotifiedSeason'] as num?)?.toInt() ?? 0,
      addedToWatchlist: json['addedToWatchlist'] as bool? ?? false,
      isInRateslist: json['isInRateslist'] as bool? ?? false,
    );
  }

  TmdbTitle toTmdbTitle() {
    return TmdbTitle(
      tmdbId: tmdbId,
      mediaType: mediaType,
      name: name,
      posterPathSuffix: posterPathSuffix,
      voteAverage: voteAverage,
      lastUpdated: AppConstants.defaultDate,
      dateRated: DateTime.fromMillisecondsSinceEpoch(0),
    )
      ..notifyNewSeasons = notifyNewSeasons
      ..lastNotifiedSeason = lastNotifiedSeason;
  }
}

class PendingNotificationSyncService {
  static final PendingNotificationSyncService _instance =
      PendingNotificationSyncService._internal();

  factory PendingNotificationSyncService() => _instance;

  PendingNotificationSyncService._internal();

  Future<void>? _activeFlush;

  Future<void> enqueue(
    TmdbTitle title, {
    required bool addedToWatchlist,
    required bool isInRateslist,
    List<String>? logLines,
  }) async {
    try {
      await PreferencesService().refresh();
      final prefs = PreferencesService().prefs;
      final rawList =
          prefs.getStringList(AppConstants.pendingNotificationSyncs) ?? [];

      final items = _decodeList(rawList);
      final incoming = _PendingNotificationSync(
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
        name: title.name,
        posterPathSuffix: title.posterPathSuffix,
        voteAverage: title.voteAverage,
        notifyNewSeasons: title.notifyNewSeasons,
        lastNotifiedSeason: title.lastNotifiedSeason,
        addedToWatchlist: addedToWatchlist,
        isInRateslist: isInRateslist,
      );

      final existingIndex =
          items.indexWhere((item) => item.dedupKey == incoming.dedupKey);
      if (existingIndex >= 0) {
        final existing = items[existingIndex];
        items[existingIndex] = _PendingNotificationSync(
          tmdbId: incoming.tmdbId,
          mediaType: incoming.mediaType,
          name: incoming.name,
          posterPathSuffix: incoming.posterPathSuffix,
          voteAverage: incoming.voteAverage,
          notifyNewSeasons: incoming.notifyNewSeasons,
          lastNotifiedSeason: incoming.lastNotifiedSeason,
          addedToWatchlist:
              existing.addedToWatchlist || incoming.addedToWatchlist,
          isInRateslist: incoming.isInRateslist,
        );
      } else {
        items.add(incoming);
      }

      await prefs.setStringList(
        AppConstants.pendingNotificationSyncs,
        items.map((item) => jsonEncode(item.toJson())).toList(),
      );
      logLines?.add(
          '- [CloudDatabase Sync] ${title.name}: Queued for foreground sync');
    } catch (e, stackTrace) {
      logLines?.add('- [CloudDatabase Sync] ${title.name}: Queue error $e');
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error queueing notification sync',
        reportToCrashlytics: false,
      );
    }
  }

  Future<void> flushPendingSyncs({CloudTitleRepository? cloudRepository}) {
    final inFlight = _activeFlush;
    if (inFlight != null) return inFlight;

    final future = _performFlush(cloudRepository: cloudRepository);
    _activeFlush = future.whenComplete(() {
      if (identical(_activeFlush, future)) {
        _activeFlush = null;
      }
    });
    return _activeFlush!;
  }

  Future<void> _performFlush({CloudTitleRepository? cloudRepository}) async {
    try {
      final user = CloudDatabaseService.currentUser;
      if (user == null) return;

      await PreferencesService().refresh();
      final prefs = PreferencesService().prefs;
      final rawList =
          prefs.getStringList(AppConstants.pendingNotificationSyncs) ?? [];
      if (rawList.isEmpty) return;

      final items = _decodeList(rawList);
      if (items.isEmpty) {
        await prefs.remove(AppConstants.pendingNotificationSyncs);
        return;
      }

      final repo = cloudRepository ?? CloudTitleRepository();
      final succeededVersions = <String>{};
      final logLines = <String>[
        '---------------------------',
        'Cloud Sync Flush: ${DateTime.now().toLocal().toString().split('.').first}',
        '---------------------------',
      ];

      for (final item in items) {
        logLines.add(
            '- [CloudDatabase Sync] ${item.name}: Syncing (user: ${user.id}, lastNotifiedSeason: ${item.lastNotifiedSeason}, inRateslist: ${item.isInRateslist}, addedToWatchlist: ${item.addedToWatchlist})');
        try {
          await repo.syncNotification(
            userId: user.id,
            title: item.toTmdbTitle(),
            addedToWatchlist: item.addedToWatchlist,
            isInRateslist: item.isInRateslist,
          );
          succeededVersions.add(item.versionKey);
          logLines.add(
              '- [CloudDatabase Sync] ${item.name}: Completed successfully');
        } catch (e, stackTrace) {
          if (ErrorService.isNetworkError(e)) {
            debugPrint('Deferred notification sync (offline): $e');
            logLines
                .add('- [CloudDatabase Sync] ${item.name}: Deferred (offline)');
          } else {
            logLines.add('- [CloudDatabase Sync] ${item.name}: Error $e');
            ErrorService.log(
              e,
              stackTrace: stackTrace,
              userMessage: 'Error syncing queued notification',
              reportToCrashlytics: false,
            );
          }
        }
      }

      if (succeededVersions.isNotEmpty) {
        await PreferencesService().refresh();
        final latestRaw =
            prefs.getStringList(AppConstants.pendingNotificationSyncs) ?? [];
        final remaining = _decodeList(latestRaw)
            .where((item) => !succeededVersions.contains(item.versionKey))
            .toList();

        if (remaining.isEmpty) {
          await prefs.remove(AppConstants.pendingNotificationSyncs);
        } else {
          await prefs.setStringList(
            AppConstants.pendingNotificationSyncs,
            remaining.map((item) => jsonEncode(item.toJson())).toList(),
          );
        }
      }

      final pendingCount = items.length - succeededVersions.length;
      logLines.add(
          'Summary: ${items.length} queued - ${succeededVersions.length} synced - $pendingCount pending');
      logLines.add('---------------------------');
      await saveLogs(logLines);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error flushing notification sync queue',
        reportToCrashlytics: false,
      );
    }
  }

  List<_PendingNotificationSync> _decodeList(List<String> rawList) {
    final items = <_PendingNotificationSync>[];
    for (final raw in rawList) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          items.add(_PendingNotificationSync.fromJson(decoded));
        }
      } catch (_) {}
    }
    return items;
  }
}
