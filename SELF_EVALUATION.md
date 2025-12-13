# Tự Đánh Giá Bài Tập Lớn

## Thông Tin Sinh Viên

- **Họ tên:** Vũ Văn Tỉnh
- **MSSV:** 2221050517
- **Lớp:** Công nghệ Thông tin Chất lượng cao B K67

---

## Tiêu Chí Đánh Giá Chi Tiết

### 1. Build & CI/CD

| Tiêu chí                          | Trạng thái | Ghi chú                                   |
| --------------------------------- | ---------- | ----------------------------------------- |
| Build thành công trên máy cá nhân | Đạt        | `flutter run` chạy thành công             |
| GitHub Actions cấu hình đúng      | Đạt        | File `.github/workflows/flutter_test.yml` |
| CI/CD báo "Success"               | Đạt        | Xem trạng thái trên GitHub                |

**Điểm phần này: 5/5**

---

### 2. Chức Năng CRUD

| Chức năng  | Đối tượng   | Trạng thái | File liên quan                                        |
| ---------- | ----------- | ---------- | ----------------------------------------------------- |
| **Create** | Transaction | Đạt        | `add_expense_screen.dart`                             |
| **Read**   | Transaction | Đạt        | `home_screen.dart`, `transaction_history_screen.dart` |
| **Update** | Transaction | Đạt        | `add_expense_screen.dart` (edit mode)                 |
| **Delete** | Transaction | Đạt        | `transaction_history_screen.dart`                     |
| **Create** | Category    | Đạt        | `category_service.dart`                               |
| **Read**   | Category    | Đạt        | `default_categories.dart`                             |

**Data Model được sử dụng:**

- `Transaction` (giao_dich_model.dart): id, amount, type, category, date, note
- `Category` (category_model.dart): id, name, icon, type, color

**Điểm phần này: 1/1**

---

### 3. Quản Lý Trạng Thái & UI

| Tiêu chí                           | Trạng thái | Chi tiết                                              |
| ---------------------------------- | ---------- | ----------------------------------------------------- |
| Giao diện hiển thị danh sách       | Đạt        | `home_screen.dart`, `transaction_history_screen.dart` |
| Giao diện chi tiết đối tượng       | Đạt        | `add_expense_screen.dart`                             |
| Thao tác CRUD không cần reload app | Đạt        | Sử dụng `setState`, widget key                        |
| Thông báo thành công/thất bại      | Đạt        | SnackBar cho mọi thao tác                             |
| Quản lý trạng thái                 | Đạt        | Provider (theme), StatefulWidget                      |

**Các màn hình đã có:**

1.  HomeScreen - Dashboard tổng quan
2.  AddExpenseScreen - Thêm/sửa giao dịch
3.  TransactionHistoryScreen - Lịch sử giao dịch
4.  StatisticCategoryScreen - Thống kê theo danh mục
5.  StatisticMonthScreen - Thống kê theo tháng
6.  BackupRestoreScreen - Sao lưu/khôi phục
7.  SettingsScreen - Cài đặt

**Điểm phần này: 1/1**

---

### 4. Tích Hợp API/CSDL

| Tiêu chí                    | Trạng thái | Chi tiết                      |
| --------------------------- | ---------- | ----------------------------- |
| Lưu trữ cục bộ (Localstore) | Đạt        | NoSQL/JSON, hoạt động offline |
| Tích hợp Firebase Firestore | Đạt        | Sao lưu/khôi phục dữ liệu     |
| Xử lý lỗi API/CSDL          | Đạt        | try-catch, hiển thị SnackBar  |
| Đồng bộ dữ liệu             | Đạt        | `syns_data.dart`              |

**Cấu trúc dữ liệu trên Firestore:**

```
backups/
└── app_shared_backup/
    └── sessions/
        └── {timestamp}/
            ├── transactions/
            ├── spending/
            └── finance/totals
```

**Điểm phần này: 1/1**

---

### 6. Tối Ưu Hóa & UI/UX Mượt Mà

| Tiêu chí                           | Trạng thái | Chi tiết               |
| ---------------------------------- | ---------- | ---------------------- |
| Không có cảnh báo trong code       | Đạt        | Cần fix thêm           |
| UI/UX mượt mà                      | Trung bình | Animation, transitions |
| Tính năng nâng cao (tìm kiếm, lọc) | Đạt        | Có thể bổ sung         |
| CI/CD hoàn thiện                   | Trung bình | GitHub Actions         |

**Điểm phần này: 0.5/1**

---

## Tổng Kết Điểm

| Mục                      | Điểm tối đa | Điểm đạt được |
| ------------------------ | ----------- | ------------- |
| Build & CI/CD            | 5           | 5             |
| CRUD cơ bản              | 1           | 1             |
| Quản lý trạng thái & UI  | 1           | 1             |
| Tích hợp API/CSDL        | 1           | 1             |
| Kiểm thử & UI hoàn thiện | 1           | 0.5           |
| Tối ưu hóa & UI/UX       | 1           | 0.5           |
| **TỔNG**                 | **10**      | **9**         |

---

## Điểm Tự Đánh Giá: **9/10**

### Lý do:

1.  **Đạt yêu cầu cơ bản:** Build thành công, CRUD đầy đủ, UI thân thiện
2.  **Tích hợp backend:** Localstore + Firebase Firestore
3.  **Quản lý trạng thái:** Provider + StatefulWidget
