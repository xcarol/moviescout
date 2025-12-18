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
    if (term.trim().isEmpty) return;

    _history.remove(term);

    _history.insert(0, term);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }

    await _save();
  }

  Future<void> delete(String term) async {
    _history.remove(term);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
  }

  List<String> getSuggestions(String query) {
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _history
        .where((term) => term.toLowerCase().startsWith(lowerQuery))
        .toList();
  }
}
