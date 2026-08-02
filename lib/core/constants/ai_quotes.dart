import 'dart:math';

/// AI Kids Academy — Sun'iy Intellekt Motivatsiya va O'qituvchi Iboralari
class AiQuotes {
  static final Random _random = Random();

  /// Harflar modulidagi AI Tutor iboralari
  static const List<String> letterIntroQuotes = [
    "Bugun yangi va sehrli harflarni birgalikda o'rganamiz! 🔤✨",
    "Harflar bilimlaring kalitidir! Tayyormisan? 🚀",
    "Har bir harf senga yangi so'z sovg'a qiladi! 🎁",
  ];

  /// To'g'ri javob uchun AI maqtovlari
  static const List<String> praiseQuotes = [
    "Barakalla! Sen juda yaxshi ishlayapsan! 🌟",
    "Zo'r! Biliming kundan-kunga oshib boryapti! 🚀",
    "Ajoyib! Xuddi haqiqiy bilimdandek javob berding! 🎉",
    "Mukammal! Sen bilan faxrlanaman! 🏆",
    "Juda topqir ekansan! Shunday davom et! 👏",
  ];

  /// Noto'g'ri javob uchun AI dalda va motivatsiyalari
  static const List<String> encouragementQuotes = [
    "Yana bir bor urinib ko'r, sen buni uddalaysan! 💡",
    "Xafa bo me! Har bir xato yangi saboqdir! 🌱",
    "Men senga ishonaman! Yana diqqat bilan qara. 🤗",
    "Hechqisi yo'q, bilim olish takrorlashdan boshlanadi! ✨",
    "Diyoringni jamla, keyingisida albatta to'g'ri topasan! 💪",
  ];

  /// Kunlik motivatsion iboralar (AI Motivation System)
  static const List<String> dailyMotivationQuotes = [
    "Bugun juda yaxshi ishlading! 🌈",
    "Faqat bitta topshiriq qoldi! O'zingni ko'rsat! ⚡",
    "Sen yangi rekord o'rnatding! Qoyil! 🏆",
    "Yana davom et, sen bugungi qahramonsan! 🦸",
    "Biliming har kuni yulduzdek porlamoqda! ⭐️",
  ];

  /// Random ibora olish funksiyalari
  static String getRandomPraise() =>
      praiseQuotes[_random.nextInt(praiseQuotes.length)];

  static String getRandomEncouragement() =>
      encouragementQuotes[_random.nextInt(encouragementQuotes.length)];

  static String getRandomDailyMotivation() =>
      dailyMotivationQuotes[_random.nextInt(dailyMotivationQuotes.length)];

  static String getRandomLetterIntro() =>
      letterIntroQuotes[_random.nextInt(letterIntroQuotes.length)];
}
