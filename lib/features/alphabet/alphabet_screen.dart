import 'package:flutter/material.dart';
import '../../core/services/adaptive_learning_service.dart';
import '../../core/services/ai_tutor_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../data/models/learning_history_item.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';
import '../../shared/animations/confetti_overlay_widget.dart';
import '../../shared/widgets/ai_tutor_bubble_widget.dart';

/// Harflarni o'rganish bo'limi sahifasi (Alphabet Screen — Stage 6 Fix)
class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final Map<String, List<Map<String, String>>> _letterWords = const {
    'A': [
      {'word': 'Anor 🍎', 'meaning': 'Maza tola shirin meva'},
      {'word': 'Ayiq 🐻', 'meaning': 'O\'rmon polvoni'},
    ],
    'B': [
      {'word': 'Baliq 🐟', 'meaning': 'Suvda suzuvchi jonivor'},
      {'word': 'Banan 🍌', 'meaning': 'Sariq va shirin meva'},
    ],
    'D': [
      {'word': 'Delfin 🐬', 'meaning': 'Aqlli dengiz jonivori'},
      {'word': 'Daraxt 🌳', 'meaning': 'Yashil bargli o\'simlik'},
    ],
    'E': [
      {'word': 'Eski kalit 🔑', 'meaning': 'Qulfni ochuvchi buyum'},
    ],
    'F': [
      {'word': 'Fil 🐘', 'meaning': 'Xartumi bor ulkan hayvon'},
    ],
    'G': [
      {'word': 'Gul 🌺', 'meaning': 'Chiroyli hidli o\'simlik'},
    ],
    'H': [
      {'word': 'Hulkar ⭐️', 'meaning': 'Osmondagi yulduz'},
    ],
  };

  final List<String> _letters = const [
    'A', 'B', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z',
    "O'", "G'", 'SH', 'CH', 'NG'
  ];

  String? _selectedLetter;
  bool _showCelebration = false;
  int _stars = 0;
  String _aiTutorMessage = "";
  late String _currentDifficulty;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getModuleStars('alphabet');
    _aiTutorMessage = AiTutorService().getModuleIntro('alphabet');
    _currentDifficulty = AdaptiveLearningService().getDifficulty('alphabet');
  }

  void _onLetterTap(String letter) async {
    AudioService().playClickSound();
    AudioService().playSuccessSound();
    AudioService().playStarEarnSound();

    TtsService().speak("$letter harfi", language: 'uz-UZ');

    final updatedStars =
        await StorageService.instance.addModuleStars('alphabet', 1);

    await AdaptiveLearningService().recordAttempt(
      moduleId: 'alphabet',
      isCorrect: true,
    );

    await StorageService.instance.addLearningHistory(
      LearningHistoryItem(
        moduleId: 'alphabet',
        moduleTitle: 'Harflar',
        level: 1,
        isCompleted: true,
        scorePercentage: 100.0,
        starsEarned: 1,
        completionDate: DateTime.now().toIso8601String(),
      ),
    );

    final praise = AiTutorService().onCorrectAnswer(speakVoice: false);

    if (mounted) {
      setState(() {
        _selectedLetter = letter;
        _stars = updatedStars;
        _showCelebration = true;
        _aiTutorMessage = "$praise Bugun $letter harfini mukammal o'rgandik! 🎉";
        _currentDifficulty = AdaptiveLearningService().getDifficulty('alphabet');
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _showCelebration = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _selectedLetter != null
        ? (_letterWords[_selectedLetter] ?? [
            {'word': 'Namuna', 'meaning': 'Yangi so\'z'}
          ])
        : <Map<String, String>>[];

    return ConfettiOverlayWidget(
      show: _showCelebration,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "Harflar Sehrli Dunyosi 🔤",
          starCount: _stars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AiTutorBubbleWidget(message: _aiTutorMessage),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryViolet.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Daraja: ${_currentDifficulty.toUpperCase()} ⚡",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryViolet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Harfni bosing va ovozini eshiting!",
                style: AppTextStyles.h2.copyWith(color: AppColors.darkSlate),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _letters.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final letter = _letters[index];
                  final isSelected = _selectedLetter == letter;

                  return GestureDetector(
                    onTap: () => _onLetterTap(letter),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.warmCoral : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryViolet.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: AppTextStyles.h2.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryViolet,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (_selectedLetter != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.softTeal.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_selectedLetter Harfiga Oid So'zlar:",
                        style: AppTextStyles.h3
                            .copyWith(color: AppColors.primaryViolet),
                      ),
                      const SizedBox(height: 10),
                      ...words.map(
                        (w) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.brightYellow),
                              const SizedBox(width: 8),
                              Text(
                                "${w['word']}: ",
                                style: AppTextStyles.bodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  w['meaning'] ?? '',
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
