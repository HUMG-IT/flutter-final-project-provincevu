import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/pie_chart.dart';
import 'package:flutter_final_project_provincevu/utils/currency.dart';

typedef OnMonthChanged = void Function(DateTime monthYear);

class FinanceSummaryCard extends StatelessWidget {
  final double monthlyIncome;
  final double monthlyExpense;
  final DateTime currentMonth; // Tháng đang chọn
  final OnMonthChanged onMonthChanged;
  final VoidCallback? onUpdate;

  const FinanceSummaryCard({
    super.key,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.currentMonth,
    required this.onMonthChanged,
    this.onUpdate,
  });

  String get _monthLabel =>
      'Tháng ${currentMonth.month.toString().padLeft(2, '0')}, ${currentMonth.year}';

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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  'Chọn tháng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              'Tháng ${(i + 1).toString().padLeft(2, '0')}',
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
                    label: const Text('Áp dụng'),
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
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 4,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Sơ lược theo tháng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  if (onUpdate != null)
                    TextButton(
                      onPressed: onUpdate,
                      child: const Text(
                        'chi tiết',
                        style: TextStyle(fontSize: 13),
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: Colors.grey,
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
                  const Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Thu nhập:', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 6),
                        Text('Chi tiêu:', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 13),
                        Text('Còn lại:', style: TextStyle(fontSize: 12)),
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
                          color: Colors.green,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 6),
                        vndText(
                          monthlyExpense,
                          color: Colors.red,
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
                          color: Colors.green,
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
