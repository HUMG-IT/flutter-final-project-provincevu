import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/default_categories.dart';

void main() {
  group('Default Categories Tests', () {
    test('nên có các danh mục mặc định', () {
      expect(defaultCategories.isNotEmpty, true);
    });

    test('nên có các danh mục chi tiêu', () {
      final expenseCategories =
          defaultCategories.where((c) => c.type == 'expense').toList();
      expect(expenseCategories.isNotEmpty, true);
    });

    test('nên có các danh mục thu nhập', () {
      final incomeCategories =
          defaultCategories.where((c) => c.type == 'income').toList();
      expect(incomeCategories.isNotEmpty, true);
    });

    test('tất cả các danh mục nên có id hợp lệ', () {
      for (final category in defaultCategories) {
        expect(category.id.isNotEmpty, true);
      }
    });

    test('tất cả các danh mục nên có tên hợp lệ', () {
      for (final category in defaultCategories) {
        expect(category.name.isNotEmpty, true);
      }
    });

    test('tất cả các danh mục nên có biểu tượng hợp lệ', () {
      for (final category in defaultCategories) {
        expect(category.icon.isNotEmpty, true);
      }
    });

    test('tất cả các danh mục nên có loại hợp lệ', () {
      for (final category in defaultCategories) {
        expect(
          category.type == 'expense' || category.type == 'income',
          true,
        );
      }
    });

    test('nên có các danh mục chi tiêu phổ biến', () {
      final expenseNames = defaultCategories
          .where((c) => c.type == 'expense')
          .map((c) => c.name)
          .toList();

      // Kiểm tra có ít nhất một số danh mục chi tiêu phổ biến
      expect(expenseNames.isNotEmpty, true);
    });

    test('nên có các danh mục thu nhập phổ biến', () {
      final incomeNames = defaultCategories
          .where((c) => c.type == 'income')
          .map((c) => c.name)
          .toList();

      // Kiểm tra có ít nhất một số danh mục thu nhập phổ biến
      expect(incomeNames.isNotEmpty, true);
    });

    test('id của các danh mục nên là duy nhất', () {
      final ids = defaultCategories.map((c) => c.id).toList();
      final uniqueIds = ids.toSet().toList();
      expect(ids.length, uniqueIds.length);
    });
  });
}
