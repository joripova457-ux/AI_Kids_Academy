/// Ota-ona Paneli 2.0 Analitika Modeli
class ParentAnalyticsModel {
  final int totalXP;
  final int totalStars;
  final int level;
  final int dailyStreak;
  final int weeklyTimeMinutes;
  final int monthlyTimeMinutes;
  final String bestSubject;
  final String challengingSubject;
  final String lastActiveDate;
  final int todayTimeMinutes;
  final int completedTasksCount;
  final Map<String, int> subjectProgressPercentage;

  const ParentAnalyticsModel({
    required this.totalXP,
    required this.totalStars,
    required this.level,
    required this.dailyStreak,
    required this.weeklyTimeMinutes,
    required this.monthlyTimeMinutes,
    required this.bestSubject,
    required this.challengingSubject,
    required this.lastActiveDate,
    required this.todayTimeMinutes,
    required this.completedTasksCount,
    required this.subjectProgressPercentage,
  });

  factory ParentAnalyticsModel.empty() {
    return ParentAnalyticsModel(
      totalXP: 0,
      totalStars: 0,
      level: 1,
      dailyStreak: 1,
      weeklyTimeMinutes: 0,
      monthlyTimeMinutes: 0,
      bestSubject: "O'zbek tili",
      challengingSubject: "Matematika",
      lastActiveDate: DateTime.now().toIso8601String().substring(0, 10),
      todayTimeMinutes: 0,
      completedTasksCount: 0,
      subjectProgressPercentage: const {
        'alphabet': 80,
        'math': 60,
        'english': 75,
        'uzbek': 90,
      },
    );
  }
}
