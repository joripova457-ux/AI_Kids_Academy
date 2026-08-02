import 'dart:async';
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

class _CardModel {
  final int id;
  final String icon;
  bool isFlipped = false;
  bool isMatched = false;

  _CardModel({
    required this.id,
    required this.icon,
  });
}

/// Memory Match Game Screen (Stage 6 Fix)
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<_CardModel> _cards;
  _CardModel? _firstSelectedCard;
  bool _isProcessing = false;
  int _score = 0;
  int _moves = 0;
  bool _isGameWon = false;
  int _earnedStars = 0;

  final List<String> _iconsPool = const [
    '🐱', '🐶', '🦁', '🐻', '🐼', '🦊', '🐸', '🐵'
  ];

  @override
  void initState() {
    super.initState();
    _earnedStars = StorageService.instance.getModuleStars('mini_games');
    _startNewGame();
  }

  void _startNewGame() {
    final selectedIcons = List<String>.from(_iconsPool)..shuffle();
    final gameIcons = selectedIcons.take(4).toList();
    final paired = [...gameIcons, ...gameIcons]..shuffle();

    _cards = List.generate(
      paired.length,
      (index) => _CardModel(id: index, icon: paired[index]),
    );

    _firstSelectedCard = null;
    _isProcessing = false;
    _score = 0;
    _moves = 0;
    _isGameWon = false;
    setState(() {});
  }

  void _onCardTap(_CardModel card) {
    if (_isProcessing || card.isFlipped || card.isMatched) return;

    AudioService().playClickSound();

    setState(() {
      card.isFlipped = true;
    });

    if (_firstSelectedCard == null) {
      _firstSelectedCard = card;
    } else {
      _moves++;
      _isProcessing = true;
      final first = _firstSelectedCard!;

      if (first.icon == card.icon) {
        AudioService().playSuccessSound();
        setState(() {
          first.isMatched = true;
          card.isMatched = true;
          _score += 1;
          _isProcessing = false;
          _firstSelectedCard = null;

          if (_score == 4) {
            _isGameWon = true;
            AudioService().playStarEarnSound();
            StorageService.instance.addModuleStars('mini_games', 5).then((updated) {
              if (mounted) {
                setState(() {
                  _earnedStars = updated;
                });
              }
            });
          }
        });
      } else {
        AudioService().playErrorSound();
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              first.isFlipped = false;
              card.isFlipped = false;
              _isProcessing = false;
              _firstSelectedCard = null;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      isTriggered: _isGameWon,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🧠 Xotira O'yini",
          starCount: _earnedStars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MascotBubble(
                speechText: _isGameWon
                    ? "Ofarin! Barcha juftliklarni topdingiz! 🎉+5 ⭐️"
                    : "Bir xil hayvonlar rasmini toping! Qadamlar: $_moves",
              ),
              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(card),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: card.isFlipped
                            ? (card.isMatched
                                ? AppColors.softTeal.withValues(alpha: 0.2)
                                : Colors.white)
                            : AppColors.primaryViolet,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: card.isMatched
                              ? AppColors.softTeal
                              : AppColors.primaryViolet,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          card.isFlipped ? card.icon : '❓',
                          style: TextStyle(
                            fontSize: card.isFlipped ? 36 : 28,
                            color: card.isFlipped ? null : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              if (_isGameWon) ...[
                Text(
                  "G'alaba! Barakalla! 🏆",
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.softTeal,
                  ),
                ),
                const SizedBox(height: 12),
                BigRoundButton(
                  text: "Qayta O'ynash 🔄",
                  variant: BigRoundButtonVariant.success,
                  onPressed: _startNewGame,
                ),
              ] else ...[
                BigRoundButton(
                  text: "Qayta boshlash 🔄",
                  variant: BigRoundButtonVariant.secondary,
                  onPressed: _startNewGame,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
