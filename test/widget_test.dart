import 'package:flutter_test/flutter_test.dart';
import 'package:ai_kids_academy/main.dart';

void main() {
  testWidgets('AI Kids Academy Bosh Sahifasi muvaffaqiyatli yuklanadi', (WidgetTester tester) async {
    // Ilovani yuklash
    await tester.pumpWidget(const AIKidsAcademyApp());

    // Bosh sahifadagi sarlovha va bo'limlar tekshiruvi
    expect(find.textContaining('AI Kids Academy'), findsOneWidget);
    expect(find.textContaining('Harflar'), findsOneWidget);
    expect(find.textContaining('Matematika'), findsOneWidget);
  });
}
