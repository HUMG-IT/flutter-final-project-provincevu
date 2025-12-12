import 'package:localstore/localstore.dart';

import '../data/default_categories.dart';

class CategoryService {
  final db = Localstore.instance;

  /// Kiểm tra và khởi tạo danh mục mặc định
  Future<void> initializeDefaultCategories() async {
    final existingCategories = await db.collection('categories').get();

    // Nếu danh mục chưa có, thêm danh mục mặc định
    if (existingCategories == null || existingCategories.isEmpty) {
      for (final category in defaultCategories) {
        await db
            .collection('categories')
            .doc(category.id)
            .set(category.toMap());
      }
    }
  }
}
