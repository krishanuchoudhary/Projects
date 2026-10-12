# CodeAlpha Task 4: Language Learning App

## Included features

- Learn Spanish, French, or German.
- Daily word / learning card.
- Flashcard lessons with:
  - translation
  - pronunciation guide
  - example sentence
  - grammar note
  - text-to-speech
  - mastered state
- Vocabulary and Grammar categories.
- 5-question interactive practice quiz.
- Instant quiz feedback and score tracking.
- Progress, mastered cards, quiz attempts, best score, and streak.
- Local persistence using `shared_preferences`.
- Profile screen with saved learning progress.
- No Firebase account required.

## Tech stack

- Flutter / Dart
- Material 3
- `shared_preferences`
- `flutter_tts`

## Run locally

```bash
flutter pub get
flutter analyze
flutter test
flutter emulators
flutter emulators --launch <emulator_id>
flutter run -d emulator-5554
```

## Project structure

```text
lib/
  data/app_data.dart
  models/learning_models.dart
  services/app_controller.dart
  services/speech_service.dart
  screens/home_screen.dart
  screens/lesson_screen.dart
  screens/quiz_screen.dart
  screens/profile_screen.dart
  main.dart

test/widget_test.dart
pubspec.yaml
README.md
```

