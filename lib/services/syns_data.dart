import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstore/localstore.dart';

class DataSyncService {
  final Localstore localStore = Localstore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Kiểm tra người dùng đã đăng nhập hay chưa
  bool get isLoggedIn => firebaseAuth.currentUser != null;

  /// Lấy email của người dùng hiện tại
  String? get userEmail => firebaseAuth.currentUser?.email;

  /// Lấy ID của người dùng hiện tại
  String? get userId => firebaseAuth.currentUser?.uid;

  /// Tải dữ liệu từ Localstore
  Future<Map<String, dynamic>> getAllLocalstoreData() async {
    final data = await localStore.collection('transactions').get();
    return data ?? {};
  }

  /// Sao lưu dữ liệu từ Localstore lên Firebase
  Future<void> backupToFirebase() async {
    if (!isLoggedIn) {
      throw Exception("Người dùng chưa đăng nhập");
    }

    final String? userId = firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Không thể xác định ID người dùng");
    }

    // Lấy dữ liệu từ Localstore
    final localData = await getAllLocalstoreData();

    // Tải lên Firebase Firestore
    final backupCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('backups');

    for (var entry in localData.entries) {
      await backupCollection.doc(entry.key).set(entry.value);
    }

    print("Dữ liệu đã sao lưu lên Firebase");
  }

  /// Phục hồi dữ liệu từ Firebase về Localstore
  Future<void> restoreFromFirebase() async {
    if (!isLoggedIn) {
      throw Exception("Người dùng chưa đăng nhập");
    }

    final String? userId = firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Không thể xác định ID người dùng");
    }

    final backupCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('backups');

    final snapshot = await backupCollection.get();

    for (var doc in snapshot.docs) {
      await localStore.collection('transactions').doc(doc.id).set(doc.data());
    }

    print("Dữ liệu đã được phục hồi từ Firebase về thiết bị");
  }

  /// Đăng nhập người dùng bằng email và password
  Future<UserCredential> login(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký tài khoản mới
  Future<UserCredential> register(String email, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
