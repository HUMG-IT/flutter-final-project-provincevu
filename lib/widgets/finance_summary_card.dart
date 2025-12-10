import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/pie_chart.dart';
import 'package:flutter_final_project_provincevu/utils/currency.dart';

class FinanceSummaryCard extends StatelessWidget {
  final double thuNhap;
  final double chiTieu;
  final VoidCallback? onUpdate;
  const FinanceSummaryCard({
    super.key,
    required this.thuNhap,
    required this.chiTieu,
    this.onUpdate,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  const Text(
                    'Sơ lược',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  if (onUpdate != null)
                    TextButton(
                      onPressed: onUpdate,
                      child: const Text(
                        'Cập nhật',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (context) {
                            final now = DateTime.now();
                            final month = now.month.toString().padLeft(2, '0');
                            final year = now.year;
                            return Text(
                              'Tháng $month, $year',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: PieChartWidget(
                            thuNhap: thuNhap,
                            chiTieu: chiTieu,
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
                        Text('Thu nhập:', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 6),
                        Text('Chi tiêu:', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 6),
                        Text('Còn lại:', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        vndText(
                          thuNhap,
                          color: const Color.fromARGB(255, 65, 80, 197),
                          fontSize: 14,
                        ),
                        const SizedBox(height: 6),
                        vndText(chiTieu, color: Colors.red, fontSize: 14),
                        const SizedBox(height: 6),
                        vndText(
                          thuNhap - chiTieu,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
