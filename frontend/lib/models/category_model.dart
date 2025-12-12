class Category {
  final String id; // ID duy nhất
  final String name; // Tên danh mục
  final String type; // "income" hoặc "expense"
  final String icon; // Icon đại diện cho danh mục (e.g., tên Material Icon)

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['id'] as String,
      name: data['name'] as String,
      type: data['type'] as String,
      icon: data['icon'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type, 'icon': icon};
  }
}
