import 'package:flutter/material.dart';

import '../screens/backup_restore_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistic_category_screen.dart';
import '../screens/statistic_month_screen.dart';
import '../screens/transaction_history_screen.dart';
import '../utils/app_strings.dart';

/// Các hằng số cho index của các màn hình trong menu
class MenuIndex {
  static const int home = 0;
  static const int statisticMonth = 1;
  static const int statisticCategory = 2;
  static const int transactionHistory = 3;
  static const int backupRestore = 4;
  static const int settings = 5;
}

/// Drawer menu bên trái – điều hướng đến màn hình tương ứng và loại bỏ nút "quay lại"
/// [currentIndex] xác định mục menu đang được chọn để highlight
class AppSideMenu extends StatelessWidget {
  final int currentIndex;

  const AppSideMenu({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu highlight cho mục đang chọn - phù hợp với cả dark và light theme
    final selectedColor = isDark
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.primaryContainer.withOpacity(0.3);
    final selectedTextColor = isDark
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.primary;
    final unselectedTextColor =
        isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurface;

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
      // Chỉ navigate nếu không phải màn hình hiện tại
      if (index != currentIndex) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => screens[index]),
        );
      }
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
                  final isSelected = index == currentIndex;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        color: isSelected
                            ? selectedTextColor
                            : unselectedTextColor,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () => onSelect(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
