# CodeAlpha Task 1 — Flashcard Quiz App

## Included requirements

- Question on the front and answer on the back.
- **Show Answer** button.
- **Previous** and **Next** navigation.
- Add new flashcards.
- Edit existing flashcards.
- Delete flashcards with confirmation.
- Clean, responsive Material 3 interface.
- Flashcard list/browse view.
- Local persistence with `shared_preferences`, so cards remain after restarting the app.

## Run the app

1. Install Flutter SDK and configure a device/emulator.
2. Open this folder in Android Studio or VS Code.
3. Run:

```bash
flutter pub get
flutter emulators
flutter emulators --launch <emulator_id>
flutter run -d emulator-5554
```

## Build APK

```bash
flutter build apk --release
```

The release APK will be generated under:

`build/app/outputs/flutter-apk/app-release.apk`

## Project structure

```text
lib/
  main.dart       # UI + app logic
  models.dart     # Flashcard model
  storage.dart    # Local persistence
```
