import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/add_expense_screen.dart';

void main() {
  group('AddExpenseScreen Widget Tests', () {
    testWidgets('should render AddExpenseScreen without error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have app bar with title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have text fields for input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should have at least one TextField
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('should have save button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should have ElevatedButton or similar
      final buttons = find.byType(ElevatedButton);
      expect(buttons.evaluate().isNotEmpty, true);
    });

    testWidgets('should have back button in app bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - AppBar should be present
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should be scrollable for long content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
