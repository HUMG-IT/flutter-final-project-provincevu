# Ứng Dụng Quản Lý Chi Tiêu Cá Nhân

## Thông Tin Dự Án

- **Tên dự án:** Flutter Final Project - Personal Finance Manager
- **Sinh viên:** [Điền tên sinh viên]
- **MSSV:** [Điền MSSV]
- **Môn học:** Phát Triển Đa Nền Tảng
- **Giảng viên:** [Điền tên giảng viên]

---

## Mục Tiêu Dự Án

Ứng dụng quản lý chi tiêu cá nhân được xây dựng với Flutter, cho phép người dùng:

- Theo dõi thu nhập và chi tiêu hàng ngày
- Phân loại giao dịch theo danh mục
- Xem thống kê chi tiêu theo thời gian và danh mục
- Sao lưu và khôi phục dữ liệu qua Firebase
- Hoạt động offline với dữ liệu cục bộ

---

---

## Công Nghệ & Thư Viện Sử Dụng

| Thư viện        | Phiên bản | Mục đích                            |
| --------------- | --------- | ----------------------------------- |
| Flutter         | 3.x       | Framework xây dựng UI               |
| Dart            | >=3.0.0   | Ngôn ngữ lập trình                  |
| localstore      | ^1.4.0    | Lưu trữ dữ liệu cục bộ (JSON/NoSQL) |
| firebase_core   | ^4.2.1    | Tích hợp Firebase                   |
| firebase_auth   | ^6.1.2    | Xác thực người dùng                 |
| cloud_firestore | ^6.1.0    | Cơ sở dữ liệu đám mây               |
| charts_flutter  | ^0.12.0   | Vẽ biểu đồ                          |
| provider        | ^6.0.5    | Quản lý trạng thái                  |
| intl            | ^0.17.0   | Định dạng ngày tháng, tiền tệ       |
| http            | ^1.2.0    | Gọi API RESTful                     |

---

## Chức Năng Đã Hoàn Thành

### 1. CRUD Giao Dịch

- [x] **Create:** Thêm giao dịch mới (thu nhập/chi tiêu)
- [x] **Read:** Xem danh sách giao dịch, lịch sử giao dịch
- [x] **Update:** Sửa thông tin giao dịch
- [x] **Delete:** Xóa giao dịch

### 2. Giao Diện Người Dùng

- [x] Màn hình chính (Dashboard) với tổng quan tài chính
- [x] Màn hình thêm/sửa giao dịch
- [x] Màn hình lịch sử giao dịch
- [x] Màn hình thống kê theo danh mục
- [x] Màn hình thống kê theo tháng
- [x] Màn hình sao lưu/khôi phục dữ liệu
- [x] Màn hình cài đặt (đổi theme sáng/tối)
- [x] Menu điều hướng (Side Menu)

### 3. Tích Hợp Backend/Database

- [x] Lưu trữ cục bộ với Localstore (NoSQL/JSON)
- [x] Đồng bộ dữ liệu lên Firebase Firestore
- [x] Sao lưu & khôi phục dữ liệu giữa các thiết bị
- [x] Xử lý lỗi và hiển thị thông báo cho người dùng

### 4. Quản Lý Trạng Thái

- [x] Sử dụng Provider để quản lý theme (sáng/tối)
- [x] StatefulWidget để quản lý state cục bộ
- [x] Cập nhật UI tự động khi dữ liệu thay đổi

### 5. Biểu Đồ & Thống Kê

- [x] Biểu đồ tròn (Pie Chart) - Tỷ lệ thu/chi
- [x] Biểu đồ cột (Bar Chart) - Chi tiêu 7 ngày gần đây
- [x] Thống kê theo danh mục
- [x] Thống kê theo tháng

### 6. CI/CD

- [x] Cấu hình GitHub Actions
- [x] Tự động chạy kiểm thử khi push code

---

## Kiểm Thử Tự Động

### Chạy kiểm thử trên máy cá nhân:

```bash
cd frontend
flutter test
```

### Chạy kiểm thử với coverage:

```bash
cd frontend
flutter test --coverage
```

---

## Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### Yêu cầu:

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Git

### Các bước cài đặt:

1. **Clone repository:**

```bash
git clone https://github.com/HUMG-IT/flutter-final-project-provincevu.git
cd flutter_final_project_provincevu/frontend
```

2. **Cài đặt dependencies:**

```bash
flutter pub get
```

3. **Chạy ứng dụng:**

```bash
flutter run
```

---

## Video Demo

| Nội dung              | Link         |
| --------------------- | ------------ |
| Demo chức năng chính  | [Link video] |
| Demo kiểm thử tự động | [Link video] |

---

## Tự Đánh Giá

Xem chi tiết tại: [SELF_EVALUATION.md](./SELF_EVALUATION.md)

---

## Ghi Chú Thêm

- Ứng dụng hoạt động tốt trên cả Android và iOS
- Hỗ trợ chế độ sáng/tối (Dark Mode)
- Dữ liệu được lưu cục bộ, có thể sao lưu lên Firebase
- Responsive design, hiển thị tốt trên nhiều kích thước màn hình

---

## Liên Hệ

- Email: [tinhvu2k4@gmail.com]
- GitHub: [@provincevu]
