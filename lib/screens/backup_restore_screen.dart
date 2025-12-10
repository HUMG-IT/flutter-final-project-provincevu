import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/services/syns_data.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final DataSyncService dataSyncService = DataSyncService(); // Khởi tạo service
  bool _loading = false; // Trạng thái tải

  /// Thực hiện sao lưu dữ liệu lên Firebase
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

  /// Thực hiện khôi phục dữ liệu từ Firebase về Localstore
  // Trong BackupRestoreScreen, sau khi restore
  Future<void> _performRestore() async {
    setState(() => _loading = true);

    try {
      await dataSyncService.restoreFromFirebase();

      // Sau khi restore xong, gọi reload dữ liệu cho HomeScreen
      // Cách đơn giản nhất là truyền callback hoặc dùng Navigator để pop về home rồi reload, ví dụ:
      // Navigator.of(context).pop(); // Nếu backupRestore là màn phụ
      // Hoặc force reload HomeScreen
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dữ liệu đã được khôi phục!"),
            backgroundColor: Colors.green,
          ),
        );
        // Sau khi khôi phục xong, reload HomeScreen
        // Đơn giản nhất: gọi reload khi pop về Home (ví dụ truyền callback khi mở BackupRestoreScreen)
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
                  "Bạn có thể sao lưu và khôi phục dữ liệu của mình trên Firebase.\n"
                  "Dữ liệu được ghép từ nhiều bộ sưu tập (collections) hiện tại.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: !_loading ? _performBackup : null,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Sao lưu dữ liệu"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 20),
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
