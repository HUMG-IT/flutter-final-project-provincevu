import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/services/login_dialog.dart';
import 'package:flutter_final_project_provincevu/services/syns_data.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final DataSyncService dataSyncService = DataSyncService(); // Khởi tạo service
  bool _loading = false; // Trạng thái tải

  void _showRegisterDialog(BuildContext context, DataSyncService service) {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Đăng ký tài khoản mới"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await service.register(
                    emailController.text.trim(),
                    passController.text.trim(),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đăng ký thành công")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Lỗi đăng ký: $e")));
                }
              },
              child: const Text("Đăng ký"),
            ),
          ],
        );
      },
    );
  }

  /// Thực hiện sao lưu dữ liệu lên Firebase
  Future<void> _performBackup() async {
    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      await dataSyncService.backupToFirebase();
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dữ liệu đã sao lưu thành công"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi khi sao lưu: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Thực hiện khôi phục dữ liệu từ Firebase về Localstore
  Future<void> _performRestore() async {
    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      await dataSyncService.restoreFromFirebase();
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dữ liệu đã được khôi phục"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi khi khôi phục: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sao lưu & Khôi phục"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Bạn có thể sao lưu và khôi phục dữ liệu của mình trên Firebase. "
                  "Hãy đảm bảo rằng bạn đã đăng nhập trước khi thực hiện các thao tác này.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: dataSyncService.isLoggedIn && !_loading
                      ? _performBackup
                      : null, // Không cho ấn nút khi chưa đăng nhập hoặc đang tải
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Sao lưu dữ liệu"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: dataSyncService.isLoggedIn && !_loading
                      ? _performRestore
                      : null,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text("Khôi phục dữ liệu"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 20),
                if (!dataSyncService.isLoggedIn)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Bạn chưa đăng nhập. Hãy "),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => LoginDialog(
                                  dataSyncService: dataSyncService,
                                ),
                              );
                            },
                            child: const Text("đăng nhập"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Hoặc "),
                          TextButton(
                            onPressed: () {
                              _showRegisterDialog(context, dataSyncService);
                            },
                            child: const Text("tạo tài khoản mới"),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Hiển thị trạng thái tải
          if (_loading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
