import 'package:flutter/foundation.dart';

/// 7-BOSQICH Content Filter Service (Xavfsizlik va Ma'lumotlar Filtrlash Tizimi)
/// Dual-Layer Content Filter: Bola matnini yuborishdan oldin va AI javobini ko'rsatishdan oldin filtrlaydi.
class ContentFilterResult {
  final bool isSafe;
  final String? filteredText;
  final String? warningMessage;

  const ContentFilterResult({
    required this.isSafe,
    this.filteredText,
    this.warningMessage,
  });
}

class ContentFilterService {
  static final ContentFilterService _instance = ContentFilterService._internal();
  factory ContentFilterService() => _instance;
  ContentFilterService._internal();

  /// Taqiqlangan va nomaqbul so'zlar ro'yxati (Kid Safety Filter)
  static final List<String> _forbiddenWords = [
    'yomon', 'so\'kish', 'urish', 'xafa', 'pichoq', 'qurol', 'urush',
    'o\'ldirish', 'qon', 'o\'g\'ri', 'alash', 'zo\'ravonlik', 'sigaret',
    'kashanda', 'zahar', 'kriminal', 'portlash'
  ];

  /// Shaxsiy ma'lumotlarni aniqlash uchun Regex patternlar
  static final RegExp _phoneRegex = RegExp(r'\+?\d{9,13}|\d{2}[-\s]?\d{3}[-\s]?\d{2}[-\s]?\d{2}');
  static final RegExp _pinRegex = RegExp(r'\b\d{4}\b');

  /// 1. Bola kiritgan matnni tekshirish (Input Filter)
  ContentFilterResult filterInput(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return const ContentFilterResult(isSafe: true, filteredText: '');
    }

    // Telefon raqami yoki shaxsiy raqamlarni sezish
    if (_phoneRegex.hasMatch(cleanText)) {
      if (kDebugMode) {
        debugPrint('[ContentFilter] Phone number detected in input!');
      }
      return const ContentFilterResult(
        isSafe: false,
        warningMessage:
            "Shaxsiy telefon raqamlaringizni begonalarga bermang! Ota-onangiz bilan maslahatlashing 😊",
      );
    }

    // Nomaqbul so'zlarni tekshirish
    final lowerText = cleanText.toLowerCase();
    for (final word in _forbiddenWords) {
      if (lowerText.contains(word)) {
        if (kDebugMode) {
          debugPrint('[ContentFilter] Forbidden word detected: $word');
        }
        return const ContentFilterResult(
          isSafe: false,
          warningMessage:
              "Men faqat yaxshi, shirin va tarbiyaviy mavzularda so'zlashaman! Keling, do'stlik yoki koinot haqida gaplashaylik ✨",
        );
      }
    }

    return ContentFilterResult(isSafe: true, filteredText: cleanText);
  }

  /// 2. AI generatsiya qilgan javobni tekshirish (Output Filter)
  ContentFilterResult filterOutput(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return const ContentFilterResult(isSafe: false, warningMessage: 'Javob bo\'sh!');
    }

    final lowerText = cleanText.toLowerCase();
    for (final word in _forbiddenWords) {
      if (lowerText.contains(word)) {
        if (kDebugMode) {
          debugPrint('[ContentFilter] AI Output contained forbidden word: $word');
        }
        return const ContentFilterResult(
          isSafe: false,
          warningMessage:
              "Men siz uchun eng go'zal va do'stona javobni tayyorladim! Qani, yana bir bor sinab ko'raylik ✨",
        );
      }
    }

    // PIN yoki maxfiy kodlarni qaytarmasligini tekshirish
    if (_pinRegex.hasMatch(cleanText) && lowerText.contains('pin')) {
      return const ContentFilterResult(
        isSafe: false,
        warningMessage: "Xavfsizlik va maxfiylik har doim muhim! 🔐",
      );
    }

    return ContentFilterResult(isSafe: true, filteredText: cleanText);
  }
}
