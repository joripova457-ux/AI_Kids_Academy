/// Smart Recommendation Engine Modeli
class RecommendationModel {
  final String title;
  final String message;
  final String suggestedModuleId;
  final String iconEmoji;
  final int priority; // 1 (Past) -> 5 (Yuqori)

  const RecommendationModel({
    required this.title,
    required this.message,
    required this.suggestedModuleId,
    required this.iconEmoji,
    this.priority = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'suggestedModuleId': suggestedModuleId,
      'iconEmoji': iconEmoji,
      'priority': priority,
    };
  }

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      title: json['title'] as String? ?? "AI Tavsiyasi",
      message: json['message'] as String? ?? "Bugun darslarni boshlaymiz!",
      suggestedModuleId: json['suggestedModuleId'] as String? ?? 'alphabet',
      iconEmoji: json['iconEmoji'] as String? ?? '🤖',
      priority: json['priority'] as int? ?? 3,
    );
  }
}
