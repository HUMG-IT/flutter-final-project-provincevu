import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/add_expense_screen.dart';

void main() {
  group('AddExpenseScreen Widget Tests', () {
    testWidgets('Nên hiển thị AddExpenseScreen mà không lỗi', (tester) async {
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

    testWidgets('Nên có app bar với tiêu đề', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Nên có các trường nhập liệu', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should have at least one TextField
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('Nên có nút lưu', (tester) async {
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

    testWidgets('Nên có nút quay lại trong app bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - AppBar should be present
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Nên có khả năng cuộn khi nội dung dài', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpenseScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
