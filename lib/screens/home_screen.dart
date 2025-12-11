import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/bar_chart.dart';
import 'package:flutter_final_project_provincevu/screens/add_expense_screen.dart';
import 'package:flutter_final_project_provincevu/services/category_service.dart';
import 'package:flutter_final_project_provincevu/side_menu.dart';
import 'package:flutter_final_project_provincevu/utils/currency.dart'
    as currency;
import 'package:flutter_final_project_provincevu/widgets/finance_summary_card.dart';
import 'package:localstore/localstore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Localstore.instance;

  // Tổng toàn bộ dữ liệu
  double totalIncomeAll = 0;
  double totalExpenseAll = 0;
  int tongSoDuAll = 0;

  // Dữ liệu theo tháng được chọn
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
      raw.forEach((key, data) {
        final amt = (data['amount'] as num?)?.toDouble() ?? 0.0;
        if (data['type'] == 'income') {
          totalIncome += amt;
        } else if (data['type'] == 'expense') {
          totalExpense += amt;
        }
      });
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
      raw.forEach((key, data) {
        final txDate = DateTime.parse(data['date']);
        if (txDate.month == monthYear.month && txDate.year == monthYear.year) {
          final amt = (data['amount'] as num?)?.toDouble() ?? 0.0;
          if (data['type'] == 'income') {
            mi += amt;
          } else if (data['type'] == 'expense') {
            me += amt;
          }
        }
      });
    }

    setState(() {
      currentMonth = DateTime(monthYear.year, monthYear.month);
      monthlyIncome = mi;
      monthlyExpense = me;
    });
  }

  // Chi tiêu 7 ngày gần đây
  Future<List<Map<String, dynamic>>> _loadDailyExpense7Days() async {
    final raw = await db.collection('transactions').get();
    final now = DateTime.now();
    final Map<String, double> dailyExpenses = {};

    if (raw != null) {
      raw.forEach((key, data) {
        if (data['type'] == 'expense') {
          final txDate = DateTime.parse(data['date']);
          final dateKey =
              "${txDate.year.toString().padLeft(4, '0')}-${txDate.month.toString().padLeft(2, '0')}-${txDate.day.toString().padLeft(2, '0')}";
          final last7days = now.subtract(const Duration(days: 6));
          if (!txDate.isBefore(last7days) && !txDate.isAfter(now)) {
            final amt = (data['amount'] as num?)?.toDouble() ?? 0.0;
            dailyExpenses[dateKey] = (dailyExpenses[dateKey] ?? 0.0) + amt;
          }
        }
      });
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppSideMenu(),
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
                            const Text(
                              'Tổng số dư',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            vndText(
                              tongSoDuAll,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.dark_mode),
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
                      onUpdate: () async {
                        await _loadFinanceForMonth(currentMonth);
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
                              const Row(
                                children: [
                                  Text(
                                    'Chi tiêu 7 ngày gần đây',
                                    style: TextStyle(
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
                                          return const Center(
                                            child: Text('Không có dữ liệu.'),
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
            final id = DateTime.now().millisecondsSinceEpoch.toString();
            await db.collection('transactions').doc(id).set({
              'amount': result['amount'],
              'type': result['type'],
              'categoryId': result['categoryId'],
              'categoryName': result['categoryName'],
              'date': result['date'],
              'note': result['note'],
            });
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
