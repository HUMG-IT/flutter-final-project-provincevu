import 'package:flutter/material.dart';

/// Biểu đồ tròn – Stateless
class PieChartWidget extends StatelessWidget {
  final double thuNhap;
  final double chiTieu;

  const PieChartWidget({
    super.key,
    required this.thuNhap,
    required this.chiTieu,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu muốn tỷ lệ chi tiêu so với thu nhập, dùng:
    // final base = thuNhap;
    // final percent = base > 0 ? (chiTieu / base) : 0.0;

    // Hiện tại dùng tỷ lệ chi tiêu trên tổng (thuNhap + chiTieu)
    final total = thuNhap + chiTieu;
    double percent = total > 0 ? (chiTieu / total) : 0.0;

    // Đảm bảo trong khoảng 0..1
    percent = percent.clamp(0.0, 1.0);

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
