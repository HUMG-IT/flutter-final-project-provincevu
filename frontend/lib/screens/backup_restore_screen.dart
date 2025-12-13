import 'package:flutter/material.dart';

import '../services/syns_data.dart';
import '../widgets/side_menu.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final DataSyncService dataSyncService =
      DataSyncService(); // Service cho việc đồng bộ
  bool _loading = false; // Trạng thái đang thực hiện

  /// Sao lưu dữ liệu lên Firebase
  Future<void> _performBackup() async {
    setState(() => _loading = true);

    try {
      await dataSyncService.backupToFirebase();
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dữ liệu đã sao lưu thành công!"),
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

  /// Khôi phục dữ liệu từ Firebase về Local
  Future<void> _performRestore() async {
    setState(() => _loading = true);

    try {
      await dataSyncService.restoreFromFirebase();

      // Xử lý sau khi khôi phục thành công
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dữ liệu đã được khôi phục!"),
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
      // Side menu (Drawer) cho phép mở danh mục
      drawer: AppSideMenu(),
      appBar: AppBar(
        title: const Text("Sao lưu & Khôi phục"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Bạn có thể sao lưu và khôi phục dữ liệu của mình trên Firebase.\n"
                  "Dữ liệu bao gồm các giao dịch, ví và danh mục hiện có.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Nút sao lưu
                ElevatedButton.icon(
                  onPressed: !_loading ? _performBackup : null,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Sao lưu dữ liệu"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 20),

                // Nút khôi phục
                ElevatedButton.icon(
                  onPressed: !_loading ? _performRestore : null,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text("Khôi phục dữ liệu"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          // Hiển thị Progress Indicator khi đang tải
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
