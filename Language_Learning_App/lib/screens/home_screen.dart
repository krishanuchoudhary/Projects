import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../services/app_controller.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppController controller;
  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Dashboard(controller: widget.controller, onOpenLesson: () => _openLesson(0)),
      LessonScreen(controller: widget.controller),
      QuizScreen(controller: widget.controller),
      ProfileScreen(controller: widget.controller),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _currentIndex, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.style_outlined), selectedIcon: Icon(Icons.style), label: 'Lessons'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _openLesson(int index) {
    setState(() => _currentIndex = 1);
  }
}

class _Dashboard extends StatelessWidget {
  final AppController controller;
  final VoidCallback onOpenLesson;

  const _Dashboard({required this.controller, required this.onOpenLesson});

  @override
  Widget build(BuildContext context) {
    final language = languages.firstWhere((item) => item.code == controller.selectedLanguage);
    final progress = controller.progressFor(language.code);
    final words = lessonWords[language.code] ?? const [];
    final dailyIndex = DateTime.now().day % words.length;
    final dailyWord = words[dailyIndex];
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good ${_greeting()},', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 2),
                    const Text('Let’s learn something new.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(language.flag, style: const TextStyle(fontSize: 22)),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('YOUR ${language.name.toUpperCase()} JOURNEY', style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: .75), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                            const SizedBox(height: 7),
                            Text('${(progress * 100).round()}% complete', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 5),
                            Text('${controller.masteredCountFor(language.code)} of ${controller.totalWordsFor(language.code)} learning cards mastered', style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: .85))),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 76,
                        height: 76,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(value: progress, strokeWidth: 8, backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: .16), color: theme.colorScheme.onPrimary),
                            Text('${(progress * 100).round()}%', style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onOpenLesson,
                      style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.onPrimary, foregroundColor: theme.colorScheme.primary),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Continue learning'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _StatCard(icon: Icons.local_fire_department_outlined, title: 'Streak', value: '${controller.streak} day${controller.streak == 1 ? '' : 's'}')),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(icon: Icons.emoji_events_outlined, title: 'Best quiz', value: '${controller.bestQuizScore}/5')),
            ],
          ),
          const SizedBox(height: 24),
          Text('Daily bite', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _DailyWordCard(languageName: language.name, word: dailyWord),
          const SizedBox(height: 24),
          Text('Explore lessons', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _CategoryCard(icon: Icons.translate_rounded, title: 'Vocabulary', subtitle: 'Words & phrases', color: const Color(0xFFEAF4FF), onTap: onOpenLesson)),
              const SizedBox(width: 12),
              Expanded(child: _CategoryCard(icon: Icons.menu_book_rounded, title: 'Grammar', subtitle: 'Simple patterns', color: const Color(0xFFF5EDFF), onTap: onOpenLesson)),
            ],
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _StatCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.secondaryContainer, child: Icon(icon, color: color.onSecondaryContainer)),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 3), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))])),
          ],
        ),
      ),
    );
  }
}

class _DailyWordCard extends StatelessWidget {
  final String languageName;
  final dynamic word;
  const _DailyWordCard({required this.languageName, required this.word});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.tertiaryContainer, child: Icon(Icons.lightbulb_outline_rounded, color: color.onTertiaryContainer)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('WORD OF THE DAY · $languageName'.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color.primary)), const SizedBox(height: 4), Text(word.word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text('${word.translation}  ·  /${word.pronunciation}/', style: TextStyle(color: color.onSurfaceVariant))])),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _CategoryCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(radius: 24, backgroundColor: color, child: Icon(icon, color: Colors.black87)),
            const SizedBox(height: 13),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}
