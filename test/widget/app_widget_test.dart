import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_facts_ai/widgets/buttons/kid_button.dart';
import 'package:math_facts_ai/widgets/visuals/star_rating_bar.dart';
import 'package:math_facts_ai/widgets/visuals/analog_clock_widget.dart';
import 'package:math_facts_ai/widgets/visuals/pizza_fraction_widget.dart';

void main() {
  testWidgets('KidButton renders text and triggers callback on tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KidButton(
            text: 'Play Game 🚀',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Play Game 🚀'), findsOneWidget);
    await tester.tap(find.text('Play Game 🚀'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('StarRatingBar renders 3 star icons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StarRatingBar(starCount: 2),
        ),
      ),
    );

    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
  });

  testWidgets('AnalogClockWidget and PizzaFractionWidget render CustomPaint', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AnalogClockWidget(hour: 3, minute: 30),
              PizzaFractionWidget(highlightedSlices: 2, totalSlices: 4),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsWidgets);
  });
}
