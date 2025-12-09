import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/bar_chart.dart';
import 'package:flutter_final_project_provincevu/charts/pie_chart.dart';
import 'package:flutter_final_project_provincevu/side_menu.dart';

/// Home screen – Stateful
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Key để mở Drawer từ IconButton
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  final double thuNhap = 10000;
  final double chiTieu = 4500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // Drawer (menu bên trái)
      drawer: const AppSideMenu(),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Thanh trên cùng: menu, số dư, đổi giao diện
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Mở Drawer
                            _scaffoldKey.currentState?.openDrawer();
                          },
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
                        child: Center(
                          child: PieChartWidget(
                            thuNhap: thuNhap,
                            chiTieu: chiTieu,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Biểu đồ cột: nút Chi tiết sẽ điều hướng sang screen khác
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
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        '/details',
                                        arguments: getSpendingData(),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Chi tiết"),
                                        SizedBox(width: 6),
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

                    // Danh sách các danh mục – đúng chiều cao, cuộn theo SingleChildScrollView
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent.withValues(
                            alpha: 0.1,
                          ),
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
