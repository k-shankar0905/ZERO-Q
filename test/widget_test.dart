// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:zeroq/main.dart';

void main() {
  testWidgets('ZeroQApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ZeroQApp());

    // Verify that our app renders
    expect(find.text('Smart Self-Checkout 🛒'), findsOneWidget);
  });
}

