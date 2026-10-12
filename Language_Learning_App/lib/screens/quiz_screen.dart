import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/learning_models.dart';
import '../services/app_controller.dart';

class QuizScreen extends StatefulWidget {
  final AppController controller;
  const QuizScreen({super.key, required this.controller});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  List<QuizQuestion> get _questions => quizQuestions[widget.controller.selectedLanguage] ?? const [];

  void _select(int index) {
    if (_selected != null || _finished) return;
    setState(() {
      _selected = index;
      if (index == _questions[_questionIndex].answerIndex) _score++;
    });
  }

  Future<void> _next() async {
    if (_selected == null) return;
    if (_questionIndex == _questions.length - 1) {
      await widget.controller.recordQuiz(_score);
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _questionIndex++;
      _selected = null;
    });
  }

  void _restart() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
      _selected = null;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = languages.firstWhere((item) => item.code == widget.controller.selectedLanguage);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: _finished ? _ResultView(score: _score, languageName: language.name, onRestart: _restart) : _QuestionView(question: _questions[_questionIndex], index: _questionIndex, total: _questions.length, selected: _selected, score: _score, onSelect: _select, onNext: _next),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final QuizQuestion question;
  final int index;
  final int total;
  final int? selected;
  final int score;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _QuestionView({required this.question, required this.index, required this.total, required this.selected, required this.score, required this.onSelect, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Practice quiz', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('Test your recall and reinforce what you have learned.', style: TextStyle(color: color.onSurfaceVariant)),
      const SizedBox(height: 18),
      Row(children: [Expanded(child: LinearProgressIndicator(value: (index + 1) / total, minHeight: 7, borderRadius: BorderRadius.circular(20))), const SizedBox(width: 12), Text('${index + 1}/$total', style: const TextStyle(fontWeight: FontWeight.w800))]),
      const SizedBox(height: 22),
      Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TRANSLATION CHECK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color.primary, letterSpacing: 1)),
        const SizedBox(height: 14),
        Text(question.prompt, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
        const SizedBox(height: 6),
        Text(question.translation, style: TextStyle(color: color.onSurfaceVariant)),
      ]))),
      const SizedBox(height: 14),
      ...List.generate(question.options.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _OptionTile(index: i, text: question.options[i], selected: selected, correct: question.answerIndex, onTap: () => onSelect(i)))),
      if (selected != null) ...[
        const SizedBox(height: 4),
        Card(color: color.surfaceContainerHighest, child: Padding(padding: const EdgeInsets.all(15), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(selected == question.answerIndex ? Icons.check_circle_outline : Icons.info_outline, color: selected == question.answerIndex ? Colors.green : color.primary), const SizedBox(width: 10), Expanded(child: Text(question.explanation, style: TextStyle(color: color.onSurfaceVariant, height: 1.35)))]))),
      ],
      const Spacer(),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: selected == null ? null : onNext, child: Text(index == total - 1 ? 'Finish quiz' : 'Next question'))),
    ]);
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final int? selected;
  final int correct;
  final VoidCallback onTap;
  const _OptionTile({required this.index, required this.text, required this.selected, required this.correct, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == index;
    final isCorrect = selected != null && correct == index;
    final color = Theme.of(context).colorScheme;
    Color? fill;
    Color border = color.outlineVariant;
    if (selected != null && isCorrect) {
      fill = Colors.green.withValues(alpha: 0.10);
      border = Colors.green;
    } else if (isSelected) {
      fill = color.errorContainer.withValues(alpha: 0.55);
      border = color.error;
    }
    return InkWell(
      onTap: selected == null ? onTap : null,
      borderRadius: BorderRadius.circular(17),
      child: AnimatedContainer(duration: const Duration(milliseconds: 160), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: fill ?? color.surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: border, width: 1.4)), child: Row(children: [CircleAvatar(radius: 15, backgroundColor: color.surfaceContainerHighest, child: Text(String.fromCharCode(65 + index), style: const TextStyle(fontWeight: FontWeight.w800))), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))), if (selected != null && isCorrect) const Icon(Icons.check_circle, color: Colors.green)])),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;
  final String languageName;
  final VoidCallback onRestart;
  const _ResultView({required this.score, required this.languageName, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    const total = 5;
    final ratio = score / total;
    final message = ratio == 1 ? 'Perfect round!' : ratio >= .6 ? 'Good job — keep practicing.' : 'Nice start — a little more practice will help.';
    final color = Theme.of(context).colorScheme;
    return Center(child: Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 36, backgroundColor: color.primaryContainer, child: Icon(score >= 3 ? Icons.emoji_events_rounded : Icons.refresh_rounded, size: 34, color: color.primary)), const SizedBox(height: 18), const Text('Quiz complete', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(languageName, style: TextStyle(color: color.onSurfaceVariant)), const SizedBox(height: 18), Text('$score / $total', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: color.primary)), const SizedBox(height: 6), Text(message, textAlign: TextAlign.center, style: TextStyle(color: color.onSurfaceVariant, height: 1.4)), const SizedBox(height: 22), SizedBox(width: double.infinity, child: FilledButton(onPressed: onRestart, child: const Text('Try again')))]))));
  }
}
