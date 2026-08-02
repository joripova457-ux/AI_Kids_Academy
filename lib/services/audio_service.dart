import 'package:flutter/services.dart';

/// App Sound & Audio Feedback Service
class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  AudioService._internal();

  /// Tugma bosilganda yengil tebranish/tovush
  Future<void> playClickSound() async {
    try {
      await HapticFeedback.lightImpact();
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// To'g'ri javob yoki yulduz yutganda tantanali tebranish
  Future<void> playSuccessSound() async {
    try {
      await HapticFeedback.mediumImpact();
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// Xato javob berilganda ogohlantiruvchi tebranish
  Future<void> playErrorSound() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Yulduz qo'shilganda maxsus celebration
  Future<void> playStarEarnSound() async {
    try {
      await HapticFeedback.vibrate();
    } catch (_) {}
  }
}
