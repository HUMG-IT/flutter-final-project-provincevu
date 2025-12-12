import 'dart:math';

import 'package:flutter/material.dart';

/// Model cho dữ liệu biểu đồ tròn
class PieChartData {
  final String label;
  final double value;
  final Color color;

  PieChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Biểu đồ tròn nhiều màu - hiển thị phần trăm từng danh mục
class CategoryPieChart extends StatelessWidget {
  final List<PieChartData> data;
  final double size;
  final double strokeWidth;

  const CategoryPieChart({
    super.key,
    required this.data,
    this.size = 200,
    this.strokeWidth = 30,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    if (total == 0) {
      return SizedBox(
        height: size,
        width: size,
        child: const Center(
          child: Text(
            'Không có dữ liệu',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(
        painter: _PieChartPainter(
          data: data,
          total: total,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_formatNumber(total.toInt())}đ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Tổng',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final double total;
  final double strokeWidth;

  _PieChartPainter({
    required this.data,
    required this.total,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    double startAngle = -pi / 2; // Bắt đầu từ 12 giờ

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * pi;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Danh sách màu mặc định cho biểu đồ
class ChartColors {
  static const List<Color> expense = [
    Color(0xFFE57373), // Đỏ nhạt
    Color(0xFFFFB74D), // Cam
    Color(0xFFFFF176), // Vàng
    Color(0xFF81C784), // Xanh lá nhạt
    Color(0xFF64B5F6), // Xanh dương nhạt
    Color(0xFF9575CD), // Tím
    Color(0xFFF06292), // Hồng
    Color(0xFF4DB6AC), // Xanh ngọc
    Color(0xFFFFD54F), // Vàng đậm
    Color(0xFFA1887F), // Nâu
  ];

  static const List<Color> income = [
    Color(0xFF66BB6A), // Xanh lá
    Color(0xFF42A5F5), // Xanh dương
    Color(0xFFAB47BC), // Tím
    Color(0xFF26A69A), // Xanh ngọc
    Color(0xFFFFCA28), // Vàng
  ];

  static Color getColor(int index, String type) {
    final colors = type == 'income' ? income : expense;
    return colors[index % colors.length];
  }
}
