import 'package:flutter/material.dart';

import 'models.dart';
import 'storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlashcardQuizApp());
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({super.key});

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  final FlashcardStorage _storage = FlashcardStorage();

  List<Flashcard> _cards = const [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;

  static const List<Flashcard> _starterCards = [
    Flashcard(
      id: 'starter-1',
      question: 'What does CPU stand for?',
      answer: 'Central Processing Unit — the primary processor that executes instructions.',
    ),
    Flashcard(
      id: 'starter-2',
      question: 'What is an API?',
      answer: 'An Application Programming Interface is a defined way for software components to communicate.',
    ),
    Flashcard(
      id: 'starter-3',
      question: 'What is a variable in programming?',
      answer: 'A named storage location used to hold a value that a program can read or change.',
    ),
    Flashcard(
      id: 'starter-4',
      question: 'What is an SQL database used for?',
      answer: 'It stores structured data and lets applications create, read, update, and delete records using SQL.',
    ),
  ];

  Flashcard? get _currentCard {
    if (_cards.isEmpty) return null;
    if (_currentIndex >= _cards.length) return _cards.last;
    return _cards[_currentIndex];
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final stored = await _storage.load();
    if (!mounted) return;
    setState(() {
      _cards = stored ?? List<Flashcard>.from(_starterCards);
      _currentIndex = 0;
      _isLoading = false;
    });

    if (stored == null) {
      await _storage.save(_cards);
    }
  }

  Future<void> _persist() => _storage.save(_cards);

  void _resetFlip() {
    if (_showAnswer) {
      setState(() => _showAnswer = false);
    }
  }

  void _previousCard() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
      _showAnswer = false;
    });
  }

  void _nextCard() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cards.length;
      _showAnswer = false;
    });
  }

  Future<void> _addCard() async {
    final result = await showDialog<Flashcard>(
      context: context,
      builder: (_) => const FlashcardEditorDialog(),
    );
    if (result == null) return;

    setState(() {
      _cards = [..._cards, result];
      _currentIndex = _cards.length - 1;
      _showAnswer = false;
    });
    await _persist();
  }

  Future<void> _editCard() async {
    final card = _currentCard;
    if (card == null) return;

    final result = await showDialog<Flashcard>(
      context: context,
      builder: (_) => FlashcardEditorDialog(card: card),
    );
    if (result == null) return;

    setState(() {
      _cards = [
        for (final item in _cards) item.id == card.id ? result : item,
      ];
      _showAnswer = false;
    });
    await _persist();
  }

  Future<void> _deleteCard() async {
    final card = _currentCard;
    if (card == null) return;

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete flashcard?'),
            content: const Text(
              'This flashcard will be permanently removed from your saved deck.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    setState(() {
      _cards = _cards.where((item) => item.id != card.id).toList();
      if (_cards.isEmpty) {
        _currentIndex = 0;
      } else if (_currentIndex >= _cards.length) {
        _currentIndex = _cards.length - 1;
      }
      _showAnswer = false;
    });
    await _persist();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Flashcard deleted.')),
    );
  }

  Future<void> _showCardList() async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * 0.75,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your flashcards',
                    style: Theme.of(sheetContext).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_cards.length} ${_cards.length == 1 ? 'card' : 'cards'} in this deck',
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _cards.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final card = _cards[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          tileColor: index == _currentIndex
                              ? Theme.of(sheetContext)
                                  .colorScheme
                                  .primaryContainer
                              : Theme.of(sheetContext)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            card.question,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: const Text('Tap to study this card'),
                          onTap: () => Navigator.pop(sheetContext, index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selectedIndex == null || !mounted) return;
    setState(() {
      _currentIndex = selectedIndex;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flashcard Quiz',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Study smarter, one card at a time',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'View all cards',
            onPressed: _cards.isEmpty ? null : _showCardList,
            icon: const Icon(Icons.view_list_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              tooltip: 'Add flashcard',
              onPressed: _addCard,
              icon: const Icon(Icons.add_rounded),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 40,
                        maxWidth: 720,
                      ),
                      child: Center(
                        child: _cards.isEmpty
                            ? _buildEmptyState(theme)
                            : _buildStudyView(theme),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildStudyView(ThemeData theme) {
    final card = _currentCard!;
    final progress = (_currentIndex + 1) / _cards.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Card ${_currentIndex + 1} of ${_cards.length}',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              _showAnswer ? 'Answer' : 'Question',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            minHeight: 7,
            value: progress,
          ),
        ),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: () => setState(() => _showAnswer = !_showAnswer),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _buildFlashcardFace(
              key: ValueKey('${card.id}-$_showAnswer'),
              card: card,
              showAnswer: _showAnswer,
              theme: theme,
            ),
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () => setState(() => _showAnswer = !_showAnswer),
          icon: Icon(
            _showAnswer
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
          label: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _cards.length <= 1 ? null : _previousCard,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _cards.length <= 1 ? null : _nextCard,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _editCard,
              icon: const Icon(Icons.edit_rounded, size: 20),
              label: const Text('Edit'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _deleteCard,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: const Text('Delete'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Tip: Tap the card or use Show Answer to reveal the answer.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFlashcardFace({
    required Key key,
    required Flashcard card,
    required bool showAnswer,
    required ThemeData theme,
  }) {
    return Container(
      key: key,
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer.withOpacity(0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0, 14),
            color: Color(0x16000000),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              showAnswer ? Icons.lightbulb_rounded : Icons.help_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 26),
          Text(
            showAnswer ? 'ANSWER' : 'QUESTION',
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              showAnswer ? card.answer : card.question,
              key: ValueKey(showAnswer ? card.answer : card.question),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.style_rounded,
            size: 42,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No flashcards yet',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first question and answer to start studying.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: _addCard,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Flashcard'),
        ),
      ],
    );
  }
}

class FlashcardEditorDialog extends StatefulWidget {
  final Flashcard? card;

  const FlashcardEditorDialog({super.key, this.card});

  @override
  State<FlashcardEditorDialog> createState() => _FlashcardEditorDialogState();
}

class _FlashcardEditorDialogState extends State<FlashcardEditorDialog> {
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.card != null;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.card?.question ?? '');
    _answerController = TextEditingController(text: widget.card?.answer ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final id = widget.card?.id ?? 'card-${DateTime.now().microsecondsSinceEpoch}';
    Navigator.pop(
      context,
      Flashcard(
        id: id,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Flashcard' : 'Add Flashcard'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _questionController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'e.g. What is polymorphism?',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.help_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a question.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _answerController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  hintText: 'Write a clear explanation or answer.',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.lightbulb_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an answer.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(_isEditing ? 'Save Changes' : 'Add Card'),
        ),
      ],
    );
  }
}
