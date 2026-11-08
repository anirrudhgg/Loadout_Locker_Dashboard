import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loadout_locker/main.dart';

void main() {
  testWidgets('Home page shows the PC and Console options', (tester) async {
    await tester.pumpWidget(const LoadoutLockerApp());
    expect(find.text('PC'), findsOneWidget);
    expect(find.text('Console'), findsOneWidget);
  });

  testWidgets('PC settings are saved for a game', (tester) async {
    AppData.pcSettings.clear();
    await tester.pumpWidget(const LoadoutLockerApp());

    await tester.tap(find.text('PC'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Valorant'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'DPI'), '800');
    await tester.enterText(find.widgetWithText(TextField, 'Sensitivity'), '0.35');
    await tester.tap(find.text('Save & Apply'));
    await tester.pumpAndSettle();
    // Let the "Settings Saved!" snack bar time out, so no timer is left running
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(AppData.pcSettings['Valorant']?['dpi'], '800');
    expect(AppData.pcSettings['Valorant']?['sens'], '0.35');
  });

  testWidgets('DPI field ignores letters', (tester) async {
    await tester.pumpWidget(const LoadoutLockerApp());
    await tester.tap(find.text('PC'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apex Legends'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'DPI'), '8a0b0');
    expect(find.text('800'), findsOneWidget);
  });
}
