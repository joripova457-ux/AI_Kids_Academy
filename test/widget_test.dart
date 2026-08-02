import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_kids_academy/main.dart';
import 'package:ai_kids_academy/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AI Kids Academy Bosh Sahifasi muvaffaqiyatli yuklanadi', (WidgetTester tester) async {
    // SharedPreferences mock init
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    // Ilovani yuklash
    await tester.pumpWidget(const AIKidsAcademyApp());
    await tester.pumpAndSettle();

    // Bosh sahifadagi sarlovha va bo'limlar tekshiruvi
    expect(find.textContaining('AI Kids Academy'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Harflar'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Matematika'), findsAtLeastNWidgets(1));
  });
}
