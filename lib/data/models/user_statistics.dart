import 'dart:convert';
import 'module_statistics.dart';

/// Umumiy foydalanuvchi va Ota-ona Paneli statistikasi modeli (Stage 6)
class UserStatistics {
  final int totalXP;
  final int totalStars;
  final int dailyStreak;
  final int completedLessons;
  final int todayTimeMinutes;
  final int weeklyTimeMinutes;
  final int monthlyTimeMinutes;
  final List<double> weeklyProgress;
  final Map<String, ModuleStatistics> moduleStats;

  const UserStatistics({
    this.totalXP = 150,
    this.totalStars = 102,
    this.dailyStreak = 3,
    this.completedLessons = 45,
    this.todayTimeMinutes = 18,
    this.weeklyTimeMinutes = 120,
    this.monthlyTimeMinutes = 660,
    this.weeklyProgress = const [15, 25, 10, 30, 20, 45, 18],
    this.moduleStats = const {},
  });

  Map<String, dynamic> toJson() {
    final modStatsJson = <String, dynamic>{};
    moduleStats.forEach((key, value) {
      modStatsJson[key] = value.toJson();
    });

    return {
      'totalXP': totalXP,
      'totalStars': totalStars,
      'dailyStreak': dailyStreak,
      'completedLessons': completedLessons,
      'todayTimeMinutes': todayTimeMinutes,
      'weeklyTimeMinutes': weeklyTimeMinutes,
      'monthlyTimeMinutes': monthlyTimeMinutes,
      'weeklyProgress': weeklyProgress,
      'moduleStats': modStatsJson,
    };
  }

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    final modMap = <String, ModuleStatistics>{};
    final rawModStats = json['moduleStats'] as Map<String, dynamic>?;
    if (rawModStats != null) {
      rawModStats.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          modMap[k] = ModuleStatistics.fromJson(v);
        }
      });
    }

    return UserStatistics(
      totalXP: json['totalXP'] as int? ?? 150,
      totalStars: json['totalStars'] as int? ?? 102,
      dailyStreak: json['dailyStreak'] as int? ?? 3,
      completedLessons: json['completedLessons'] as int? ?? 45,
      todayTimeMinutes: json['todayTimeMinutes'] as int? ?? 18,
      weeklyTimeMinutes: json['weeklyTimeMinutes'] as int? ?? 120,
      monthlyTimeMinutes: json['monthlyTimeMinutes'] as int? ?? 660,
      weeklyProgress: (json['weeklyProgress'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [15, 25, 10, 30, 20, 45, 18],
      moduleStats: modMap,
    );
  }

  String toRawJson() => jsonEncode(toJson());

  factory UserStatistics.fromRawJson(String str) =>
      UserStatistics.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
