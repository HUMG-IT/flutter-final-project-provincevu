class Wallet {
  final String id; // ID duy nhất của ví
  final String name; // Tên ví (e.g., "Ví Tiền mặt", "Thẻ Vietcombank")
  final double balance; // Số dư hiện tại

  Wallet({required this.id, required this.name, required this.balance});

  factory Wallet.fromMap(Map<String, dynamic> data) {
    return Wallet(
      id: data['id'] as String,
      name: data['name'] as String,
      balance: (data['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'balance': balance};
  }
}
