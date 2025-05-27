// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kitap_okuma_app/main.dart'; // Ana uygulama sınıfını import ediyoruz

void main() {
  testWidgets('Ana widget testi', (WidgetTester tester) async {
    // MyApp YERINE KitapOkumaApp kullanıyoruz
    await tester.pumpWidget(const KitapOkumaApp());

    // Login ekranındaki öğeleri kontrol ediyoruz
    expect(find.text('ÖĞRENCİ'), findsOneWidget);
    expect(find.text('VELİ'), findsOneWidget);
  });
}