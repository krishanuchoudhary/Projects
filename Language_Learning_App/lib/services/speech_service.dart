import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String languageCode) async {
    await _tts.stop();
    await _tts.setLanguage(languageCode == 'es' ? 'es-ES' : languageCode == 'fr' ? 'fr-FR' : 'de-DE');
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();

  Future<void> dispose() async {
    await _tts.stop();
  }
}
