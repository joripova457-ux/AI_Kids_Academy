import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../data/datasets/vocabulary_dataset.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// 7-BOSQICH O'zbek Tili Sahifasi (160+ Lug'at So'zlari va Ovozli Izohlar)
class UzbekLanguageScreen extends StatefulWidget {
  const UzbekLanguageScreen({super.key});

  @override
  State<UzbekLanguageScreen> createState() => _UzbekLanguageScreenState();
}

class _UzbekLanguageScreenState extends State<UzbekLanguageScreen> {
  final List<VocabularyItem> _allWords = VocabularyDataset.items;
  final TextEditingController _searchController = TextEditingController();

  int _stars = 0;
  String? _activeWord;
  String _selectedCategory = 'Barchasi';
  String _searchQuery = '';
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getModuleStars('uzbek');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VocabularyItem> get _filteredWords {
    return _allWords.where((item) {
      final matchesCategory = _selectedCategory == 'Barchasi' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.uzbek.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.english.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onWordTap(VocabularyItem item) async {
    AudioService().playClickSound();
    AudioService().playSuccessSound();
    TtsService().speak("${item.uzbek}. ${item.description}");

    final updatedStars = await StorageService.instance.addModuleStars('uzbek', 1);

    if (mounted) {
      setState(() {
        _activeWord = "${item.uzbek} ${item.emoji}";
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
  }

  @override
  Widget build(BuildContext context) {
    final categories = VocabularyDataset.categories;

    return ConfettiOverlay(
      isTriggered: _showCelebration,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🇺🇿 O'zbek Tili (160+ Lug'at)",
          starCount: _stars,
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Ona tili so'zlarini qidirish... 🔍",
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: AppColors.warmCoral,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        AudioService().playClickSound();
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MascotBubble(
                speechText: _activeWord != null
                    ? "'$_activeWord' so'zini talaffuz qildingiz! 🎉 +1 ⭐️"
                    : "Chiroyli ona tilimizdagi 160+ so'zlarni o'rganamiz! 🇺🇿",
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredWords.length,
                itemBuilder: (context, index) {
                  final item = _filteredWords[index];
                  final isSelected = _activeWord != null && _activeWord!.contains(item.uzbek);

                  return GestureDetector(
                    onTap: () => _onWordTap(item),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.warmCoral.withValues(alpha: 0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(item.emoji, style: const TextStyle(fontSize: 36)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.uzbek,
                                      style: AppTextStyles.headingSmall.copyWith(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "(${item.english})",
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.primaryViolet,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded, color: AppColors.warmCoral),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
