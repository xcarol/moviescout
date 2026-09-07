import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TmdbConfigListService extends TmdbBaseService
    with ChangeNotifier {
  final String remoteConfigName;

  String _accessToken = '';
  String _accountId = '';
  String _sessionId = '';

  RealtimeChannel? _supabaseSubscription;

  TmdbConfigListService({
    required this.remoteConfigName,
  });

  @protected
  String get accessToken => _accessToken;
  @protected
  String get accountId => _accountId;
  @protected
  String get sessionId => _sessionId;

  void clearConfig() {
    _supabaseSubscription?.unsubscribe();
    _supabaseSubscription = null;
  }

  @protected
  void setupBase(String accountId, String sessionId, String accessToken) {
    _accountId = accountId;
    _sessionId = sessionId;
    _accessToken = accessToken;
  }

  @protected
  Future<void> applyData(dynamic data);

  String? get _supabaseUserId => SupabaseService().client.auth.currentUser?.id;

  Future<void> fetchAndListen() async {
    final userId = _supabaseUserId;
    if (userId == null) return;

    try {
      final response = await SupabaseService()
          .client
          .from('user_configs')
          .select('data')
          .eq('user_id', userId)
          .eq('config_name', remoteConfigName)
          .maybeSingle();

      if (response != null && response['data'] != null) {
        await applyData(response['data']);
      }
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error fetching config $remoteConfigName');
    }

    _supabaseSubscription ??= SupabaseService()
        .client
        .channel('public:user_configs:user_id=eq.$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_configs',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'config_name',
            value: remoteConfigName,
          ),
          callback: (payload) async {
            if (payload.newRecord['data'] != null) {
              await applyData(payload.newRecord['data']);
            }
          },
        )
        .subscribe();
  }

  @protected
  Future<bool> updateRemoteConfig(dynamic data) async {
    final userId = _supabaseUserId;
    if (userId == null) return false;

    try {
      await SupabaseService().client.from('user_configs').upsert({
        'user_id': userId,
        'config_name': remoteConfigName,
        'data': data,
      }, onConflict: 'user_id, config_name');
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error saving config $remoteConfigName');
      return false;
    }
  }

  @protected
  Future<bool> updateArrayInRemoteConfig(String item, bool add) async {
    final userId = _supabaseUserId;
    if (userId == null) return false;

    try {
      final response = await SupabaseService()
          .client
          .from('user_configs')
          .select('data')
          .eq('user_id', userId)
          .eq('config_name', remoteConfigName)
          .maybeSingle();

      List<dynamic> currentList = [];
      if (response != null && response['data'] != null) {
        if (response['data'] is List) {
          currentList = List.from(response['data']);
        } else if (response['data'] is String) {
          try {
            currentList = List.from(jsonDecode(response['data']));
          } catch (e) {
            // Ignore decode errors
          }
        }
      }

      if (add) {
        if (!currentList.contains(item)) currentList.add(item);
      } else {
        currentList.remove(item);
      }

      await updateRemoteConfig(currentList);
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error updating array $remoteConfigName');
      return false;
    }
  }
}
