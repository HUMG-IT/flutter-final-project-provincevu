import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/services/syns_data.dart';

class LoginDialog extends StatefulWidget {
  final DataSyncService dataSyncService;

  const LoginDialog({super.key, required this.dataSyncService});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đăng nhập"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Mật khẩu"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await widget.dataSyncService.login(
                _emailController.text.trim(),
                _passwordController.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đăng nhập thành công")),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Lỗi đăng nhập: $e")));
            }
          },
          child: const Text("Đăng nhập"),
        ),
      ],
    );
  }
}
