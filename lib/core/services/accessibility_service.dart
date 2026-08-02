import '../../data/models/accessibility_settings_model.dart';
import '../../services/storage_service.dart';

/// Accessibility (Qulaylik Tizimi — 11-Talab)
/// Shrift o'lchamlari, TTS (text-to-speech), katta tugmalar va kontrastni boshqaradi.
class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  AccessibilitySettingsModel getSettings() {
    return StorageService.instance.getAccessibilitySettings();
  }

  Future<void> updateSettings(AccessibilitySettingsModel settings) async {
    await StorageService.instance.saveAccessibilitySettings(settings);
  }

  /// Shrift o'lchamini hisoblash kuchi (Font Scale Factor)
  double getFontScaleFactor() {
    final settings = getSettings();
    return settings.isLargeFont ? 1.25 : 1.0;
  }

  /// Tugmalar balandligi ko'paytiruvchisi
  double getButtonScaleFactor() {
    final settings = getSettings();
    return settings.isLargeButtons ? 1.2 : 1.0;
  }
}
