import '../../data/models/notification_settings_model.dart';
import '../../services/storage_service.dart';

/// Local Notification System (8-Talab)
/// Offline va Local eslatmalarni boshqarish va rejalashtirish xizmati.
class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  /// Notification tizimini ishga tushirish
  Future<void> init() async {
    final settings = StorageService.instance.getNotificationSettings();
    if (settings.isEnabled) {
      await scheduleDailyReminders(settings);
    }
  }

  /// Kunlik eslatmalarni rejalashtirish
  Future<void> scheduleDailyReminders(NotificationSettingsModel settings) async {
    // Local notification rejalashtirish mantigi
    // Eslatmalar: "📚 Bugungi darsni unutma", "🎁 Daily Reward seni kutmoqda"
  }

  /// Sozlamalarni yangilash
  Future<void> updateSettings(NotificationSettingsModel newSettings) async {
    await StorageService.instance.saveNotificationSettings(newSettings);
    if (newSettings.isEnabled) {
      await scheduleDailyReminders(newSettings);
    }
  }
}
