import '../models/category_model.dart';

final List<Category> defaultCategories = [
  Category(id: 'cat_001', name: 'Ăn uống', type: 'expense', icon: 'restaurant'),
  Category(
    id: 'cat_002',
    name: 'Đi lại',
    type: 'expense',
    icon: 'directions_car',
  ),
  Category(
    id: 'cat_003',
    name: 'Sức khỏe',
    type: 'expense',
    icon: 'health_and_safety',
  ),
  Category(id: 'cat_004', name: 'Giáo dục', type: 'expense', icon: 'school'),
  Category(
    id: 'cat_005',
    name: 'Gia đình',
    type: 'expense',
    icon: 'family_restroom',
  ),
  Category(
    id: 'cat_006',
    name: 'Mua sắm',
    type: 'expense',
    icon: 'shopping_cart',
  ),
  Category(id: 'cat_007', name: 'Thú cưng', type: 'expense', icon: 'pets'),
  Category(id: 'cat_008', name: 'Khác', type: 'expense', icon: 'more_horiz'),
  Category(id: 'cat_009', name: 'Lương', type: 'income', icon: 'paid'),
  Category(
    id: 'cat_010',
    name: 'Lãi tiền gửi tiết kiệm',
    type: 'income',
    icon: 'savings',
  ),
  Category(
    id: 'cat_011',
    name: 'Thưởng',
    type: 'income',
    icon: 'card_giftcard',
  ),
];
