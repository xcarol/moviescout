import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = AppConstants.searchHistory;
  static const int _maxHistory = 40;

  List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  /// Loads the history from SharedPreferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_key) ?? [];
  }

  /// Adds a term to the history.
  /// Moves it to the front if it already exists.
  /// Trims the list to `_maxHistory`.
  Future<void> add(String term) async {
    if (term.trim().isEmpty) return;

    // Remove if exists to move it to front
    _history.remove(term);

    // Add to front
    _history.insert(0, term);

    // Trim
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }

    await _save();
  }

  /// Removes a term from the history.
  Future<void> delete(String term) async {
    _history.remove(term);
    await _save();
  }

  /// Helper to save current state to prefs
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
  }

  /// Returns suggestions starting with [query].
  /// [query] is case-insensitive.
  List<String> getSuggestions(String query) {
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _history
        .where((term) => term.toLowerCase().startsWith(lowerQuery))
        .toList();
  }
}
