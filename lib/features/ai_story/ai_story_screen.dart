import 'dart:async';
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

/// 7-BOSQICH AI Ertak Generator (Gemini Prompt Constructor + Context Choices + Loading State)
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
  bool _showSlowLoadingHint = false;
  Timer? _loadingTimer;
  int _stars = 0;
  int _childAge = 6;
  bool _isCompleted = false;

  Map<String, dynamic>? _storyData;
  List<Map<String, String>> _contextHistory = [];

  final List<String> _themes = const [
    "Sehrli O'rmon 🌲",
    "Kosmik Sarguzasht 🚀",
    "Dinozavrlar Oroli 🦕",
    "Suv Osti Qirolligi 🐬",
    "Bulutlar Mamlakati ☁️",
    "Kamalak Tog'lari 🌈"
  ];

  final List<String> _heroes = const [
    "Aqlvoy Bot 🤖",
    "Jasur Arslon 🦁",
    "Zukko Qizaloq 👧",
    "Sehrli Qushcha 🕊️",
    "Quvnoq Quyoncha 🐰",
    "Polvon Ayiqvoy 🐻"
  ];

  @override
  void initState() {
    super.initState();
    final storage = StorageService.instance;
    final profile = storage.getActiveProfile();
    _stars = storage.getModuleStars('ai_story');
    _childAge = profile.age;
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _generateStory() async {
    if (_selectedTheme == null || _selectedHero == null || _isGenerating) return;

    AudioService().playClickSound();

    setState(() {
      _isGenerating = true;
      _showSlowLoadingHint = false;
    });

    _loadingTimer?.cancel();
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isGenerating) {
        setState(() {
          _showSlowLoadingHint = true;
        });
      }
    });

    final data = await AiService().generateStoryChapter(
      theme: _selectedTheme!,
      hero: _selectedHero!,
      step: 1,
      childAge: _childAge,
    );

    _loadingTimer?.cancel();

    if (mounted) {
      AudioService().playSuccessSound();
      final content = data['content'] as String? ?? '';
      final title = data['title'] as String? ?? 'Sehrli Ertak';

      _contextHistory = [
        {'role': 'system', 'text': 'Theme: $_selectedTheme, Hero: $_selectedHero'},
        {'role': 'story', 'text': content},
      ];

      setState(() {
        _storyData = data;
        _isGenerating = false;
        _showSlowLoadingHint = false;
        _storyStep = 1;
      });

      if (content.isNotEmpty) {
        TtsService().speak("$title. $content");
      }
    }
  }

  void _chooseOption(int choice) async {
    if (_selectedTheme == null || _selectedHero == null || _isGenerating) return;

    AudioService().playClickSound();

    setState(() {
      _isGenerating = true;
      _showSlowLoadingHint = false;
    });

    _loadingTimer?.cancel();
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isGenerating) {
        setState(() {
          _showSlowLoadingHint = true;
        });
      }
    });

    final data = await AiService().generateStoryChapter(
      theme: _selectedTheme!,
      hero: _selectedHero!,
      step: 2,
      userChoice: choice,
      contextHistory: _contextHistory,
      childAge: _childAge,
    );

    _loadingTimer?.cancel();

    if (mounted) {
      AudioService().playStarEarnSound();
      final updatedStars = await StorageService.instance.addModuleStars('ai_story', 5);
      final content = data['content'] as String? ?? '';
      final moral = data['moral'] as String? ?? '';

      setState(() {
        _storyData = data;
        _isGenerating = false;
        _showSlowLoadingHint = false;
        _storyStep = 2;
        _isCompleted = true;
        _stars = updatedStars;
      });

      if (content.isNotEmpty) {
        TtsService().speak("$content $moral");
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
      _contextHistory.clear();
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
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _themes.map((theme) {
                    final isSelected = _selectedTheme == theme;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(theme),
                      selectedColor: AppColors.primaryViolet.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primaryViolet,
                      onSelected: (val) {
                        AudioService().playClickSound();
                        setState(() {
                          _selectedTheme = val ? theme : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                Text("2. Bosh qahramonni tanlang:", style: AppTextStyles.headingSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _heroes.map((hero) {
                    final isSelected = _selectedHero == hero;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(hero),
                      selectedColor: AppColors.warmCoral.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.warmCoral,
                      onSelected: (val) {
                        AudioService().playClickSound();
                        setState(() {
                          _selectedHero = val ? hero : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                if (_isGenerating) ...[
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          "Gemini AI sehrli ertak to'qimoqda... 🔮",
                          style: AppTextStyles.bodyLarge,
                        ),
                        if (_showSlowLoadingHint) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Sehrli kitob varoqlanmoqda, ajoyib ertak tayyorlanmoqda... 📖✨",
                            style: AppTextStyles.caption.copyWith(color: AppColors.primaryViolet),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else
                  Center(
                    child: BigRoundButton(
                      text: "Ertakni Boshlash 🚀",
                      variant: BigRoundButtonVariant.success,
                      onPressed: (_selectedTheme != null && _selectedHero != null)
                          ? _generateStory
                          : null,
                    ),
                  ),
              ] else if (_storyStep == 1 && _storyData != null) ...[
                Text(_storyData!['title'] ?? 'Ertak Part 1', style: AppTextStyles.titleLarge),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _storyData!['content'] ?? '',
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                  ),
                ),
                const SizedBox(height: 24),

                Text("Endi nima bo'ladi? Tanlang: 🤔", style: AppTextStyles.headingSmall),
                const SizedBox(height: 16),

                if (_isGenerating) ...[
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text("Ertak davomi generatsiya qilinmoqda... ⚡", style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ] else ...[
                  BigRoundButton(
                    text: _storyData!['option1'] ?? '1-variant',
                    variant: BigRoundButtonVariant.secondary,
                    onPressed: () => _chooseOption(1),
                  ),
                  const SizedBox(height: 12),
                  BigRoundButton(
                    text: _storyData!['option2'] ?? '2-variant',
                    variant: BigRoundButtonVariant.warning,
                    onPressed: () => _chooseOption(2),
                  ),
                ],
              ] else if (_storyStep == 2 && _storyData != null) ...[
                Center(
                  child: Text("🎉 Ertak Yakunlandi! 🎉", style: AppTextStyles.titleLarge),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _storyData!['content'] ?? '',
                        style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                      ),
                      if (_storyData!['moral'] != null) ...[
                        const Divider(height: 32),
                        Text(
                          "💡 Tarbiyaviy xulosa:",
                          style: AppTextStyles.headingSmall.copyWith(color: AppColors.primaryViolet),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _storyData!['moral'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: BigRoundButton(
                    text: "Yangi Ertak Yaratish 🔄",
                    variant: BigRoundButtonVariant.playful,
                    onPressed: _resetStory,
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
