import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/learning_models.dart';
import '../services/app_controller.dart';
import '../services/speech_service.dart';

class LessonScreen extends StatefulWidget {
  final AppController controller;
  const LessonScreen({super.key, required this.controller});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _index = 0;
  bool _showAnswer = false;
  String _category = 'All';
  final SpeechService _speech = SpeechService();

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final allWords = lessonWords[widget.controller.selectedLanguage] ?? const <LessonWord>[];
        final filtered = _category == 'All' ? allWords : allWords.where((word) => word.category == _category).toList();
        if (_index >= filtered.length) _index = 0;
        final word = filtered[_index];
        final language = languages.firstWhere((item) => item.code == widget.controller.selectedLanguage);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 35),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Daily lessons', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Practice ${language.name} with quick, focused cards.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 18),
            Wrap(spacing: 8, children: ['All', 'Vocabulary', 'Grammar'].map((category) => ChoiceChip(label: Text(category), selected: _category == category, onSelected: (_) => setState(() { _category = category; _index = 0; _showAnswer = false; }))).toList()),
            const SizedBox(height: 18),
            LinearProgressIndicator(value: filtered.isEmpty ? 0 : (_index + 1) / filtered.length, minHeight: 7, borderRadius: BorderRadius.circular(20)),
            const SizedBox(height: 12),
            Text('Card ${_index + 1} of ${filtered.length}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _Flashcard(word: word, languageCode: language.code, showAnswer: _showAnswer, speech: _speech, onFlip: () => setState(() => _showAnswer = !_showAnswer), onMastered: () => widget.controller.toggleMastered(word.id), isMastered: widget.controller.masteredWords.contains(word.id)),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: _index > 0 ? () => setState(() { _index--; _showAnswer = false; }) : null, icon: const Icon(Icons.chevron_left), label: const Text('Previous'))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton.icon(onPressed: _index < filtered.length - 1 ? () => setState(() { _index++; _showAnswer = false; }) : () => setState(() { _index = 0; _showAnswer = false; }), icon: const Icon(Icons.chevron_right), label: Text(_index < filtered.length - 1 ? 'Next' : 'Restart'))),
            ]),
            const SizedBox(height: 24),
            Card(color: Theme.of(context).colorScheme.surfaceContainerHighest, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Icon(Icons.tips_and_updates_outlined, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 11), Expanded(child: Text('Tip: reveal the translation first, then tap “I know this” only when you can recall the answer without looking.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35)))]))),
          ]),
        );
      },
    );
  }
}

class _Flashcard extends StatelessWidget {
  final LessonWord word;
  final String languageCode;
  final bool showAnswer;
  final SpeechService speech;
  final VoidCallback onFlip;
  final VoidCallback onMastered;
  final bool isMastered;

  const _Flashcard({required this.word, required this.languageCode, required this.showAnswer, required this.speech, required this.onFlip, required this.onMastered, required this.isMastered});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onFlip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 350),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.surface, color.surfaceContainerHighest.withValues(alpha: .7)])),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(alignment: Alignment.topLeft, child: Chip(label: Text(word.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)))),
            const SizedBox(height: 34),
            Text(word.word, textAlign: TextAlign.center, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(showAnswer ? word.translation : 'Tap to reveal translation', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: showAnswer ? color.primary : color.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(showAnswer ? 'Example: ${word.example}' : 'Learn → recall → repeat', textAlign: TextAlign.center, style: TextStyle(color: color.onSurfaceVariant, height: 1.4)),
            if (showAnswer) ...[
              const SizedBox(height: 18),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton.filledTonal(onPressed: () => speech.speak(word.word, languageCode), tooltip: 'Pronounce', icon: const Icon(Icons.volume_up_rounded)),
                const SizedBox(width: 14),
                OutlinedButton.icon(onPressed: onMastered, icon: Icon(isMastered ? Icons.check_circle : Icons.check_circle_outline), label: Text(isMastered ? 'Mastered' : 'I know this')),
              ]),
            ],
            const SizedBox(height: 24),
            if (showAnswer) Text('Grammar note: ${word.grammarTip}', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color.onSurfaceVariant, height: 1.35)),
          ]),
        ),
      ),
    );
  }
}
