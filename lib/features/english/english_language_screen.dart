import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// Ingliz tili bo'limi sahifasi (English Language Screen with Quiz Mode)
class EnglishLanguageScreen extends StatefulWidget {
  const EnglishLanguageScreen({super.key});

  @override
  State<EnglishLanguageScreen> createState() => _EnglishLanguageScreenState();
}

class _EnglishLanguageScreenState extends State<EnglishLanguageScreen> {
  final List<Map<String, String>> _words = const [
    {'en': 'Apple 🍎', 'uz': 'Olma', 'emoji': '🍎'},
    {'en': 'Sun ☀️', 'uz': 'Quyosh', 'emoji': '☀️'},
    {'en': 'Cat 🐱', 'uz': 'Mushuk', 'emoji': '🐱'},
    {'en': 'Dog 🐶', 'uz': 'It', 'emoji': '🐶'},
    {'en': 'Car 🚗', 'uz': 'Mashina', 'emoji': '🚗'},
    {'en': 'Star ⭐', 'uz': 'Yulduz', 'emoji': '⭐'},
    {'en': 'Tree 🌳', 'uz': 'Daraxt', 'emoji': '🌳'},
    {'en': 'Book 📖', 'uz': 'Kitob', 'emoji': '📖'},
  ];

  int _stars = 0;
  String? _activeWord;
  bool _showCelebration = false;
  bool _isQuizMode = false;

  // Quiz state
  int _quizIndex = 0;
  int? _selectedQuizOption;
  bool _isQuizCorrect = false;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  void _onCardTap(Map<String, String> item) async {
    AudioService().playClickSound();
    AudioService().playSuccessSound();
    TtsService().speak(item['en'] ?? '', language: 'en-US');
    final updatedStars = await StorageService.instance.addModuleStars('english', 1);
    setState(() {
      _activeWord = item['en'];
      _stars = updatedStars;
      _showCelebration = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showCelebration = false);
    });
  }

  List<String> _buildQuizOptions(int correctIndex) {
    final correct = _words[correctIndex]['uz']!;
    final others = _words
        .where((w) => w['uz'] != correct)
        .map((w) => w['uz']!)
        .toList()
      ..shuffle();
    final options = [correct, ...others.take(2)]..shuffle();
    return options;
  }

  void _checkQuizAnswer(String selected) async {
    if (_isQuizCorrect) return;
    final correct = _words[_quizIndex]['uz']!;
    final isCorrect = selected == correct;

    if (isCorrect) {
      AudioService().playSuccessSound();
      AudioService().playStarEarnSound();
      final updatedStars = await StorageService.instance.addModuleStars('english', 2);
      setState(() {
        _selectedQuizOption = isCorrect ? 0 : 1;
        _isQuizCorrect = true;
        _stars = updatedStars;
        _showCelebration = true;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _showCelebration = false);
      });
    } else {
      AudioService().playErrorSound();
      setState(() => _selectedQuizOption = 1);
    }
  }

  void _nextQuizQuestion() {
    AudioService().playClickSound();
    setState(() {
      _quizIndex = (_quizIndex + 1) % _words.length;
      _selectedQuizOption = null;
      _isQuizCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      isTriggered: _showCelebration,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🇬🇧 English for Kids",
          starCount: _stars,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MascotBubble(
                speechText: _activeWord != null && !_isQuizMode
                    ? "'$_activeWord' — Zo'r! 🎉+1 ⭐️"
                    : _isQuizMode
                        ? "Quiz: English so'zning o'zbekcha ma'nosini tanlang! 🧠"
                        : "Let's learn English words together! 🇬🇧",
              ),
              const SizedBox(height: 16),

              // Mode Toggle Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isQuizMode ? AppColors.skyBlue : Colors.white,
                        foregroundColor: !_isQuizMode ? Colors.white : AppColors.skyBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        AudioService().playClickSound();
                        setState(() => _isQuizMode = false);
                      },
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text("Lug'at"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isQuizMode ? AppColors.primaryViolet : Colors.white,
                        foregroundColor: _isQuizMode ? Colors.white : AppColors.primaryViolet,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        AudioService().playClickSound();
                        setState(() {
                          _isQuizMode = true;
                          _quizIndex = 0;
                          _selectedQuizOption = null;
                          _isQuizCorrect = false;
                        });
                      },
                      icon: const Icon(Icons.quiz_rounded),
                      label: const Text("Quiz"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (!_isQuizMode) ...[
                Text("Inglizcha-O'zbekcha Lug'at (Bosib eshiting):", style: AppTextStyles.headingSmall),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _words.length,
                    itemBuilder: (context, index) {
                      final item = _words[index];
                      final isActive = _activeWord == item['en'];
                      return GestureDetector(
                        onTap: () => _onCardTap(item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.skyBlue.withValues(alpha: 0.15) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isActive ? AppColors.skyBlue : AppColors.skyBlue.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.skyBlue.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item['en']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headingMedium.copyWith(
                                  color: AppColors.primaryViolet,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['uz']!,
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.volume_up_rounded, color: AppColors.skyBlue, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                // Quiz Mode
                const SizedBox(height: 8),
                Text("Savol ${_quizIndex + 1} / ${_words.length}:", style: AppTextStyles.bodyMedium),
                const SizedBox(height: 12),
                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.skyBlue.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _words[_quizIndex]['en']!,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 36,
                          color: AppColors.primaryViolet,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Bu so'zning o'zbekchasi nima?",
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Options
                ..._buildQuizOptions(_quizIndex).map((opt) {
                  final isSelected = _selectedQuizOption != null && opt == _words[_quizIndex]['uz'];
                  final isWrongSelected = _selectedQuizOption != null && !_isQuizCorrect && opt != _words[_quizIndex]['uz'];
                  Color bgColor = Colors.white;
                  if (_selectedQuizOption != null) {
                    if (opt == _words[_quizIndex]['uz']) bgColor = AppColors.softTeal;
                    if (isWrongSelected) bgColor = Colors.white;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _checkQuizAnswer(opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? AppColors.softTeal : AppColors.primaryViolet.withValues(alpha: 0.25),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          opt,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingSmall.copyWith(
                            fontSize: 18,
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (_isQuizCorrect)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryViolet,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    onPressed: _nextQuizQuestion,
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    label: const Text("Keyingi Savol ➡️", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
