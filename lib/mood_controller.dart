import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mood_entry.dart';

class MoodController extends ChangeNotifier {
  static const int maxVisibleEntries = 7;
  static const String _storageKey = 'mood_entries';

  final List<MoodEntry> _entries = [];
  bool _isReady = false;

  List<MoodEntry> get entries => List.unmodifiable(_entries);

  MoodEntry? get latestEntry => _entries.firstOrNull;

  bool get isReady => _isReady;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedEntries = preferences.getStringList(_storageKey) ?? [];

    _entries
      ..clear()
      ..addAll(storedEntries.map(MoodEntry.fromStorageValue).nonNulls)
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    if (_entries.length > maxVisibleEntries) {
      _entries.removeRange(maxVisibleEntries, _entries.length);
    }

    _isReady = true;
    notifyListeners();
  }

  void logMood(MoodType mood) {
    _entries.insert(
      0,
      MoodEntry(
        mood: mood,
        loggedAt: DateTime.now(),
      ),
    );

    if (_entries.length > maxVisibleEntries) {
      _entries.removeRange(maxVisibleEntries, _entries.length);
    }

    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      _entries.map((entry) => entry.storageValue).toList(),
    );
  }
}
