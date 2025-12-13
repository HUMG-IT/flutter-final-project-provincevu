import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/giao_dich_model.dart';

void main() {
  group('Transaction Model Tests', () {
    test('nên tạo Transaction với các trường bắt buộc', () {
      // Arrange
      final transaction = Transaction(
        id: 'tx_001',
        amount: 100000.0,
        type: 'expense',
        category: 'Ăn uống',
        date: DateTime(2025, 12, 13, 10, 30),
        note: 'Ăn sáng',
      );

      // Assert
      expect(transaction.id, 'tx_001');
      expect(transaction.amount, 100000.0);
      expect(transaction.type, 'expense');
      expect(transaction.category, 'Ăn uống');
      expect(transaction.note, 'Ăn sáng');
    });

    test('nên tạo Transaction từ map', () {
      // Arrange
      final map = {
        'id': 'tx_002',
        'amount': 200000.0,
        'type': 'income',
        'category': 'Lương',
        'date': '2025-12-13T10:30:00.000',
        'note': 'Lương tháng 12',
      };

      // Act
      final transaction = Transaction.fromMap(map);

      // Assert
      expect(transaction.id, 'tx_002');
      expect(transaction.amount, 200000.0);
      expect(transaction.type, 'income');
      expect(transaction.category, 'Lương');
      expect(transaction.note, 'Lương tháng 12');
    });

    test('nên chuyển Transaction thành map', () {
      // Arrange
      final date = DateTime(2025, 12, 13, 10, 30);
      final transaction = Transaction(
        id: 'tx_003',
        amount: 50000.0,
        type: 'expense',
        category: 'Di chuyển',
        date: date,
        note: 'Grab',
      );

      // Act
      final map = transaction.toMap();

      // Assert
      expect(map['id'], 'tx_003');
      expect(map['amount'], 50000.0);
      expect(map['type'], 'expense');
      expect(map['category'], 'Di chuyển');
      expect(map['note'], 'Grab');
    });

    test('nên xử lý đúng trường note rỗng', () {
      // Arrange
      final map = {
        'id': 'tx_004',
        'amount': 100000.0,
        'type': 'expense',
        'category': 'Ăn uống',
        'date': '2025-12-13T10:30:00.000',
        'note': '',
      };

      // Act
      final transaction = Transaction.fromMap(map);

      // Assert
      expect(transaction.note, '');
    });

    test('nên xử lý đúng số tiền bằng 0', () {
      // Arrange
      final transaction = Transaction(
        id: 'tx_005',
        amount: 0.0,
        type: 'expense',
        category: 'Khác',
        date: DateTime.now(),
        note: '',
      );

      // Assert
      expect(transaction.amount, 0.0);
    });

    test('nên xác định đúng loại thu nhập', () {
      // Arrange
      final transaction = Transaction(
        id: 'tx_006',
        amount: 1000000.0,
        type: 'income',
        category: 'Lương',
        date: DateTime.now(),
        note: 'Lương tháng',
      );

      // Assert
      expect(transaction.type, 'income');
    });

    test('nên xác định đúng loại chi tiêu', () {
      // Arrange
      final transaction = Transaction(
        id: 'tx_007',
        amount: 50000.0,
        type: 'expense',
        category: 'Ăn uống',
        date: DateTime.now(),
        note: 'Cà phê',
      );

      // Assert
      expect(transaction.type, 'expense');
    });
  });
}
