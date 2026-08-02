import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';

/// AI Kids Academy LLM & Kid-Friendly AI Engine Service
/// OpenAI (ChatGPT) hamda Google Gemini API qo'llab-quvvatlovi,
/// maxsus System Prompt va Offline Smart Fallback tizimi bilan.
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  final Random _random = Random();

  // API Kalitlari sozlamasi (AppConfig'dan o'qib olinadi yoki runtime berilishi mumkin)
  String? _customOpenAiApiKey;
  String? _customGeminiApiKey;

  void setOpenAiApiKey(String key) => _customOpenAiApiKey = key;
  void setGeminiApiKey(String key) => _customGeminiApiKey = key;

  String get _activeOpenAiKey =>
      (_customOpenAiApiKey != null && _customOpenAiApiKey!.isNotEmpty)
          ? _customOpenAiApiKey!
          : AppConfig.openAiApiKey;

  String get _activeGeminiKey =>
      (_customGeminiApiKey != null && _customGeminiApiKey!.isNotEmpty)
          ? _customGeminiApiKey!
          : AppConfig.geminiApiKey;

  /// AI Chat orqali bolalarcha va ilmiy to'g'ri javob olish (API + Smart Offline Engine)
  Future<String> getAiChatResponse(String userPrompt) async {
    final cleanPrompt = AppConfig.sanitizeInput(userPrompt);

    // 1. Agar OpenAI API kaliti mavjud bo'lsa
    if (_activeOpenAiKey.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_activeOpenAiKey',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {'role': 'system', 'content': AppConfig.aiSystemPrompt},
              {'role': 'user', 'content': cleanPrompt},
            ],
            'max_tokens': 180,
            'temperature': 0.7,
          }),
        ).timeout(AppConfig.apiTimeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final content = data['choices']?[0]?['message']?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            return content.trim();
          }
        }
      } catch (_) {}
    }

    // 2. Agar Google Gemini API kaliti mavjud bo'lsa
    if (_activeGeminiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_activeGeminiKey',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': "${AppConfig.aiSystemPrompt}\n\nFoydalanuvchi savoli: $cleanPrompt"}
                ]
              }
            ]
          }),
        ).timeout(AppConfig.apiTimeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final content = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
          if (content != null && content.isNotEmpty) {
            return content.trim();
          }
        }
      } catch (_) {}
    }

    // 3. Offline / Smart Fallback Engine (Savol mazmuniga rostdan ham ilmiy va sodda javoblar)
    await Future.delayed(const Duration(milliseconds: 600));

    final prompt = userPrompt.toLowerCase().trim();

    if (prompt.contains("oy") || prompt.contains("oy nima")) {
      return "Ajoyib savol! Oy — bu Yergacha bo'lgan eng yaqin tabiiy yo'ldoshimizdir. 🌙 U o'zidan nur sochmaydi, balki Quyosh nurini o'zida aks ettirib, kechasi osmonimizni yoritadi!";
    }

    if (prompt.contains("yulduz") || prompt.contains("yulduzlar")) {
      return "Juda aqlli savol! Yulduzlar — koinotdagi ulkan porloq gaz sharlaridir. 🌟 Bizning Quyoshimiz ham aslida Yerga eng yaqin turgan yulduz hisoblanadi!";
    }

    if (prompt.contains("suv") || prompt.contains("suv nima")) {
      return "Suv — bu barcha tirik mavjudotlar uchun hayot manbaidir! 💧 U daryolarda oqadi, bulutlardan yomg'ir bo'lib yog'adi va tanamizga kuch-quvvat beradi.";
    }

    if (prompt.contains("yomg'ir") || prompt.contains("qor")) {
      return "Yomg'ir — bu daryo va dengizlardan bug'lanib osmonga ko'tarilgan suvlardir! 🌧️ Bulutlar suv tomchilariga to'lgach, ular pastga yog'ib, o'simlik va daraxtlarni sug'oradi.";
    }

    if (prompt.contains("qush") || prompt.contains("uchadi")) {
      return "Qushlar — yengil patlari va kuchli qanotlari bor jonivorlardir! 🕊️ Ularning suyaklari yengil va ichi bo'sh bo'lgani uchun osmonda bemalol ucha olishadi.";
    }

    if (prompt.contains("salom") || prompt.contains("assalomu")) {
      return "Salom mening zukko do'stim! 🤖 Men Bolajon AI yordamchingizman. Bugun koinot, tabiat va hayvonlar haqida nimani o'rganamiz? ✨";
    }

    if (prompt.contains("ertak") || prompt.contains("hikoya")) {
      return "Bir bor ekan, bir yo'q ekan... 🌲 Sichqoncha va Ayiqvoy degan qalin do mezoniy do'stlar bo'lgan ekan. Ular har kuni o'rmonda bir-biriga yordam berib yashasharkan! 🐻🐭";
    }

    if (prompt.contains("dinozavr")) {
      return "Dinozavrlar millionlab yillar avval Yer yuzida yashagan ulkan jonzotlardir! 🦕 Ularning ba'zilari o't-o'lan yegan, Tirannozavr (T-Rex) esa eng kuchlisi bo'lgan! 🦖";
    }

    if (prompt.contains("osmon") || prompt.contains("quyosh")) {
      return "Quyosh yerimizga issiqlik va yorug'lik beradi! ☀️ Quyosh nuri havodagi zarralardan sochilib, osmonni chiroyli ko'k rangga boyaydi! 🌌";
    }

    if (prompt.contains("jumboq") || prompt.contains("topishmoq")) {
      final riddles = [
        "Qani top-chi: Qishi-yozi bir kiyimda, oppoq qorlar bag'rida? 🌲 (Javob: Archa!)",
        "Oyoqsiz yuradi, og'izsiz so'zlaydi, hamma unga qaraydi? ⏰ (Javob: Soat!)",
        "Uzun bo'yin, sariq po'stin, eng baland daraxtga ham etar bo'yi? 🦒 (Javob: Jirafa!)",
      ];
      return riddles[_random.nextInt(riddles.length)];
    }

    if (prompt.contains("matematika") || prompt.contains("hisob")) {
      return "Matematika — sonlar va mantiqiy sehrli fan! 🔢 Masalan, 3 ta olma va 2 ta olmani qo'shsangiz, jami 5 ta olma bo'ladi! 🍎🍎🍎 + 🍎🍎 = 🍎🍎🍎🍎🍎";
    }

    if (prompt.contains("ingliz") || prompt.contains("english")) {
      return "Ingliz tilida salomlashish 'Hello!' 🇬🇧, raxmat deyish esa 'Thank you!' deyiladi! Yangi so'zlarni o'rganish juda maroqli! 🌟";
    }

    final defaultAnswers = [
      "Juda zo'r va aqlli savol berdingiz! 🌟 Bilasizmi, har bir narsani bilishga qiziqish kishini zukkoroq qiladi. Keling, buni birgalikda o'rganamiz! 🚀",
      "Ajoyib fikr! 💡 Bu savol atrofiimizdagi tabiat va ilm-fan bilan bog'liq. Izlanishda davom eting! ⭐",
      "Wau, siz juda sinchkovsiz! 🚀 Buni bilish kelajakda katta olim bo'lishingizga yordam beradi! ✨",
    ];
    return defaultAnswers[_random.nextInt(defaultAnswers.length)];
  }

  /// AI Ertak Generator uchun interaktiv ertak qismlarini yaratish
  Future<Map<String, dynamic>> generateStoryChapter({
    required String theme,
    required String hero,
    required int step,
    int? userChoice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (step == 1) {
      return {
        'title': "$theme: $hero Ning Sehrli Sarguzashti 📖",
        'content':
            "Bir bor ekan, bir yo'q ekan, $theme hududida quvnoq $hero yashagan ekan. Kunlardan bir kuni u yo'lda ketayotib, yerda sirli porlayotgan tugmaga duch kelibdi! 🌟",
        'option1': "Tugmani bosib ko'rish 🔘",
        'option2': "Tugmani aylanib o'tib olg'a yurish 🚶‍♂️",
      };
    } else {
      if (userChoice == 1) {
        return {
          'title': "Sehrli Olamga Kirish! ✨",
          'content':
              "$hero tugmani bosgan edi, birdan atrof kamalak ranglariga burandi va u yerda katta sehrli xazina qutisi paydo bo'ldi! Quti ichida ko'plab yulduzchalar bor edi! ⭐⭐⭐",
          'moral': "Jasorat va qiziquvchanlik har doim yangi kashfiyotlarga olib keladi! 🏆",
        };
      } else {
        return {
          'title': "Sadoqatli Do'stlar! 🤝",
          'content':
              "$hero yo'lida davom etdi va qiyinchilikda qolgan kichik qushchaga yordam berdi. Qushcha javoban unga sehrli oltin yulduz sovg'a qildi! 🐣⭐",
          'moral': "Boshqalarga yordam berish — eng katta ezgulikdir! ❤️",
        };
      }
    }
  }
}
