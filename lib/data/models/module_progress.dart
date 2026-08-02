import 'dart:convert';

/// Modul o'zlashtirish progress modeli (Stage 6)
class ModuleProgress {
  final String moduleId;
  final int completedItems;
  final int totalItems;
  final int stars;
  final int level;
  final String lastUpdated;

  const ModuleProgress({
    required this.moduleId,
    this.completedItems = 0,
    this.totalItems = 20,
    this.stars = 0,
    this.level = 1,
    required this.lastUpdated,
  });

  double get ratio {
    if (totalItems <= 0) return 0.0;
    return (completedItems / totalItems).clamp(0.0, 1.0);
  }

  int get percentage => (ratio * 100).round();

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'completedItems': completedItems,
      'totalItems': totalItems,
      'stars': stars,
      'level': level,
      'lastUpdated': lastUpdated,
    };
  }

  factory ModuleProgress.fromJson(Map<String, dynamic> json) {
    return ModuleProgress(
      moduleId: json['moduleId'] as String? ?? '',
      completedItems: json['completedItems'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 20,
      stars: json['stars'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      lastUpdated: json['lastUpdated'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  String toRawJson() => jsonEncode(toJson());

  factory ModuleProgress.fromRawJson(String str) =>
      ModuleProgress.fromJson(jsonDecode(str) as Map<String, dynamic>);

  ModuleProgress copyWith({
    String? moduleId,
    int? completedItems,
    int? totalItems,
    int? stars,
    int? level,
    String? lastUpdated,
  }) {
    return ModuleProgress(
      moduleId: moduleId ?? this.moduleId,
      completedItems: completedItems ?? this.completedItems,
      totalItems: totalItems ?? this.totalItems,
      stars: stars ?? this.stars,
      level: level ?? this.level,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
