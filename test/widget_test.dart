import 'package:ca_cop/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('String Comparison smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp(
      seed: 3,
    ));

    // Verify that our score starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('FWDS'), findsNothing);

    // Tap the start button and trigger a frame.
    await tester.tap(find.text('START'));
    await tester.pump();

    // Verify that the session has started.
    expect(find.text('START'), findsNothing);
    expect(find.text('SCORE: '), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('30'), findsOneWidget); // TODO: timer
    expect(find.text('same'), findsOneWidget);
    expect(find.text('different'), findsOneWidget);
    expect(find.text('XEJZ'), findsNWidgets(2));

    // Tap the correct answer.
    await tester.tap(find.text('same'));
    await tester.pump();

    // correct answer, score increase by 4
    expect(find.text('START'), findsNothing);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('ZIH'), findsOneWidget);
    expect(find.text('ZFH'), findsOneWidget);

    // Tap the correct answer
    await tester.tap(find.text('different'));
    await tester.pump();

    // correct answer, score increase by 4
    expect(find.text('8'), findsOneWidget);
    expect(find.text('DKSK'), findsOneWidget);
    expect(find.text('DSSK'), findsOneWidget);

    // Tap the wrong answer
    await tester.tap(find.text('same'));
    await tester.pump();

    // wrong answer, score decrease by 10
    expect(find.text('SUJIZAVY'), findsNWidgets(2));
    expect(find.text('-2'), findsOneWidget);
  });
}
