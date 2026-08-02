/// Ta'lim Tarixi Modeli (Learning History Item)
class LearningHistoryItem {
  final String moduleId;
  final String moduleTitle;
  final int level;
  final bool isCompleted;
  final double scorePercentage;
  final int starsEarned;
  final String completionDate; // ISO format

  const LearningHistoryItem({
    required this.moduleId,
    required this.moduleTitle,
    required this.level,
    required this.isCompleted,
    required this.scorePercentage,
    required this.starsEarned,
    required this.completionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'moduleTitle': moduleTitle,
      'level': level,
      'isCompleted': isCompleted,
      'scorePercentage': scorePercentage,
      'starsEarned': starsEarned,
      'completionDate': completionDate,
    };
  }

  factory LearningHistoryItem.fromJson(Map<String, dynamic> json) {
    return LearningHistoryItem(
      moduleId: json['moduleId'] as String? ?? 'general',
      moduleTitle: json['moduleTitle'] as String? ?? 'Dars',
      level: json['level'] as int? ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble() ?? 0.0,
      starsEarned: json['starsEarned'] as int? ?? 0,
      completionDate: json['completionDate'] as String? ??
          DateTime.now().toIso8601String(),
    );
  }
}
