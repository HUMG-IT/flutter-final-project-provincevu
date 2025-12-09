import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/screens/home_screen.dart';
import 'package:flutter_final_project_provincevu/seven_day_detail.dart';

void main() {
  runApp(const MyApp());
}

/// App root – dùng routes theo màn hình
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomeScreen(),
        '/details': (_) => const DetailsScreen(),
      },
      initialRoute: '/',
    );
  }
}
