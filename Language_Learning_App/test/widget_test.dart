import 'package:flutter_test/flutter_test.dart';

import 'package:language_learning_app/main.dart';
import 'package:language_learning_app/services/app_controller.dart';

void main() {
  testWidgets('LingoStep app shows dashboard shell', (tester) async {
    final controller = AppController();

    await tester.pumpWidget(
      LanguageLearningApp(controller: controller),
    );

    await tester.pump();

    expect(
      find.text('Let’s learn something new.'),
      findsOneWidget,
    );

    expect(find.text('Lessons'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });
}