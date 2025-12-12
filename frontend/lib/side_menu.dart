import 'package:flutter/material.dart';
import 'package:frontend/screens/backup_restore_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/statistic_category_screen.dart';
import 'package:frontend/screens/statistic_month_screen.dart';
import 'package:frontend/screens/transaction_history_screen.dart';
import 'package:frontend/utils/app_strings.dart';

/// Drawer menu bên trái – điều hướng đến màn hình tương ứng và loại bỏ nút "quay lại"
class AppSideMenu extends StatelessWidget {
  const AppSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách item menu với i18n
    final menuItems = [
      _MenuItem(Icons.home, AppStrings.home),
      _MenuItem(Icons.pie_chart, AppStrings.statisticByMonth),
      _MenuItem(Icons.list_alt, AppStrings.statisticByCategory),
      _MenuItem(Icons.history, AppStrings.transactionHistory),
      _MenuItem(Icons.backup, AppStrings.backupRestore),
      _MenuItem(Icons.settings, AppStrings.settings),
    ];

    // Danh sách màn hình tương ứng
    final screens = <Widget>[
      const HomeScreen(),
      const StatisticMonthScreen(),
      const StatisticCategoryScreen(),
      const TransactionHistoryScreen(),
      const BackupRestoreScreen(),
      const SettingsScreen(),
    ];

    void onSelect(int index) {
      Navigator.of(context).pop(); // Đóng Drawer
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => screens[index]),
      );
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              accountName: const Text('Province Vu'),
              accountEmail: const Text('provincevu@example.com'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    onTap: () => onSelect(index),
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
