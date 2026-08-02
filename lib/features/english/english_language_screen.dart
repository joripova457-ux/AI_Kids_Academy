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

/// 7-BOSQICH English Language Screen (160+ Vocabulary Words + Unlimited Random Quiz + Categories)
class EnglishLanguageScreen extends StatefulWidget {
  const EnglishLanguageScreen({super.key});

  @override
  State<EnglishLanguageScreen> createState() => _EnglishLanguageScreenState();
}

class _EnglishLanguageScreenState extends State<EnglishLanguageScreen> {
  final List<VocabularyItem> _allWords = VocabularyDataset.items;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Barchasi';
  String _searchQuery = '';
  int _stars = 0;
  String? _activeWord;
  bool _showCelebration = false;
  bool _isQuizMode = false;

  // Quiz state
  late List<VocabularyItem> _quizDeck;
  int _quizIndex = 0;
  int _quizScore = 0;
  List<String> _currentQuizOptions = [];
  String? _selectedQuizAnswer;
  bool _isQuizAnswered = false;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getModuleStars('english');
    _initQuizDeck();
  }

  void _initQuizDeck() {
    _quizDeck = List<VocabularyItem>.from(_allWords)..shuffle();
    _quizIndex = 0;
    _quizScore = 0;
    _isQuizAnswered = false;
    _selectedQuizAnswer = null;
    _generateQuizOptions();
  }

  void _generateQuizOptions() {
    if (_quizDeck.isEmpty) return;
    final currentItem = _quizDeck[_quizIndex % _quizDeck.length];
    final correctAnswer = currentItem.uzbek;

    final distractors = _allWords
        .where((w) => w.uzbek != correctAnswer)
        .map((w) => w.uzbek)
        .toSet()
        .toList()
      ..shuffle();

    final options = <String>[correctAnswer, ...distractors.take(3)]..shuffle();
    setState(() {
      _currentQuizOptions = options;
      _selectedQuizAnswer = null;
      _isQuizAnswered = false;
    });
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
          item.english.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.uzbek.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onCardTap(VocabularyItem item) async {
    AudioService().playClickSound();
    AudioService().playSuccessSound();
    TtsService().speak(item.english, language: 'en-US');

    final updatedStars = await StorageService.instance.addModuleStars('english', 1);
    if (mounted) {
      setState(() {
        _activeWord = "${item.englishWithEmoji} (${item.uzbek})";
        _stars = updatedStars;
        _showCelebration = true;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _showCelebration = false);
      });
    }
  }

  void _checkQuizAnswer(String selectedOption) async {
    if (_isQuizAnswered) return;

    final currentItem = _quizDeck[_quizIndex % _quizDeck.length];
    final isCorrect = selectedOption == currentItem.uzbek;

    setState(() {
      _selectedQuizAnswer = selectedOption;
      _isQuizAnswered = true;
    });

    if (isCorrect) {
      AudioService().playSuccessSound();
      AudioService().playStarEarnSound();
      _quizScore++;
      final updatedStars = await StorageService.instance.addModuleStars('english', 2);
      if (mounted) {
        setState(() {
          _stars = updatedStars;
          _showCelebration = true;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) setState(() => _showCelebration = false);
        });
      }
    } else {
      AudioService().playErrorSound();
    }
  }

  void _nextQuizQuestion() {
    AudioService().playClickSound();
    setState(() {
      _quizIndex++;
      if (_quizIndex >= _quizDeck.length) {
        _quizDeck.shuffle();
        _quizIndex = 0;
      }
      _generateQuizOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = VocabularyDataset.categories;

    return ConfettiOverlay(
      isTriggered: _showCelebration,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🇬🇧 English for Kids (160+ So'z)",
          starCount: _stars,
        ),
        body: Column(
          children: [
            // Top Mode Switch Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.skyBlue.withValues(alpha: 0.12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isQuizMode
                          ? "🎯 Quiz Rejim (Natija: $_quizScore ta to'g'ri)"
                          : "📚 Lug'at Bo'limi (${_filteredWords.length} ta so'z)",
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      AudioService().playClickSound();
                      setState(() {
                        _isQuizMode = !_isQuizMode;
                        if (_isQuizMode) _generateQuizOptions();
                      });
                    },
                    icon: Icon(_isQuizMode ? Icons.menu_book_rounded : Icons.quiz_rounded, size: 18),
                    label: Text(_isQuizMode ? "Lug'at" : "Quiz Test 🎯"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryViolet,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),

            if (!_isQuizMode) ...[
              // Search & Categories Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "So'z qidirish (En / Uz)... 🔍",
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
                        selectedColor: AppColors.skyBlue,
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

              MascotBubble(
                speechText: _activeWord != null
                    ? "'$_activeWord' eshitildi! 🎉 +1 ⭐️"
                    : "Kartochkani bosing va inglizcha talaffuzni eshiting! 🇬🇧",
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: _filteredWords.length,
                  itemBuilder: (context, index) {
                    final item = _filteredWords[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.emoji, style: const TextStyle(fontSize: 42)),
                            const SizedBox(height: 6),
                            Text(
                              item.english,
                              style: AppTextStyles.headingSmall.copyWith(
                                color: AppColors.primaryViolet,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              item.uzbek,
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              // QUIZ MODE
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      MascotBubble(
                        speechText: "Inglizcha so'zning o'zbekcha ma'nosini toping! 🎯",
                      ),
                      const SizedBox(height: 24),

                      if (_quizDeck.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _quizDeck[_quizIndex % _quizDeck.length].emoji,
                                style: const TextStyle(fontSize: 64),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _quizDeck[_quizIndex % _quizDeck.length].english,
                                style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryViolet),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryViolet, size: 28),
                                onPressed: () {
                                  TtsService().speak(
                                    _quizDeck[_quizIndex % _quizDeck.length].english,
                                    language: 'en-US',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Column(
                          children: _currentQuizOptions.map((opt) {
                            final currentItem = _quizDeck[_quizIndex % _quizDeck.length];
                            final isSelected = _selectedQuizAnswer == opt;
                            final isCorrect = opt == currentItem.uzbek;

                            Color btnColor = Colors.white;
                            if (_isQuizAnswered) {
                              if (isCorrect) {
                                btnColor = Colors.greenAccent.shade200;
                              } else if (isSelected) {
                                btnColor = Colors.redAccent.shade100;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnColor,
                                  foregroundColor: AppColors.textDark,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => _checkQuizAnswer(opt),
                                child: Text(
                                  opt,
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        if (_isQuizAnswered) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brightYellow,
                              foregroundColor: AppColors.textDark,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: _nextQuizQuestion,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text("Keyingi Savol 🚀", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
