import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localstore/localstore.dart';

class DataSyncService {
  final Localstore localStore = Localstore.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String backupRootDocId = 'app_shared_backup';

  final List<String> _collectionsToSync = const ['transactions', 'spending'];

  Future<Map<String, dynamic>> _getCollectionData(String collection) async {
    final data = await localStore.collection(collection).get();
    return data ?? {};
  }

  /// Backup: tạo document session trước, rồi ghi subcollections
  Future<String> backupToFirebase() async {
    final nowIso = DateTime.now().toIso8601String();
    final sessionRef = firestore
        .collection('backups')
        .doc(backupRootDocId)
        .collection('sessions')
        .doc(nowIso);

    try {
      // Tạo document session (bắt buộc để có thể query thấy)
      await sessionRef.set({
        'created_at': FieldValue.serverTimestamp(),
        'created_at_iso': nowIso,
        'app_version': '1.0.0',
      });
      print('Created session doc: ${sessionRef.path}');

      // Ghi data các collections
      for (final collection in _collectionsToSync) {
        final localData = await _getCollectionData(collection);
        final colRef = sessionRef.collection(collection);
        int count = 0;
        for (final entry in localData.entries) {
          await colRef.doc(entry.key).set(entry.value);
          count++;
        }
        print('Wrote $count docs to ${colRef.path}');
      }

      // Ghi finance/totals nếu có
      final financeTotals = await localStore
          .collection('finance')
          .doc('totals')
          .get();
      if (financeTotals != null) {
        await sessionRef.collection('finance').doc('totals').set(financeTotals);
        print(
          'Wrote finance/totals to ${sessionRef.collection('finance').doc('totals').path}',
        );
      } else {
        print('No local finance/totals found');
      }

      // Xác nhận lại có session doc
      final check = await sessionRef.get();
      print('Session exists after backup: ${check.exists}');
      print("Backup thành công tại session: $nowIso");
      return nowIso;
    } catch (e) {
      print('Backup failed: $e');
      rethrow;
    }
  }

  /// Restore: lấy session mới nhất theo created_at
  Future<void> restoreFromFirebase() async {
    print('ProjectId: ${Firebase.app().options.projectId}');

    final sessionsRoot = firestore
        .collection('backups')
        .doc(backupRootDocId)
        .collection('sessions');

    // In ra 5 doc đầu tiên (không order) để xem có gì không
    final testList = await sessionsRoot.limit(5).get();
    print('sessions count (no order): ${testList.docs.length}');
    for (final d in testList.docs) {
      print('session doc id: ${d.id}, data: ${d.data()}');
    }

    final sessionsQuery = sessionsRoot
        .orderBy('created_at', descending: true)
        .limit(1);
    final snapshot = await sessionsQuery.get();
    print('sessionsQuery docs: ${snapshot.docs.length}');
    if (snapshot.docs.isEmpty) {
      print("Không có dữ liệu để phục hồi từ Firebase");
      return;
    }

    final latestBackup = snapshot.docs.first.reference;
    print('Khôi phục từ session: ${latestBackup.id}');

    // Khôi phục các collections
    for (final collection in _collectionsToSync) {
      final colSnap = await latestBackup.collection(collection).get();
      print('Restoring collection $collection, docs: ${colSnap.docs.length}');
      for (final doc in colSnap.docs) {
        await localStore.collection(collection).doc(doc.id).set(doc.data());
      }
    }

    // Khôi phục finance/totals
    final financeTotalsDoc = await latestBackup
        .collection('finance')
        .doc('totals')
        .get();
    print('finance/totals exists: ${financeTotalsDoc.exists}');
    if (financeTotalsDoc.exists) {
      final data = financeTotalsDoc.data();
      if (data != null) {
        await localStore.collection('finance').doc('totals').set(data);
      }
    }

    print("Dữ liệu đã được phục hồi từ Firebase về thiết bị");
  }
}
