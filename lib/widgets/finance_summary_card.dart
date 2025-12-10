import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/pie_chart.dart';
import 'package:flutter_final_project_provincevu/utils/currency.dart';

class FinanceSummaryCard extends StatefulWidget {
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
  State<FinanceSummaryCard> createState() => _FinanceSummaryCardState();
}

class _FinanceSummaryCardState extends State<FinanceSummaryCard> {
  // Danh sách tháng có sẵn
  final List<String> availableMonths = [
    'Tháng 01, 2025',
    'Tháng 02, 2025',
    'Tháng 03, 2025',
    'Tháng 04, 2025',
    'Tháng 05, 2025',
    'Tháng 06, 2025',
    'Tháng 07, 2025',
    'Tháng 08, 2025',
    'Tháng 09, 2025',
    'Tháng 10, 2025',
    'Tháng 11, 2025',
    'Tháng 12, 2025',
  ];

  // Tháng đang được chọn
  String currentMonth = '';

  @override
  void initState() {
    super.initState();
    // Lấy tháng hiện tại nếu có trong danh sách, hoặc mặc định tháng đầu tiên:
    final now = DateTime.now();
    currentMonth = 'Tháng ${now.month.toString().padLeft(2, '0')}, ${now.year}';
    if (!availableMonths.contains(currentMonth)) {
      currentMonth = availableMonths[0];
    }
  }

  /// Hiển thị danh sách tháng trong BottomSheet
  void _showMonthSelectionBottomSheet(BuildContext context) {
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
              // Header của BottomSheet
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: const Text(
                  'Chọn tháng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: availableMonths.length,
                  itemBuilder: (context, index) {
                    final month = availableMonths[index];
                    return ListTile(
                      title: Text(
                        month,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: currentMonth == month
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      ),
                      trailing: currentMonth == month
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          currentMonth = month; // Cập nhật tháng đang chọn
                        });
                        Navigator.pop(context); // Đóng BottomSheet
                        // TODO: Tải dữ liệu liên quan đến tháng ở đây (nếu cần)
                      },
                    );
                  },
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
                    'Sơ lược',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  if (widget.onUpdate != null)
                    TextButton(
                      onPressed: widget.onUpdate,
                      child: const Text(
                        'Cập nhật',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showMonthSelectionBottomSheet(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentMonth,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
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
                            thuNhap: widget.thuNhap,
                            chiTieu: widget.chiTieu,
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
                          widget.thuNhap,
                          color: Colors.green,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 6),
                        vndText(
                          widget.chiTieu,
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
                          widget.thuNhap - widget.chiTieu,
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
