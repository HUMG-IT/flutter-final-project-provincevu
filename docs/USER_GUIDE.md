# 📚 Hướng Dẫn Sử Dụng Ứng Dụng Quản Lý Chi Tiêu

## 📱 Các Màn Hình Chính

### 1. Màn Hình Chính (Home Screen)

![Home Screen](docs/images/home_screen.png)

**Chức năng:**

- Xem tổng số dư (Thu nhập - Chi tiêu)
- Xem biểu đồ tròn tỷ lệ thu/chi theo tháng
- Xem biểu đồ cột chi tiêu 7 ngày gần đây
- Xem thống kê chi tiêu theo danh mục 7 ngày
- Chuyển đổi giữa theme sáng/tối

**Thao tác:**

- Nhấn nút **+** để thêm giao dịch mới
- Nhấn icon **menu** (☰) để mở menu điều hướng
- Nhấn icon **theme** (light/dark) để đổi chế độ sáng/tối
- Vuốt biểu đồ để xem chi tiết

---

### 2. Màn Hình Thêm Giao Dịch (Add Expense Screen)

![Add Expense](docs/images/add_expense.png)

**Chức năng:**

- Thêm giao dịch mới (thu nhập hoặc chi tiêu)
- Chọn danh mục cho giao dịch
- Chọn ngày giờ giao dịch
- Thêm ghi chú cho giao dịch

**Thao tác:**

1. Chọn loại giao dịch: **Thu nhập** hoặc **Chi tiêu**
2. Nhập số tiền
3. Chọn danh mục phù hợp
4. Chọn ngày giờ (mặc định là hiện tại)
5. Nhập ghi chú (tùy chọn)
6. Nhấn **Lưu** để hoàn tất

---

### 3. Màn Hình Lịch Sử Giao Dịch (Transaction History)

![Transaction History](docs/images/transaction_history.png)

**Chức năng:**

- Xem danh sách tất cả giao dịch
- Lọc theo loại (thu nhập/chi tiêu)
- Xóa giao dịch
- Sửa giao dịch

**Thao tác:**

- Nhấn vào giao dịch để xem chi tiết/sửa
- Vuốt sang trái để xóa giao dịch
- Sử dụng tab để lọc theo loại

---

### 4. Màn Hình Thống Kê Theo Danh Mục

![Category Statistics](docs/images/category_stats.png)

**Chức năng:**

- Xem biểu đồ tròn phân bổ chi tiêu/thu nhập theo danh mục
- Lọc theo tháng hoặc năm
- Xem chi tiết từng danh mục

**Thao tác:**

- Chọn tab **Chi tiêu** hoặc **Thu nhập**
- Chọn tháng/năm để xem thống kê
- Nhấn vào danh mục để xem chi tiết

---

### 5. Màn Hình Thống Kê Theo Tháng

![Month Statistics](docs/images/month_stats.png)

**Chức năng:**

- Xem biểu đồ so sánh thu nhập/chi tiêu theo tháng
- Xem số dư cuối tháng
- So sánh với các tháng trước

---

### 6. Màn Hình Sao Lưu & Khôi Phục

![Backup Restore](docs/images/backup_restore.png)

**Chức năng:**

- Sao lưu dữ liệu lên Firebase
- Khôi phục dữ liệu từ Firebase về thiết bị
- Đồng bộ dữ liệu giữa các thiết bị

**Thao tác:**

1. Nhấn **Sao lưu dữ liệu** để upload lên Firebase
2. Nhấn **Khôi phục dữ liệu** để download về thiết bị
3. Chờ thông báo thành công

**Lưu ý:**

- Cần kết nối Internet để sao lưu/khôi phục
- Dữ liệu được lưu theo phiên (timestamp)
- Khôi phục sẽ lấy bản sao lưu mới nhất

---

### 7. Màn Hình Cài Đặt

![Settings](docs/images/settings.png)

**Chức năng:**

- Đổi chế độ sáng/tối
- Xem thông tin ứng dụng
- Các tùy chọn khác

---

## Luồng Hoạt Động

### Thêm Giao Dịch Mới

```
HomeScreen → Nhấn (+) → AddExpenseScreen → Nhập thông tin → Lưu → Quay về HomeScreen (đã cập nhật)
```

### Xem & Sửa Giao Dịch

```
HomeScreen → Menu → Lịch sử giao dịch → Chọn giao dịch → Sửa → Lưu
```

### Sao Lưu Dữ Liệu

```
HomeScreen → Menu → Sao lưu → Nhấn "Sao lưu dữ liệu" → Chờ thành công
```

### Khôi Phục Dữ Liệu

```
HomeScreen → Menu → Sao lưu → Nhấn "Khôi phục dữ liệu" → Chờ thành công → Reload app
```

---

## Mẹo Sử Dụng

1. **Thêm giao dịch nhanh:** Từ màn hình chính, nhấn nút (+) màu xanh
2. **Xem thống kê nhanh:** Nhấn vào biểu đồ tròn trên màn hình chính
3. **Đổi theme:** Nhấn icon mặt trời/mặt trăng góc phải trên
4. **Sao lưu thường xuyên:** Để tránh mất dữ liệu khi đổi thiết bị

---

## FAQ - Câu Hỏi Thường Gặp

### Q: Dữ liệu có được lưu khi tắt ứng dụng không?

**A:** Có, dữ liệu được lưu cục bộ trên thiết bị bằng Localstore.

### Q: Làm sao để đồng bộ dữ liệu giữa 2 điện thoại?

**A:**

1. Trên điện thoại 1: Vào Sao lưu → Nhấn "Sao lưu dữ liệu"
2. Trên điện thoại 2: Vào Sao lưu → Nhấn "Khôi phục dữ liệu"

### Q: Ứng dụng có hoạt động offline không?

**A:** Có, tất cả dữ liệu được lưu cục bộ. Chỉ cần Internet khi sao lưu/khôi phục.
