import 'package:flutter_test/flutter_test.dart';
import 'package:endosense_ai/main.dart';

void main() {
  testWidgets('EndoSense-AI application loads successfully', (
    WidgetTester tester,
  ) async {
    // Launch the application.
    await tester.pumpWidget(const EndoSenseApp());

    // Check that the splash screen appears.
    expect(find.text('EndoSense-AI'), findsOneWidget);

    // Advance the fake clock by 3 seconds.
    await tester.pump(const Duration(seconds: 3));

    // Complete the navigation animation.
    await tester.pumpAndSettle();

    // Check that the onboarding screen appears.
    expect(find.text('Understand Your Health'), findsOneWidget);
  });
}
