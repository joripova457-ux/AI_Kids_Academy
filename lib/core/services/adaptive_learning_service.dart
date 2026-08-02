import '../../data/models/adaptive_difficulty_state.dart';
import '../../services/storage_service.dart';

/// Adaptive Learning System (2-Talab)
/// Oxirgi 20 ta urinish va aniqlik natijalarini kuzatib boradi
/// va qiyinchilik darajasini moslashtiradi (Difficulty Scaling).
class AdaptiveLearningService {
  static final AdaptiveLearningService _instance =
      AdaptiveLearningService._internal();
  factory AdaptiveLearningService() => _instance;
  AdaptiveLearningService._internal();

  /// Urinish natijasini qayd etish (isCorrect: true/false)
  Future<AdaptiveDifficultyState> recordAttempt({
    required String moduleId,
    required bool isCorrect,
  }) async {
    final storage = StorageService.instance;
    final currentState = storage.getAdaptiveState(moduleId);

    final updatedRecent = List<bool>.from(currentState.recentAnswers);
    updatedRecent.add(isCorrect);

    // Maksimal 20 ta urinishni saqlaymiz
    if (updatedRecent.length > 20) {
      updatedRecent.removeAt(0);
    }

    final totalCorrect =
        currentState.totalCorrect + (isCorrect ? 1 : 0);
    final totalWrong =
        currentState.totalWrong + (isCorrect ? 0 : 1);

    // Qiyinchilik darajasini avtomatik oshirish yoki kamaytirish
    String newDifficulty = currentState.currentDifficulty;
    if (updatedRecent.length >= 5) {
      final correctCount = updatedRecent.where((a) => a).length;
      final accuracyRatio = correctCount / updatedRecent.length;

      // 90% dan yuqori (masalan 18/20) -> qiyinroq
      if (accuracyRatio >= 0.9) {
        if (newDifficulty == 'easy') {
          newDifficulty = 'medium';
        } else if (newDifficulty == 'medium') {
          newDifficulty = 'hard';
        }
      }
      // 40% dan past (masalan 8/20) -> osongina
      else if (accuracyRatio <= 0.4) {
        if (newDifficulty == 'hard') {
          newDifficulty = 'medium';
        } else if (newDifficulty == 'medium') {
          newDifficulty = 'easy';
        }
      }
    }

    final newState = currentState.copyWith(
      recentAnswers: updatedRecent,
      currentDifficulty: newDifficulty,
      totalCorrect: totalCorrect,
      totalWrong: totalWrong,
    );

    await storage.saveAdaptiveState(newState);
    return newState;
  }

  /// Modulning joriy qiyinchilik darajasini olish
  String getDifficulty(String moduleId) {
    return StorageService.instance.getAdaptiveState(moduleId).currentDifficulty;
  }
}
