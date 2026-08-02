import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../core/services/content_filter_service.dart';
import '../services/storage_service.dart';

/// 7-BOSQICH Gemini API Service Interface
abstract class AIService {
  Future<String> getAiChatResponse(
    String userPrompt, {
    List<Map<String, String>>? conversationHistory,
    int childAge = 6,
  });

  Future<Map<String, dynamic>> generateStoryChapter({
    required String theme,
    required String hero,
    required int step,
    int? userChoice,
    List<Map<String, String>>? contextHistory,
    int childAge = 6,
  });
}

/// 7-BOSQICH Gemini AI Engine Service (With Advanced Diagnostics & Resilient Endpoints)
class AiService implements AIService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  final Random _random = Random();

  String? _customGeminiApiKey;
  String? _lastChatResponse;
  final Set<String> _recentStoryTitles = {};

  // Request limits
  static const int maxDailyChatRequests = 50;
  static const int maxDailyStoryRequests = 20;

  void setGeminiApiKey(String key) => _customGeminiApiKey = key;

  /// API Key Resolution Order:
  /// 1. --dart-define=GEMINI_API_KEY=xxx
  /// 2. Runtime custom set key (_customGeminiApiKey)
  /// 3. Saved Key in StorageService (SharedPreferences)
  /// 4. AppConfig fallback
  String get _activeGeminiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    if (envKey.isNotEmpty && envKey != "YOUR_GEMINI_API_KEY_HERE") return envKey;
    
    if (_customGeminiApiKey != null &&
        _customGeminiApiKey!.isNotEmpty &&
        _customGeminiApiKey != "YOUR_GEMINI_API_KEY_HERE") {
      return _customGeminiApiKey!;
    }

    try {
      final savedKey = StorageService.instance.getCustomGeminiApiKey();
      if (savedKey.isNotEmpty && savedKey != "YOUR_GEMINI_API_KEY_HERE") {
        return savedKey;
      }
    } catch (_) {}

    final configKey = AppConfig.geminiApiKey;
    if (configKey.isNotEmpty && configKey != "YOUR_GEMINI_API_KEY_HERE") {
      return configKey;
    }

    return "";
  }

  // ==================== 1. AI CHAT — GEMINI REAL INTEGRATION ====================

  @override
  Future<String> getAiChatResponse(
    String userPrompt, {
    List<Map<String, String>>? conversationHistory,
    int childAge = 6,
  }) async {
    // A. 1-Bosqich: Input Content Filter
    final filterResult = ContentFilterService().filterInput(userPrompt);
    if (!filterResult.isSafe) {
      if (kDebugMode) {
        debugPrint('[GEMINI DIAGNOSTIC] Input blocked by safety filter: "${filterResult.warningMessage}"');
      }
      return filterResult.warningMessage ??
          "Men faqat shirin va tarbiyaviy so'zlardan foydalanaman! ✨";
    }

    final cleanPrompt = filterResult.filteredText ?? userPrompt;
    final apiKey = _activeGeminiKey;

    if (kDebugMode) {
      debugPrint('[GEMINI DIAGNOSTIC] 🔍 Checking API Key status...');
      debugPrint('[GEMINI DIAGNOSTIC] Active Key Present: ${apiKey.isNotEmpty} (Key Length: ${apiKey.length})');
    }

    if (apiKey.isEmpty) {
      if (kDebugMode) {
        debugPrint(
            '[GEMINI DIAGNOSTIC] ⚠️ GEMINI_API_KEY is missing/empty!\n'
            '👉 Falling back to Smart Offline Engine.\n'
            '👉 To fix: Pass --dart-define=GEMINI_API_KEY=YOUR_KEY or update Parent Gate settings.');
      }
      return _getSmartOfflineChatResponse(cleanPrompt);
    }

    // B. Daily Limit Check & Real Gemini Request
    final currentChatRequests = StorageService.instance.getDailyChatRequestCount();
    if (currentChatRequests < maxDailyChatRequests) {
      try {
        await StorageService.instance.incrementDailyChatRequestCount();
        final newCount = currentChatRequests + 1;

        if (kDebugMode) {
          final estCost = (newCount * 0.0001).toStringAsFixed(4);
          debugPrint(
              '[GEMINI DIAGNOSTIC] 🚀 Sending Request #$newCount/day to Gemini API. Est Cost: \$$estCost');
        }

        final responseText = await _callGeminiChatApi(
          apiKey: apiKey,
          prompt: cleanPrompt,
          history: conversationHistory ?? [],
          childAge: childAge,
        );

        if (responseText != null && responseText.isNotEmpty) {
          // Output Content Filter
          final outputFilter = ContentFilterService().filterOutput(responseText);
          if (outputFilter.isSafe && outputFilter.filteredText != null) {
            _lastChatResponse = outputFilter.filteredText!;
            if (kDebugMode) {
              debugPrint('[GEMINI DIAGNOSTIC] ✅ SUCCESS! Received response from Gemini: "$responseText"');
            }
            return outputFilter.filteredText!;
          }
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('[GEMINI DIAGNOSTIC] ❌ Exception during API call: $e');
          debugPrint(stackTrace.toString());
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint('[GEMINI DIAGNOSTIC] ⚠️ Daily request limit ($maxDailyChatRequests) reached. Using Offline Fallback.');
      }
    }

    // C. Offline Smart Response Generator (Fallback)
    if (kDebugMode) {
      debugPrint('[GEMINI DIAGNOSTIC] 🔄 Executing Smart Offline Fallback Generator for: "$cleanPrompt"');
    }
    return _getSmartOfflineChatResponse(cleanPrompt);
  }

  /// Resilient Direct REST API call to Gemini 1.5 Flash & Gemini Pro
  Future<String?> _callGeminiChatApi({
    required String apiKey,
    required String prompt,
    required List<Map<String, String>> history,
    required int childAge,
  }) async {
    final systemInstructionText =
        "Siz $childAge yoshli bola uchun 'Bolajon AI' do'stona va oqil yordamchisiz.\n"
        "QAT'IY QOIDALAR:\n"
        "1. Faqat bolaga mos, 2-4 gapli, sodda va quvnoq tilda o'zbekcha javob bering.\n"
        "2. Har bir aniq va ilmiy savolga (masalan 'quyoshning vazifasi nima', '2+2', 'oy nima') ALBATTA aniq, ilmiy to'g'ri va tushunarli javob bering!\n"
        "3. Nomaqbul yoki xavfli mavzularga muloyimlik bilan javob bermang va mavzuni yaxshilikka o'zgartiring.\n"
        "4. Boladan SHAXSIY MA'LUMOT (ism, familiya, manzil, telefon, PIN) so'ramang va agar bola bersa saqlamang!\n"
        "5. Emojilardan (✨, 🚀, 🤖, 📚, ☀️) unumli foydalaning.";

    final contents = <Map<String, dynamic>>[];
    final recentHistory = history.length > 5 ? history.sublist(history.length - 5) : history;

    for (final msg in recentHistory) {
      final role = msg['sender'] == 'user' ? 'user' : 'model';
      final text = msg['text'] ?? '';
      if (text.isNotEmpty) {
        contents.add({
          'role': role,
          'parts': [
            {'text': text}
          ]
        });
      }
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': prompt}
      ]
    });

    // 1. Try Gemini 1.5 Flash Endpoint
    final urlFlash = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    final bodyFlash = jsonEncode({
      'contents': contents,
      'systemInstruction': {
        'parts': [
          {'text': systemInstructionText}
        ]
      },
      'safetySettings': [
        {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_LOW_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_LOW_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_LOW_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_LOW_AND_ABOVE'}
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 250,
      }
    });

    if (kDebugMode) {
      debugPrint('[GEMINI DIAGNOSTIC] Attempting HTTP POST to gemini-1.5-flash...');
    }

    try {
      final response = await http
          .post(
            urlFlash,
            headers: {'Content-Type': 'application/json'},
            body: bodyFlash,
          )
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        debugPrint('[GEMINI DIAGNOSTIC] Response Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
        if (text != null && text.trim().isNotEmpty) {
          return text.trim();
        }
      } else {
        if (kDebugMode) {
          debugPrint('[GEMINI DIAGNOSTIC] ⚠️ Flash endpoint status: ${response.statusCode}, Body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GEMINI DIAGNOSTIC] ⚠️ Flash endpoint request failed: $e');
      }
    }

    // 2. Fallback to Gemini Pro Endpoint with System Prompt inside Content
    final urlPro = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );

    final fallbackContents = [
      {
        'role': 'user',
        'parts': [
          {'text': "$systemInstructionText\n\nSavol: $prompt"}
        ]
      }
    ];

    final bodyPro = jsonEncode({
      'contents': fallbackContents,
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 250,
      }
    });

    if (kDebugMode) {
      debugPrint('[GEMINI DIAGNOSTIC] Attempting Fallback HTTP POST to gemini-pro...');
    }

    try {
      final responsePro = await http
          .post(
            urlPro,
            headers: {'Content-Type': 'application/json'},
            body: bodyPro,
          )
          .timeout(const Duration(seconds: 15));

      if (responsePro.statusCode == 200) {
        final data = jsonDecode(utf8.decode(responsePro.bodyBytes));
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
        if (text != null && text.trim().isNotEmpty) {
          if (kDebugMode) {
            debugPrint('[GEMINI DIAGNOSTIC] ✅ Fallback Gemini Pro SUCCESS!');
          }
          return text.trim();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GEMINI DIAGNOSTIC] ❌ Fallback Gemini Pro failed: $e');
      }
    }

    return null;
  }

  // ==================== 2. AI STORY — GEMINI REAL INTEGRATION ====================

  @override
  Future<Map<String, dynamic>> generateStoryChapter({
    required String theme,
    required String hero,
    required int step,
    int? userChoice,
    List<Map<String, String>>? contextHistory,
    int childAge = 6,
  }) async {
    final apiKey = _activeGeminiKey;
    final currentStoryRequests = StorageService.instance.getDailyStoryRequestCount();

    if (apiKey.isNotEmpty && currentStoryRequests < maxDailyStoryRequests) {
      try {
        await StorageService.instance.incrementDailyStoryRequestCount();
        final newCount = currentStoryRequests + 1;

        if (kDebugMode) {
          final estCost = (newCount * 0.0002).toStringAsFixed(4);
          debugPrint(
              '[GEMINI DIAGNOSTIC Story] Request #$newCount/day. Est. Cost: \$$estCost');
        }

        final storyResult = await _callGeminiStoryApi(
          apiKey: apiKey,
          theme: theme,
          hero: hero,
          step: step,
          userChoice: userChoice,
          childAge: childAge,
        );

        if (storyResult != null && storyResult.containsKey('content')) {
          final contentFilter =
              ContentFilterService().filterOutput(storyResult['content'] as String);
          if (contentFilter.isSafe) {
            return storyResult;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[GEMINI DIAGNOSTIC Story Error] Falling back to offline story generator: $e');
        }
      }
    }

    // Offline Smart Story Generator (Fallback)
    return _generateOfflineStoryChapter(
      theme: theme,
      hero: hero,
      step: step,
      userChoice: userChoice,
    );
  }

  Future<Map<String, dynamic>?> _callGeminiStoryApi({
    required String apiKey,
    required String theme,
    required String hero,
    required int step,
    int? userChoice,
    required int childAge,
  }) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    String prompt = "";
    if (step == 1) {
      final place = storyPlaces[_random.nextInt(storyPlaces.length)];
      final problem = storyProblems[_random.nextInt(storyProblems.length)];
      prompt =
          "Mavzu: '$theme', Bosh qahramon: '$hero'. Makon: '$place'. Muammo/Hodisa: '$problem'.\n"
          "Vazifa: $childAge yoshli bola uchun ertakning 1-qismini yarating.\n"
          "Format JSON holda berilishi SHART:\n"
          "{\n"
          "  \"title\": \"Ertak sarlavhasi (emojilar bilan)\",\n"
          "  \"content\": \"2-4 gapdan iborat qiziqarli ertak matni\",\n"
          "  \"option1\": \"1-tanlov varianti (masalan: Oltin kalitni ishlatdi)\",\n"
          "  \"option2\": \"2-tanlov varianti (masalan: Do'stlarini yordamga chaqirdi)\"\n"
          "}";
    } else {
      final choiceText = userChoice == 1
          ? storyEventsChoice1[_random.nextInt(storyEventsChoice1.length)]
          : storyEventsChoice2[_random.nextInt(storyEventsChoice2.length)];
      prompt =
          "Mavzu: '$theme', Bosh qahramon: '$hero'. Bola tanlagan yo'l: '$choiceText'.\n"
          "Vazifa: $childAge yoshli bola uchun ertakning 2-qismini (yakuniy g'alaba) yarating.\n"
          "Format JSON holda berilishi SHART:\n"
          "{\n"
          "  \"title\": \"Sehrli Yakun Sarlavhasi\",\n"
          "  \"content\": \"2-4 gapdan iborat ertak yakuni va 5 ta yulduzcha sovrini\",\n"
          "  \"moral\": \"Ertakdan olinadigan 1 gapli chiroyli tarbiyaviy xulosa\"\n"
          "}";
    }

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'systemInstruction': {
        'parts': [
          {
            'text':
                "Siz bolalar uchun sehrli ertaklar to'quvchi zukkosiz. Har doim javobni to'g'ri va xatosiz JSON formatida berishingiz kerak."
          }
        ]
      },
      'generationConfig': {
        'temperature': 0.8,
        'responseMimeType': 'application/json',
        'maxOutputTokens': 350,
      }
    });

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final jsonStr =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final parsedMap = jsonDecode(jsonStr) as Map<String, dynamic>;
        return parsedMap;
      }
    }
    return null;
  }

  // ==================== 3. OFFLINE DATASETS & SMART FALLBACK ENGINES ====================

  static const List<String> storyHeroes = [
    "Aqlvoy Bot 🤖", "Jasur Arslon 🦁", "Zukko Qizaloq 👧", "Sehrli Qushcha 🕊️",
    "Quvnoq Quyoncha 🐰", "Polvon Ayiqvoy 🐻", "Bilag'on Sichqoncha 🐭", "Aqlli Delfin 🐬"
  ];

  static const List<String> storyPlaces = [
    "Sehrli O'rmon 🌲", "Kosmik Sarguzasht 🚀", "Dinozavrlar Oroli 🦕", "Suv Osti Qirolligi 🐬"
  ];

  static const List<String> storyProblems = [
    "yerda sirli porlayotgan oltin tugmaga duch kelibdi 🌟",
    "yo'qolgan kamalak kalitini izlab yo'lga chiqibdi 🔑"
  ];

  static const List<String> storyEventsChoice1 = [
    "Oltin tugmani caddiyat bilan bosdi va sehrli eshik ochildi! ✨",
    "Kamalak kaliti bilan sehrli qutini ochdi va u yerdan nurlik shar chiqdi! 🔮"
  ];

  static const List<String> storyEventsChoice2 = [
    "Ehtiyotkorlik bilan aylanib o'tib, sadoqatli do'stini yordamga chaqirdi! 🤝",
    "Donolik bilan jumboqni o'ylab ko'rdi va ikkinchi to'g'ri yo'lni tanladi! 💡"
  ];

  static const List<String> storyMorals = [
    "Jasorat va qiziquvchanlik har doim yangi kashfiyotlarga olib keladi! 🏆",
    "Boshqalarga yordam berish — eng katta ezgulikdir! ❤️"
  ];

  Future<String> _getSmartOfflineChatResponse(String userPrompt) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prompt = userPrompt.toLowerCase().trim();

    if (prompt.contains("quyosh") && (prompt.contains("vazifa") || prompt.contains("nima") || prompt.contains("bajaradi"))) {
      return "Quyosh yerimizga issiqlik, yorug'lik va hayot beruvchi ulkan yulduzdir! ☀️ U o'simliklarning o'sishi va barcha tirik mavjudotlar yashashi uchun eng asosiy quvvat manbaidir.";
    } else if (prompt.contains("quyosh")) {
      return "Quyosh — bizga eng yaqin bo'lgan porloq yulduzdir! ☀️ U har kuni ertalab chiqib yer yuzini yoritadi va isitadi.";
    } else if (prompt.contains("oy nima") || prompt.contains("oy haqida")) {
      return "Oy — Yerimizning yagona tabiiy yo'ldoshidir. 🌙 U o'zidan nur sochmaydi, balki Quyosh nurini aks ettirib kechasi osmonni yoritadi!";
    } else if (prompt.contains("2+2") || prompt.contains("2 + 2")) {
      return "2 ga 2 ni qo'shsak 4 bo'ladi! 🔢 🍎🍎 + 🍎🍎 = 🍎🍎🍎🍎 Jami 4 ta olma bo'ladi!";
    } else if (prompt.contains("suv nima") || prompt.contains("suv haqida")) {
      return "Suv — barcha tirik jonzotlar va o'simliklar uchun hayot manbaidir! 💧 U daryo va yomg'ir bo'lib oqadi va tanamizni tetiklashtiradi.";
    } else if (prompt.contains("qush") && prompt.contains("uchadi")) {
      return "Qushlarning suyaklari yengil va ichi bo'sh, qanotlari hamda patlari esa havo oqimini ushlab ularga uchishga yordam beradi! 🕊️";
    } else if (prompt.contains("dinozavr")) {
      return "Dinozavrlar millionlab yillar avval Yer yuzida yashagan ulkan jonzotlardir! 🦕 T-Rex eng kuchli yirtqich bo'lgan! 🦖";
    } else if (prompt.contains("salom") || prompt.contains("assalomu") || prompt.contains("qalay")) {
      return _getRandom([
        "Salom mening zukko do'stim! 🤖 Men Bolajon AI yordamchingizman. Bugun qaysi bilimlarni egallaymiz? ✨",
        "Assalomu alaykum! 🌟 Kayfiyatingiz alo deb umid qilaman. Keling, birgalikda sarguzasht boshlaymiz!"
      ]);
    } else if (prompt.contains("jumboq") || prompt.contains("topishmoq")) {
      return _getRandom([
        "Qani top-chi: Qishi-yozi bir kiyimda, oppoq qorlar bag'rida? 🌲 (Javob: Archa!)",
        "Oyoqsiz yuradi, og'izsiz so'zlaydi, hamma unga qaraydi? ⏰ (Javob: Soat!)"
      ]);
    } else {
      return _getRandom([
        "Juda zo'r va aqlli savol berdingiz! 🌟 Bilasizmi, har bir narsani bilishga qiziqish kishini zukkoroq qiladi. Keling, buni birgalikda o'rganamiz! 🚀",
        "Ajoyib fikr! 💡 Bu savol atrofiimizdagi tabiat va ilm-fan bilan bog'liq. Izlanishda va savol berishda davom eting! ⭐"
      ]);
    }
  }

  Map<String, dynamic> _generateOfflineStoryChapter({
    required String theme,
    required String hero,
    required int step,
    int? userChoice,
  }) {
    if (step == 1) {
      final place = storyPlaces[_random.nextInt(storyPlaces.length)];
      final problem = storyProblems[_random.nextInt(storyProblems.length)];
      final title = "$hero Ning $theme Sarguzashti 📖";
      _recentStoryTitles.add(title);

      return {
        'title': title,
        'content':
            "Bir bor ekan, bir yo'q ekan, $place hududida quvnoq $hero yashagan ekan. Kunlardan bir kuni u $problem!",
        'option1': storyEventsChoice1[_random.nextInt(storyEventsChoice1.length)],
        'option2': storyEventsChoice2[_random.nextInt(storyEventsChoice2.length)],
      };
    } else {
      final moral = storyMorals[_random.nextInt(storyMorals.length)];
      final event = userChoice == 1
          ? storyEventsChoice1[_random.nextInt(storyEventsChoice1.length)]
          : storyEventsChoice2[_random.nextInt(storyEventsChoice2.length)];

      return {
        'title': "Sehrli Olamga Kirish! ✨",
        'content':
            "$hero jasorat ko'rsatdi! $event Natijada barcha do'stlar quvonchga to'ldi va unga 5 ta oltin yulduz taqdim etildi! ⭐⭐⭐⭐⭐",
        'moral': moral,
      };
    }
  }

  String _getRandom(List<String> items) {
    if (items.isEmpty) return "";
    String chosen;
    do {
      chosen = items[_random.nextInt(items.length)];
    } while (chosen == _lastChatResponse && items.length > 1);
    return chosen;
  }
}
