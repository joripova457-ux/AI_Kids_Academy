import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../data/models/accessibility_settings_model.dart';
import '../data/models/adaptive_difficulty_state.dart';
import '../data/models/learning_history_item.dart';
import '../data/models/module_progress.dart';
import '../data/models/notification_settings_model.dart';
import '../data/models/user_progress.dart';
import '../data/models/user_statistics.dart';
import '../models/child_profile.dart';
import '../models/progress.dart';

/// SharedPreferences orqali ma'lumotlarni saqlash va boshqarish xizmati (Stage 6 Upgrade)
class StorageService {
  static const String _keyActiveProfile = 'active_child_profile';
  static const String _keyProfilesList = 'child_profiles_list';
  static const String _keyProgressList = 'child_progress_list';
  static const String _keyUserProgress = 'user_progress_data';
  static const String _keyTotalXP = 'total_xp_earned';
  static const String _keyParentPin = 'parent_gate_pin';
  static const String _keyScreenTimeMinutes = 'screen_time_minutes_today';
  static const String _keyScreenTimeWeekly = 'screen_time_weekly';
  static const String _keyScreenTimeMonthly = 'screen_time_monthly';
  static const String _keyChatHistory = 'ai_chat_history_v2';
  static const String _keySavedDrawings = 'saved_drawings_list';

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
      throw Exception("StorageService hali ishga tushirilmadi. init() chaqirilishi kerak.");
    }
    return _instance!;
  }

  // Default module initial stars map
  static const Map<String, int> defaultModuleStars = {
    'alphabet': 15,
    'math': 12,
    'uzbek': 18,
    'english': 14,
    'ai_chat': 21,
    'ai_story': 15,
    'mini_games': 8,
    'drawing': 10,
  };

  // Default module max items map
  static const Map<String, int> defaultModuleTotalItems = {
    'alphabet': 20,
    'math': 30,
    'uzbek': 20,
    'english': 20,
    'ai_chat': 30,
    'ai_story': 30,
    'mini_games': 20,
    'drawing': 20,
  };

  // Faol profilni saqlash va olish
  Future<bool> saveActiveProfile(ChildProfile profile) async {
    try {
      return await _prefs.setString(_keyActiveProfile, profile.toRawJson());
    } catch (_) {
      return false;
    }
  }

  ChildProfile getActiveProfile() {
    final raw = _prefs.getString(_keyActiveProfile);
    if (raw == null || raw.isEmpty) {
      final defaultP = ChildProfile.defaultProfile();
      final calculatedStars = getTotalStars();
      return defaultP.copyWith(totalStars: calculatedStars, totalXP: getTotalXP());
    }
    try {
      final profile = ChildProfile.fromRawJson(raw);
      final calculatedStars = getTotalStars();
      return profile.copyWith(totalStars: calculatedStars, totalXP: getTotalXP());
    } catch (_) {
      return ChildProfile.defaultProfile();
    }
  }

  // Profillar ro'yxati
  Future<bool> saveProfiles(List<ChildProfile> profiles) async {
    try {
      final rawList = profiles.map((p) => p.toRawJson()).toList();
      return await _prefs.setStringList(_keyProfilesList, rawList);
    } catch (_) {
      return false;
    }
  }

  List<ChildProfile> getProfiles() {
    try {
      final rawList = _prefs.getStringList(_keyProfilesList);
      if (rawList == null) return [getActiveProfile()];
      return rawList.map((e) => ChildProfile.fromRawJson(e)).toList();
    } catch (_) {
      return [getActiveProfile()];
    }
  }

  // Modullar bo'yicha yulduzlar (Module Isolation)
  int getModuleStars(String moduleId) {
    try {
      final key = 'module_stars_$moduleId';
      final initial = defaultModuleStars[moduleId] ?? 0;
      return _prefs.getInt(key) ?? initial;
    } catch (_) {
      return defaultModuleStars[moduleId] ?? 0;
    }
  }

  Future<int> addModuleStars(String moduleId, int count) async {
    try {
      final currentModuleStars = getModuleStars(moduleId);
      final updatedModuleStars = currentModuleStars + count;
      await _prefs.setInt('module_stars_$moduleId', updatedModuleStars);

      // Modul progressini ham mos ravishda yangilash
      final modProgress = getModuleProgressModel(moduleId);
      final newCompleted = (modProgress.completedItems + 1).clamp(0, modProgress.totalItems);
      await updateModuleProgress(
        moduleId,
        completedItems: newCompleted,
        stars: updatedModuleStars,
      );

      // XP ni oshirish
      await addXP(count * AppConstants.xpPerCorrectAnswer);

      return updatedModuleStars;
    } catch (_) {
      return getModuleStars(moduleId);
    }
  }

  /// STAGE 6 FORMULA:
  /// TotalStars = Letters + Math + English + Uzbek + Story + Chat + Games + Drawing
  int getTotalStars() {
    try {
      final letters = getModuleStars('alphabet');
      final math = getModuleStars('math');
      final english = getModuleStars('english');
      final uzbek = getModuleStars('uzbek');
      final story = getModuleStars('ai_story');
      final chat = getModuleStars('ai_chat');
      final games = getModuleStars('mini_games');
      final drawing = getModuleStars('drawing');

      return letters + math + english + uzbek + story + chat + games + drawing;
    } catch (_) {
      return 102;
    }
  }

  int getTotalXP() {
    try {
      return _prefs.getInt(_keyTotalXP) ?? 150;
    } catch (_) {
      return 150;
    }
  }

  Future<int> addXP(int count) async {
    try {
      final current = getTotalXP();
      final updated = current + count;
      await _prefs.setInt(_keyTotalXP, updated);

      final profile = getActiveProfile();
      final newLevel = (updated / 100).floor() + 1;
      await saveActiveProfile(profile.copyWith(
        totalXP: updated,
        totalStars: getTotalStars(),
        level: newLevel,
      ));
      return updated;
    } catch (_) {
      return getTotalXP();
    }
  }

  int getUserLevel() {
    final xp = getTotalXP();
    return (xp / 100).floor() + 1;
  }

  // Modullar bo'yicha progress (UserProgress & ModuleProgress)
  UserProgress getUserProgress() {
    try {
      final raw = _prefs.getString(_keyUserProgress);
      if (raw == null || raw.isEmpty) {
        return UserProgress.initial();
      }
      return UserProgress.fromRawJson(raw);
    } catch (_) {
      return UserProgress.initial();
    }
  }

  Future<bool> saveUserProgress(UserProgress progress) async {
    try {
      return await _prefs.setString(_keyUserProgress, progress.toRawJson());
    } catch (_) {
      return false;
    }
  }

  ModuleProgress getModuleProgressModel(String moduleId) {
    try {
      final userProgress = getUserProgress();
      final defaultTotal = defaultModuleTotalItems[moduleId] ?? 20;
      final defaultStars = defaultModuleStars[moduleId] ?? 0;
      return userProgress.getModuleProgress(
        moduleId,
        defaultTotal: defaultTotal,
        defaultStars: defaultStars,
      );
    } catch (_) {
      return ModuleProgress(
        moduleId: moduleId,
        completedItems: 10,
        totalItems: defaultModuleTotalItems[moduleId] ?? 20,
        stars: getModuleStars(moduleId),
        lastUpdated: DateTime.now().toIso8601String(),
      );
    }
  }

  double getModuleProgress(String moduleId) {
    try {
      final model = getModuleProgressModel(moduleId);
      return model.ratio;
    } catch (_) {
      return 0.5;
    }
  }

  Future<bool> updateModuleProgress(
    String moduleId, {
    int? completedItems,
    int? totalItems,
    int? stars,
  }) async {
    try {
      final userProgress = getUserProgress();
      final current = getModuleProgressModel(moduleId);

      final updated = current.copyWith(
        completedItems: completedItems ?? current.completedItems,
        totalItems: totalItems ?? current.totalItems,
        stars: stars ?? current.stars,
        lastUpdated: DateTime.now().toIso8601String(),
      );

      final newUserProgress = userProgress.updateModule(updated);
      return await saveUserProgress(newUserProgress);
    } catch (_) {
      return false;
    }
  }

  // Parent PIN Code
  String getParentPin() {
    try {
      return _prefs.getString(_keyParentPin) ?? '1234';
    } catch (_) {
      return '1234';
    }
  }

  Future<bool> setParentPin(String newPin) async {
    try {
      return await _prefs.setString(_keyParentPin, newPin);
    } catch (_) {
      return false;
    }
  }

  // Today, Weekly & Monthly Screen Time
  int getScreenTimeToday() {
    try {
      return _prefs.getInt(_keyScreenTimeMinutes) ?? 18;
    } catch (_) {
      return 18;
    }
  }

  int getScreenTimeWeekly() {
    try {
      return _prefs.getInt(_keyScreenTimeWeekly) ?? 120;
    } catch (_) {
      return 120;
    }
  }

  int getScreenTimeMonthly() {
    try {
      return _prefs.getInt(_keyScreenTimeMonthly) ?? 660;
    } catch (_) {
      return 660;
    }
  }

  Future<bool> addScreenTime(int minutes) async {
    try {
      final today = getScreenTimeToday() + minutes;
      final weekly = getScreenTimeWeekly() + minutes;
      final monthly = getScreenTimeMonthly() + minutes;

      await _prefs.setInt(_keyScreenTimeMinutes, today);
      await _prefs.setInt(_keyScreenTimeWeekly, weekly);
      return await _prefs.setInt(_keyScreenTimeMonthly, monthly);
    } catch (_) {
      return false;
    }
  }

  // Learning History
  List<LearningHistoryItem> getLearningHistory() {
    try {
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
    } catch (_) {
      return [];
    }
  }

  Future<bool> addLearningHistory(LearningHistoryItem item) async {
    try {
      final history = getLearningHistory();
      history.add(item);
      final rawList = history.map((e) => jsonEncode(e.toJson())).toList();
      return await _prefs.setStringList(AppConstants.keyLearningHistory, rawList);
    } catch (_) {
      return false;
    }
  }

  // Adaptive Difficulty State
  AdaptiveDifficultyState getAdaptiveState(String moduleId) {
    try {
      final raw = _prefs.getString('${AppConstants.keyAdaptiveState}_$moduleId');
      if (raw == null || raw.isEmpty) {
        return AdaptiveDifficultyState(moduleId: moduleId);
      }
      return AdaptiveDifficultyState.fromJson(jsonDecode(raw));
    } catch (_) {
      return AdaptiveDifficultyState(moduleId: moduleId);
    }
  }

  Future<bool> saveAdaptiveState(AdaptiveDifficultyState state) async {
    try {
      return await _prefs.setString(
        '${AppConstants.keyAdaptiveState}_${state.moduleId}',
        jsonEncode(state.toJson()),
      );
    } catch (_) {
      return false;
    }
  }

  // Notification Settings
  NotificationSettingsModel getNotificationSettings() {
    try {
      final raw = _prefs.getString(AppConstants.keyParentNotificationSettings);
      if (raw == null || raw.isEmpty) {
        return const NotificationSettingsModel();
      }
      return NotificationSettingsModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return const NotificationSettingsModel();
    }
  }

  Future<bool> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    try {
      return await _prefs.setString(
        AppConstants.keyParentNotificationSettings,
        jsonEncode(settings.toJson()),
      );
    } catch (_) {
      return false;
    }
  }

  // Accessibility Settings
  AccessibilitySettingsModel getAccessibilitySettings() {
    try {
      final raw = _prefs.getString(AppConstants.keyAccessibilitySettings);
      if (raw == null || raw.isEmpty) {
        return const AccessibilitySettingsModel();
      }
      return AccessibilitySettingsModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return const AccessibilitySettingsModel();
    }
  }

  Future<bool> saveAccessibilitySettings(
      AccessibilitySettingsModel settings) async {
    try {
      return await _prefs.setString(
        AppConstants.keyAccessibilitySettings,
        jsonEncode(settings.toJson()),
      );
    } catch (_) {
      return false;
    }
  }

  // AI Chat History Persistence
  List<Map<String, String>> getChatHistory() {
    try {
      final rawList = _prefs.getStringList(_keyChatHistory);
      if (rawList == null || rawList.isEmpty) {
        return [
          {
            "sender": "ai",
            "text": "Salom! Men Bolajon AI yordamchingizman. Bugun nimani o'rganamiz? 🚀✨",
            "time": "Hozir"
          }
        ];
      }
      return rawList
          .map((item) => Map<String, String>.from(jsonDecode(item)))
          .toList();
    } catch (_) {
      return [
        {
          "sender": "ai",
          "text": "Salom! Men Bolajon AI yordamchingizman. Bugun nimani o'rganamiz? 🚀✨",
          "time": "Hozir"
        }
      ];
    }
  }

  Future<bool> saveChatHistory(List<Map<String, String>> history) async {
    try {
      final rawList = history.map((e) => jsonEncode(e)).toList();
      return await _prefs.setStringList(_keyChatHistory, rawList);
    } catch (_) {
      return false;
    }
  }

  // Drawing Canvas Saved Data
  List<String> getSavedDrawings() {
    try {
      return _prefs.getStringList(_keySavedDrawings) ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveDrawingData(String drawingJson) async {
    try {
      final drawings = getSavedDrawings();
      drawings.add(drawingJson);
      return await _prefs.setStringList(_keySavedDrawings, drawings);
    } catch (_) {
      return false;
    }
  }

  // O'zlashtirish progressini saqlash (Legacy support)
  Future<bool> saveProgress(Progress progress) async {
    try {
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
    } catch (_) {
      return false;
    }
  }

  List<Progress> getProgressList() {
    try {
      final rawList = _prefs.getStringList(_keyProgressList);
      if (rawList == null) return [];
      return rawList.map((e) => Progress.fromRawJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // Real Ota-ona paneli statistikalarini hisoblash
  UserStatistics getUserStatistics() {
    try {
      final totalStars = getTotalStars();
      final totalXP = getTotalXP();
      final profile = getActiveProfile();
      final todayTime = getScreenTimeToday();
      final weeklyTime = getScreenTimeWeekly();
      final monthlyTime = getScreenTimeMonthly();

      int totalCompletedLessons = 0;
      final userProgress = getUserProgress();
      userProgress.modules.forEach((key, value) {
        totalCompletedLessons += value.completedItems;
      });

      return UserStatistics(
        totalXP: totalXP,
        totalStars: totalStars,
        dailyStreak: profile.dailyStreak,
        completedLessons: totalCompletedLessons > 0 ? totalCompletedLessons : 45,
        todayTimeMinutes: todayTime,
        weeklyTimeMinutes: weeklyTime,
        monthlyTimeMinutes: monthlyTime,
        weeklyProgress: [15, 25, 10, 30, 20, 45, todayTime.toDouble()],
      );
    } catch (_) {
      return const UserStatistics();
    }
  }

  static const String _keyCustomGeminiApiKey = 'custom_gemini_api_key_v1';

  String getCustomGeminiApiKey() {
    return _prefs.getString(_keyCustomGeminiApiKey) ?? '';
  }

  Future<bool> saveCustomGeminiApiKey(String key) async {
    return await _prefs.setString(_keyCustomGeminiApiKey, key.trim());
  }

  // ==================== 7-BOSQICH DAILY API REQUEST LIMITS ====================
  static const String _keyDailyApiDate = 'daily_api_date';
  static const String _keyDailyChatRequests = 'daily_chat_requests_count';
  static const String _keyDailyStoryRequests = 'daily_story_requests_count';

  void _checkAndResetDailyApiLimits() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = _prefs.getString(_keyDailyApiDate) ?? '';
    if (savedDate != today) {
      _prefs.setString(_keyDailyApiDate, today);
      _prefs.setInt(_keyDailyChatRequests, 0);
      _prefs.setInt(_keyDailyStoryRequests, 0);
    }
  }

  int getDailyChatRequestCount() {
    _checkAndResetDailyApiLimits();
    return _prefs.getInt(_keyDailyChatRequests) ?? 0;
  }

  Future<int> incrementDailyChatRequestCount() async {
    _checkAndResetDailyApiLimits();
    final count = getDailyChatRequestCount() + 1;
    await _prefs.setInt(_keyDailyChatRequests, count);
    return count;
  }

  int getDailyStoryRequestCount() {
    _checkAndResetDailyApiLimits();
    return _prefs.getInt(_keyDailyStoryRequests) ?? 0;
  }

  Future<int> incrementDailyStoryRequestCount() async {
    _checkAndResetDailyApiLimits();
    final count = getDailyStoryRequestCount() + 1;
    await _prefs.setInt(_keyDailyStoryRequests, count);
    return count;
  }

  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (_) {
      return false;
    }
  }
}

