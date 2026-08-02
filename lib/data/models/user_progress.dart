import 'dart:convert';
import 'module_progress.dart';

/// Foydalanuvchi barcha modullari progress agregatori (Stage 6)
class UserProgress {
  final Map<String, ModuleProgress> modules;

  const UserProgress({
    required this.modules,
  });

  factory UserProgress.initial() {
    final now = DateTime.now().toIso8601String();
    return UserProgress(
      modules: {
        'alphabet': ModuleProgress(moduleId: 'alphabet', completedItems: 16, totalItems: 20, stars: 15, lastUpdated: now),
        'math': ModuleProgress(moduleId: 'math', completedItems: 12, totalItems: 30, stars: 12, lastUpdated: now),
        'uzbek': ModuleProgress(moduleId: 'uzbek', completedItems: 18, totalItems: 20, stars: 18, lastUpdated: now),
        'english': ModuleProgress(moduleId: 'english', completedItems: 14, totalItems: 20, stars: 14, lastUpdated: now),
        'ai_chat': ModuleProgress(moduleId: 'ai_chat', completedItems: 21, totalItems: 30, stars: 21, lastUpdated: now),
        'ai_story': ModuleProgress(moduleId: 'ai_story', completedItems: 15, totalItems: 30, stars: 15, lastUpdated: now),
        'mini_games': ModuleProgress(moduleId: 'mini_games', completedItems: 8, totalItems: 20, stars: 8, lastUpdated: now),
        'drawing': ModuleProgress(moduleId: 'drawing', completedItems: 10, totalItems: 20, stars: 10, lastUpdated: now),
      },
    );
  }

  ModuleProgress getModuleProgress(String moduleId, {int defaultTotal = 20, int defaultStars = 0}) {
    return modules[moduleId] ??
        ModuleProgress(
          moduleId: moduleId,
          completedItems: 0,
          totalItems: defaultTotal,
          stars: defaultStars,
          lastUpdated: DateTime.now().toIso8601String(),
        );
  }

  int get calculateTotalStars {
    int total = 0;
    for (final mp in modules.values) {
      total += mp.stars;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    modules.forEach((key, val) {
      map[key] = val.toJson();
    });
    return map;
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final modulesMap = <String, ModuleProgress>{};
    json.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        modulesMap[key] = ModuleProgress.fromJson(val);
      }
    });
    return UserProgress(modules: modulesMap);
  }

  String toRawJson() => jsonEncode(toJson());

  factory UserProgress.fromRawJson(String str) =>
      UserProgress.fromJson(jsonDecode(str) as Map<String, dynamic>);

  UserProgress updateModule(ModuleProgress progress) {
    final updated = Map<String, ModuleProgress>.from(modules);
    updated[progress.moduleId] = progress;
    return UserProgress(modules: updated);
  }
}
