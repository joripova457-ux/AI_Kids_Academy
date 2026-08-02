import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import 'screens/memory_game_screen.dart';
import 'screens/shapes_game_screen.dart';
import 'screens/riddles_game_screen.dart';

/// Mini o'yinlar bo'limi sahifasi (Mini Games Screen with Dynamic Stars)
class MiniGamesScreen extends StatefulWidget {
  const MiniGamesScreen({super.key});

  @override
  State<MiniGamesScreen> createState() => _MiniGamesScreenState();
}

class _MiniGamesScreenState extends State<MiniGamesScreen> {
  int _stars = 0;
  int _moduleStars = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final storage = StorageService.instance;
    setState(() {
      _stars = storage.getTotalStars();
      _moduleStars = storage.getModuleStars('mini_games');
      _progress = storage.getModuleProgress('mini_games');
    });
  }

  void _openGame(Widget gameScreen) async {
    AudioService().playClickSound();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => gameScreen),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      appBar: ChildAppBar(
        title: "🎮 Mini O'yinlar",
        starCount: _stars,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MascotBubble(
              speechText: "Mantiqiy mini-o'yinlar o'ynab yulduzlar yutib oling! 🎮✨",
            ),
            const SizedBox(height: 24),
            BouncyCard(
              title: "Xotira O'yini (Memory Game) 🧠",
              subtitle: "Juft rasmlarni toping va xotirangizni charxlang",
              icon: Icons.extension_rounded,
              color: AppColors.brightYellow,
              stars: _moduleStars,
              progress: _progress,
              onTap: () => _openGame(const MemoryGameScreen()),
            ),
            const SizedBox(height: 16),
            BouncyCard(
              title: "Shakllar va Ranglar 🎨",
              subtitle: "To'g'ri shakllarni birlashtiring",
              icon: Icons.category_rounded,
              color: AppColors.softTeal,
              stars: _moduleStars,
              progress: _progress,
              onTap: () => _openGame(const ShapesGameScreen()),
            ),
            const SizedBox(height: 16),
            BouncyCard(
              title: "Topishmoqlar ❓",
              subtitle: "Qiziqarli topshiriqlar va topishmoqlar",
              icon: Icons.psychology_rounded,
              color: AppColors.warmCoral,
              stars: _moduleStars,
              progress: _progress,
              onTap: () => _openGame(const RiddlesGameScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
