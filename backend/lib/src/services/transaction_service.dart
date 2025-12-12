import '../models/transaction_model.dart';

/// Service xử lý logic nghiệp vụ giao dịch (in-memory storage)
class TransactionService {
  // In-memory storage - trong thực tế có thể thay bằng database
  final Map<String, TransactionModel> _transactions = {};

  /// Lấy tất cả giao dịch
  List<TransactionModel> getAll() {
    return _transactions.values.toList();
  }

  /// Lấy giao dịch theo ID
  TransactionModel? getById(String id) {
    return _transactions[id];
  }

  /// Tạo giao dịch mới
  TransactionModel create(Map<String, dynamic> data) {
    final id = data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    final transaction = TransactionModel(
      id: id,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      date: data['date'] != null
          ? DateTime.parse(data['date'] as String)
          : DateTime.now(),
      type: data['type'] as String,
      note: data['note'] as String? ?? '',
    );
    _transactions[id] = transaction;
    return transaction;
  }

  /// Cập nhật giao dịch
  TransactionModel? update(String id, Map<String, dynamic> data) {
    if (!_transactions.containsKey(id)) return null;

    final existing = _transactions[id]!;
    final updated = TransactionModel(
      id: id,
      amount: (data['amount'] as num?)?.toDouble() ?? existing.amount,
      category: data['category'] as String? ?? existing.category,
      date: data['date'] != null
          ? DateTime.parse(data['date'] as String)
          : existing.date,
      type: data['type'] as String? ?? existing.type,
      note: data['note'] as String? ?? existing.note,
    );
    _transactions[id] = updated;
    return updated;
  }

  /// Xoá giao dịch
  bool delete(String id) {
    return _transactions.remove(id) != null;
  }

  /// Lấy giao dịch theo tháng
  List<TransactionModel> getByMonth(int year, int month) {
    return _transactions.values.where((tx) {
      return tx.date.year == year && tx.date.month == month;
    }).toList();
  }

  /// Tính tổng thu nhập
  double getTotalIncome() {
    return _transactions.values
        .where((tx) => tx.type == 'income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Tính tổng chi tiêu
  double getTotalExpense() {
    return _transactions.values
        .where((tx) => tx.type == 'expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Tính số dư
  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  /// Thống kê chi tiêu 7 ngày gần đây
  List<Map<String, dynamic>> getLast7DaysExpense() {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dateKey =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

      final dayExpense = _transactions.values.where((tx) {
        return tx.type == 'expense' &&
            tx.date.year == day.year &&
            tx.date.month == day.month &&
            tx.date.day == day.day;
      }).fold(0.0, (sum, tx) => sum + tx.amount);

      result.add({'day': dateKey, 'amount': dayExpense});
    }
    return result;
  }
}
