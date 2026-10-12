class LessonWord {
  final String id;
  final String category;
  final String word;
  final String translation;
  final String pronunciation;
  final String example;
  final String grammarTip;

  const LessonWord({
    required this.id,
    required this.category,
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.example,
    required this.grammarTip,
  });
}

class QuizQuestion {
  final String prompt;
  final String translation;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const QuizQuestion({
    required this.prompt,
    required this.translation,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
