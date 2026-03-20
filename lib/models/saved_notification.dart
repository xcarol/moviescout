import 'dart:convert';

class SavedNotification {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? payload;
  final DateTime timestamp;
  final List<int> providerIds;

  SavedNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.payload,
    required this.timestamp,
    this.providerIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (payload != null) 'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'providerIds': providerIds,
    };
  }

  factory SavedNotification.fromMap(Map<String, dynamic> map) {
    return SavedNotification(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      payload: map['payload'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      providerIds: map['providerIds'] != null
          ? List<int>.from(map['providerIds'])
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedNotification.fromJson(String source) =>
      SavedNotification.fromMap(json.decode(source));
}
