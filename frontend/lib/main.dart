import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'services/seven_day_detail.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Khởi tạo AppState (load theme/locale từ storage)
  await AppState().init();

  runApp(const MyApp());
}

/// App root – dùng routes theo màn hình
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi theme/locale
    AppState().addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.themeMode,
      locale: appState.locale,
      routes: {
        '/': (_) => const HomeScreen(),
        '/details': (_) => const DetailsScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/history': (_) => const TransactionHistoryScreen(),
      },
      initialRoute: '/',
    );
  }
}
