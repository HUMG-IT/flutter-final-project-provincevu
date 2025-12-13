import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/category_model.dart';

void main() {
  group('Category Model Tests', () {
    test('nên tạo Category với các trường bắt buộc', () {
      // Arrange
      final category = Category(
        id: 'cat_001',
        name: 'Ăn uống',
        icon: 'restaurant',
        type: 'expense',
      );

      // Assert
      expect(category.id, 'cat_001');
      expect(category.name, 'Ăn uống');
      expect(category.icon, 'restaurant');
      expect(category.type, 'expense');
    });

    test('nên tạo Category từ map', () {
      // Arrange
      final map = {
        'id': 'cat_002',
        'name': 'Lương',
        'icon': 'paid',
        'type': 'income',
      };

      // Act
      final category = Category.fromMap(map);

      // Assert
      expect(category.id, 'cat_002');
      expect(category.name, 'Lương');
      expect(category.icon, 'paid');
      expect(category.type, 'income');
    });

    test('nên chuyển Category thành map', () {
      // Arrange
      final category = Category(
        id: 'cat_003',
        name: 'Di chuyển',
        icon: 'directions_car',
        type: 'expense',
      );

      // Act
      final map = category.toMap();

      // Assert
      expect(map['id'], 'cat_003');
      expect(map['name'], 'Di chuyển');
      expect(map['icon'], 'directions_car');
      expect(map['type'], 'expense');
    });

    test('nên xác định đúng danh mục chi tiêu', () {
      // Arrange
      final category = Category(
        id: 'cat_004',
        name: 'Mua sắm',
        icon: 'shopping_cart',
        type: 'expense',
      );

      // Assert
      expect(category.type, 'expense');
    });

    test('nên xác định đúng danh mục thu nhập', () {
      // Arrange
      final category = Category(
        id: 'cat_005',
        name: 'Tiết kiệm',
        icon: 'savings',
        type: 'income',
      );

      // Assert
      expect(category.type, 'income');
    });

    test('nên xử lý đúng các tên biểu tượng khác nhau', () {
      // Arrange
      final icons = [
        'restaurant',
        'directions_car',
        'health_and_safety',
        'school',
        'shopping_cart',
        'paid',
        'savings',
      ];

      // Assert
      for (final icon in icons) {
        final category = Category(
          id: 'cat_test',
          name: 'Test',
          icon: icon,
          type: 'expense',
        );
        expect(category.icon, icon);
      }
    });
  });
}
