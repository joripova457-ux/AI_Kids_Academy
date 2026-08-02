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

/// O'zbek tili bo'limi sahifasi (Uzbek Language Screen with Audio simulation)
class UzbekLanguageScreen extends StatefulWidget {
  const UzbekLanguageScreen({super.key});

  @override
  State<UzbekLanguageScreen> createState() => _UzbekLanguageScreenState();
}

class _UzbekLanguageScreenState extends State<UzbekLanguageScreen> {
  int _stars = 0;
  String? _activeWord;
  bool _showCelebration = false;

  final List<Map<String, String>> _words = const [
    {'word': 'Quyosh ☀️', 'category': 'Tabiat', 'description': 'Erga issiqlik beruvchi nurlardan iborat'},
    {'word': 'Kitob 📖', 'category': 'O\'quv quroli', 'description': 'Bilimlar manbai'},
    {'word': 'Olma 🍎', 'category': 'Meva', 'description': 'Shirin va vitaminli meva'},
    {'word': 'Mushuk 🐱', 'category': 'Hayvonlar', 'description': 'Yumshoq junli uy hayvoni'},
    {'word': 'Samolyot ✈️', 'category': 'Transport', 'description': 'Osmonda uchadigan transport'},
    {'word': 'Gul 🌺', 'category': 'Tabiat', 'description': 'Chiroyli hidli va rang-barang'},
  ];

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  void _onWordTap(Map<String, String> item) async {
    AudioService().playClickSound();
    AudioService().playSuccessSound();
    TtsService().speak(item['word'] ?? '');

    final updatedStars = await StorageService.instance.addModuleStars('uzbek', 1);

    setState(() {
      _activeWord = item['word'];
      _stars = updatedStars;
      _showCelebration = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      isTriggered: _showCelebration,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🇺🇿 O'zbek Tili",
          starCount: _stars,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MascotBubble(
                speechText: _activeWord != null
                    ? "'$_activeWord' so'zini talaffuz qildingiz! 🎉+1 ⭐️"
                    : "Chiroyli ona tilimizdagi yangi so'zlarni o'rganamiz! 🇺🇿",
              ),
              const SizedBox(height: 24),
              Text(
                "Yangi so'zlar lug'ati (Bosing va eshiting):",
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _words.length,
                  itemBuilder: (context, index) {
                    final item = _words[index];
                    final isSelected = _activeWord == item['word'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.warmCoral.withValues(alpha: 0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.warmCoral : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warmCoral.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.warmCoral.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.volume_up_rounded,
                              color: AppColors.warmCoral,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['word']!,
                                  style: AppTextStyles.headingSmall,
                                ),
                                Text(
                                  "${item['category']!} • ${item['description']!}",
                                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warmCoral,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => _onWordTap(item),
                            child: const Text("🔊 O'qish", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
