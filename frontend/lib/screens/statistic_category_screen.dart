import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../charts/category_pie_chart.dart';
import '../data/default_categories.dart';
import '../models/category_model.dart';
import '../models/giao_dich_model.dart';
import '../utils/currency.dart' as currency;
import '../widgets/side_menu.dart';

class StatisticCategoryScreen extends StatefulWidget {
  const StatisticCategoryScreen({super.key});

  @override
  State<StatisticCategoryScreen> createState() =>
      _StatisticCategoryScreenState();
}

class _StatisticCategoryScreenState extends State<StatisticCategoryScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Localstore.instance;

  late TabController _tabController;

  // Lọc theo tháng hoặc năm
  String _filterType = 'month'; // 'month' hoặc 'year'
  late int _selectedMonth;
  late int _selectedYear;

  // Dữ liệu
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  final Map<String, double> _categoryTotals = {};

  // Màu xanh lá đẹp
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _lightGreen = Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;

    _loadCategories();
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
    _calculateCategoryTotals();
  }

  String get _currentType => _tabController.index == 0 ? 'expense' : 'income';

  Future<void> _loadCategories() async {
    final raw = await db.collection('categories').get();
    if (raw != null && raw.isNotEmpty) {
      _categories = raw.values.map((e) => Category.fromMap(e)).toList();
    } else {
      _categories = defaultCategories;
    }
    setState(() {});
  }

  Future<void> _loadTransactions() async {
    final raw = await db.collection('transactions').get();
    if (raw != null) {
      _transactions = raw.values.map((e) {
        if (e is Map<String, dynamic>) {
          return Transaction.fromMap(e);
        }
        return e as Transaction;
      }).toList();
    }
    _calculateCategoryTotals();
    setState(() {});
  }

  void _calculateCategoryTotals() {
    _categoryTotals.clear();

    final filteredTransactions = _transactions.where((tx) {
      // Lọc theo type (chi tiêu/thu nhập)
      if (tx.type != _currentType) return false;

      // Lọc theo thời gian
      if (_filterType == 'month') {
        return tx.date.month == _selectedMonth && tx.date.year == _selectedYear;
      } else {
        return tx.date.year == _selectedYear;
      }
    });

    for (final tx in filteredTransactions) {
      _categoryTotals[tx.category] =
          (_categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    setState(() {});
  }

  List<Category> get _filteredCategories {
    return _categories.where((c) => c.type == _currentType).toList();
  }

  List<PieChartData> get _chartData {
    final categories = _filteredCategories;
    final List<PieChartData> data = [];

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final total = _categoryTotals[cat.name] ?? 0;
      if (total > 0) {
        data.add(
          PieChartData(
            label: cat.name,
            value: total,
            color: ChartColors.getColor(i, _currentType),
          ),
        );
      }
    }

    return data;
  }

  double get _totalAmount {
    return _categoryTotals.values.fold(0.0, (sum, v) => sum + v);
  }

  // Tạo danh sách 12 tháng gần nhất
  List<Map<String, int>> _getLast12Months() {
    final now = DateTime.now();
    final List<Map<String, int>> months = [];
    int year = now.year;
    int month = now.month;
    for (int i = 0; i < 12; i++) {
      months.add({'month': month, 'year': year});
      month--;
      if (month == 0) {
        month = 12;
        year--;
      }
    }
    return months;
  }

  // Tạo danh sách 12 năm gần nhất
  List<int> _getLast12Years() {
    final now = DateTime.now();
    return List.generate(12, (i) => now.year - i);
  }

  void _showCategoryHistory(Category category) {
    final transactions = _transactions.where((tx) {
      if (tx.category != category.name || tx.type != _currentType) return false;
      if (_filterType == 'month') {
        return tx.date.month == _selectedMonth && tx.date.year == _selectedYear;
      } else {
        return tx.date.year == _selectedYear;
      }
    }).toList();

    transactions.sort((a, b) => b.date.compareTo(a.date));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconData(category.icon),
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${transactions.length} giao dịch',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có giao dịch nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: tx.type == 'expense'
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            child: Icon(
                              tx.type == 'expense' ? Icons.remove : Icons.add,
                              color: tx.type == 'expense'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          title: currency.vndText(
                            tx.amount,
                            color: tx.type == 'expense'
                                ? Colors.red
                                : Colors.green,
                            fontSize: 16,
                          ),
                          subtitle: Text(
                            tx.note.isNotEmpty ? tx.note : 'Không có ghi chú',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
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
    return iconMap[iconName] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppSideMenu(),
      body: Column(
        children: [
          // Header với background xanh lá
          _buildHeader(),

          // Tab Chi tiêu / Thu nhập
          _buildTabBar(),

          // Nội dung chính
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bộ lọc tháng/năm
                  _buildFilterSection(),
                  const SizedBox(height: 20),

                  // Biểu đồ tròn
                  _buildPieChart(),
                  const SizedBox(height: 20),

                  // Danh sách danh mục
                  _buildCategoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryGreen, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Thống kê theo danh mục',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance cho icon menu
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.grey.shade100,
      child: TabBar(
        controller: _tabController,
        labelColor: _primaryGreen,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _primaryGreen,
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.trending_down), text: 'Chi tiêu'),
          Tab(icon: Icon(Icons.trending_up), text: 'Thu nhập'),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lọc theo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Toggle Tháng/Năm
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'month', label: Text('Tháng')),
                      ButtonSegment(value: 'year', label: Text('Năm')),
                    ],
                    selected: {_filterType},
                    onSelectionChanged: (value) {
                      setState(() {
                        _filterType = value.first;
                      });
                      _calculateCategoryTotals();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return _lightGreen;
                        }
                        return null;
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Dropdown chọn tháng hoặc năm
            _filterType == 'month'
                ? _buildMonthDropdown()
                : _buildYearDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    final months = _getLast12Months();
    final values = months.map((m) => '${m['month']}_${m['year']}').toList();
    String currentValue = '${_selectedMonth}_$_selectedYear';
    if (!values.contains(currentValue)) {
      currentValue = values.first;
      final parts = currentValue.split('_');
      _selectedMonth = int.parse(parts[0]);
      _selectedYear = int.parse(parts[1]);
    }
    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      decoration: InputDecoration(
        labelText: 'Chọn tháng',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: months.map((m) {
        final value = '${m['month']}_${m['year']}';
        return DropdownMenuItem(
          value: value,
          child: Text('Tháng ${m['month']}/${m['year']}'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          final parts = value.split('_');
          setState(() {
            _selectedMonth = int.parse(parts[0]);
            _selectedYear = int.parse(parts[1]);
          });
          _calculateCategoryTotals();
        }
      },
    );
  }

  Widget _buildYearDropdown() {
    final years = _getLast12Years();

    return DropdownButtonFormField<int>(
      initialValue: _selectedYear,
      decoration: InputDecoration(
        labelText: 'Chọn năm',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: years.map((y) {
        return DropdownMenuItem(value: y, child: Text('Năm $y'));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedYear = value;
          });
          _calculateCategoryTotals();
        }
      },
    );
  }

  Widget _buildPieChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _currentType == 'expense'
                  ? 'Chi tiêu theo danh mục'
                  : 'Thu nhập theo danh mục',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            CategoryPieChart(data: _chartData, size: 220, strokeWidth: 35),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _chartData.map((item) {
                final percent = _totalAmount > 0
                    ? (item.value / _totalAmount * 100).toStringAsFixed(1)
                    : '0';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.label} ($percent%)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = _filteredCategories;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Danh mục',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final total = _categoryTotals[cat.name] ?? 0;
              final color = ChartColors.getColor(index, _currentType);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(_getIconData(cat.icon), color: color),
                ),
                title: Text(
                  cat.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: currency.vndText(
                  total,
                  color: _currentType == 'expense' ? Colors.red : Colors.green,
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
}
