# 🛠️ Hướng Dẫn Phát Triển (Developer Guide)

## Yêu Cầu Hệ Thống

- **Flutter SDK:** >= 3.0.0
- **Dart SDK:** >= 3.0.0
- **Android Studio** hoặc **VS Code** với Flutter extension
- **Git**
- **Firebase CLI** (cho tính năng sao lưu)

---

## Cài Đặt Môi Trường

### 1. Clone Repository

```bash
git clone https://github.com/HUMG-IT/flutter-final-project-provincevu.git
cd flutter_final_project_provincevu
```

### 2. Cài Đặt Dependencies

```bash
cd frontend
flutter pub get
```

### 3. Cấu Hình Firebase (Tùy chọn)

```bash
# Cài đặt Firebase CLI
npm install -g firebase-tools

# Đăng nhập Firebase
firebase login

# Cấu hình FlutterFire
flutterfire configure
```

### 4. Chạy Ứng Dụng

```bash
flutter run
```

---

## Cấu Trúc Thư Mục Chi Tiết

```
frontend/lib/
├── main.dart                 # Entry point, khởi tạo app
├── firebase_options.dart     # Cấu hình Firebase (auto-generated)
│
├── charts/                   # Các widget biểu đồ
│   ├── bar_chart.dart        # Biểu đồ cột
│   ├── pie_chart.dart        # Biểu đồ tròn
│   └── category_pie_chart.dart
│
├── data/                     # Dữ liệu tĩnh/mặc định
│   └── default_categories.dart  # Danh mục mặc định
│
├── models/                   # Data models (PODO)
│   ├── category_model.dart   # Model danh mục
│   ├── giao_dich_model.dart  # Model giao dịch (Transaction)
│   └── user_model.dart       # Model người dùng
│
├── providers/                # State management
│   └── app_state.dart        # Provider quản lý theme
│
├── screens/                  # Các màn hình chính
│   ├── home_screen.dart
│   ├── add_expense_screen.dart             # Màn hình thêm chi tiêu
│   ├── transaction_history_screen.dart     # Màn hinh lịch sử giao dịch
│   ├── statistic_category_screen.dart      # Thống kê theo danh mục
│   ├── statistic_month_screen.dart         # Thống kê theo tháng
│   ├── backup_restore_screen.dart          # Màn hình sao lưu/khôi phục
│   └── settings_screen.dart
│
├── services/                 # Các dịch vụ & API
│   ├── category_service.dart # Service quản lý danh mục
│   └── syns_data.dart        # Service đồng bộ Firebase
│
├── utils/                    # Tiện ích chung
│   ├── app_strings.dart      # Chuỗi văn bản
│   ├── app_theme.dart        # Theme sáng/tối
│   └── currency.dart         # Format tiền tệ VND
│
└── widgets/                  # Widget tái sử dụng nhiều lần
    ├── finance_summary_card.dart   # Card tổng quan tài chính
    └── category_7days_widget.dart  # Widget danh mục 7 ngày
```

---

## Kiến Trúc Ứng Dụng

### Luồng Dữ Liệu

```
User Input → Screen → Service → Localstore/Firebase → Service → Screen → UI Update
```

---

## Data Models

### Transaction (giao_dich_model.dart)

```dart
class Transaction {
  final String id;
  final double amount;
  final String type;      // 'income' | 'expense'
  final String category;
  final DateTime date;
  final String note;

  // Methods: toMap(), fromMap(), copyWith()
}
```

### Category (category_model.dart)

```dart
class Category {
  final String id;
  final String name;
  final String icon;      // Icon name là string
  final String type;      // gồm 'income' | 'expense'

  // Methods: toMap(), fromMap(), copyWith()
}
```

---

## Lưu Trữ Dữ Liệu

### Localstore (Offline)

```dart
final db = Localstore.instance;

// Create
await db.collection('transactions').doc(id).set(data);

// Read
final data = await db.collection('transactions').get();

// Update
await db.collection('transactions').doc(id).set(updatedData);

// Delete
await db.collection('transactions').doc(id).delete();
```

### Firebase Firestore (Backup dữ liệu)

```dart
final firestore = FirebaseFirestore.instance;

// Backup
await firestore
    .collection('backups')
    .doc('app_shared_backup')
    .collection('sessions')
    .doc(timestamp)
    .collection('transactions')
    .doc(id)
    .set(data);

// Restore
final snapshot = await firestore
    .collection('backups')
    .doc('app_shared_backup')
    .collection('sessions')
    .orderBy(FieldPath.documentId, descending: true)
    .limit(1)
    .get();
```

---

## Kiểm Thử

### Chạy Unit Test

```bash
flutter test
```

### Chạy Test với Coverage

```bash
flutter test --coverage
```

### Xem Coverage Report

```bash
# Cài genhtml (đối với Linux/Mac)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Viết Test Mới

```dart
// test/my_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyWidget Tests', () {
    test('should do something', () {
      // Arrange
      // Act
      // Assert
      expect(actual, expected);
    });

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(MyWidget());
      expect(find.text('Hello'), findsOneWidget);
    });
  });
}
```

## Hỗ Trợ

Mọi vấn đề vui lòng:

1. Tạo Issue trên GitHub
2. Liên hệ qua email: [tinhvu2k4@gmail.com]
