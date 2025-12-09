import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/side_menu.dart';

class StatisticMonthScreen extends StatefulWidget {
  const StatisticMonthScreen({super.key});

  @override
  State<StatisticMonthScreen> createState() => _StatisticMonthScreenState();
}

class _StatisticMonthScreenState extends State<StatisticMonthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Key để điều khiển Scaffold và mở Drawer
      // Drawer menu bên trái
      drawer: AppSideMenu(),

      // Nội dung màn hình chính
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
                    // Thanh trên cùng: menu icon, tiêu đề
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nút menu để mở Drawer
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        const Text(
                          'Thống kê theo tháng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder để tạo cân đối
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Nội dung chính của màn hình
                    const Center(
                      child: Text(
                        'Nội dung chính của màn hình Thống kê theo tháng.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
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
