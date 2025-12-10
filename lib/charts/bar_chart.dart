import 'package:flutter/material.dart';

/// Biểu đồ cột – Stateful
class BarChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> spendingData;

  const BarChartWidget({super.key, required this.spendingData});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  /// Helper function to format numbers with . as thousand separator
  String _formatNumber(num value) {
    final s = value.toStringAsFixed(0);
    return s.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
  }

  /// Helper function to build RichText with number and "đ"
  Widget _vndText(num amount, {Color? color}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
        children: [
          TextSpan(text: _formatNumber(amount)),
          const TextSpan(
            text: ' đ',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentData = widget.spendingData.isEmpty
        ? const <Map<String, dynamic>>[]
        : widget.spendingData.reversed.take(7).toList().reversed.toList();

    final amounts = recentData
        .map((e) => (e['amount'] as num?)?.toDouble() ?? 0.0)
        .toList();

    final double maxValue = amounts.isEmpty
        ? 0
        : amounts.reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double topLabelHeight = 18.0;
        const double bottomLabelHeight = 14.0;
        const double verticalSpacing = 6.0;

        final double availableHeight = constraints.maxHeight;
        double maxBarHeight =
            availableHeight -
            topLabelHeight -
            bottomLabelHeight -
            (verticalSpacing * 2);
        if (maxBarHeight < 0) maxBarHeight = 0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: recentData.map((data) {
            final double amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
            final double scaledHeight = (maxValue > 0 && amount > 0)
                ? (amount / maxValue) * maxBarHeight
                : 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: topLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _vndText(amount, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                Container(
                  height: scaledHeight,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                SizedBox(
                  height: bottomLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      ((data['day'] as String?) ?? '').isNotEmpty
                          ? (data['day'] as String).substring(5)
                          : '',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
