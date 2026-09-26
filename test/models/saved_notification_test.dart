import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/saved_notification.dart';

void main() {
  group('SavedNotification', () {
    final timestamp = DateTime(2026, 4, 15, 12, 30);

    test('instantiates with all properties', () {
      final notification = SavedNotification(
        id: 42,
        title: 'New Episode',
        body: 'Episode 5 is available',
        imageUrl: 'https://image.tmdb.org/t/p/w500/test.jpg',
        payload: 'media_type:tv,id:123',
        timestamp: timestamp,
        providerIds: [8, 337],
      );

      expect(notification.id, 42);
      expect(notification.title, 'New Episode');
      expect(notification.body, 'Episode 5 is available');
      expect(notification.imageUrl, 'https://image.tmdb.org/t/p/w500/test.jpg');
      expect(notification.payload, 'media_type:tv,id:123');
      expect(notification.timestamp, timestamp);
      expect(notification.providerIds, [8, 337]);
    });

    test('toMap includes optional fields when present', () {
      final notification = SavedNotification(
        id: 1,
        title: 'Title',
        body: 'Body',
        imageUrl: 'https://example.com/img.png',
        payload: 'payload_data',
        timestamp: timestamp,
        providerIds: [1, 2],
      );

      final map = notification.toMap();
      expect(map['id'], 1);
      expect(map['title'], 'Title');
      expect(map['body'], 'Body');
      expect(map['imageUrl'], 'https://example.com/img.png');
      expect(map['payload'], 'payload_data');
      expect(map['timestamp'], timestamp.toIso8601String());
      expect(map['providerIds'], [1, 2]);
    });

    test('toMap omits imageUrl and payload when null', () {
      final notification = SavedNotification(
        id: 2,
        title: 'Title 2',
        body: 'Body 2',
        imageUrl: null,
        payload: null,
        timestamp: timestamp,
      );

      final map = notification.toMap();
      expect(map.containsKey('imageUrl'), isFalse);
      expect(map.containsKey('payload'), isFalse);
      expect(map['providerIds'], isEmpty);
    });

    test('fromMap parses map correctly with all fields', () {
      final map = {
        'id': 10,
        'title': 'Test Title',
        'body': 'Test Body',
        'imageUrl': 'https://example.com/image.jpg',
        'payload': 'sample_payload',
        'timestamp': timestamp.toIso8601String(),
        'providerIds': [8, 9],
      };

      final notification = SavedNotification.fromMap(map);
      expect(notification.id, 10);
      expect(notification.title, 'Test Title');
      expect(notification.body, 'Test Body');
      expect(notification.imageUrl, 'https://example.com/image.jpg');
      expect(notification.payload, 'sample_payload');
      expect(notification.timestamp, timestamp);
      expect(notification.providerIds, [8, 9]);
    });

    test('fromMap falls back to defaults when optional/missing fields are null', () {
      final notification = SavedNotification.fromMap({});
      expect(notification.id, 0);
      expect(notification.title, '');
      expect(notification.body, '');
      expect(notification.imageUrl, isNull);
      expect(notification.payload, isNull);
      expect(notification.timestamp, isNotNull);
      expect(notification.providerIds, isEmpty);
    });

    test('toJson and fromJson roundtrip serialization', () {
      final original = SavedNotification(
        id: 99,
        title: 'Serialized Notification',
        body: 'Details here',
        imageUrl: 'https://example.com/icon.png',
        payload: 'route:/title/100',
        timestamp: timestamp,
        providerIds: [101, 102],
      );

      final jsonStr = original.toJson();
      final decoded = SavedNotification.fromJson(jsonStr);

      expect(decoded.id, original.id);
      expect(decoded.title, original.title);
      expect(decoded.body, original.body);
      expect(decoded.imageUrl, original.imageUrl);
      expect(decoded.payload, original.payload);
      expect(decoded.timestamp, original.timestamp);
      expect(decoded.providerIds, original.providerIds);
    });
  });
}
