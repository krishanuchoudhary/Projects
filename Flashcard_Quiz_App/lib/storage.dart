import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class FlashcardStorage {
  static const _storageKey = 'flashcards';

  Future<List<Flashcard>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> save(List<Flashcard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(cards.map((card) => card.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
