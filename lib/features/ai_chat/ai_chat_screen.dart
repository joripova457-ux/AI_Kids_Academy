import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../services/ai_service.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// AI Chat bo'limi sahifasi (AI Mascot Interactive Chat with Voice & TTS)
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': "Salom Do'stim! Men Zukko AI yordamchingizman. Menga xohlagan savolingizni bering! 🤖✨"
    },
  ];

  bool _isRecordingVoice = false;
  bool _isAiThinking = false;
  int _stars = 0;

  final List<String> _quickPrompts = [
    "Menga jumboq so'ra ❓",
    "Nega osmon ko'k? 🌌",
    "Sehrli ertak ayt 📖",
    "Dinozavrlar haqida 🦕",
    "Matematikadan yordam ber 🔢",
  ];

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    AudioService().playClickSound();

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _messageController.clear();
      _isAiThinking = true;
    });

    final responseText = await AiService().getAiChatResponse(text);

    if (mounted) {
      AudioService().playSuccessSound();
      final updatedStars = await StorageService.instance.addModuleStars('ai_chat', 1);

      setState(() {
        _isAiThinking = false;
        _messages.add({'sender': 'ai', 'text': responseText});
        _stars = updatedStars;
      });

      // AI javobini ovozli o'qib berish (TTS)
      TtsService().speak(responseText);
    }
  }

  void _toggleVoiceRecord() {
    AudioService().playClickSound();
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
    });

    if (_isRecordingVoice) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isRecordingVoice) {
          setState(() {
            _isRecordingVoice = false;
          });
          _handleSendMessage("Menga qiziqarli jumboq ayt 🎙️");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      appBar: ChildAppBar(
        title: "🤖 AI Yordamchi Chat",
        starCount: _stars,
      ),
      body: Column(
        children: [
          // Mascot Mood Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.primaryViolet.withValues(alpha: 0.08),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.brightYellow,
                  child: Text(_isAiThinking ? '🤔' : '🤖', style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isAiThinking ? "Bolajon AI o'ylamoqda..." : "Bolajon AI tayyor! Ovozli tinglash ochiq 🔊",
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAi = msg['sender'] == 'ai';

                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    decoration: BoxDecoration(
                      color: isAi ? Colors.white : AppColors.primaryViolet,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isAi ? 4 : 20),
                        bottomRight: Radius.circular(isAi ? 20 : 4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            msg['text']!,
                            style: isAi
                                ? AppTextStyles.mascotText
                                : AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                          ),
                        ),
                        if (isAi) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              AudioService().playClickSound();
                              TtsService().speak(msg['text']!);
                            },
                            child: const Icon(
                              Icons.volume_up_rounded,
                              size: 20,
                              color: AppColors.primaryViolet,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Prompt Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, idx) {
                final prompt = _quickPrompts[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: AppColors.softTeal.withValues(alpha: 0.15),
                    label: Text(prompt, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                    onPressed: () => _handleSendMessage(prompt),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Input Bar with Voice Simulation Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleVoiceRecord,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isRecordingVoice ? Colors.redAccent : AppColors.brightYellow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRecordingVoice ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Savol bering...",
                      hintStyle: AppTextStyles.bodyMedium,
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    onSubmitted: (val) => _handleSendMessage(val),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _handleSendMessage(_messageController.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
