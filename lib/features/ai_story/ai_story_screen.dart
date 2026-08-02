import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../services/ai_service.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// AI Ertak Generator (Interactive Story Wizard with Voice TTS)
class AiStoryScreen extends StatefulWidget {
  const AiStoryScreen({super.key});

  @override
  State<AiStoryScreen> createState() => _AiStoryScreenState();
}

class _AiStoryScreenState extends State<AiStoryScreen> {
  String? _selectedTheme;
  String? _selectedHero;
  int _storyStep = 0; // 0: Select Theme & Hero, 1: Story Part 1, 2: Story Part 2
  bool _isGenerating = false;
  int _stars = 0;
  bool _isCompleted = false;

  Map<String, dynamic>? _storyData;

  final List<String> _themes = [
    "Sehrli O'rmon 🌲",
    "Kosmik Sarguzasht 🚀",
    "Dinozavrlar Oroli 🦕",
    "Suv Osti Qirolligi 🐬"
  ];

  final List<String> _heroes = [
    "Aqlvoy Bot 🤖",
    "Jasur Arslon 🦁",
    "Zukko Qizaloq 👧",
    "Sehrli Qushcha 🕊️"
  ];

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  void _generateStory() async {
    if (_selectedTheme == null || _selectedHero == null) return;

    AudioService().playClickSound();

    setState(() {
      _isGenerating = true;
    });

    final data = await AiService().generateStoryChapter(
      theme: _selectedTheme!,
      hero: _selectedHero!,
      step: 1,
    );

    if (mounted) {
      AudioService().playSuccessSound();
      setState(() {
        _storyData = data;
        _isGenerating = false;
        _storyStep = 1;
      });

      // Ertak matnini ovozli o'qib berish (TTS)
      final content = data['content'] as String?;
      if (content != null) {
        TtsService().speak(content);
      }
    }
  }

  void _chooseOption(int choice) async {
    AudioService().playClickSound();

    setState(() {
      _isGenerating = true;
    });

    final data = await AiService().generateStoryChapter(
      theme: _selectedTheme!,
      hero: _selectedHero!,
      step: 2,
      userChoice: choice,
    );

    if (mounted) {
      AudioService().playStarEarnSound();
      final updatedStars = await StorageService.instance.addModuleStars('ai_story', 5);
      setState(() {
        _storyData = data;
        _isGenerating = false;
        _storyStep = 2;
        _isCompleted = true;
        _stars = updatedStars;
      });

      final content = data['content'] as String?;
      if (content != null) {
        TtsService().speak(content);
      }
    }
  }

  void _resetStory() {
    AudioService().playClickSound();
    TtsService().stop();
    setState(() {
      _selectedTheme = null;
      _selectedHero = null;
      _storyStep = 0;
      _storyData = null;
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      isTriggered: _isCompleted,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "📖 AI Ertaklar Olamida",
          starCount: _stars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_storyStep == 0) ...[
                const MascotBubble(
                  speechText: "O'zingiz xohlagan sehrli ertakni birga yaratamiz! ✨",
                ),
                const SizedBox(height: 20),

                Text("1. Ertak mavzusini tanlang:", style: AppTextStyles.headingSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _themes.map((theme) {
                    final isSel = _selectedTheme == theme;
                    return ChoiceChip(
                      selected: isSel,
                      label: Text(theme, style: AppTextStyles.bodyMedium),
                      selectedColor: AppColors.primaryViolet,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textDark),
                      onSelected: (val) {
                        AudioService().playClickSound();
                        setState(() => _selectedTheme = theme);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                Text("2. Bosh qahramonni tanlang:", style: AppTextStyles.headingSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _heroes.map((hero) {
                    final isSel = _selectedHero == hero;
                    return ChoiceChip(
                      selected: isSel,
                      label: Text(hero, style: AppTextStyles.bodyMedium),
                      selectedColor: AppColors.softTeal,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textDark),
                      onSelected: (val) {
                        AudioService().playClickSound();
                        setState(() => _selectedHero = hero);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
                if (_isGenerating)
                  const Center(child: CircularProgressIndicator())
                else
                  BigRoundButton(
                    text: "Ertak Yaratish ✨",
                    variant: BigRoundButtonVariant.primary,
                    onPressed: (_selectedTheme != null && _selectedHero != null)
                        ? _generateStory
                        : () {},
                  ),
              ] else if (_storyStep == 1 && _storyData != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: MascotBubble(
                        speechText: "$_selectedHero bilan sarguzasht boshlandi! 📖",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryViolet, size: 28),
                      tooltip: "Ertakni ovozli o'qish",
                      onPressed: () {
                        AudioService().playClickSound();
                        TtsService().speak(_storyData!['content'] ?? '');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brightYellow.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _storyData!['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingSmall.copyWith(color: AppColors.primaryViolet),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _storyData!['content'] ?? '',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text("Qahramonimiz nima qilsin?", style: AppTextStyles.headingSmall),
                const SizedBox(height: 12),

                if (_isGenerating)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  BigRoundButton(
                    text: "1. ${_storyData!['option1']} 🔑",
                    variant: BigRoundButtonVariant.secondary,
                    onPressed: () => _chooseOption(1),
                  ),
                  const SizedBox(height: 12),
                  BigRoundButton(
                    text: "2. ${_storyData!['option2']} 📢",
                    variant: BigRoundButtonVariant.success,
                    onPressed: () => _chooseOption(2),
                  ),
                ],
              ] else if (_storyStep == 2 && _storyData != null) ...[
                Row(
                  children: [
                    const Expanded(
                      child: MascotBubble(
                        speechText: "Barakalla! Ertak muvaffaqiyatli yakunlandi! 🎉 +5 ⭐️",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.softTeal, size: 28),
                      tooltip: "Yakunni o'qish",
                      onPressed: () {
                        AudioService().playClickSound();
                        TtsService().speak(_storyData!['content'] ?? '');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.softTeal, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(_storyData!['title'] ?? 'Ertak Yakuni 🏆', style: AppTextStyles.headingMedium),
                      const SizedBox(height: 12),
                      Text(
                        _storyData!['content'] ?? '',
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.softTeal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "💡 Xulosa: ${_storyData!['moral']}",
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                BigRoundButton(
                  text: "Yangi Ertak Yaratish 🔄",
                  variant: BigRoundButtonVariant.primary,
                  onPressed: _resetStory,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
