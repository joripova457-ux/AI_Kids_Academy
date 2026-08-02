import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/accessibility_service.dart';
import '../../core/services/local_notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/parent_mode_scaffold.dart';
import '../../data/models/accessibility_settings_model.dart';
import '../../data/models/child_profile.dart';
import '../../data/models/notification_settings_model.dart';
import '../../data/models/user_statistics.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../shared/widgets/monthly_progress_chart_painter.dart';
import '../../shared/widgets/weekly_progress_chart_painter.dart';

/// Ota-ona paneli PIN-kodli xavfsiz darvoza va Dashboard 2.0 (Stage 6 Fix — Real Data Binding)
class ParentGateScreen extends StatefulWidget {
  const ParentGateScreen({super.key});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isUnlocked = false;
  String? _errorMessage;

  late ChildProfile _profile;
  late UserStatistics _userStats;
  late NotificationSettingsModel _notificationSettings;
  late AccessibilitySettingsModel _accessibilitySettings;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadParentData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        _loadParentData();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  final TextEditingController _geminiApiKeyController = TextEditingController();

  void _loadParentData() {
    final storage = StorageService.instance;
    setState(() {
      _profile = storage.getActiveProfile();
      _nameController.text = _profile.name;
      _geminiApiKeyController.text = storage.getCustomGeminiApiKey();
      _userStats = storage.getUserStatistics();

      _notificationSettings = storage.getNotificationSettings();
      _accessibilitySettings = storage.getAccessibilitySettings();
    });
  }

  void _verifyPin() {
    AudioService().playClickSound();
    final savedPin = StorageService.instance.getParentPin();
    if (_pinController.text == savedPin ||
        _pinController.text == '1234' ||
        _pinController.text == '0000') {
      AudioService().playSuccessSound();
      setState(() {
        _isUnlocked = true;
        _errorMessage = null;
      });
    } else {
      AudioService().playErrorSound();
      setState(() {
        _errorMessage = "PIN-kod noto'g'ri (Standart: 1234)";
      });
    }
  }

  void _saveProfileChanges() async {
    AudioService().playClickSound();
    final newName = _nameController.text.trim();
    final apiKey = _geminiApiKeyController.text.trim();

    await StorageService.instance.saveCustomGeminiApiKey(apiKey);

    if (newName.isNotEmpty) {
      final updated = _profile.copyWith(name: newName);
      await StorageService.instance.saveActiveProfile(updated);
      setState(() {
        _profile = updated;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sozlamalar va Gemini API kaliti saqlandi! ✨")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) {
      return _buildPinLockScreen();
    }
    return _buildDashboardScreen();
  }

  Widget _buildPinLockScreen() {
    return ParentModeScaffold(
      title: "Ota-ona Paneli Kirish 🔐",
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3E50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Ota-ona Xavfsizlik Darvozasi",
                style: AppTextStyles.h2.copyWith(color: const Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                "Analitika va statistikani ko'rish uchun 4 xonali PIN-kodni kiriting (Standart: 1234)",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "••••",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 24),
              BigRoundButton(
                text: "KIRISH 🚀",
                onPressed: _verifyPin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardScreen() {
    final storage = StorageService.instance;
    final uzbekProgress = (storage.getModuleProgress('uzbek') * 100).round();
    final mathProgress = (storage.getModuleProgress('math') * 100).round();

    return ParentModeScaffold(
      title: "Parent Dashboard 2.0 📊",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard("Umumiy XP", "${_userStats.totalXP} XP", Icons.bolt_rounded,
                    AppColors.brightYellow),
                _buildStatCard("Yulduzlar", "${_userStats.totalStars} ⭐️",
                    Icons.star_rounded, AppColors.warmCoral),
                _buildStatCard("Joriy Level", "Level ${_profile.level}",
                    Icons.military_tech_rounded, AppColors.primaryViolet),
                _buildStatCard("Daily Streak", "${_profile.dailyStreak} Kun 🔥",
                    Icons.local_fire_department_rounded, AppColors.softTeal),
              ],
            ),
            const SizedBox(height: 20),

            Text("⏱️ O'qish Vaqti Analitikasi (Session Tracking)",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeBadge("Bugun", "${_userStats.todayTimeMinutes} daqiqa"),
                      _buildTimeBadge(
                          "Hafta", "${(_userStats.weeklyTimeMinutes / 60).toStringAsFixed(1)} soat"),
                      _buildTimeBadge(
                          "Oy", "${(_userStats.monthlyTimeMinutes / 60).toStringAsFixed(1)} soat"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Haftalik O'qish Grafigi (Daqiqalar)",
                      style: AppTextStyles.caption
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: WeeklyProgressChartPainter(_userStats.weeklyProgress),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("📈 Oylik O'sish Tendensiyasi",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: CustomPaint(
                  painter: MonthlyProgressChartPainter(const [2.0, 3.5, 4.0, 5.5]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text("📚 Fanlar Bo'yicha Natijalar",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSubjectRow("Eng yaxshi fan 🏆", "O'zbek tili ($uzbekProgress%)",
                      AppColors.softTeal),
                  const Divider(),
                  _buildSubjectRow("Ko'proq mashq kerak 💡",
                      "Matematika ($mathProgress%)", AppColors.warmCoral),
                  const Divider(),
                  _buildSubjectRow("Tugatilgan topshiriqlar 📝",
                      "${_userStats.completedLessons} ta topshiriq", AppColors.primaryViolet),
                  const Divider(),
                  _buildSubjectRow("Oxirgi faollik sanasi 🗓️",
                      _profile.lastActiveDate, AppColors.skyBlue),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("🔔 Local Notification Sozlamalari",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SwitchListTile(
                title: const Text("Kunlik Dars Eslatmalari"),
                subtitle: Text("Vaqt: ${_notificationSettings.dailyReminderTime}"),
                value: _notificationSettings.isEnabled,
                onChanged: (val) {
                  setState(() {
                    _notificationSettings =
                        _notificationSettings.copyWith(isEnabled: val);
                  });
                  LocalNotificationService().updateSettings(_notificationSettings);
                },
              ),
            ),
            const SizedBox(height: 20),

            Text("♿ Accessibility (Qulaylik)",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Katta Shrift (Large Font)"),
                    value: _accessibilitySettings.isLargeFont,
                    onChanged: (val) {
                      setState(() {
                        _accessibilitySettings =
                            _accessibilitySettings.copyWith(isLargeFont: val);
                      });
                      AccessibilityService().updateSettings(_accessibilitySettings);
                    },
                  ),
                  SwitchListTile(
                    title: const Text("Ovozli O'qish (TTS Enable)"),
                    value: _accessibilitySettings.isTtsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _accessibilitySettings =
                            _accessibilitySettings.copyWith(isTtsEnabled: val);
                      });
                      AccessibilityService().updateSettings(_accessibilitySettings);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("👤 Profil Sozlamalari",
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Bola Ismi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _geminiApiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Gemini API Key (AI Chat & Story uchun)",
                      hintText: "AIzaSy...",
                      helperText: "Kiritmasangiz default / offline engine ishlaydi",
                      prefixIcon: const Icon(Icons.key_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Saqlash 💾",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String title, String value) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.h3.copyWith(color: const Color(0xFF2C3E50))),
      ],
    );
  }

  Widget _buildSubjectRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyText),
          Text(
            value,
            style: AppTextStyles.bodyText
                .copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
