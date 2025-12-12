/// Model danh mục chi tiêu
class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String type; // 'income' hoặc 'expense'

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'category',
      type: json['type'] as String? ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
    };
  }
}
