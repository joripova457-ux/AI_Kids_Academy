import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LevelItemData {
  final int levelNumber;
  final String title;
  final String description;
  final int requiredStars;
  final bool isUnlocked;
  final bool isCompleted;
  final int starsEarned;

  const LevelItemData({
    required this.levelNumber,
    required this.title,
    required this.description,
    this.requiredStars = 0,
    this.isUnlocked = true,
    this.isCompleted = false,
    this.starsEarned = 0,
  });
}

/// Bolalar uchun darajalar yo'lagi (Level Map / Roadmap)
class LevelMapWidget extends StatelessWidget {
  final List<LevelItemData> levels;
  final Function(LevelItemData level) onLevelSelect;

  const LevelMapWidget({
    super.key,
    required this.levels,
    required this.onLevelSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final item = levels[index];
        final isEven = index % 2 == 0;

        return Column(
          children: [
            Align(
              alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: item.isUnlocked ? () => onLevelSelect(item) : null,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: item.isUnlocked ? Colors.white : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: item.isCompleted
                            ? AppColors.softTeal
                            : (item.isUnlocked
                                ? AppColors.primaryViolet
                                : Colors.grey.shade300),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: item.isUnlocked
                              ? AppColors.primaryViolet.withValues(alpha: 0.12)
                              : Colors.transparent,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Level number circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: item.isUnlocked
                                ? (item.isCompleted
                                    ? const LinearGradient(colors: [
                                        AppColors.softTeal,
                                        Color(0xFF20B2AA)
                                      ])
                                    : AppColors.primaryGradient)
                                : null,
                            color: item.isUnlocked ? null : Colors.grey.shade400,
                          ),
                          child: Center(
                            child: item.isUnlocked
                                ? Text(
                                    "${item.levelNumber}",
                                    style: AppTextStyles.headingSmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  )
                                : const Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyles.headingSmall.copyWith(
                                  fontSize: 16,
                                  color: item.isUnlocked
                                      ? AppColors.textDark
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(3, (starIndex) {
                                  return Icon(
                                    starIndex < item.starsEarned
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: starIndex < item.starsEarned
                                        ? AppColors.brightYellow
                                        : Colors.grey.shade300,
                                    size: 18,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        if (item.isUnlocked)
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: item.isCompleted
                                ? AppColors.softTeal
                                : AppColors.primaryViolet,
                            size: 32,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (index < levels.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.primaryViolet.withValues(alpha: 0.4),
                  size: 24,
                ),
              ),
          ],
        );
      },
    );
  }
}
