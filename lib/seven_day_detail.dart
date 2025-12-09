import 'package:flutter/material.dart';

/// Details screen – Stateful, nhận dữ liệu qua arguments khi điều hướng
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Map<String, dynamic>> _data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _data = (args is List<Map<String, dynamic>>) ? args : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết chi tiêu')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _data.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _data[index];
          return ListTile(
            title: Text(item['day'].toString()),
            trailing: Text('\$${item['amount']}'),
          );
        },
      ),
    );
  }
}
