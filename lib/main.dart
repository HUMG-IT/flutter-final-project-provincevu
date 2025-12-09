import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Giả lập dữ liệu: Chi tiêu trong nhiều ngày (sẽ lấy 7 ngày gần nhất)
  List<Map<String, dynamic>> getSpendingData() {
    return [
      {"day": "2025-12-01", "amount": 300},
      {"day": "2025-12-02", "amount": 500},
      {"day": "2025-12-03", "amount": 700},
      {"day": "2025-12-04", "amount": 200},
      {"day": "2025-12-05", "amount": 900}, // lớn nhất
      {"day": "2025-12-06", "amount": 400},
      {"day": "2025-12-07", "amount": 600},
      {"day": "2025-12-08", "amount": 250}, // ngoài phạm vi 7 ngày
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Đảm bảo nội dung cuộn được
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Thanh trên cùng: menu, số dư, đổi giao diện
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                        const Column(
                          children: [
                            Text(
                              'Tổng số dư',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$15,825.40',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
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

                    // Biểu đồ tròn hiển thị phần trăm chi tiêu
                    SizedBox(
                      height: 140,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: PieChartWidget()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Biểu đồ cột: sửa lỗi TextButton
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
                                  const Text(
                                    'Chi tiêu 7 ngày gần đây',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Chi tiết"),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: BarChartWidget(
                                  spendingData: getSpendingData(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danh sách các danh mục – đúng chiều cao
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.redAccent.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.category,
                            color: Colors.redAccent,
                          ),
                        ),
                        title: Text('Danh mục $index'),
                        subtitle: const Text('Tiền đã chi: \$1000'),
                        trailing: const Text(
                          '-\$500.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Biểu đồ tròn (sửa widget nếu cần)
class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 20,
            backgroundColor: Colors.grey.shade300,
            color: Colors.redAccent,
          ),
        ),
        const Text(
          "70%",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Biểu đồ cột (giữ logic)
class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> spendingData;

  const BarChartWidget({super.key, required this.spendingData});

  @override
  Widget build(BuildContext context) {
    final recentData = spendingData.reversed.take(7).toList().reversed.toList();
    final amounts =
        recentData.map((e) => (e['amount'] as num).toDouble()).toList();
    final double maxValue =
        amounts.isEmpty ? 0 : amounts.reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double topLabelHeight = 18.0;
        const double bottomLabelHeight = 14.0;
        const double verticalSpacing = 6.0;

        final double availableHeight = constraints.maxHeight;
        double maxBarHeight = availableHeight -
            topLabelHeight -
            bottomLabelHeight -
            (verticalSpacing * 2);
        if (maxBarHeight < 0) maxBarHeight = 0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: recentData.map((data) {
            final double amount = (data['amount'] as num).toDouble();
            final double scaledHeight =
                maxValue > 0 ? (amount / maxValue) * maxBarHeight : 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: topLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${amount.toInt()}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                Container(
                  height: scaledHeight,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                SizedBox(
                  height: bottomLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (data['day'] as String).substring(5),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
