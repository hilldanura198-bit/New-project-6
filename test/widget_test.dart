// Basic smoke test to ensure the ARSIVA app can render.
import 'package:flutter_test/flutter_test.dart';

import 'package:arsiva_gallery_art/src/app.dart';

void main() {
  testWidgets('Arsiva app renders onboarding title', (WidgetTester tester) async {
    await tester.pumpWidget(const ArsivaApp());

    expect(find.text('ARSIVA Gallery Art'), findsOneWidget);
  });
}
