import 'package:flutter/material.dart';

import '../providers/app_state.dart';
import '../side_menu.dart';
import '../utils/app_strings.dart';
import '../utils/app_theme.dart';

/// Màn hình Cài đặt - Theme và Ngôn ngữ (đơn giản)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    final isDark = _appState.isDarkMode;
    final isVi = _appState.isVietnamese;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSideMenu(),
      appBar: AppBar(
        title: Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Switch
          Card(
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppColors.accentBlue : AppColors.accentOrange,
              ),
              title: Text(AppStrings.theme),
              subtitle:
                  Text(isDark ? AppStrings.darkMode : AppStrings.lightMode),
              trailing: Switch(
                value: isDark,
                onChanged: (value) async {
                  await _appState.toggleTheme();
                  setState(() {});
                },
                activeThumbColor: AppColors.primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Language Switch
          Card(
            child: ListTile(
              leading: Text(isVi ? '🇻🇳' : '🇺🇸',
                  style: const TextStyle(fontSize: 24)),
              title: Text(AppStrings.languageLabel),
              subtitle: Text(isVi ? AppStrings.vietnamese : AppStrings.english),
              trailing: Switch(
                value: isVi,
                onChanged: (value) async {
                  await _appState.toggleLanguage();
                  AppStrings.setLanguage(value ? 'vi' : 'en');
                  setState(() {});
                },
                activeThumbColor: AppColors.primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Info
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
