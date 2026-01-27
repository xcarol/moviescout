import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moviescout/services/deep_link_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.linux)) {
      return;
    }

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final File file = await DefaultCacheManager().getSingleFile(imageUrl);
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(file.path),
          largeIcon: FilePathAndroidBitmap(file.path),
          contentTitle: title,
          summaryText: body,
        );
      } catch (e) {
        // Fallback to normal notification if image fails
      }
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'title_availability_channel',
      'Title Availability',
      channelDescription: 'Notifications for watchlist title availability',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
      color: const Color.fromARGB(0xFF, 0x2B, 0x20, 0x16),
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
