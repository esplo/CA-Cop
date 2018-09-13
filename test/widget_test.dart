import 'package:ca_cop/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('String Comparison smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp(
      seed: 3,
    ));

    expect(find.text('START'), findsNWidgets(2));

    await tester.tap(find.text('START').first);
    await tester.pumpAndSettle();

    // Verify that there's no score
    expect(find.text('0'), findsNothing);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('FWDS'), findsNothing);

    // Tap the start button and trigger a frame.
    await tester.tap(find.text('START'));
    await tester.pump();

    // TODO: score test

    // Verify that the session has started.
    expect(find.text('START'), findsNothing);
    expect(find.text('30'), findsOneWidget); // TODO: timer
    expect(find.text('same'), findsOneWidget);
    expect(find.text('different'), findsOneWidget);
    expect(find.text('ZIH'), findsOneWidget);
    expect(find.text('ZFH'), findsOneWidget);

    // Tap the correct answer.
    await tester.tap(find.text('same'));
    await tester.pump();

    // correct answer, score increase by 4
    expect(find.text('START'), findsNothing);
    expect(find.text('DKSK'), findsOneWidget);
    expect(find.text('DSSK'), findsOneWidget);

    // Tap the correct answer
    await tester.tap(find.text('different'));
    await tester.pump();

    // correct answer, score increase by 5
    expect(find.text('SUJIZAVY'), findsNWidgets(2));
  });
}
