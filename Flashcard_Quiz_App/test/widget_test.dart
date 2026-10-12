import 'package:flutter_test/flutter_test.dart';

import 'package:codealpha_flashcard_quiz_app/main.dart';

void main() {
  testWidgets('shows the Flashcard Quiz title', (tester) async {
    await tester.pumpWidget(const FlashcardQuizApp());
    await tester.pumpAndSettle();

    expect(find.text('Flashcard Quiz'), findsOneWidget);
  });
}
