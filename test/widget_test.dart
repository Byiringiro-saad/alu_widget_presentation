import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:animated_list_demo/main.dart';

void main() {
  // [menu title, first item, item added by +]
  const demos = [
    ['Fade', 'Item 1', 'Item 4'],
    ['Slide', 'Apple', 'Fruit 1'],
    ['Size', 'Item 1', 'Item 4'],
    ['Scale', 'Item 1', 'Item 4'],
    ['Rotation', 'Item 1', 'Item 4'],
    ['Combo + Curve', 'Item 1', 'Item 4'],
  ];

  for (final demo in demos) {
    testWidgets('${demo[0]} screen: add and remove items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text(demo[0]));
      await tester.pumpAndSettle();
      expect(find.text(demo[1]), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text(demo[2]), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      expect(find.text(demo[1]), findsNothing);
    });
  }
}
