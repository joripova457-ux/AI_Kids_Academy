/// Accessibility (Qulaylik) Sozlamalari Modeli
class AccessibilitySettingsModel {
  final bool isLargeFont;
  final bool isTtsEnabled;
  final bool isHighContrast;
  final bool isLargeButtons;

  const AccessibilitySettingsModel({
    this.isLargeFont = false,
    this.isTtsEnabled = true,
    this.isHighContrast = false,
    this.isLargeButtons = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'isLargeFont': isLargeFont,
      'isTtsEnabled': isTtsEnabled,
      'isHighContrast': isHighContrast,
      'isLargeButtons': isLargeButtons,
    };
  }

  factory AccessibilitySettingsModel.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettingsModel(
      isLargeFont: json['isLargeFont'] as bool? ?? false,
      isTtsEnabled: json['isTtsEnabled'] as bool? ?? true,
      isHighContrast: json['isHighContrast'] as bool? ?? false,
      isLargeButtons: json['isLargeButtons'] as bool? ?? false,
    );
  }

  AccessibilitySettingsModel copyWith({
    bool? isLargeFont,
    bool? isTtsEnabled,
    bool? isHighContrast,
    bool? isLargeButtons,
  }) {
    return AccessibilitySettingsModel(
      isLargeFont: isLargeFont ?? this.isLargeFont,
      isTtsEnabled: isTtsEnabled ?? this.isTtsEnabled,
      isHighContrast: isHighContrast ?? this.isHighContrast,
      isLargeButtons: isLargeButtons ?? this.isLargeButtons,
    );
  }
}
