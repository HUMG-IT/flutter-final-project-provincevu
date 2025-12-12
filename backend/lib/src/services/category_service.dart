import '../models/category_model.dart';

/// Service quản lý danh mục
class CategoryService {
  final Map<String, CategoryModel> _categories = {};

  CategoryService() {
    _initDefaultCategories();
  }

  void _initDefaultCategories() {
    final defaults = [
      CategoryModel(id: 'food', name: 'Ăn uống', icon: 'restaurant', type: 'expense'),
      CategoryModel(id: 'transport', name: 'Đi lại', icon: 'directions_car', type: 'expense'),
      CategoryModel(id: 'shopping', name: 'Mua sắm', icon: 'shopping_bag', type: 'expense'),
      CategoryModel(id: 'entertainment', name: 'Giải trí', icon: 'movie', type: 'expense'),
      CategoryModel(id: 'health', name: 'Sức khoẻ', icon: 'medical_services', type: 'expense'),
      CategoryModel(id: 'education', name: 'Giáo dục', icon: 'school', type: 'expense'),
      CategoryModel(id: 'bills', name: 'Hoá đơn', icon: 'receipt', type: 'expense'),
      CategoryModel(id: 'other_expense', name: 'Khác', icon: 'more_horiz', type: 'expense'),
      CategoryModel(id: 'salary', name: 'Lương', icon: 'account_balance_wallet', type: 'income'),
      CategoryModel(id: 'bonus', name: 'Thưởng', icon: 'card_giftcard', type: 'income'),
      CategoryModel(id: 'investment', name: 'Đầu tư', icon: 'trending_up', type: 'income'),
      CategoryModel(id: 'other_income', name: 'Thu nhập khác', icon: 'attach_money', type: 'income'),
    ];
    for (final cat in defaults) {
      _categories[cat.id] = cat;
    }
  }

  List<CategoryModel> getAll() => _categories.values.toList();

  CategoryModel? getById(String id) => _categories[id];

  List<CategoryModel> getByType(String type) {
    return _categories.values.where((c) => c.type == type).toList();
  }

  CategoryModel create(Map<String, dynamic> data) {
    final cat = CategoryModel.fromJson(data);
    _categories[cat.id] = cat;
    return cat;
  }

  bool delete(String id) => _categories.remove(id) != null;
}
