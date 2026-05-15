import 'package:flutter/foundation.dart';

import 'mood_entry.dart';

class MoodController extends ChangeNotifier {
  static const int maxVisibleEntries = 7;

  final List<MoodEntry> _entries = [];

  List<MoodEntry> get entries => List.unmodifiable(_entries);

  MoodEntry? get latestEntry => _entries.firstOrNull;

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
  }
}
