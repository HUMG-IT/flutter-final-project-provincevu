# Frontend - Ứng dụng Flutter Quản lý Chi tiêu

Ứng dụng Flutter đa nền tảng cho quản lý thu chi cá nhân.

## Cấu trúc thư mục

```
frontend/
├── lib/
│   ├── main.dart              # Entry point
│   ├── firebase_options.dart  # Firebase config
│   ├── charts/                # Biểu đồ
│   ├── data/                  # Dữ liệu mặc định
│   ├── models/                # Data models
│   ├── screens/               # Màn hình UI
│   ├── services/              # Business logic
│   ├── utils/                 # Utilities
│   └── widgets/               # Custom widgets
├── android/                   # Android platform
├── ios/                       # iOS platform
├── web/                       # Web platform
├── windows/                   # Windows platform
├── linux/                     # Linux platform
├── macos/                     # macOS platform
└── pubspec.yaml
```

## Cài đặt

```bash
cd frontend
flutter pub get
```

## Chạy ứng dụng

### Chạy trên thiết bị/emulator

```bash
flutter run
```

### Chạy trên web

```bash
flutter run -d chrome
```

### Chạy trên Windows

```bash
flutter run -d windows
```

## Tính năng

- Quản lý giao dịch thu/chi
- Danh mục chi tiêu tùy chỉnh
- Thống kê theo tháng
- Biểu đồ chi tiêu 7 ngày
- Backup/Restore với Firebase
- Lưu trữ offline với Localstore

## Kết nối với Backend

Frontend có thể kết nối với Backend API:

```dart
// Ví dụ gọi API
final response = await http.get(
  Uri.parse('http://localhost:8080/api/v1/transactions'),
);
```

Để sử dụng API backend thay vì Firebase, cập nhật các service trong `lib/services/`.
