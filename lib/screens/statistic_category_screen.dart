import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/side_menu.dart';

class StatisticCategoryScreen extends StatefulWidget {
  const StatisticCategoryScreen({super.key});

  @override
  State<StatisticCategoryScreen> createState() =>
      _StatisticCategoryScreenState();
}

class _StatisticCategoryScreenState extends State<StatisticCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Gắn Key vào Scaffold
      // Drawer (menu bên trái)
      drawer: AppSideMenu(),

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
                    // Thanh trên cùng: menu, tiêu đề
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icon Button mở Drawer bên trái
                        IconButton(
                          onPressed: () {
                            // Mở Drawer khi bấm vào Icon
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        const Text(
                          'Thống kê danh mục',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Placeholder để cân bằng khoảng trống
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Nội dung chính của màn hình
                    const Center(
                      child: Text(
                        'Nội dung chính của màn hình Thống kê Danh mục.',
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
