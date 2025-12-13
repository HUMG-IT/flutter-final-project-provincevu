import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../charts/bar_chart.dart';
import '../models/giao_dich_model.dart';
import '../providers/app_state.dart';
import '../services/category_service.dart';
import '../side_menu.dart';
import '../utils/app_strings.dart';
import '../utils/currency.dart' as currency;
import '../widgets/category_7days_widget.dart';
import '../widgets/finance_summary_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Localstore.instance;

  double totalIncomeAll = 0;
  double totalExpenseAll = 0;
  int tongSoDuAll = 0;

  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  double monthlyIncome = 0;
  double monthlyExpense = 0;

  @override
  void initState() {
    super.initState();
    CategoryService().initializeDefaultCategories();
    _loadOverallBalances();
    _loadFinanceForMonth(currentMonth);
  }

  Widget vndText(
    num amount, {
    Color? color,
    double fontSize = 10.0,
    FontWeight fontWeight = FontWeight.bold,
    bool negative = false,
  }) {
    return currency.vndText(
      amount,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      negative: negative,
    );
  }

  // Tổng hợp toàn bộ income/expense
  Future<void> _loadOverallBalances() async {
    final raw = await db.collection('transactions').get();
    double totalIncome = 0;
    double totalExpense = 0;

    if (raw != null) {
      // Đảm bảo luôn xử lý Map
      for (final value in raw.values) {
        // Nếu value là Transaction (object), chuyển lại sang Map
        final map = value is Map<String, dynamic>
            ? value
            : (value as Transaction).toMap();
        final amt = (map['amount'] as num?)?.toDouble() ?? 0.0;
        if (map['type'] == 'income') {
          totalIncome += amt;
        } else if (map['type'] == 'expense') {
          totalExpense += amt;
        }
      }
    }

    setState(() {
      totalIncomeAll = totalIncome;
      totalExpenseAll = totalExpense;
      tongSoDuAll = (totalIncome - totalExpense).toInt();
    });
  }

  // Tổng hợp theo tháng được chọn
  Future<void> _loadFinanceForMonth(DateTime monthYear) async {
    final raw = await db.collection('transactions').get();
    double mi = 0;
    double me = 0;

    if (raw != null) {
      for (final value in raw.values) {
        final map = value is Map<String, dynamic>
            ? value
            : (value as Transaction).toMap();
        final dateRaw = map['date'];
        final txDate =
            dateRaw is DateTime ? dateRaw : DateTime.parse(dateRaw.toString());
        if (txDate.month == monthYear.month && txDate.year == monthYear.year) {
          final amt = (map['amount'] as num?)?.toDouble() ?? 0.0;
          if (map['type'] == 'income') {
            mi += amt;
          } else if (map['type'] == 'expense') {
            me += amt;
          }
        }
      }
    }

    setState(() {
      currentMonth = DateTime(monthYear.year, monthYear.month);
      monthlyIncome = mi;
      monthlyExpense = me;
    });
  }

  // Chi tiêu 7 ngày gần đây - cũng đọc ra Map cho an toàn
  Future<List<Map<String, dynamic>>> _loadDailyExpense7Days() async {
    final raw = await db.collection('transactions').get();
    final now = DateTime.now();
    final Map<String, double> dailyExpenses = {};

    if (raw != null) {
      for (final value in raw.values) {
        final map = value is Map<String, dynamic>
            ? value
            : (value as Transaction).toMap();
        if (map['type'] == 'expense') {
          final dateRaw = map['date'];
          final txDate = dateRaw is DateTime
              ? dateRaw
              : DateTime.parse(dateRaw.toString());
          final dateKey =
              "${txDate.year.toString().padLeft(4, '0')}-${txDate.month.toString().padLeft(2, '0')}-${txDate.day.toString().padLeft(2, '0')}";
          final last7days = now.subtract(const Duration(days: 6));
          if (!txDate.isBefore(last7days) && !txDate.isAfter(now)) {
            final amt = (map['amount'] as num?)?.toDouble() ?? 0.0;
            dailyExpenses[dateKey] = (dailyExpenses[dateKey] ?? 0.0) + amt;
          }
        }
      }
    }

    final result = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dateKey =
          "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
      result.add({'day': dateKey, 'amount': dailyExpenses[dateKey] ?? 0.0});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSideMenu(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  children: [
                    // Header: Tổng số dư toàn bộ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          icon: const Icon(Icons.menu),
                        ),
                        Column(
                          children: [
                            Text(
                              AppStrings.totalBalance,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                            vndText(
                              tongSoDuAll,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => AppState().toggleTheme(),
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sơ lược theo tháng (Pie + thống kê tháng)
                    FinanceSummaryCard(
                      monthlyIncome: monthlyIncome,
                      monthlyExpense: monthlyExpense,
                      currentMonth: currentMonth,
                      onMonthChanged: (monthYear) async {
                        await _loadFinanceForMonth(monthYear);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),

                    // BarChart: Chi tiêu 7 ngày gần đây
                    SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppStrings.last7Days,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child:
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                  future: _loadDailyExpense7Days(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Text(AppStrings.noData),
                                      );
                                    }
                                    final spendingData = snapshot.data!;
                                    return BarChartWidget(
                                      spendingData: spendingData,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Thống kê theo danh mục 7 ngày
                    Category7DaysWidget(
                        key: ValueKey(DateTime.now().millisecondsSinceEpoch)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (result != null) {
            // luôn dùng model toMap để lưu vào localstore, đảm bảo luôn là Map khi đọc lại
            final tx = result as Transaction;
            await db.collection('transactions').doc(tx.id).set(tx.toMap());
            await _loadOverallBalances();
            await _loadFinanceForMonth(currentMonth);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
