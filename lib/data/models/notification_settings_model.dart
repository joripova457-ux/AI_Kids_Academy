/// Local Notification Sozlamalari Modeli
class NotificationSettingsModel {
  final bool isEnabled;
  final String dailyReminderTime; // Format "HH:mm" masalan "17:00"
  final bool rewardReminderEnabled;
  final bool streakReminderEnabled;

  const NotificationSettingsModel({
    this.isEnabled = true,
    this.dailyReminderTime = "17:00",
    this.rewardReminderEnabled = true,
    this.streakReminderEnabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'dailyReminderTime': dailyReminderTime,
      'rewardReminderEnabled': rewardReminderEnabled,
      'streakReminderEnabled': streakReminderEnabled,
    };
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      isEnabled: json['isEnabled'] as bool? ?? true,
      dailyReminderTime: json['dailyReminderTime'] as String? ?? "17:00",
      rewardReminderEnabled: json['rewardReminderEnabled'] as bool? ?? true,
      streakReminderEnabled: json['streakReminderEnabled'] as bool? ?? true,
    );
  }

  NotificationSettingsModel copyWith({
    bool? isEnabled,
    String? dailyReminderTime,
    bool? rewardReminderEnabled,
    bool? streakReminderEnabled,
  }) {
    return NotificationSettingsModel(
      isEnabled: isEnabled ?? this.isEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      rewardReminderEnabled:
          rewardReminderEnabled ?? this.rewardReminderEnabled,
      streakReminderEnabled:
          streakReminderEnabled ?? this.streakReminderEnabled,
    );
  }
}
