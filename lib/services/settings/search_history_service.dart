import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = AppConstants.searchHistory;
  static const int _maxHistory = 40;

  List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_key) ?? [];
  }

  Future<void> add(String term) async {
    final cleanTerm = term.trim();
    if (cleanTerm.isEmpty) return;

    _history.removeWhere(
      (item) => item.toLowerCase() == cleanTerm.toLowerCase(),
    );

    _history.removeWhere(
      (item) => cleanTerm.toLowerCase().startsWith(item.toLowerCase()),
    );

    _history.insert(0, cleanTerm);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }

    await _save();
  }

  Future<void> delete(String term) async {
    final cleanTerm = term.trim().toLowerCase();
    _history.removeWhere((item) => item.trim().toLowerCase() == cleanTerm);
    await _save();
  }

  Future<void> clear() async {
    _history.clear();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
  }

  List<String> getSuggestions(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return List.unmodifiable(_history);

    return _history
        .where((term) => term.toLowerCase().startsWith(cleanQuery))
        .toList();
  }
}
