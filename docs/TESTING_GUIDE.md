# Hướng Dẫn Kiểm Thử Tự Động (Testing Guide)

## Tổng Quan

Dự án sử dụng `flutter_test` để thực hiện kiểm thử tự động, bao gồm:

- **Unit Test:** Kiểm thử logic, models, services
- **Widget Test:** Kiểm thử giao diện người dùng
- **Integration Test:** Kiểm thử luồng hoạt động (tùy chọn)

---

## Cấu Trúc Thư Mục Test

```
frontend/test/
├── unit/                     # Unit tests
│   ├── models/
│   │   ├── transaction_model_test.dart # Kiểm thử mô hình giao dịch
│   │   └── category_model_test.dart    # Kiểm thử mô hình danh mục
│   └── services/
│       ├── category_service_test.dart  # Kiểm thử dịch vụ danh mục
│       └── sync_data_service_test.dart # Kiểm thử dịch vụ đồng bộ dữ liệu
│
── widget/                   # Widget tests
   ├── screens/
   │   ├── home_screen_test.dart         # Kiểm thử màn hình chính
   │   └── add_expense_screen_test.dart  # Kiểm thử màn hình thêm chi tiêu
   └── widgets/
       └── finance_summary_card_test.dart  # Kiểm thử widget tổng quan tài chính

```

---

## Chạy Kiểm Thử

### Chạy Tất Cả Test

```bash
cd frontend
flutter test
```

### Chạy Test Cụ Thể

```bash
# Chạy một file test
flutter test test/unit/models/transaction_model_test.dart

# Chạy test trong thư mục
flutter test test/unit/
```

### Chạy Test với Coverage

```bash
flutter test --coverage
```

### Xem Báo Cáo Coverage

```bash
# Windows (cần cài lcov)
perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml coverage/lcov.info -o coverage/html

# Mac/Linux
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Mẫu Unit Test

### Test Model

```dart
// test/unit/models/transaction_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/giao_dich_model.dart';

void main() {
  group('Transaction Model', () {
    test('should create Transaction from map', () {
      // Arrange
      final map = {
        'id': 'tx_001',
        'amount': 100000.0,
        'type': 'expense',
        'category': 'Ăn uống',
        'date': '2025-12-13T10:30:00.000',
        'note': 'Ăn sáng',
      };

      // Act
      final transaction = Transaction.fromMap(map);

      // Assert
      expect(transaction.id, 'tx_001');
      expect(transaction.amount, 100000.0);
      expect(transaction.type, 'expense');
      expect(transaction.category, 'Ăn uống');
      expect(transaction.note, 'Ăn sáng');
    });

    test('should convert Transaction to map', () {
      // Arrange
      final transaction = Transaction(
        id: 'tx_001',
        amount: 100000.0,
        type: 'expense',
        category: 'Ăn uống',
        date: DateTime(2025, 12, 13, 10, 30),
        note: 'Ăn sáng',
      );

      // Act
      final map = transaction.toMap();

      // Assert
      expect(map['id'], 'tx_001');
      expect(map['amount'], 100000.0);
      expect(map['type'], 'expense');
    });

    test('should handle null note', () {
      final map = {
        'id': 'tx_001',
        'amount': 100000.0,
        'type': 'expense',
        'category': 'Ăn uống',
        'date': '2025-12-13T10:30:00.000',
        'note': null,
      };

      final transaction = Transaction.fromMap(map);
      expect(transaction.note, '');
    });
  });
}
```

### Test Service

```dart
// test/unit/services/category_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/category_service.dart';
import 'package:frontend/data/default_categories.dart';

void main() {
  group('CategoryService', () {
    late CategoryService service;

    setUp(() {
      service = CategoryService();
    });

    test('default categories should not be empty', () {
      expect(defaultCategories.isNotEmpty, true);
    });

    test('should have both expense and income categories', () {
      final expenseCategories = defaultCategories
          .where((c) => c.type == 'expense')
          .toList();
      final incomeCategories = defaultCategories
          .where((c) => c.type == 'income')
          .toList();

      expect(expenseCategories.isNotEmpty, true);
      expect(incomeCategories.isNotEmpty, true);
    });
  });
}
```

---

## Mẫu Widget Test

### Test Screen

```dart
// test/widget/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/home_screen.dart';

void main() {
  group('HomeScreen Widget', () {
    testWidgets('should display total balance', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Tổng số dư'), findsOneWidget);
    });

    testWidgets('should have menu button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should have floating action button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
```

### Test Widget Component

```dart
// test/widget/widgets/finance_summary_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/finance_summary_card.dart';

void main() {
  group('FinanceSummaryCard Widget', () {
    testWidgets('should display income and expense', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FinanceSummaryCard(
              monthlyIncome: 10000000,
              monthlyExpense: 5000000,
              currentMonth: DateTime(2025, 12),
              onMonthChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify card is rendered
      expect(find.byType(Card), findsWidgets);
    });
  });
}
```

---

## Checklist Kiểm Thử

### Unit Tests

- [x] Transaction model: toMap, fromMap, copyWith
- [x] Category model: toMap, fromMap
- [x] CategoryService: initializeDefaultCategories
- [x] DataSyncService: backupToFirebase, restoreFromFirebase
- [x] Currency utils: formatVND

### Widget Tests

- [x] HomeScreen: hiển thị đúng các thành phần
- [x] AddExpenseScreen: nhập liệu và validate
- [x] TransactionHistoryScreen: hiển thị danh sách
- [x] FinanceSummaryCard: hiển thị thu/chi
- [x] Category7DaysWidget: hiển thị biểu đồ

### Integration Tests

- [x] Luồng thêm giao dịch
- [x] Luồng sửa giao dịch
- [x] Luồng xóa giao dịch
- [x] Luồng sao lưu/khôi phục

---

---

## Báo Cáo Kết Quả Test

Sau khi chạy `flutter test`, kết quả sẽ hiển thị:

```
00:05 +10: All tests passed!
```

Hoặc nếu có lỗi:

```
00:05 +8 -2: Một số test thất bại.

FAILED: test/unit/models/transaction_model_test.dart
  Expected: 100000
  Actual: 100001
```
