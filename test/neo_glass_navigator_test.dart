import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_glass_navigator/neo_glass_navigator.dart';

void main() {
  testWidgets('NeoGlassNavigator renders items and triggers onTap',
      (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.blue)),
              Align(
                alignment: Alignment.bottomCenter,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return NeoGlassNavigator(
                      currentIndex: selectedIndex,
                      onTap: (index) => setState(() => selectedIndex = index),
                      items: const [
                        NeoGlassNavItem(label: 'Inicio', icon: Icons.home),
                        NeoGlassNavItem(label: 'Mapa', icon: Icons.map),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Mapa'), findsOneWidget);

    await tester.tap(find.text('Mapa'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });
}
