import '../constants/ai_quotes.dart';
import '../../services/tts_service.dart';

/// AI Tutor (Sun'iy Intellekt O'qituvchi Xizmati — 1 va 9-Talablar)
/// Har bir modul ichida bolaga yo'l-yo'riq ko'rsatadi,
/// to'g'ri va xato javoblarda samimiy motivatsiya beradi va ovozli o'qiydi.
class AiTutorService {
  static final AiTutorService _instance = AiTutorService._internal();
  factory AiTutorService() => _instance;
  AiTutorService._internal();

  /// To'g'ri javobda motivatsiya va ovozli o'qish
  String onCorrectAnswer({bool speakVoice = true}) {
    final quote = AiQuotes.getRandomPraise();
    if (speakVoice) {
      TtsService().speak(quote, language: 'uz-UZ');
    }
    return quote;
  }

  /// Noto'g'ri javobda dalda va ovozli o'qish
  String onWrongAnswer({bool speakVoice = true}) {
    final quote = AiQuotes.getRandomEncouragement();
    if (speakVoice) {
      TtsService().speak(quote, language: 'uz-UZ');
    }
    return quote;
  }

  /// Modul kirish motivatsiyasi
  String getModuleIntro(String moduleId, {bool speakVoice = false}) {
    String quote;
    switch (moduleId) {
      case 'alphabet':
        quote = AiQuotes.getRandomLetterIntro();
        break;
      case 'math':
        quote = "Bugun qiziqarli matematika misollarini birga yechamiz! 🔢✨";
        break;
      case 'english':
        quote = "Let's learn English together! Yangi so'zlarni tayyorla! 🇬🇧💬";
        break;
      case 'uzbek':
        quote = "Ona tilimizdagi chiroyli so'zlarni o'rganamiz! 🇺🇿📖";
        break;
      default:
        quote = AiQuotes.getRandomDailyMotivation();
    }
    if (speakVoice) {
      TtsService().speak(quote, language: 'uz-UZ');
    }
    return quote;
  }
}
