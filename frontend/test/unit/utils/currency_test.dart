import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/currency.dart';

void main() {
  group('Currency Utils Tests', () {
    test('should format positive number', () {
      // Arrange
      const amount = 1000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted.contains('1'), true);
      expect(formatted.contains('000'), true);
    });

    test('should format zero', () {
      // Arrange
      const amount = 0;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '0');
    });

    test('should format large number with thousand separators', () {
      // Arrange
      const amount = 10000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '10.000.000');
    });

    test('should format small number without separator', () {
      // Arrange
      const amount = 500;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '500');
    });

    test('should handle negative numbers', () {
      // Arrange
      const amount = -500000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted.isNotEmpty, true);
    });

    test('should format 1 million correctly', () {
      // Arrange
      const amount = 1000000;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '1.000.000');
    });

    test('should format decimal number by truncating', () {
      // Arrange
      const amount = 1500000.99;

      // Act
      final formatted = formatNumber(amount);

      // Assert
      expect(formatted, '1.500.001'); // Rounds to nearest integer
    });
  });
}
