import 'package:flutter/material.dart';

/// Biểu đồ tròn – Stateful
class PieChartWidget extends StatefulWidget {
  final double thuNhap;
  final double chiTieu;
  const PieChartWidget({
    super.key,
    required this.thuNhap,
    required this.chiTieu,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  late double total;
  late double percent;

  @override
  void initState() {
    super.initState();
    total = widget.thuNhap + widget.chiTieu;
    percent = widget.chiTieu / total; // ví dụ cho phép thay đổi sau này
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 20,
            backgroundColor: const Color.fromARGB(255, 69, 199, 73),
            color: Colors.redAccent,
          ),
        ),
        Text(
          "${(percent * 100).round()}%",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
