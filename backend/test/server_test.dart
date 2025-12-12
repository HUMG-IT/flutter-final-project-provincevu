import 'package:backend/src/models/category_model.dart';
import 'package:backend/src/models/transaction_model.dart';
import 'package:backend/src/services/category_service.dart';
import 'package:backend/src/services/transaction_service.dart';
import 'package:test/test.dart';

void main() {
  group('Kiểm thử TransactionService', () {
    late TransactionService service;

    setUp(() {
      service = TransactionService();
    });

    test('Tạo giao dịch thêm vào bộ nhớ', () {
      final data = {
        'id': 'test_1',
        'amount': 100000,
        'category': 'Ăn uống',
        'type': 'expense',
        'note': 'Test transaction'
      };

      final result = service.create(data);

      expect(result.id, 'test_1');
      expect(result.amount, 100000);
      expect(result.category, 'Ăn uống');
      expect(result.type, 'expense');
    });

    test('getAll trả về tất cả giao dịch', () {
      service.create(
          {'id': '1', 'amount': 50000, 'category': 'A', 'type': 'expense'});
      service.create(
          {'id': '2', 'amount': 60000, 'category': 'B', 'type': 'income'});

      final all = service.getAll();

      expect(all.length, 2);
    });

    test('getById trả về giao dịch đúng', () {
      service.create({
        'id': 'find_me',
        'amount': 75000,
        'category': 'Test',
        'type': 'expense'
      });

      final found = service.getById('find_me');

      expect(found, isNotNull);
      expect(found!.id, 'find_me');
      expect(found.amount, 75000);
    });

    test('getById trả về null cho id không tồn tại', () {
      final found = service.getById('non_existent');

      expect(found, isNull);
    });

    test('update cập nhật giao dịch tồn tại', () {
      service.create({
        'id': 'update_me',
        'amount': 100000,
        'category': 'Old',
        'type': 'expense'
      });

      final updated =
          service.update('update_me', {'amount': 200000, 'category': 'New'});

      expect(updated, isNotNull);
      expect(updated!.amount, 200000);
      expect(updated.category, 'New');
    });

    test('update trả về null cho id không tồn tại', () {
      final updated = service.update('non_existent', {'amount': 100});

      expect(updated, isNull);
    });

    test('delete xóa giao dịch', () {
      service.create({
        'id': 'delete_me',
        'amount': 50000,
        'category': 'Test',
        'type': 'expense'
      });

      final result = service.delete('delete_me');
      final found = service.getById('delete_me');

      expect(result, true);
      expect(found, isNull);
    });

    test('delete trả về false cho id không tồn tại', () {
      final result = service.delete('non_existent');

      expect(result, false);
    });

    test('getTotalIncome tính tổng thu nhập', () {
      service.create({
        'id': '1',
        'amount': 1000000,
        'category': 'Lương',
        'type': 'income'
      });
      service.create(
          {'id': '2', 'amount': 500000, 'category': 'Bonus', 'type': 'income'});
      service.create({
        'id': '3',
        'amount': 100000,
        'category': 'Ăn uống',
        'type': 'expense'
      });

      final totalIncome = service.getTotalIncome();

      expect(totalIncome, 1500000);
    });

    test('getTotalExpense tính tổng chi tiêu', () {
      service.create({
        'id': '1',
        'amount': 100000,
        'category': 'Ăn uống',
        'type': 'expense'
      });
      service.create({
        'id': '2',
        'amount': 200000,
        'category': 'Di chuyển',
        'type': 'expense'
      });
      service.create({
        'id': '3',
        'amount': 5000000,
        'category': 'Lương',
        'type': 'income'
      });

      final totalExpense = service.getTotalExpense();

      expect(totalExpense, 300000);
    });
  });

  group('Kiểm thử CategoryService', () {
    late CategoryService service;

    setUp(() {
      service = CategoryService();
    });

    test('getAll trả về danh mục mặc định', () {
      final all = service.getAll();

      expect(all, isNotEmpty);
    });

    test('getByType expense lọc danh mục chi tiêu', () {
      final expenses = service.getByType('expense');

      expect(expenses.every((c) => c.type == 'expense'), true);
    });

    test('getByType income lọc danh mục thu nhập', () {
      final incomes = service.getByType('income');

      expect(incomes.every((c) => c.type == 'income'), true);
    });

    test('getById trả về danh mục đúng', () {
      final all = service.getAll();
      if (all.isNotEmpty) {
        final first = all.first;
        final found = service.getById(first.id);

        expect(found, isNotNull);
        expect(found!.id, first.id);
      }
    });

    test('create thêm danh mục mới', () {
      final data = {
        'id': 'test_cat',
        'name': 'Test Category',
        'icon': 'star',
        'type': 'expense'
      };

      final result = service.create(data);

      expect(result.name, 'Test Category');
      expect(result.icon, 'star');
      expect(result.type, 'expense');
    });
  });

  group('Kiểm thử TransactionModel', () {
    test('toJson và fromJson hoạt động đúng', () {
      final transaction = TransactionModel(
        id: 'test_123',
        amount: 150000,
        category: 'Ăn uống',
        date: DateTime(2024, 12, 12),
        type: 'expense',
        note: 'Test note',
      );

      final map = transaction.toJson();

      expect(map['id'], 'test_123');
      expect(map['amount'], 150000);
      expect(map['category'], 'Ăn uống');
      expect(map['type'], 'expense');
      expect(map['note'], 'Test note');

      final fromJson = TransactionModel.fromJson(map);

      expect(fromJson.id, transaction.id);
      expect(fromJson.amount, transaction.amount);
      expect(fromJson.category, transaction.category);
    });
  });

  group('Kiểm thử CategoryModel', () {
    test('toJson và fromJson hoạt động đúng', () {
      final category = CategoryModel(
        id: 'cat_123',
        name: 'Ăn uống',
        icon: 'restaurant',
        type: 'expense',
      );

      final map = category.toJson();

      expect(map['id'], 'cat_123');
      expect(map['name'], 'Ăn uống');
      expect(map['icon'], 'restaurant');
      expect(map['type'], 'expense');

      final fromJson = CategoryModel.fromJson(map);

      expect(fromJson.id, category.id);
      expect(fromJson.name, category.name);
      expect(fromJson.icon, category.icon);
      expect(fromJson.type, category.type);
    });
  });
}
