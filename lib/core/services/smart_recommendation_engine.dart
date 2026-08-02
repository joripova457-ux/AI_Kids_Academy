import '../../data/models/recommendation_model.dart';
import '../../services/storage_service.dart';

/// Smart Recommendation Engine (3-Talab)
/// Foydalanuvchining progress va statistikasini tahlil qilib
/// moslashtirilgan AI tavsiyalarini chiqaradi.
class SmartRecommendationEngine {
  static final SmartRecommendationEngine _instance =
      SmartRecommendationEngine._internal();
  factory SmartRecommendationEngine() => _instance;
  SmartRecommendationEngine._internal();

  /// Hozirgi statistika asosida eng yaxshi tavsiyani olish
  RecommendationModel getTopRecommendation() {
    final storage = StorageService.instance;
    final mathProgress = storage.getModuleProgress('math');
    final englishProgress = storage.getModuleProgress('english');
    final alphabetProgress = storage.getModuleProgress('alphabet');
    final uzbekProgress = storage.getModuleProgress('uzbek');

    // 1. Agar Matematikadan progress nisbatan past bo'lsa
    if (mathProgress < 0.5 && mathProgress <= englishProgress) {
      return const RecommendationModel(
        title: "Matematikani rivojlantiramiz! 🔢",
        message:
            "Matematikada biroz qiynalayapsan. Bugun sonlar va misollarni davom ettiraylik!",
        suggestedModuleId: 'math',
        iconEmoji: '🤖',
        priority: 5,
      );
    }

    // 2. Agar Ingliz tilidan progress nisbatan past bo'lsa
    if (englishProgress < 0.5 && englishProgress <= alphabetProgress) {
      return const RecommendationModel(
        title: "Ingliz tili darsi! 🇬🇧",
        message:
            "Bugun Ingliz tili bilan shug'ullanishni va yangi so'zlarni yodlashni tavsiya qilaman.",
        suggestedModuleId: 'english',
        iconEmoji: '⭐️',
        priority: 4,
      );
    }

    // 3. Agar Harflar tugallanmagan bo'lsa
    if (alphabetProgress < 0.7) {
      return const RecommendationModel(
        title: "Harflar Sehrli Dunyosi 🔤",
        message:
            "Alifbo harflarini to'liq o'rganib chiqaylik! Har bir harf yangi do'stdir.",
        suggestedModuleId: 'alphabet',
        iconEmoji: '🚀',
        priority: 3,
      );
    }

    // 4. Agar O'zbek tili progressi pastroq bo'lsa
    if (uzbekProgress < 0.8) {
      return const RecommendationModel(
        title: "O'zbek tili so'z boyligi 🇺🇿",
        message:
            "Ona tilimizdagi yangi so'zlar va iboralarni o'rganishni davom ettiramiz!",
        suggestedModuleId: 'uzbek',
        iconEmoji: '📚',
        priority: 2,
      );
    }

    // 5. Default quvnoq AI tavsiyasi
    return const RecommendationModel(
      title: "Ajoyib Natijalar! 🌟",
      message:
          "Bugun mini-o'yinlar va rasm chizish bilan ijodiy bilimingni oshir!",
      suggestedModuleId: 'mini_games',
      iconEmoji: '🎉',
      priority: 1,
    );
  }
}
