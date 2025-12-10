import 'package:flutter/widgets.dart';

String formatNumber(num amount) {
  final s = amount.toStringAsFixed(0);
  return s.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
}

Widget vndText(
  num amount, {
  Color? color,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.bold,
  bool negative = false,
}) {
  final baseStyle = TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
  final number = formatNumber(amount);
  return RichText(
    text: TextSpan(
      style: baseStyle,
      children: [
        TextSpan(text: negative ? '-$number' : number),
        const TextSpan(text: ' '),
        TextSpan(
          text: 'đ',
          style: baseStyle.copyWith(decoration: TextDecoration.underline),
        ),
      ],
    ),
  );
}
