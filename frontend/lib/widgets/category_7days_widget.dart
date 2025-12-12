import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../charts/category_pie_chart.dart';
import '../data/default_categories.dart';
import '../models/category_model.dart';
import '../models/giao_dich_model.dart';
import '../screens/statistic_category_screen.dart';
import '../screens/transaction_history_screen.dart';
import '../utils/app_strings.dart';
import '../utils/app_theme.dart';
import '../utils/currency.dart' as currency;

// Map từ String sang IconData để dùng cho Category
const Map<String, IconData> categoryIconMap = {
  'restaurant': Icons.restaurant,
  'directions_car': Icons.directions_car,
  'health_and_safety': Icons.health_and_safety,
  'school': Icons.school,
  'family_restroom': Icons.family_restroom,
  'shopping_cart': Icons.shopping_cart,
  'pets': Icons.pets,
  'more_horiz': Icons.more_horiz,
  'paid': Icons.paid,
  'savings': Icons.savings,
  'card_giftcard': Icons.card_giftcard,
};

/// Widget thống kê chi tiêu theo danh mục 7 ngày gần đây (Bar Line)
class Category7DaysWidget extends StatefulWidget {
  const Category7DaysWidget({super.key});

  @override
  State<Category7DaysWidget> createState() => _Category7DaysWidgetState();
}

class _Category7DaysWidgetState extends State<Category7DaysWidget> {
  final db = Localstore.instance;
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  Map<String, double> _categoryTotals = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load categories
    final catRaw = await db.collection('categories').get();
    if (catRaw != null && catRaw.isNotEmpty) {
      _categories = catRaw.values.map((e) => Category.fromMap(e)).toList();
    } else {
      _categories = defaultCategories;
    }

    // Load transactions
    final txRaw = await db.collection('transactions').get();
    if (txRaw != null) {
      _transactions = txRaw.values.map((e) {
        if (e is Map<String, dynamic>) {
          return Transaction.fromMap(e);
        }
        return e as Transaction;
      }).toList();
    }

    _calculateTotals();
    setState(() => _isLoading = false);
  }

  void _calculateTotals() {
    _categoryTotals = {};
    final now = DateTime.now();
    final last7days = now.subtract(const Duration(days: 6));

    final filteredTransactions = _transactions.where((tx) {
      if (tx.type != 'expense') return false;
      return !tx.date.isBefore(
            DateTime(last7days.year, last7days.month, last7days.day),
          ) &&
          !tx.date.isAfter(now);
    });

    for (final tx in filteredTransactions) {
      _categoryTotals[tx.category] =
          (_categoryTotals[tx.category] ?? 0) + tx.amount;
    }
  }

  List<Category> get _expenseCategories {
    return _categories.where((c) => c.type == 'expense').toList();
  }

  List<_BarData> get _barData {
    final categories = _expenseCategories;
    final List<_BarData> data = [];

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final total = _categoryTotals[cat.name] ?? 0;
      if (total > 0) {
        data.add(
          _BarData(
            label: cat.name,
            value: total,
            color: ChartColors.getColor(i, 'expense'),
          ),
        );
      }
    }
    // Sắp xếp giảm dần theo giá trị
    data.sort((a, b) => b.value.compareTo(a.value));
    return data;
  }

  double get _totalAmount {
    return _categoryTotals.values.fold(0.0, (sum, v) => sum + v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final barData = _barData;
    final total = _totalAmount;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.isVietnamese
                      ? 'Danh mục 7 ngày gần đây'
                      : 'Categories in last 7 days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StatisticCategoryScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.isVietnamese ? 'chi tiết' : 'details',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (barData.isEmpty)
              SizedBox(
                height: 80,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.noData,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  // Bar Line
                  SizedBox(
                    height: 32,
                    child: _MultiColorBar(data: barData, total: total),
                  ),
                  const SizedBox(height: 12),
                  // Legend
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: barData.take(6).map((item) {
                      final percent = total > 0
                          ? (item.value / total * 100).toStringAsFixed(1)
                          : '0';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: item.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(item.label, style: theme.textTheme.bodySmall),
                          const SizedBox(width: 3),
                          Text(
                            '($percent%)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  if (barData.length > 6)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${barData.length - 6} ${AppStrings.isVietnamese ? 'danh mục khác' : 'more categories'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),

            const Divider(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.total,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currency.vndText(
                  total,
                  color: AppColors.expense,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Danh sách category
            _buildCategoryList(theme),
          ],
        ),
      ),
    );
  }

  // Widget danh sách category
  Widget _buildCategoryList(ThemeData theme) {
    final categories = _expenseCategories;

    // Chỉ hiển thị category có giao dịch
    final categoriesWithData = categories
        .where((c) => (_categoryTotals[c.name] ?? 0) > 0)
        .toList();

    if (categoriesWithData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppStrings.isVietnamese ? 'Danh mục' : 'Categories',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoriesWithData.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cat = categoriesWithData[index];
              final total = _categoryTotals[cat.name] ?? 0;
              final color = ChartColors.getColor(index, 'expense');

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(_getIconData(cat.icon), color: color),
                ),
                title: Text(
                  cat.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: currency.vndText(
                  total,
                  color: AppColors.expense,
                  fontSize: 14,
                ),
                onTap: () => _showCategoryHistory(cat),
              );
            },
          ),
        ],
      ),
    );
  }

  // Hiển thị lịch sử giao dịch của category
  void _showCategoryHistory(Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionHistoryScreen(
          categoryFilter: category.name,
          typeFilter: 'expense',
        ),
      ),
    );
  }

  // Hàm lấy icon cho category
  IconData _getIconData(String? iconName) {
    return categoryIconMap[iconName] ?? Icons.category;
  }
}

/// Dữ liệu cho từng phần của bar
class _BarData {
  final String label;
  final double value;
  final Color color;
  _BarData({required this.label, required this.value, required this.color});
}

/// Widget vẽ bar line nhiều màu
class _MultiColorBar extends StatelessWidget {
  final List<_BarData> data;
  final double total;

  const _MultiColorBar({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || total == 0) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        return Row(
          children: data.map((item) {
            final percent = item.value / total;
            return Container(
              width: width * percent,
              height: 28,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.horizontal(
                  left: item == data.first
                      ? const Radius.circular(8)
                      : Radius.zero,
                  right: item == data.last
                      ? const Radius.circular(8)
                      : Radius.zero,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
