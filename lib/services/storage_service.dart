import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../data/models/accessibility_settings_model.dart';
import '../data/models/adaptive_difficulty_state.dart';
import '../data/models/learning_history_item.dart';
import '../data/models/notification_settings_model.dart';
import '../models/child_profile.dart';
import '../models/progress.dart';

/// SharedPreferences orqali ma'lumotlarni saqlash va boshqarish xizmati (6-BOSQICH Upgrade)
class StorageService {
  static const String _keyActiveProfile = 'active_child_profile';
  static const String _keyProfilesList = 'child_profiles_list';
  static const String _keyProgressList = 'child_progress_list';
  static const String _keyTotalStars = 'total_stars_earned';
  static const String _keyTotalXP = 'total_xp_earned';
  static const String _keyParentPin = 'parent_gate_pin';
  static const String _keyScreenTimeMinutes = 'screen_time_minutes_today';
  static const String _keyScreenTimeWeekly = 'screen_time_weekly';
  static const String _keyScreenTimeMonthly = 'screen_time_monthly';

  final SharedPreferences _prefs;
  static StorageService? _instance;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = StorageService(prefs);
    return _instance!;
  }

  static StorageService get instance {
    if (_instance == null) {
      throw Exception(
          "StorageService hali ishga tushirilmadi. init() chaqirilishi kerak.");
    }
    return _instance!;
  }

  // Default module configuration
  static const Map<String, int> defaultModuleStars = {
    'alphabet': 15,
    'math': 12,
    'uzbek': 18,
    'english': 14,
    'ai_chat': 21,
    'ai_story': 15,
    'mini_games': 8,
    'drawing': 10,
    'parent_gate': 0,
  };

  static const Map<String, int> defaultModuleMaxStars = {
    'alphabet': 20,
    'math': 20,
    'uzbek': 20,
    'english': 20,
    'ai_chat': 30,
    'ai_story': 30,
    'mini_games': 20,
    'drawing': 20,
    'parent_gate': 1,
  };

  // Faol profilni saqlash va olish
  Future<bool> saveActiveProfile(ChildProfile profile) async {
    return await _prefs.setString(_keyActiveProfile, profile.toRawJson());
  }

  ChildProfile getActiveProfile() {
    final raw = _prefs.getString(_keyActiveProfile);
    if (raw == null || raw.isEmpty) {
      return ChildProfile.defaultProfile();
    }
    try {
      return ChildProfile.fromRawJson(raw);
    } catch (_) {
      return ChildProfile.defaultProfile();
    }
  }

  // Profillar ro'yxati
  Future<bool> saveProfiles(List<ChildProfile> profiles) async {
    final rawList = profiles.map((p) => p.toRawJson()).toList();
    return await _prefs.setStringList(_keyProfilesList, rawList);
  }

  List<ChildProfile> getProfiles() {
    final rawList = _prefs.getStringList(_keyProfilesList);
    if (rawList == null) return [getActiveProfile()];
    return rawList.map((e) => ChildProfile.fromRawJson(e)).toList();
  }

  // Yulduzlar va XP hisobi
  int getTotalStars() {
    return _prefs.getInt(_keyTotalStars) ?? 28;
  }

  Future<bool> setTotalStars(int stars) async {
    return await _prefs.setInt(_keyTotalStars, stars);
  }

  Future<int> addStars(int count) async {
    final current = getTotalStars();
    final updated = current + count;
    await setTotalStars(updated);
    return updated;
  }

  int getTotalXP() {
    return _prefs.getInt(_keyTotalXP) ?? 150;
  }

  Future<int> addXP(int count) async {
    final current = getTotalXP();
    final updated = current + count;
    await _prefs.setInt(_keyTotalXP, updated);

    // Profile sync
    final profile = getActiveProfile();
    final newLevel = (updated / 100).floor() + 1;
    await saveActiveProfile(profile.copyWith(
      totalXP: updated,
      level: newLevel,
    ));
    return updated;
  }

  int getUserLevel() {
    final xp = getTotalXP();
    return (xp / 100).floor() + 1;
  }

  // Modullar bo'yicha yulduzlar va progress
  int getModuleStars(String moduleId) {
    final key = 'module_stars_$moduleId';
    final initial = defaultModuleStars[moduleId] ?? 0;
    return _prefs.getInt(key) ?? initial;
  }

  int getModuleMaxStars(String moduleId) {
    return defaultModuleMaxStars[moduleId] ?? 20;
  }

  double getModuleProgress(String moduleId) {
    final stars = getModuleStars(moduleId);
    final maxStars = getModuleMaxStars(moduleId);
    if (maxStars <= 0) return 0.0;
    final ratio = stars / maxStars;
    return ratio.clamp(0.0, 1.0);
  }

  Future<int> addModuleStars(String moduleId, int count) async {
    final currentModuleStars = getModuleStars(moduleId);
    final updatedModuleStars = currentModuleStars + count;
    await _prefs.setInt('module_stars_$moduleId', updatedModuleStars);

    // Dynamic total stars and XP recalculation
    await addStars(count);
    await addXP(count * AppConstants.xpPerCorrectAnswer);
    return updatedModuleStars;
  }

  // Parent PIN Code
  String getParentPin() {
    return _prefs.getString(_keyParentPin) ?? '1234';
  }

  Future<bool> setParentPin(String newPin) async {
    return await _prefs.setString(_keyParentPin, newPin);
  }

  // Today, Weekly & Monthly Screen Time (Session Tracking 2.0)
  int getScreenTimeToday() {
    return _prefs.getInt(_keyScreenTimeMinutes) ?? 18;
  }

  int getScreenTimeWeekly() {
    return _prefs.getInt(_keyScreenTimeWeekly) ?? 120; // 2 hours
  }

  int getScreenTimeMonthly() {
    return _prefs.getInt(_keyScreenTimeMonthly) ?? 660; // 11 hours
  }

  Future<bool> addScreenTime(int minutes) async {
    final today = getScreenTimeToday() + minutes;
    final weekly = getScreenTimeWeekly() + minutes;
    final monthly = getScreenTimeMonthly() + minutes;

    await _prefs.setInt(_keyScreenTimeMinutes, today);
    await _prefs.setInt(_keyScreenTimeWeekly, weekly);
    return await _prefs.setInt(_keyScreenTimeMonthly, monthly);
  }

  // Learning History (Requirement 6)
  List<LearningHistoryItem> getLearningHistory() {
    final rawList = _prefs.getStringList(AppConstants.keyLearningHistory);
    if (rawList == null || rawList.isEmpty) {
      return [
        LearningHistoryItem(
          moduleId: 'alphabet',
          moduleTitle: 'Harflar',
          level: 1,
          isCompleted: true,
          scorePercentage: 100.0,
          starsEarned: 5,
          completionDate: DateTime.now().toIso8601String(),
        ),
        LearningHistoryItem(
          moduleId: 'math',
          moduleTitle: 'Matematika',
          level: 1,
          isCompleted: true,
          scorePercentage: 85.0,
          starsEarned: 4,
          completionDate: DateTime.now().toIso8601String(),
        ),
        LearningHistoryItem(
          moduleId: 'english',
          moduleTitle: 'Ingliz tili',
          level: 1,
          isCompleted: true,
          scorePercentage: 72.0,
          starsEarned: 3,
          completionDate: DateTime.now().toIso8601String(),
        ),
      ];
    }
    return rawList
        .map((e) => LearningHistoryItem.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<bool> addLearningHistory(LearningHistoryItem item) async {
    final history = getLearningHistory();
    history.add(item);
    final rawList = history.map((e) => jsonEncode(e.toJson())).toList();
    return await _prefs.setStringList(AppConstants.keyLearningHistory, rawList);
  }

  // Adaptive Difficulty State (Requirement 2)
  AdaptiveDifficultyState getAdaptiveState(String moduleId) {
    final raw = _prefs.getString('${AppConstants.keyAdaptiveState}_$moduleId');
    if (raw == null || raw.isEmpty) {
      return AdaptiveDifficultyState(moduleId: moduleId);
    }
    try {
      return AdaptiveDifficultyState.fromJson(jsonDecode(raw));
    } catch (_) {
      return AdaptiveDifficultyState(moduleId: moduleId);
    }
  }

  Future<bool> saveAdaptiveState(AdaptiveDifficultyState state) async {
    return await _prefs.setString(
      '${AppConstants.keyAdaptiveState}_${state.moduleId}',
      jsonEncode(state.toJson()),
    );
  }

  // Local Notification Settings (Requirement 8)
  NotificationSettingsModel getNotificationSettings() {
    final raw = _prefs.getString(AppConstants.keyParentNotificationSettings);
    if (raw == null || raw.isEmpty) {
      return const NotificationSettingsModel();
    }
    try {
      return NotificationSettingsModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return const NotificationSettingsModel();
    }
  }

  Future<bool> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    return await _prefs.setString(
      AppConstants.keyParentNotificationSettings,
      jsonEncode(settings.toJson()),
    );
  }

  // Accessibility Settings (Requirement 11)
  AccessibilitySettingsModel getAccessibilitySettings() {
    final raw = _prefs.getString(AppConstants.keyAccessibilitySettings);
    if (raw == null || raw.isEmpty) {
      return const AccessibilitySettingsModel();
    }
    try {
      return AccessibilitySettingsModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return const AccessibilitySettingsModel();
    }
  }

  Future<bool> saveAccessibilitySettings(
      AccessibilitySettingsModel settings) async {
    return await _prefs.setString(
      AppConstants.keyAccessibilitySettings,
      jsonEncode(settings.toJson()),
    );
  }

  // O'zlashtirish progressini saqlash
  Future<bool> saveProgress(Progress progress) async {
    final allProgress = getProgressList();
    final index = allProgress.indexWhere(
      (p) => p.subject == progress.subject && p.topicId == progress.topicId,
    );
    if (index >= 0) {
      allProgress[index] = progress;
    } else {
      allProgress.add(progress);
    }
    final rawList = allProgress.map((p) => p.toRawJson()).toList();
    return await _prefs.setStringList(_keyProgressList, rawList);
  }

  List<Progress> getProgressList() {
    final rawList = _prefs.getStringList(_keyProgressList);
    if (rawList == null) return [];
    return rawList.map((e) => Progress.fromRawJson(e)).toList();
  }

  // Barcha ma'lumotlarni tozalash
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
