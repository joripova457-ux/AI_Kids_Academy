import 'dart:convert';

/// Learning Progress Data Model per subject & topic
class Progress {
  final String subject;
  final String topicId;
  final bool completed;
  final int stars;
  final int attempts;
  final DateTime lastAttempt;

  const Progress({
    required this.subject,
    required this.topicId,
    required this.completed,
    required this.stars,
    required this.attempts,
    required this.lastAttempt,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'topicId': topicId,
      'completed': completed,
      'stars': stars,
      'attempts': attempts,
      'lastAttempt': lastAttempt.toIso8601String(),
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      subject: json['subject'] as String,
      topicId: json['topicId'] as String,
      completed: json['completed'] as bool? ?? false,
      stars: json['stars'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      lastAttempt: DateTime.parse(json['lastAttempt'] as String),
    );
  }

  String toRawJson() => jsonEncode(toJson());

  factory Progress.fromRawJson(String str) =>
      Progress.fromJson(jsonDecode(str) as Map<String, dynamic>);

  Progress copyWith({
    String? subject,
    String? topicId,
    bool? completed,
    int? stars,
    int? attempts,
    DateTime? lastAttempt,
  }) {
    return Progress(
      subject: subject ?? this.subject,
      topicId: topicId ?? this.topicId,
      completed: completed ?? this.completed,
      stars: stars ?? this.stars,
      attempts: attempts ?? this.attempts,
      lastAttempt: lastAttempt ?? this.lastAttempt,
    );
  }
}
