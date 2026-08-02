import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/level_map_widget.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// Matematika bo'limi (Math Screen with Comparison, Level Map & Interactive Quizzes)
class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  int _currentLevel = 1;
  bool _inGameMode = false;
  int _num1 = 3;
  int _num2 = 2;
  String _op = '+'; // +, -, > (Comparison mode)
  String? _selectedOption;
  bool _isSuccess = false;
  int _stars = 0;

  final List<LevelItemData> _levels = [
    const LevelItemData(
      levelNumber: 1,
      title: "1-Daraja: Oson Qo'shish ➕",
      description: "1 dan 5 gacha sonlarni qo'shish",
      isUnlocked: true,
      isCompleted: true,
      starsEarned: 3,
    ),
    const LevelItemData(
      levelNumber: 2,
      title: "2-Daraja: Qo'shish 10 gacha ➕",
      description: "10 gacha bo'lgan misollar",
      isUnlocked: true,
      isCompleted: false,
      starsEarned: 2,
    ),
    const LevelItemData(
      levelNumber: 3,
      title: "3-Daraja: Ayirish ➖",
      description: "Sonlarni ayirishni o'rganamiz",
      isUnlocked: true,
      isCompleted: false,
      starsEarned: 1,
    ),
    const LevelItemData(
      levelNumber: 4,
      title: "4-Daraja: Taqqoslash ⚖️",
      description: "Qaysi biri katta: >, < yoki = ?",
      isUnlocked: true,
      isCompleted: false,
      starsEarned: 2,
    ),
    const LevelItemData(
      levelNumber: 5,
      title: "5-Daraja: Super Zukko 🏆",
      description: "Chaqqon hisoblash testi",
      isUnlocked: true,
      isCompleted: false,
      starsEarned: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  void _startLevel(LevelItemData level) {
    AudioService().playClickSound();
    setState(() {
      _currentLevel = level.levelNumber;
      _inGameMode = true;
      _generateQuestion();
    });
  }

  void _generateQuestion() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_currentLevel == 1) {
      _op = '+';
      _num1 = (now % 4) + 1;
      _num2 = ((now ~/ 10) % 3) + 1;
    } else if (_currentLevel == 2) {
      _op = '+';
      _num1 = (now % 6) + 3;
      _num2 = ((now ~/ 7) % 5) + 1;
    } else if (_currentLevel == 3) {
      _op = '-';
      _num1 = (now % 6) + 5;
      _num2 = ((now ~/ 5) % _num1) + 1;
    } else if (_currentLevel == 4) {
      _op = '⚖️'; // Comparison mode
      _num1 = (now % 9) + 1;
      _num2 = ((now ~/ 3) % 9) + 1;
    } else {
      _op = (now % 2 == 0) ? '+' : '-';
      _num1 = (now % 8) + 4;
      _num2 = (_op == '-')
          ? ((now ~/ 3) % _num1) + 1
          : ((now ~/ 4) % 6) + 1;
    }
    _selectedOption = null;
    _isSuccess = false;
  }

  String get _correctAnswer {
    if (_op == '⚖️') {
      if (_num1 > _num2) return '>';
      if (_num1 < _num2) return '<';
      return '=';
    }
    return _op == '+' ? "${_num1 + _num2}" : "${_num1 - _num2}";
  }

  void _checkAnswer(String option) {
    if (_isSuccess) return;

    setState(() {
      _selectedOption = option;
      if (option == _correctAnswer) {
        _isSuccess = true;
        AudioService().playSuccessSound();
        AudioService().playStarEarnSound();
        TtsService().speak("Barakalla! To'g'ri topdingiz!");

        StorageService.instance.addModuleStars('math', 1).then((updated) {
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

  @override
  Widget build(BuildContext context) {
    List<String> options;
    if (_op == '⚖️') {
      options = ['>', '=', '<'];
    } else {
      final correctInt = int.parse(_correctAnswer);
      options = [
        "${correctInt - 1}",
        "$correctInt",
        "${correctInt + 2}",
      ]..shuffle();
    }

    return ConfettiOverlay(
      isTriggered: _isSuccess,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🔢 Matematika Olamida",
          starCount: _stars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_inGameMode) ...[
                const MascotBubble(
                  speechText: "Matematik darajani tanlang va misollarni yechishni boshlang! 🚀",
                ),
                const SizedBox(height: 24),
                Text(
                  "Matematika Darajalari Yo'lagi:",
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 16),
                LevelMapWidget(
                  levels: _levels,
                  onLevelSelect: _startLevel,
                ),
              ] else ...[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryViolet),
                      onPressed: () {
                        AudioService().playClickSound();
                        setState(() => _inGameMode = false);
                      },
                    ),
                    Text(
                      "$_currentLevel-Daraja topshirig'i",
                      style: AppTextStyles.headingSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryViolet),
                      tooltip: "Ovozli o'qib berish",
                      onPressed: () {
                        if (_op == '⚖️') {
                          TtsService().speak("$_num1 bilan $_num2 sonlarini taqqoslang");
                        } else {
                          TtsService().speak("$_num1 $_op $_num2 necha bo'ladi?");
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MascotBubble(
                  speechText: _isSuccess
                      ? "Barakalla! To'g'ri topdingiz! 🎉 +1 ⭐️"
                      : (_op == '⚖️'
                          ? "$_num1 bilan $_num2 ni taqqoslang: >, < yoki = ?"
                          : "Misolni yeching: $_num1 $_op $_num2 = ?"),
                ),
                const SizedBox(height: 24),

                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softTeal.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _op == '⚖️' ? "$_num1  " : "$_num1 $_op $_num2 = ",
                        style: AppTextStyles.titleLarge.copyWith(fontSize: 40),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isSuccess
                              ? AppColors.softTeal.withValues(alpha: 0.15)
                              : AppColors.primaryViolet.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _selectedOption ?? "?",
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 40,
                            color: _isSuccess ? AppColors.softTeal : AppColors.primaryViolet,
                          ),
                        ),
                      ),
                      if (_op == '⚖️')
                        Text(
                          "  $_num2",
                          style: AppTextStyles.titleLarge.copyWith(fontSize: 40),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  "To'g'ri javobni tanlang:",
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: options.map((opt) {
                    final isSelected = _selectedOption == opt;
                    return GestureDetector(
                      onTap: () => _checkAnswer(opt),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (_isSuccess ? AppColors.softTeal : AppColors.warmCoral)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            opt,
                            style: AppTextStyles.headingMedium.copyWith(
                              fontSize: 32,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
                if (_isSuccess)
                  BigRoundButton(
                    text: "Keyingi Misol ➡️",
                    variant: BigRoundButtonVariant.success,
                    onPressed: () {
                      AudioService().playClickSound();
                      setState(() {
                        _generateQuestion();
                      });
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
