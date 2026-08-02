/// AI Kids Academy — Markazlashtirilgan Tizim O'zgarmaslari
class AppConstants {
  static const String appName = 'AI Kids Academy';
  static const String appVersion = '2.0.0 (Professional AI)';

  // Modullar ID'lari
  static const String moduleAlphabet = 'alphabet';
  static const String moduleMath = 'math';
  static const String moduleUzbek = 'uzbek';
  static const String moduleEnglish = 'english';
  static const String moduleAiChat = 'ai_chat';
  static const String moduleAiStory = 'ai_story';
  static const String moduleMiniGames = 'mini_games';
  static const String moduleDrawing = 'drawing';

  // O'yin va Ta'lim Sozlamalari
  static const int xpPerCorrectAnswer = 10;
  static const int starsPerModuleLevel = 2;
  static const int streakWindowHours = 36;
  static const int adaptiveAccuracyWindow = 20; // Oxirgi 20 ta urinish

  // Qiyinchilik darajalari
  static const String difficultyEasy = 'easy';
  static const String difficultyMedium = 'medium';
  static const String difficultyHard = 'hard';

  // Storage Kalitlari
  static const String keyChildProfile = 'child_profile_v2';
  static const String keyLearningHistory = 'learning_history_v2';
  static const String keyAdaptiveState = 'adaptive_state_v2';
  static const String keyParentNotificationSettings = 'notification_settings_v2';
  static const String keyAccessibilitySettings = 'accessibility_settings_v2';
  static const String keyScreenTimeLog = 'screen_time_log_v2';
}
