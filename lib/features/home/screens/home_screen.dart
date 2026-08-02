import 'package:flutter/material.dart';
import '../../../core/services/smart_recommendation_engine.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../core/widgets/child_app_bar.dart';
import '../../../core/widgets/child_mode_scaffold.dart';
import '../../../core/widgets/mascot_bubble.dart';
import '../../../core/widgets/parental_gate_dialog.dart';
import '../../../data/models/child_profile.dart';
import '../../../data/models/recommendation_model.dart';
import '../../../services/audio_service.dart';
import '../../../services/storage_service.dart';
import '../../../shared/widgets/responsive_layout_builder.dart';

import '../../ai_chat/ai_chat_screen.dart';
import '../../ai_story/ai_story_screen.dart';
import '../../alphabet/alphabet_screen.dart';
import '../../drawing/drawing_screen.dart';
import '../../english/english_language_screen.dart';
import '../../math/math_screen.dart';
import '../../mini_games/mini_games_screen.dart';
import '../../parent_gate/parent_gate_screen.dart';
import '../../uzbek/uzbek_language_screen.dart';
import '../models/section_item.dart';

/// AI Kids Academy Bosh Sahifasi (Home Screen — Stage 6 Fix & Stability)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChildProfile _profile;
  late RecommendationModel _aiRecommendation;
  int _totalStars = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    final storage = StorageService.instance;
    setState(() {
      _profile = storage.getActiveProfile();
      _totalStars = storage.getTotalStars();
      _aiRecommendation = SmartRecommendationEngine().getTopRecommendation();
    });
  }

  List<SectionItem> _buildSections(BuildContext context) {
    final storage = StorageService.instance;

    return [
      SectionItem(
        id: 'alphabet',
        title: "Harflar 🔤",
        subtitle: "Alifboni o'rganamiz",
        icon: Icons.sort_by_alpha_rounded,
        color: AppColors.primaryViolet,
        progress: storage.getModuleProgress('alphabet'),
        stars: storage.getModuleStars('alphabet'),
        builder: (ctx) => const AlphabetScreen(),
      ),
      SectionItem(
        id: 'math',
        title: "Matematika 🔢",
        subtitle: "Sonlar va misollar",
        icon: Icons.calculate_rounded,
        color: AppColors.softTeal,
        progress: storage.getModuleProgress('math'),
        stars: storage.getModuleStars('math'),
        builder: (ctx) => const MathScreen(),
      ),
      SectionItem(
        id: 'uzbek',
        title: "O'zbek tili 🇺🇿",
        subtitle: "Ona tili so'zlari",
        icon: Icons.translate_rounded,
        color: AppColors.warmCoral,
        progress: storage.getModuleProgress('uzbek'),
        stars: storage.getModuleStars('uzbek'),
        builder: (ctx) => const UzbekLanguageScreen(),
      ),
      SectionItem(
        id: 'english',
        title: "Ingliz tili 🇬🇧",
        subtitle: "English for Kids",
        icon: Icons.language_rounded,
        color: AppColors.skyBlue,
        progress: storage.getModuleProgress('english'),
        stars: storage.getModuleStars('english'),
        builder: (ctx) => const EnglishLanguageScreen(),
      ),
      SectionItem(
        id: 'ai_chat',
        title: "AI Chat 🤖",
        subtitle: "AI yordamchi maskot",
        icon: Icons.smart_toy_rounded,
        color: AppColors.playfulPink,
        progress: storage.getModuleProgress('ai_chat'),
        stars: storage.getModuleStars('ai_chat'),
        builder: (ctx) => const AiChatScreen(),
      ),
      SectionItem(
        id: 'ai_story',
        title: "AI Ertak 📖",
        subtitle: "Sehrli ertaklar yaratamiz",
        icon: Icons.auto_stories_rounded,
        color: AppColors.brightYellow,
        progress: storage.getModuleProgress('ai_story'),
        stars: storage.getModuleStars('ai_story'),
        builder: (ctx) => const AiStoryScreen(),
      ),
      SectionItem(
        id: 'mini_games',
        title: "Mini o'yinlar 🎮",
        subtitle: "Mantiqiy mini-o'yinlar",
        icon: Icons.sports_esports_rounded,
        color: AppColors.softTeal,
        progress: storage.getModuleProgress('mini_games'),
        stars: storage.getModuleStars('mini_games'),
        builder: (ctx) => const MiniGamesScreen(),
      ),
      SectionItem(
        id: 'drawing',
        title: "Rasm chizish 🎨",
        subtitle: "Ijodiy rasm chizish taxtasi",
        icon: Icons.palette_rounded,
        color: AppColors.primaryViolet,
        progress: storage.getModuleProgress('drawing'),
        stars: storage.getModuleStars('drawing'),
        builder: (ctx) => const DrawingScreen(),
      ),
      SectionItem(
        id: 'parent_gate',
        title: "Ota-ona paneli 🔐",
        subtitle: "Kattalar uchun statistikalar",
        icon: Icons.admin_panel_settings_rounded,
        color: const Color(0xFF2C3E50),
        progress: 0.0,
        stars: 0,
        builder: (ctx) => const ParentGateScreen(),
      ),
    ];
  }

  void _navigateToSection(SectionItem section) async {
    AudioService().playClickSound();

    if (section.id == 'parent_gate') {
      final unlocked = await ParentalGateDialog.show(context);
      if (unlocked == true && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: section.builder),
        );
        _loadState();
      }
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: section.builder),
      );
      _loadState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections(context);
    final isDesktop = ResponsiveLayoutBuilder.isDesktop(context);
    final isTablet = ResponsiveLayoutBuilder.isTablet(context);
    final crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);

    return ChildModeScaffold(
      appBar: ChildAppBar(
        title: "AI Kids Academy ✨",
        starCount: _totalStars,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryViolet.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.brightYellow,
                        child: Text("👑", style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profile.name,
                            style: AppTextStyles.h3.copyWith(fontSize: 16),
                          ),
                          Text(
                            "Level ${_profile.level} • ${_profile.totalXP} XP",
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryViolet,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warmCoral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text("🔥", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 4),
                        Text(
                          "${_profile.dailyStreak} Kun",
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.warmCoral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryViolet, AppColors.skyBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Text(
                    _aiRecommendation.iconEmoji,
                    style: const TextStyle(fontSize: 42),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _aiRecommendation.title,
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _aiRecommendation.message,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const MascotBubble(
              speechText:
                  "Salom Do'stim! Bugun qaysi sehrli bilimlar dunyosiga va AI sarguzashtlariga sayohat qilamiz? 🚀✨",
            ),
            const SizedBox(height: 20),

            Text(
              "O'quv Bo'limlari",
              style: AppTextStyles.h2.copyWith(color: AppColors.darkSlate),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 14.0,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, index) {
                final item = sections[index];
                return BouncyCard(
                  onTap: () => _navigateToSection(item),
                  color: item.color,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 44, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                          ),
                        ),
                        if (item.id != 'parent_gate') ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: item.progress,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 14, color: AppColors.brightYellow),
                              const SizedBox(width: 2),
                              Text(
                                "${item.stars} yulduz",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
