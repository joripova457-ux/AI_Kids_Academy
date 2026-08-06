import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'services/session_timer_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local SharedPreferences servisini ishga tushirish
  await StorageService.init();

  // Real vaqt taymerini ishga tushirish (Screen Time Tracking)
  SessionTimerService().start();


  runApp(const AIKidsAcademyApp());
}

/// AI Kids Academy ilovasi ildiz vidjeti
class AIKidsAcademyApp extends StatelessWidget {
  const AIKidsAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Kids Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
