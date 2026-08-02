import 'dart:async';
import 'storage_service.dart';

/// Ilovadan foydalanish vaqtini real-vaqt rejimida hisoblab boruvchi servis
class SessionTimerService {
  static final SessionTimerService _instance = SessionTimerService._internal();
  factory SessionTimerService() => _instance;
  SessionTimerService._internal();

  Timer? _timer;
  final DateTime _sessionStartTime = DateTime.now();

  /// Seans timerini ishga tushirish
  void start() {
    _timer?.cancel();
    // Har 1 daqiqada SharedPreferences'ga saqlash
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      StorageService.instance.addScreenTime(1);
    });
  }

  /// Bugungi umumiy ekranda o'tkazilgan vaqtni (daqiqa) olish
  int getTodayScreenTimeMinutes() {
    final savedToday = StorageService.instance.getScreenTimeToday();
    final elapsedCurrentSession = DateTime.now().difference(_sessionStartTime).inMinutes;
    final total = savedToday + elapsedCurrentSession;
    return total > 0 ? total : 1; // Kamida 1 daqiqa deb ko'rsatiladi
  }
}
