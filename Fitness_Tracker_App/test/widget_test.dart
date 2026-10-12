import 'package:flutter_test/flutter_test.dart';
import 'package:codealpha_fitness_tracker/main.dart';

void main() {
  testWidgets('FitTrack app starts', (tester) async {
    await tester.pumpWidget(const FitnessTrackerApp());
    expect(find.byType(FitnessTrackerApp), findsOneWidget);
    expect(find.text('FitTrack'), findsOneWidget);
  });
}
