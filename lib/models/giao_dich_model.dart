class Transaction {
  final String id; // ID duy nhất của giao dịch
  final double amount; // Số tiền
  final String category; // Danh mục (e.g., "Ăn uống", "Đi lại")
  final DateTime date; // Ngày giao dịch
  final String type; // Loại giao dịch ('income' hoặc 'expense')
  final String note; // Ghi chú (có thể null)

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note = '',
  });

  factory Transaction.fromMap(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      date: DateTime.parse(data['date'] as String),
      type: data['type'] as String,
      note: data['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type,
      'note': note,
    };
  }
}
