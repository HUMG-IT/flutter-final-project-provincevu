import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

/// Quản lý trạng thái ứng dụng: Theme và Ngôn ngữ
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final db = Localstore.instance;

  // Theme
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Ngôn ngữ
  Locale _locale = const Locale('vi', 'VN');
  Locale get locale => _locale;
  bool get isVietnamese => _locale.languageCode == 'vi';

  /// Khởi tạo từ local storage
  Future<void> init() async {
    final settings = await db.collection('settings').doc('app').get();
    if (settings != null) {
      _themeMode =
          settings['isDarkMode'] == true ? ThemeMode.dark : ThemeMode.light;
      _locale = settings['language'] == 'en'
          ? const Locale('en', 'US')
          : const Locale('vi', 'VN');
    }
    notifyListeners();
  }

  /// Chuyển đổi theme
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveSettings();
    notifyListeners();
  }

  /// Đặt theme cụ thể
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveSettings();
    notifyListeners();
  }

  /// Chuyển đổi ngôn ngữ
  Future<void> toggleLanguage() async {
    _locale = _locale.languageCode == 'vi'
        ? const Locale('en', 'US')
        : const Locale('vi', 'VN');
    await _saveSettings();
    notifyListeners();
  }

  /// Đặt ngôn ngữ cụ thể
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await db.collection('settings').doc('app').set({
      'isDarkMode': _themeMode == ThemeMode.dark,
      'language': _locale.languageCode,
    });
  }
}
