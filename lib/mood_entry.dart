import 'dart:convert';

import 'package:flutter/material.dart';

enum MoodType {
  happy('Happy', Color(0xFFF2B84B)),
  calm('Calm', Color(0xFF4F9D8F)),
  sad('Sad', Color(0xFF5B79C9)),
  angry('Angry', Color(0xFFD94B4B));

  const MoodType(this.label, this.accent);

  final String label;
  final Color accent;
}

class MoodEntry {
  const MoodEntry({required this.mood, required this.loggedAt});

  final MoodType mood;
  final DateTime loggedAt;

  String get storageValue =>
      jsonEncode({'mood': mood.name, 'loggedAt': loggedAt.toIso8601String()});

  static MoodEntry? fromStorageValue(String value) {
    try {
      final decoded = jsonDecode(value) as Map<String, dynamic>;
      final moodName = decoded['mood'] as String;
      final loggedAt = DateTime.parse(decoded['loggedAt'] as String);
      final mood = MoodType.values.byName(moodName);

      return MoodEntry(mood: mood, loggedAt: loggedAt);
    } on Object {
      return null;
    }
  }
}
