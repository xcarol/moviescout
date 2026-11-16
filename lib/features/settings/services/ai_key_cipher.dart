import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:pointycastle/export.dart';

class AiKeyCipher {
  static const String _versionPrefix = 'v1';
  static const int _ivLengthBytes = 12;
  static const int _macSizeBits = 128;

  final String? _overrideSecret;

  const AiKeyCipher({String? secret}) : _overrideSecret = secret;

  String get _secret {
    if (_overrideSecret != null) return _overrideSecret;
    if (!dotenv.isInitialized) return '';
    return dotenv.env[AppConstants.aiKeyEncryptionSecret]?.trim() ?? '';
  }

  bool get isConfigured => _secret.isNotEmpty;

  Uint8List _deriveKey(String userId) {
    final hmac = Hmac(sha256, utf8.encode(_secret));
    final digest = hmac.convert(utf8.encode('moviescout:ai-key:v1:$userId'));
    return Uint8List.fromList(digest.bytes);
  }

  Uint8List _aadBytes(String userId) =>
      Uint8List.fromList(utf8.encode('moviescout:ai-key:v1:$userId'));

  String? encrypt(String plaintext, {required String userId}) {
    final trimmed = plaintext.trim();
    if (trimmed.isEmpty) return null;
    if (!isConfigured || userId.trim().isEmpty) return null;

    final random = Random.secure();
    final iv = Uint8List.fromList(
      List<int>.generate(_ivLengthBytes, (_) => random.nextInt(256)),
    );
    final key = _deriveKey(userId);
    final aad = _aadBytes(userId);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), _macSizeBits, iv, aad),
      );
    final cipherBytes =
        cipher.process(Uint8List.fromList(utf8.encode(trimmed)));

    return '$_versionPrefix:${base64Url.encode(iv)}:${base64Url.encode(cipherBytes)}';
  }

  String? decrypt(String? payload, {required String userId}) {
    if (payload == null || payload.trim().isEmpty) return null;
    if (!isConfigured || userId.trim().isEmpty) return null;

    final parts = payload.trim().split(':');
    if (parts.length != 3 || parts[0] != _versionPrefix) {
      return null;
    }

    try {
      final iv = base64Url.decode(parts[1]);
      final cipherBytes = base64Url.decode(parts[2]);
      final key = _deriveKey(userId);
      final aad = _aadBytes(userId);

      final cipher = GCMBlockCipher(AESEngine())
        ..init(
          false,
          AEADParameters(KeyParameter(key), _macSizeBits, iv, aad),
        );
      final plainBytes = cipher.process(Uint8List.fromList(cipherBytes));
      return utf8.decode(plainBytes);
    } catch (_) {
      return null;
    }
  }
}
