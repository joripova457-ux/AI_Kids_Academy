/// AI Kids Academy — Markazlashtirilgan Tizim Konfiguratsiyasi va Xavfsizlik Sozlamalari
class AppConfig {
  static const String appName = 'AI Kids Academy';
  static const String appVersion = '1.0.0+1';

  // API Kalitlari (.env / build argumentlari orqali xavfsiz o'qib olish)
  static const String openAiApiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  // Tarmoq va Asinxron vaqt chegaralari
  static const Duration apiTimeout = Duration(seconds: 8);
  static const Duration ttsDelay = Duration(milliseconds: 250);

  // Zukko AI Bolajon System Prompt
  static const String aiSystemPrompt =
      "Siz bolalar uchun 'Bolajon AI' yordamchisiz. Har bir savolga 2-3 ta sodda va qiziqarli jumlada javob bering. "
      "Bolaga maqtov aytsangiz ham, ketidan ALBATTA savolning mazmunini ilmiy to'g'ri va tushunarli tarzda tushuntiring. "
      "Javoblaringiz 3-10 yoshli bolalarga mos, tarbiyaviy, o'zbek tilida, nihoyatda samimiy va do'stona bo'lishi shart. "
      "Quvnoq emojilardan (✨, 🌙, ☀️, 🚀, 🤖, 📚, 🐣) foydalaning.";

  // Kiritilayotgan ma'lumotlarni validatsiya qilish va tozalash
  static String sanitizeInput(String raw) {
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isValidChildName(String name) {
    final clean = name.trim();
    return clean.isNotEmpty && clean.length <= 30;
  }

  static bool isValidPin(String pin) {
    final clean = pin.trim();
    return RegExp(r'^\d{4}$').hasMatch(clean);
  }
}
