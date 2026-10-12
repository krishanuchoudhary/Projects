import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController();
  await controller.load();
  runApp(LanguageLearningApp(controller: controller));
}

class LanguageLearningApp extends StatelessWidget {
  final AppController controller;

  const LanguageLearningApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF5B5CE2);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LingoStep',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seed),
            scaffoldBackgroundColor: const Color(0xFFF7F7FC),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            cardTheme: const CardThemeData(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
            ),
          ),
          home: HomeScreen(controller: controller),
        );
      },
    );
  }
}
