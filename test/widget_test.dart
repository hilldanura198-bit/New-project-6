import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsiva_gallery_art/src/app.dart';

void main() {
  testWidgets('Arsiva app renders onboarding title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    expect(find.text('ARSIVA'), findsOneWidget);
  });
}