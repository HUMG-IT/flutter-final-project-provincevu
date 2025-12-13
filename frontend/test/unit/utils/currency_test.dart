import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/currency.dart';

void main() {
  group('Currency Utils Tests', () {
    test('nên định dạng số dương', () {
      // Arrange
      const amount = 1000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted.contains('1'), true);
      expect(formatted.contains('000'), true);
    });

    test('nên định dạng số 0', () {
      // Arrange
      const amount = 0;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '0');
    });

    test('nên định dạng số lớn với dấu phân cách hàng nghìn', () {
      // Arrange
      const amount = 10000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '10.000.000');
    });

    test('nên định dạng số nhỏ không có dấu phân cách', () {
      // Arrange
      const amount = 500;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '500');
    });

    test('nên xử lý số âm đúng cách', () {
      // Arrange
      const amount = -500000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted.isNotEmpty, true);
    });

    test('nên định dạng 1 triệu đúng cách', () {
      // Arrange
      const amount = 1000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '1.000.000');
    });

    test('nên định dạng số thập phân bằng cách làm tròn', () {
      // Arrange
      const amount = 1500000.99;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '1.500.001'); // Rounds to nearest integer
    });
  });
}
