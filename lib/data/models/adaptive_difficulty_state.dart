/// Adaptiv Ta'lim Qiyinchilik Holati Modeli (Adaptive Learning System)
class AdaptiveDifficultyState {
  final String moduleId;
  final String currentDifficulty; // 'easy', 'medium', 'hard'
  final List<bool> recentAnswers; // Oxirgi 20 ta javob: true (to'g'ri), false (xato)
  final int totalCorrect;
  final int totalWrong;

  const AdaptiveDifficultyState({
    required this.moduleId,
    this.currentDifficulty = 'easy',
    this.recentAnswers = const [],
    this.totalCorrect = 0,
    this.totalWrong = 0,
  });

  /// Aniq aniqlik (accuracy) nisbatini hisoblash
  double get accuracyRate {
    if (recentAnswers.isEmpty) return 0.5;
    final correctCount = recentAnswers.where((a) => a).length;
    return correctCount / recentAnswers.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'currentDifficulty': currentDifficulty,
      'recentAnswers': recentAnswers,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
    };
  }

  factory AdaptiveDifficultyState.fromJson(Map<String, dynamic> json) {
    return AdaptiveDifficultyState(
      moduleId: json['moduleId'] as String? ?? 'general',
      currentDifficulty: json['currentDifficulty'] as String? ?? 'easy',
      recentAnswers: (json['recentAnswers'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          [],
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      totalWrong: json['totalWrong'] as int? ?? 0,
    );
  }

  AdaptiveDifficultyState copyWith({
    String? moduleId,
    String? currentDifficulty,
    List<bool>? recentAnswers,
    int? totalCorrect,
    int? totalWrong,
  }) {
    return AdaptiveDifficultyState(
      moduleId: moduleId ?? this.moduleId,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      recentAnswers: recentAnswers ?? this.recentAnswers,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
    );
  }
}
