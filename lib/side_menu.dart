import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/screens/home_screen.dart';
import 'package:flutter_final_project_provincevu/screens/statistic_category_screen.dart';
import 'package:flutter_final_project_provincevu/screens/statistic_month_screen.dart';

/// Drawer menu bên trái – điều hướng đến màn hình tương ứng
class AppSideMenu extends StatefulWidget {
  const AppSideMenu({super.key});

  @override
  State<AppSideMenu> createState() => _AppSideMenuState();
}

class _AppSideMenuState extends State<AppSideMenu> {
  int _selectedIndex = 0;

  // Danh sách item menu
  final List<_MenuItem> _menuItems = const [
    _MenuItem(Icons.home, 'Trang chủ'),
    _MenuItem(Icons.pie_chart, 'Thống kê theo tháng'),
    _MenuItem(Icons.list_alt, 'Thống kê theo danh mục'),
  ];

  // Danh sách màn hình tương ứng
  final List<Widget> _screens = [
    const HomeScreen(), // Màn hình trang chủ
    const StatisticMonthScreen(), // Màn hình Thống kê
    const StatisticCategoryScreen(), // Màn hình Danh mục
  ];

  /// Xử lý lựa chọn menu
  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật Index được chọn
    });

    // Đóng Drawer
    Navigator.of(context).pop();

    // Điều hướng đến màn hình tương ứng
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => _screens[index]),
      (route) => false, // Xóa tất cả các route trước
    );
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
                  final item = _menuItems[index];
                  final selected = index == _selectedIndex;
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: selected ? Colors.blue : null,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selected ? Colors.blue : null,
                      ),
                    ),
                    // Khi chọn item, trigger `_onSelect`
                    onTap: () => _onSelect(index),
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
