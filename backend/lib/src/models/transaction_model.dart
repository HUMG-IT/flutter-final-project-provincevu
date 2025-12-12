/// Model giao dịch (thu nhập/chi tiêu)
class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String type; // 'income' hoặc 'expense'
  final String note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note = '',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
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
