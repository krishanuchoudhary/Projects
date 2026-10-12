# CodeAlpha Task 3 - Fitness Tracker App

## Task coverage
- Daily fitness activity tracking: steps, workout duration, calories burned, and exercise type.
- Manual fitness logging.
- Daily summary dashboard.
- Seven-day progress chart.
- Progress bars for daily goals.
- Activity history with edit and delete.
- Offline local record storage using SQLite.
- Clean, simple Material 3 UI.

## Tech stack
- Flutter / Dart
- Material 3
- SQLite through `sqflite`
- `fl_chart` for visual progress
- `intl` for date formatting

## Project structure
- `lib/main.dart` - app entry point and theme
- `lib/models/fitness_log.dart` - fitness record model
- `lib/services/database_service.dart` - SQLite CRUD operations
- `lib/screens/home_screen.dart` - dashboard and 7-day chart
- `lib/screens/log_activity_screen.dart` - manual activity form
- `lib/screens/history_screen.dart` - stored record history
- `lib/widgets/` - reusable stat/progress cards

## Run on VSCode
This workspace was prepared with the Flutter application source and dependencies, but Flutter itself is not installed in the build environment used to prepare the files.

1. Install the latest stable Flutter SDK.
2. In this project folder run:

```bash
flutter pub get
flutter emulators
flutter emulators --launch <emulator_id>
flutter run -d emulator-5554
```

