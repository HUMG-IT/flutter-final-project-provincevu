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

// Đổi từ StatelessWidget thành StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Giả lập dữ liệu: Chi tiêu trong nhiều ngày (sẽ lấy 7 ngày gần nhất)
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Thanh trên cùng: Menu, số dư, đổi giao diện
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
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

              // Biểu đồ tròn hiển thị phần trăm chi tiêu - nhỏ hơn, viền dày hơn
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

              // Biểu đồ cột chi tiêu 7 ngày gần đây - nằm trong SizedBox, có scale để tránh overflow
              SizedBox(
                height: 200, // Chiều cao cố định của vùng biểu đồ cột
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiêu 7 ngày gần đây',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

              // Danh sách các danh mục chi tiêu
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      child:
                          const Icon(Icons.category, color: Colors.redAccent),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Biểu đồ tròn – nhỏ hơn, viền dày hơn
class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 90, // nhỏ hơn
          width: 90,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 18, // viền dày hơn nữa
            backgroundColor: Colors.grey.shade300,
            color: Colors.redAccent, // đồng màu với bar để thống nhất chủ đề
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

/// Biểu đồ cột (7 ngày gần đây) – chống overflow bằng LayoutBuilder và scale theo max
class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> spendingData;

  const BarChartWidget({super.key, required this.spendingData});

  @override
  Widget build(BuildContext context) {
    // Lấy 7 ngày gần nhất theo thứ tự thời gian
    final recentData = spendingData.reversed.take(7).toList().reversed.toList();

    // Chuyển amount sang double để tính max
    final amounts =
        recentData.map((e) => (e['amount'] as num).toDouble()).toList();

    final double maxValue =
        amounts.isEmpty ? 0 : amounts.reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính chiều cao tối đa cho THANH CỘT, trừ đi chiều cao label phía trên & dưới
        const double topLabelHeight = 18.0; // Text giá trị phía trên cột
        const double bottomLabelHeight = 14.0; // Text ngày phía dưới cột
        const double verticalSpacing = 6.0; // khoảng cách giữa label và cột

        final double availableHeight = constraints.maxHeight;
        double maxBarHeight = availableHeight -
            topLabelHeight -
            bottomLabelHeight -
            (verticalSpacing * 2);

        // Đảm bảo không âm
        if (maxBarHeight < 0) maxBarHeight = 0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: recentData.map((data) {
            final double amount = (data['amount'] as num).toDouble();
            // scale chiều cao theo maxValue (cột lớn nhất cao bằng maxBarHeight)
            final double scaledHeight =
                maxValue > 0 ? (amount / maxValue) * maxBarHeight : 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Label giá trị phía trên – cố định chiều cao để layout ổn định
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

                // THANH CỘT – màu đỏ, dày hơn, bo góc chỉ phía trên
                Container(
                  height: scaledHeight,
                  width: 18, // dày hơn để nhìn cân đối
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: verticalSpacing),

                // Label ngày phía dưới – cố định chiều cao
                SizedBox(
                  height: bottomLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      // Hiển thị MM-DD
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
