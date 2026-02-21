import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moviescout/services/deep_link_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _enabled = true;

  bool get enabled => _enabled;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handlePayload(response.payload!);
        }
      },
    );

    _enabled =
        PreferencesService().prefs.getBool(AppConstants.notificationsEnabled) ??
            true;

    await checkSystemPermission();
  }

  Future<void> checkSystemPermission() async {
    bool systemGranted = false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      systemGranted =
          await androidImplementation?.areNotificationsEnabled() ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // For iOS, a direct check normally requires higher permissions or is assumed granted if requested.
      // Defaulting for now as it's more complex without permission_handler.
      systemGranted = true;
    } else {
      systemGranted = true;
    }

    if (!systemGranted && _enabled) {
      _enabled = false;
      await PreferencesService()
          .prefs
          .setBool(AppConstants.notificationsEnabled, false);
      notifyListeners();
    }
  }

  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      return granted ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return granted ?? false;
    }
    return true;
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await PreferencesService()
        .prefs
        .setBool(AppConstants.notificationsEnabled, value);
    notifyListeners();
  }

  void _handlePayload(String payload) {
    if (payload.isNotEmpty) {
      final parts = payload.split('|');
      if (parts.length == 2) {
        final type = parts[0];
        final id = int.tryParse(parts[1]);
        if (id != null) {
          DeepLinkService().navigateTo(type, id);
        }
      }
    }
  }

  Future<void> handleColdStartNotification() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          notificationAppLaunchDetails?.notificationResponse?.payload;
      if (payload != null) {
        // Give the app a moment to settle navigation state
        Future.delayed(const Duration(milliseconds: 500), () {
          _handlePayload(payload);
        });
      }
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? imageUrl,
    String? payload,
  }) async {
    if (!_enabled) {
      return;
    }

    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.linux)) {
      return;
    }

    StyleInformation? styleInformation;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final File file = await DefaultCacheManager().getSingleFile(imageUrl);
        styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(file.path),
          largeIcon: FilePathAndroidBitmap(file.path),
          contentTitle: title,
          summaryText: body,
        );
      } catch (e, stackTrace) {
        ErrorService.log(
          e,
          stackTrace: stackTrace,
          showSnackBar: false,
        );
      }
    }

    styleInformation ??= BigTextStyleInformation(
      body,
      contentTitle: title,
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'title_availability_channel',
      'Title Availability',
      channelDescription: 'Notifications for watchlist title availability',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: styleInformation,
      color: const Color.fromARGB(0xFF, 0x2B, 0x20, 0x16),
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
