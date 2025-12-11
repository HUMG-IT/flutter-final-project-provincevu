import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/screens/backup_restore_screen.dart';
import 'package:flutter_final_project_provincevu/screens/home_screen.dart';
import 'package:flutter_final_project_provincevu/screens/statistic_category_screen.dart';
import 'package:flutter_final_project_provincevu/screens/statistic_month_screen.dart';

/// Drawer menu bên trái – điều hướng đến màn hình tương ứng và loại bỏ nút "quay lại"
class AppSideMenu extends StatelessWidget {
  AppSideMenu({super.key});

  // Danh sách item menu
  final List<_MenuItem> _menuItems = const [
    _MenuItem(Icons.home, 'Trang chủ'),
    _MenuItem(Icons.pie_chart, 'Thống kê theo tháng'),
    _MenuItem(Icons.list_alt, 'Thống kê theo danh mục'),
    _MenuItem(Icons.backup, 'Sao lưu & Khôi phục'),
    // _MenuItem(Icons.settings, 'Cài đặt'),
  ];

  // Danh sách màn hình tương ứng
  final List<Widget> _screens = [
    const HomeScreen(), // Màn hình trang chủ
    const StatisticMonthScreen(), // Màn hình Thống kê
    const StatisticCategoryScreen(), // Màn hình Danh mục
    const BackupRestoreScreen(),
    // const SettingsScreen(), // Màn hình Cài đặt
    // const AboutScreen(), // Màn hình Giới thiệu
  ];

  void _onSelect(BuildContext context, int index) {
    Navigator.of(context).pop(); // Đóng Drawer
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => _screens[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              accountName: Text('Province Vu'),
              accountEmail: Text('provincevu@example.com'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _menuItems[index]; // Lấy Item Menu
                  return ListTile(
                    leading: Icon(
                      item.icon,
                    ), // Mặc định giữ nguyên màu cho Icon
                    title: Text(item.title), // Mặc định giữ nguyên màu cho Text
                    // Khi chọn item, trigger `_onSelect`
                    onTap: () => _onSelect(context, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lớp model menu giữ thông tin từng item
class _MenuItem {
  final IconData icon;
  final String title;
  const _MenuItem(this.icon, this.title);
}
