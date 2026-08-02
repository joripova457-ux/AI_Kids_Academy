import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Bolajon AI va ilova uchun Text-To-Speech (Ovozli o'qib berish) servisi
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal() {
    _initTts();
  }

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("uz-UZ");
      await _flutterTts.setSpeechRate(0.45); // Bolalarga mos ravon tezlik
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0); // Tabiiy va ravon ton

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
      });

      _isInitialized = true;
    } catch (_) {
      _isInitialized = false;
    }
  }

  /// Matnni ovozli o'qib berish (Web va Qurilmada ravon o'qish uchun bo'laklarga bo'lish)
  Future<void> speak(String text, {String language = 'uz-UZ'}) async {
    if (text.trim().isEmpty) return;
    try {
      if (!_isInitialized) {
        await _initTts();
      }
      await stop();
      await _flutterTts.setLanguage(language);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.0);

      // Emoji hamda ortiqcha belgilarni tozalash (TTS sifatini oshirish uchun)
      final cleanText = text
          .replaceAll(
            RegExp(
              r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
              unicode: true,
            ),
            '',
          )
          .trim();

      if (cleanText.isEmpty) return;

      // Web brauzer yoki mobil platformada uzilishlar va chaynalishlar bo'lmasligi uchun matnni bo'laklab o'qish
      if (kIsWeb || cleanText.length > 80) {
        final sentences = cleanText
            .split(RegExp(r'(?<=[.!?])\s+'))
            .where((s) => s.trim().isNotEmpty)
            .toList();

        if (sentences.length > 1) {
          for (final sentence in sentences) {
            await _flutterTts.speak(sentence.trim());
            await Future.delayed(const Duration(milliseconds: 250));
          }
          return;
        }
      }

      await _flutterTts.speak(cleanText);
    } catch (_) {
      // Platforma TTS qo'llab-quvvatlamasa ham ilova xatosiz ishlayveradi
    }
  }

  /// Ovozni to'xtatish
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (_) {}
  }
}
