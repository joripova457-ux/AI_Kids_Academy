import 'dart:convert';

/// Bola Profili Modeli (v2 — Enhanced Gamification & Analytics)
class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarAsset;
  final String pin;
  final DateTime createdAt;
  final int totalXP;
  final int totalStars;
  final int level;
  final int dailyStreak;
  final String lastActiveDate; // ISO string format: YYYY-MM-DD
  final int completedTasksCount;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarAsset,
    this.pin = '0000',
    DateTime? createdAt,
    this.totalXP = 0,
    this.totalStars = 0,
    this.level = 1,
    this.dailyStreak = 1,
    String? lastActiveDate,
    this.completedTasksCount = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastActiveDate = lastActiveDate ??
            DateTime.now().toIso8601String().substring(0, 10);

  /// Backward compatibility getter
  String get avatar => avatarAsset;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'avatarAsset': avatarAsset,
      'pin': pin,
      'createdAt': createdAt.toIso8601String(),
      'totalXP': totalXP,
      'totalStars': totalStars,
      'level': level,
      'dailyStreak': dailyStreak,
      'lastActiveDate': lastActiveDate,
      'completedTasksCount': completedTasksCount,
    };
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] as String? ?? 'default_child',
      name: json['name'] as String? ?? 'Islomjon',
      age: json['age'] as int? ?? 6,
      avatarAsset: (json['avatarAsset'] ?? json['avatar']) as String? ??
          'assets/images/mascot.png',
      pin: json['pin'] as String? ?? '0000',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      totalXP: json['totalXP'] as int? ?? 0,
      totalStars: json['totalStars'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      dailyStreak: json['dailyStreak'] as int? ?? 1,
      lastActiveDate: json['lastActiveDate'] as String? ??
          DateTime.now().toIso8601String().substring(0, 10),
      completedTasksCount: json['completedTasksCount'] as int? ?? 0,
    );
  }

  String toRawJson() => jsonEncode(toJson());

  factory ChildProfile.fromRawJson(String str) =>
      ChildProfile.fromJson(jsonDecode(str) as Map<String, dynamic>);

  ChildProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? avatarAsset,
    String? pin,
    DateTime? createdAt,
    int? totalXP,
    int? totalStars,
    int? level,
    int? dailyStreak,
    String? lastActiveDate,
    int? completedTasksCount,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
      totalXP: totalXP ?? this.totalXP,
      totalStars: totalStars ?? this.totalStars,
      level: level ?? this.level,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
    );
  }

  static ChildProfile defaultProfile() {
    return ChildProfile(
      id: 'child_1',
      name: 'Islomjon',
      age: 6,
      avatarAsset: 'assets/images/mascot.png',
      pin: '0000',
      totalXP: 120,
      totalStars: 15,
      level: 2,
      dailyStreak: 3,
      lastActiveDate: DateTime.now().toIso8601String().substring(0, 10),
      completedTasksCount: 12,
    );
  }
}
