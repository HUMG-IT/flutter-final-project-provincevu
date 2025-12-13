import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../charts/pie_chart.dart';
import '../utils/app_strings.dart';
import '../utils/currency.dart' as currency;
import '../widgets/side_menu.dart';

class StatisticMonthScreen extends StatefulWidget {
  const StatisticMonthScreen({super.key});

  @override
  State<StatisticMonthScreen> createState() => _StatisticMonthScreenState();
}

class _StatisticMonthScreenState extends State<StatisticMonthScreen> {
  final db = Localstore.instance;

  late final List<DateTime>
      _months; // First day of each month, descending from current
  final List<_MonthlySummary> _summaries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _months = _generateLast36Months();
    _loadMonthlySummaries();
  }

  List<DateTime> _generateLast36Months() {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month);
    return List.generate(36, (i) {
      final dt = DateTime(currentMonthStart.year, currentMonthStart.month - i);
      return DateTime(dt.year, dt.month); // normalize to first day
    });
  }

  String _monthKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  String _monthLabel(DateTime d) =>
      'Tháng ${d.month.toString().padLeft(2, '0')}, ${d.year}';

  Future<void> _loadMonthlySummaries() async {
    setState(() => _loading = true);

    // Prepare a map for quick aggregation
    final Map<String, _MonthlySummary> byMonth = {
      for (final m in _months) _monthKey(m): _MonthlySummary(month: m),
    };

    final raw = await db.collection('transactions').get();

    if (raw != null) {
      for (final value in raw.values) {
        // value should be a Map from Localstore
        final map = value is Map<String, dynamic>
            ? value
            : Map<String, dynamic>.from(value as Map);
        final dateRaw = map['date'];
        if (dateRaw == null) continue;

        DateTime txDate;
        if (dateRaw is DateTime) {
          txDate = DateTime(dateRaw.year, dateRaw.month, dateRaw.day);
        } else {
          // Expecting ISO8601 String
          try {
            final parsed = DateTime.parse(dateRaw.toString());
            txDate = DateTime(parsed.year, parsed.month, parsed.day);
          } catch (_) {
            continue;
          }
        }

        final key = _monthKey(DateTime(txDate.year, txDate.month));
        if (!byMonth.containsKey(key)) {
          // Not in the last 36 months range
          continue;
        }

        final amt = (map['amount'] as num?)?.toDouble() ?? 0.0;
        final type = map['type']?.toString();

        final summary = byMonth[key]!;
        if (type == 'income') {
          summary.income += amt;
        } else if (type == 'expense') {
          summary.expense += amt;
        }
      }
    }

    // Build summaries list in descending month order (current -> older)
    _summaries
      ..clear()
      ..addAll(_months.map((m) => byMonth[_monthKey(m)]!));

    setState(() => _loading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer integrated into Scaffold (Side Menu)
      drawer: AppSideMenu(),

      appBar: AppBar(
        title: Text(
          AppStrings.isVietnamese
              ? 'Tổng hợp 36 tháng gần đây'
              : 'Last 36 months summary',
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _summaries.isEmpty
              ? const Center(child: Text('Không có dữ liệu giao dịch.'))
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: _summaries.length,
                  itemBuilder: (context, index) {
                    final s = _summaries[index];
                    return _MonthlySummaryCard(
                      title: _monthLabel(s.month),
                      income: s.income,
                      expense: s.expense,
                      vndText: vndText,
                    );
                  },
                ),
    );
  }
}

class _MonthlySummary {
  final DateTime month; // first day of month
  double income;
  double expense;

  _MonthlySummary({required this.month})
      : income = 0.0,
        expense = 0.0;
}

class _MonthlySummaryCard extends StatelessWidget {
  final String title;
  final double income;
  final double expense;
  final Widget Function(
    num amount, {
    Color? color,
    double fontSize,
    FontWeight fontWeight,
    bool negative,
  }) vndText;

  const _MonthlySummaryCard({
    required this.title,
    required this.income,
    required this.expense,
    required this.vndText,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final labelStyle = TextStyle(fontSize: 12, color: textColor);

    return Card(
      // Use theme card color (works with both light/dark mode)
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 90,
                    child: PieChartWidget(thuNhap: income, chiTieu: expense),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.isVietnamese ? 'Thu nhập:' : 'Income:',
                        style: labelStyle,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.isVietnamese ? 'Chi tiêu:' : 'Expense:',
                        style: labelStyle,
                      ),
                      const SizedBox(height: 13),
                      Text(
                        AppStrings.isVietnamese ? 'Còn lại:' : 'Balance:',
                        style: labelStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      vndText(income, color: Colors.green, fontSize: 12),
                      const SizedBox(height: 6),
                      vndText(expense, color: Colors.red, fontSize: 12),
                      const SizedBox(height: 6),
                      const SizedBox(
                        height: 1,
                        child: Divider(color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 6),
                      vndText(
                        income - expense,
                        color:
                            (income - expense) >= 0 ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
