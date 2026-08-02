import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/big_round_button.dart';
import '../../../core/widgets/child_app_bar.dart';
import '../../../core/widgets/child_mode_scaffold.dart';
import '../../../core/widgets/confetti_overlay.dart';
import '../../../core/widgets/mascot_bubble.dart';
import '../../../services/audio_service.dart';
import '../../../services/storage_service.dart';

class _RiddleItem {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;

  const _RiddleItem({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
  });
}

/// Riddles Game Screen (Stage 6 Fix)
class RiddlesGameScreen extends StatefulWidget {
  const RiddlesGameScreen({super.key});

  @override
  State<RiddlesGameScreen> createState() => _RiddlesGameScreenState();
}

class _RiddlesGameScreenState extends State<RiddlesGameScreen> {
  final List<_RiddleItem> _riddles = const [
    _RiddleItem(
      question: "Qanoti bor, lekin ucholmaydi, suvda suzadi, muzni yaxshi ko'radi. Bu nima? 🐧",
      options: ["Pingvin", "O'rdak", "Tovuq"],
      correctIndex: 0,
      hint: "U Antarktidada yashaydi!",
    ),
    _RiddleItem(
      question: "Oynada ko'rasan o'zingni, ko'rsatadi har bir yuzingni. Bu nima? 🪞",
      options: ["Deraza", "Ko'zgular (Oyna)", "Rasm"],
      correctIndex: 1,
      hint: "Ertalab unga qarab sochingizni taraysiz!",
    ),
    _RiddleItem(
      question: "Uzun quloq, qisqa dum, sabzini juda yaxshi ko'radi. Bu kim? 🐰",
      options: ["Mushuk", "Quyon", "Ayiq"],
      correctIndex: 1,
      hint: "Sakrab-sakrab yuradi!",
    ),
    _RiddleItem(
      question: "Kun kelganda yo'qoladi, tunda osmonda porlaydi. Bu nima? ⭐️",
      options: ["Yulduzlar", "Quyosh", "Bulut"],
      correctIndex: 0,
      hint: "Tunda osmonda miltillaydi!",
    ),
  ];

  int _currentIndex = 0;
  int? _selectedIndex;
  bool _showHint = false;
  bool _isCorrect = false;
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getModuleStars('mini_games');
  }

  void _checkAnswer(int index) {
    if (_isCorrect) return;

    setState(() {
      _selectedIndex = index;
      if (index == _riddles[_currentIndex].correctIndex) {
        _isCorrect = true;
        AudioService().playSuccessSound();
        AudioService().playStarEarnSound();
        StorageService.instance.addModuleStars('mini_games', 2).then((updated) {
          if (mounted) {
            setState(() {
              _stars = updated;
            });
          }
        });
      } else {
        AudioService().playErrorSound();
      }
    });
  }

  void _nextRiddle() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _riddles.length;
      _selectedIndex = null;
      _showHint = false;
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final riddle = _riddles[_currentIndex];

    return ConfettiOverlay(
      isTriggered: _isCorrect,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "❓ Topishmoqlar Olamida",
          starCount: _stars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MascotBubble(
                speechText: _isCorrect
                    ? "Barakalla! Topishmoqni to'g'ri topdingiz! 🎉+2 ⭐️"
                    : "Topishmoq javobini topa olasizmi? 🤔",
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmCoral.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Topishmoq #${_currentIndex + 1}:",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.warmCoral,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      riddle.question,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 18),
                    ),
                    if (_showHint) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.brightYellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "💡 Maslahat: ${riddle.hint}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),
              if (!_showHint && !_isCorrect)
                TextButton.icon(
                  onPressed: () {
                    AudioService().playClickSound();
                    setState(() => _showHint = true);
                  },
                  icon: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.brightYellow),
                  label: Text(
                    "Maslahat olish 💡",
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryViolet),
                  ),
                ),

              const SizedBox(height: 20),

              ...List.generate(riddle.options.length, (optIndex) {
                final optionText = riddle.options[optIndex];
                final isSelected = _selectedIndex == optIndex;
                final isAnswerCorrect = optIndex == riddle.correctIndex;

                Color btnBgColor = Colors.white;
                Color textColor = AppColors.textDark;

                if (isSelected) {
                  if (isAnswerCorrect) {
                    btnBgColor = AppColors.softTeal;
                    textColor = Colors.white;
                  } else {
                    btnBgColor = AppColors.warmCoral;
                    textColor = Colors.white;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: _isCorrect ? null : () => _checkAnswer(optIndex),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: btnBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? btnBgColor
                              : AppColors.primaryViolet.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        optionText,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingSmall.copyWith(
                          color: textColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
              if (_isCorrect)
                BigRoundButton(
                  text: "Keyingi Topishmoq ➡️",
                  variant: BigRoundButtonVariant.success,
                  onPressed: _nextRiddle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
