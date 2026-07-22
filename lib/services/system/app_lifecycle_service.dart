import 'dart:async';
import 'package:flutter/widgets.dart';

class AppLifecycleService extends WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  static AppLifecycleService get instance => _instance;

  bool _isResumed = true;
  Completer<void>? _resumeCompleter;

  AppLifecycleService._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isResumed = true;
      if (_resumeCompleter != null && !_resumeCompleter!.isCompleted) {
        _resumeCompleter!.complete();
      }
      _resumeCompleter = null;
    } else {
      _isResumed = false;
    }
  }

  /// Waits until the application is in the foreground (resumed).
  /// If it is already in the foreground, it completes immediately.
  Future<void> waitUntilResumed() async {
    if (_isResumed) return;
    _resumeCompleter ??= Completer<void>();
    await _resumeCompleter!.future;
  }
}
