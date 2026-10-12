# Setup checklist

1. Install Flutter stable and verify:

```bash
flutter doctor
```

2. Open the extracted project folder.

3. Generate the platform files for your installed Flutter version:

```bash
flutter create .
```

4. Fetch dependencies:

```bash
flutter pub get
```

5. Run:

```bash
flutter run
```

6. For an APK:

```bash
flutter build apk --release
```

The application stores fitness records locally in SQLite, so no Firebase or server configuration is needed for the task.
