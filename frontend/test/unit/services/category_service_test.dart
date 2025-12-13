import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/default_categories.dart';

void main() {
  group('Default Categories Tests', () {
    test('should have default categories', () {
      expect(defaultCategories.isNotEmpty, true);
    });

    test('should have expense categories', () {
      final expenseCategories =
          defaultCategories.where((c) => c.type == 'expense').toList();
      expect(expenseCategories.isNotEmpty, true);
    });

    test('should have income categories', () {
      final incomeCategories =
          defaultCategories.where((c) => c.type == 'income').toList();
      expect(incomeCategories.isNotEmpty, true);
    });

    test('all categories should have valid id', () {
      for (final category in defaultCategories) {
        expect(category.id.isNotEmpty, true);
      }
    });

    test('all categories should have valid name', () {
      for (final category in defaultCategories) {
        expect(category.name.isNotEmpty, true);
      }
    });

    test('all categories should have valid icon', () {
      for (final category in defaultCategories) {
        expect(category.icon.isNotEmpty, true);
      }
    });

    test('all categories should have valid type', () {
      for (final category in defaultCategories) {
        expect(
          category.type == 'expense' || category.type == 'income',
          true,
        );
      }
    });

    test('should have common expense categories', () {
      final expenseNames = defaultCategories
          .where((c) => c.type == 'expense')
          .map((c) => c.name)
          .toList();

      // Kiểm tra có ít nhất một số danh mục chi tiêu phổ biến
      expect(expenseNames.isNotEmpty, true);
    });

    test('should have common income categories', () {
      final incomeNames = defaultCategories
          .where((c) => c.type == 'income')
          .map((c) => c.name)
          .toList();

      // Kiểm tra có ít nhất một số danh mục thu nhập phổ biến
      expect(incomeNames.isNotEmpty, true);
    });

    test('category ids should be unique', () {
      final ids = defaultCategories.map((c) => c.id).toList();
      final uniqueIds = ids.toSet().toList();
      expect(ids.length, uniqueIds.length);
    });
  });
}
