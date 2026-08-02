import 'dart:convert';

/// Modul statistikasi modeli (Stage 6)
class ModuleStatistics {
  final String moduleId;
  final double scorePercentage;
  final int totalAttempts;
  final int correctAnswers;
  final int timeSpentMinutes;

  const ModuleStatistics({
    required this.moduleId,
    this.scorePercentage = 0.0,
    this.totalAttempts = 0,
    this.correctAnswers = 0,
    this.timeSpentMinutes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'scorePercentage': scorePercentage,
      'totalAttempts': totalAttempts,
      'correctAnswers': correctAnswers,
      'timeSpentMinutes': timeSpentMinutes,
    };
  }

  factory ModuleStatistics.fromJson(Map<String, dynamic> json) {
    return ModuleStatistics(
      moduleId: json['moduleId'] as String? ?? '',
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble() ?? 0.0,
      totalAttempts: json['totalAttempts'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      timeSpentMinutes: json['timeSpentMinutes'] as int? ?? 0,
    );
  }

  String toRawJson() => jsonEncode(toJson());

  factory ModuleStatistics.fromRawJson(String str) =>
      ModuleStatistics.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
