import 'package:flutter/material.dart';

/// Drawer menu bên trái – giữ đơn giản, không tách model riêng để giảm khó khăn
class AppSideMenu extends StatefulWidget {
  const AppSideMenu({super.key});

  @override
  State<AppSideMenu> createState() => _AppSideMenuState();
}

class _AppSideMenuState extends State<AppSideMenu> {
  int _selectedIndex = 0;

  // Danh sách item menu nằm tại đây để tránh tách file gây phức tạp
  final List<_MenuItem> _menuItems = const [
    _MenuItem(Icons.home, 'Trang chủ'),
    _MenuItem(Icons.pie_chart, 'Biểu đồ'),
    _MenuItem(Icons.list_alt, 'Danh mục'),
    _MenuItem(Icons.settings, 'Cài đặt'),
    _MenuItem(Icons.info, 'Giới thiệu'),
  ];

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Đóng Drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chọn: ${_menuItems[index].title}')),
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

class _MenuItem {
  final IconData icon;
  final String title;
  const _MenuItem(this.icon, this.title);
}
