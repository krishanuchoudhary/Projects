# Projects

A collection of machine learning and Flutter projects by **Krishanu Choudhary**, B.Tech Computer Science and Engineering student at Guru Nanak Institute of Technology, Hyderabad (2023–2027).

| Project | Stack | Folder |
| --- | --- | --- |
| Brain Tumor Detection from MRI Scans | Python, TensorFlow/Keras, OpenCV, scikit-learn | [Brain Tumor Detection from MRI Scans](./Brain%20Tumor%20Detection%20from%20MRI%20Scans) |
| Language Learning App | Flutter, Dart, shared_preferences, flutter_tts | [Language_Learning_App](./Language_Learning_App) |
| Fitness Tracker App | Flutter, Dart, SQLite/sqflite, fl_chart | [Fitness_Tracker_App](./Fitness_Tracker_App) |
| Flashcard Quiz App | Flutter, Dart, Material 3, shared_preferences | [Flashcard_Quiz_App](./Flashcard_Quiz_App) |

---

## 1. Brain Tumor Detection from MRI Scans

A CNN-based pipeline for automated brain-tumor detection from MRI scans, reaching **97.7% accuracy**.

- Image preprocessing and augmentation with OpenCV
- Multi-level Otsu thresholding to segment tumor regions
- RBF-kernel SVM for classification
- Built with Python, TensorFlow/Keras, OpenCV and scikit-learn

## 2. Language Learning App

A Flutter app for learning Spanish, French and German.

- Lessons with translations, pronunciation guides, example sentences and grammar notes
- Text-to-speech using `flutter_tts`
- Five-question practice quiz that saves progress, mastered cards, scores and streaks (`shared_preferences`)

## 3. Fitness Tracker App

A Flutter app for logging daily fitness activity.

- Manual logging of steps, workout duration, calories and exercise type
- Daily summaries, goal progress bars and a seven-day chart (`fl_chart`)
- Local storage in SQLite (`sqflite`) with editable and deletable history

## 4. Flashcard Quiz App

An offline Flutter flashcard app.

- Front/back question cards with answer reveal
- Previous/next navigation and a browse view
- Add, edit and delete cards, with a confirmation step before deletion
- Material 3 UI, data saved with `shared_preferences`

---

## Running the Flutter apps

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install).

```bash
cd <app-folder>      # e.g. Fitness_Tracker_App
flutter pub get
flutter run
```

## Running the MRI project

Requires Python 3 with TensorFlow/Keras, OpenCV, scikit-learn and NumPy.

```bash
cd "Brain Tumor Detection from MRI Scans"
pip install tensorflow opencv-python scikit-learn numpy
```

See the project folder for the notebook or script to run.

## Contact

- Email: krishanuchoudhary702@gmail.com
- LinkedIn: [krishanu-choudhary](https://www.linkedin.com/in/krishanu-choudhary-45ab87301)
- GitHub: [krishanuchoudhary](https://github.com/krishanuchoudhary)
