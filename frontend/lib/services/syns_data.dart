import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Ghi data các collections
      for (final collection in _collectionsToSync) {
        final localData = await _getCollectionData(collection);
        final colRef = sessionRef.collection(collection);
        for (final entry in localData.entries) {
          await colRef.doc(entry.key).set(entry.value);
        }
      }

      // Ghi finance/totals nếu có
      final financeTotals =
          await localStore.collection('finance').doc('totals').get();
      if (financeTotals != null) {
        await sessionRef.collection('finance').doc('totals').set(financeTotals);
      }
      return nowIso;
    } catch (e) {
      rethrow;
    }
  }

  /// Restore: lấy session mới nhất theo created_at
  Future<void> restoreFromFirebase() async {
    final sessionsRoot = firestore
        .collection('backups')
        .doc(backupRootDocId)
        .collection('sessions');

    final sessionsQuery =
        sessionsRoot.orderBy('created_at', descending: true).limit(1);
    final snapshot = await sessionsQuery.get();
    if (snapshot.docs.isEmpty) {
      return;
    }

    final latestBackup = snapshot.docs.first.reference;

    // Khôi phục các collections
    for (final collection in _collectionsToSync) {
      final colSnap = await latestBackup.collection(collection).get();
      for (final doc in colSnap.docs) {
        await localStore.collection(collection).doc(doc.id).set(doc.data());
      }
    }

    // Khôi phục finance/totals
    final financeTotalsDoc =
        await latestBackup.collection('finance').doc('totals').get();
    if (financeTotalsDoc.exists) {
      final data = financeTotalsDoc.data();
      if (data != null) {
        await localStore.collection('finance').doc('totals').set(data);
      }
    }
  }
}
