import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../services/audio_service.dart';

/// Ota-ona paneli xavfsizlik darvozasi (Parental Gate Dialog)
/// Yosh bolalar tasodifan kirib ketmasligi uchun matematik savol dialogi.
class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ParentalGateDialog(),
    );
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  final TextEditingController _answerController = TextEditingController();
  late int _num1;
  late int _num2;
  late String _operator;
  late int _expectedAnswer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateMathQuestion();
  }

  void _generateMathQuestion() {
    final random = Random();
    final type = random.nextInt(3); // 0: multiplication, 1: addition, 2: subtraction
    if (type == 0) {
      _num1 = random.nextInt(5) + 6; // 6 - 10
      _num2 = random.nextInt(6) + 4; // 4 - 9
      _operator = 'x';
      _expectedAnswer = _num1 * _num2;
    } else if (type == 1) {
      _num1 = random.nextInt(20) + 15; // 15 - 34
      _num2 = random.nextInt(25) + 12; // 12 - 36
      _operator = '+';
      _expectedAnswer = _num1 + _num2;
    } else {
      _num1 = random.nextInt(30) + 25; // 25 - 54
      _num2 = random.nextInt(15) + 7;  // 7 - 21
      _operator = '-';
      _expectedAnswer = _num1 - _num2;
    }
    _answerController.clear();
    _errorMessage = null;
  }

  void _verifyAnswer() {
    AudioService().playClickSound();
    final input = int.tryParse(_answerController.text.trim());

    if (input == _expectedAnswer) {
      AudioService().playSuccessSound();
      Navigator.of(context).pop(true);
    } else {
      AudioService().playErrorSound();
      setState(() {
        _errorMessage = "Noto'g'ri javob! Qayta urinib ko'ring yoki yangi savol oling. 🔒";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sarlavha belgisi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryViolet.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                size: 40,
                color: AppColors.primaryViolet,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Ota-ona Xavfsizlik Darvozasi 🔐",
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 8),

            Text(
              "Bu bo'lim faqat kattalar uchun! Davom etish uchun quyidagi misolni yeching:",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),

            // Matematik savol kartochkasi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$_num1 $_operator $_num2 = ?",
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryViolet,
                      fontSize: 28,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryViolet),
                    tooltip: "Yangi savol",
                    onPressed: () {
                      AudioService().playClickSound();
                      setState(() {
                        _generateMathQuestion();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Javob kiritish maydoni
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _verifyAnswer(),
              decoration: InputDecoration(
                hintText: "Javobni kiriting...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primaryViolet, width: 2),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.warmCoral,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Tugmalar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      AudioService().playClickSound();
                      Navigator.of(context).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Bekor qilish",
                      style: AppTextStyles.buttonText.copyWith(color: Colors.grey.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verifyAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryViolet,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Tekshirish",
                      style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
