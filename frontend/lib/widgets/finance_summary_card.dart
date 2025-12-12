import 'package:flutter/material.dart';
import 'package:frontend/charts/pie_chart.dart';
import 'package:frontend/screens/statistic_month_screen.dart';
import 'package:frontend/utils/app_strings.dart';
import 'package:frontend/utils/app_theme.dart';
import 'package:frontend/utils/currency.dart';

typedef OnMonthChanged = void Function(DateTime monthYear);

class FinanceSummaryCard extends StatelessWidget {
  final double monthlyIncome;
  final double monthlyExpense;
  final DateTime currentMonth; // Tháng đang chọn
  final OnMonthChanged onMonthChanged;

  const FinanceSummaryCard({
    super.key,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.currentMonth,
    required this.onMonthChanged,
  });

  String get _monthLabel =>
      '${AppStrings.isVietnamese ? "Tháng" : "Month"} ${currentMonth.month.toString().padLeft(2, '0')}, ${currentMonth.year}';

  void _showMonthSelectionBottomSheet(BuildContext context) {
    int selectedMonth = currentMonth.month;
    int selectedYear = currentMonth.year;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  AppStrings.selectMonth,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        value: selectedMonth,
                        isExpanded: true,
                        items: List.generate(
                          12,
                          (i) => DropdownMenuItem(
                            value: i + 1,
                            child: Text(
                              '${AppStrings.isVietnamese ? "Tháng" : "Month"} ${(i + 1).toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            selectedMonth = val;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<int>(
                        value: selectedYear,
                        isExpanded: true,
                        items: List.generate(
                          101, // ví dụ: 2000..2100
                          (i) {
                            final year = 2000 + i;
                            return DropdownMenuItem(
                              value: year,
                              child: Text('$year'),
                            );
                          },
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            selectedYear = val;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onMonthChanged(DateTime(selectedYear, selectedMonth));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: Text(AppStrings.isVietnamese ? 'Áp dụng' : 'Apply'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppStrings.isVietnamese
                        ? 'Sơ lược theo tháng'
                        : 'Monthly summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const StatisticMonthScreen(),
                        ),
                      );
                    },
                    child: Row(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _showMonthSelectionBottomSheet(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _monthLabel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: theme.iconTheme.color ?? Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: PieChartWidget(
                            thuNhap: monthlyIncome,
                            chiTieu: monthlyExpense,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppStrings.income}:',
                            style: theme.textTheme.bodySmall),
                        const SizedBox(height: 6),
                        Text('${AppStrings.expense}:',
                            style: theme.textTheme.bodySmall),
                        const SizedBox(height: 13),
                        Text(
                            AppStrings.isVietnamese ? 'Còn lại:' : 'Remaining:',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        vndText(
                          monthlyIncome,
                          color: AppColors.income,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 6),
                        vndText(
                          monthlyExpense,
                          color: AppColors.expense,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 6),
                        const SizedBox(
                          height: 1,
                          child: Divider(color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 6),
                        vndText(
                          monthlyIncome - monthlyExpense,
                          color: AppColors.income,
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
      ),
    );
  }
}
