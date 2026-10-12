import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/learning_models.dart';
import '../services/app_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AppController controller;

  const ProfileScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final language = languages.firstWhere(
          (item) => item.code == controller.selectedLanguage,
        );
        final progress = controller.progressFor(language.code);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile & settings',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose your learning language and view your progress.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 31,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          language.flag,
                          style: const TextStyle(fontSize: 29),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              language.nativeName,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Learning language',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ...languages.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _LanguageTile(
                    option: option,
                    selected: option.code == controller.selectedLanguage,
                    onTap: () => controller.selectLanguage(option.code),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Stats',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _RowStat(
                        title: 'Current streak',
                        value:
                            '${controller.streak} day${controller.streak == 1 ? '' : 's'}',
                      ),
                      const Divider(height: 24),
                      _RowStat(
                        title: 'Quiz attempts',
                        value: '${controller.quizAttempts}',
                      ),
                      const Divider(height: 24),
                      _RowStat(
                        title: 'Best quiz score',
                        value: '${controller.bestQuizScore}/5',
                      ),
                      const Divider(height: 24),
                      _RowStat(
                        title: 'Cards mastered',
                        value:
                            '${controller.masteredCountFor(language.code)}/${controller.totalWordsFor(language.code)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _showProgress(context),
                icon: const Icon(Icons.data_object),
                label: const Text('View saved progress JSON'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProgress(BuildContext context) {
    final pretty = const JsonEncoder.withIndent('  ').convert(
      controller.exportProgress(),
    );

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Saved learning data'),
        content: SingleChildScrollView(
          child: SelectableText(
            pretty,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Card(
      color: selected ? color.primaryContainer.withValues(alpha: 0.7) : null,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Text(
          option.flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          option.name,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(option.nativeName),
        trailing: selected
            ? Icon(Icons.check_circle, color: color.primary)
            : const Icon(Icons.circle_outlined),
      ),
    );
  }
}

class _RowStat extends StatelessWidget {
  final String title;
  final String value;

  const _RowStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
