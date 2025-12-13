import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should render HomeScreen without error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Wait for async operations
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - HomeScreen should be rendered
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have menu button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should have floating action button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should have add icon in FAB', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should have theme toggle button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should have either light_mode or dark_mode icon
      final lightMode = find.byIcon(Icons.light_mode);
      final darkMode = find.byIcon(Icons.dark_mode);
      expect(lightMode.evaluate().isNotEmpty || darkMode.evaluate().isNotEmpty,
          true);
    });

    testWidgets('menu button should be tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Act
      final menuButton = find.byIcon(Icons.menu);
      expect(menuButton, findsOneWidget);

      // Tap should not throw error
      await tester.tap(menuButton);
      await tester.pump();
    });

    testWidgets('FAB should be tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Act
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      // Tap should not throw error
      await tester.tap(fab);
      await tester.pump();
    });
  });
}
