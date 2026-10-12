import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_data.dart';

class AppController extends ChangeNotifier {
  static const _languageKey = 'selected_language';
  static const _masteredKey = 'mastered_words';
  static const _quizAttemptsKey = 'quiz_attempts';
  static const _quizBestKey = 'quiz_best';
  static const _streakKey = 'streak';
  static const _lastStudyDayKey = 'last_study_day';

  String _selectedLanguage = languages.first.code;
  final Set<String> _masteredWords = <String>{};
  int _quizAttempts = 0;
  int _bestQuizScore = 0;
  int _streak = 0;
  String? _lastStudyDay;
  SharedPreferences? _prefs;

  String get selectedLanguage => _selectedLanguage;
  Set<String> get masteredWords => Set.unmodifiable(_masteredWords);
  int get quizAttempts => _quizAttempts;
  int get bestQuizScore => _bestQuizScore;
  int get streak => _streak;

  int totalWordsFor(String languageCode) => lessonWords[languageCode]?.length ?? 0;
  int masteredCountFor(String languageCode) => lessonWords[languageCode]?.where((w) => _masteredWords.contains(w.id)).length ?? 0;
  double progressFor(String languageCode) {
    final total = totalWordsFor(languageCode);
    if (total == 0) return 0;
    return masteredCountFor(languageCode) / total;
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _selectedLanguage = _prefs?.getString(_languageKey) ?? languages.first.code;
    final stored = _prefs?.getStringList(_masteredKey) ?? const <String>[];
    _masteredWords
      ..clear()
      ..addAll(stored);
    _quizAttempts = _prefs?.getInt(_quizAttemptsKey) ?? 0;
    _bestQuizScore = _prefs?.getInt(_quizBestKey) ?? 0;
    _streak = _prefs?.getInt(_streakKey) ?? 0;
    _lastStudyDay = _prefs?.getString(_lastStudyDayKey);
    notifyListeners();
  }

  Future<void> selectLanguage(String code) async {
    _selectedLanguage = code;
    await _prefs?.setString(_languageKey, code);
    notifyListeners();
  }

  Future<void> toggleMastered(String wordId) async {
    if (_masteredWords.contains(wordId)) {
      _masteredWords.remove(wordId);
    } else {
      _masteredWords.add(wordId);
    }
    await _prefs?.setStringList(_masteredKey, _masteredWords.toList());
    await recordStudyActivity();
    notifyListeners();
  }

  Future<void> recordStudyActivity() async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (_lastStudyDay == today) return;

    final yesterdayDate = now.subtract(const Duration(days: 1));
    final yesterday = '${yesterdayDate.year}-${yesterdayDate.month.toString().padLeft(2, '0')}-${yesterdayDate.day.toString().padLeft(2, '0')}';
    _streak = _lastStudyDay == yesterday ? _streak + 1 : 1;
    _lastStudyDay = today;

    await _prefs?.setInt(_streakKey, _streak);
    await _prefs?.setString(_lastStudyDayKey, today);
  }

  Future<void> recordQuiz(int score) async {
    _quizAttempts += 1;
    if (score > _bestQuizScore) _bestQuizScore = score;
    await recordStudyActivity();
    await _prefs?.setInt(_quizAttemptsKey, _quizAttempts);
    await _prefs?.setInt(_quizBestKey, _bestQuizScore);
    notifyListeners();
  }

  Map<String, dynamic> exportProgress() => {
        'language': _selectedLanguage,
        'masteredWords': _masteredWords.toList(),
        'quizAttempts': _quizAttempts,
        'bestQuizScore': _bestQuizScore,
        'streak': _streak,
      };

  Future<void> importProgress(String json) async {
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    _selectedLanguage = decoded['language'] as String? ?? languages.first.code;
    _masteredWords
      ..clear()
      ..addAll((decoded['masteredWords'] as List<dynamic>? ?? const <dynamic>[]).whereType<String>());
    _quizAttempts = decoded['quizAttempts'] as int? ?? 0;
    _bestQuizScore = decoded['bestQuizScore'] as int? ?? 0;
    _streak = decoded['streak'] as int? ?? 0;
    await _prefs?.setString(_languageKey, _selectedLanguage);
    await _prefs?.setStringList(_masteredKey, _masteredWords.toList());
    await _prefs?.setInt(_quizAttemptsKey, _quizAttempts);
    await _prefs?.setInt(_quizBestKey, _bestQuizScore);
    await _prefs?.setInt(_streakKey, _streak);
    notifyListeners();
  }
}
