# Backend - API Server Quản lý Chi tiêu

REST API server viết bằng Dart sử dụng Shelf framework.

## Cấu trúc thư mục

```
backend/
├── bin/
│   └── server.dart          # Entry point
├── lib/
│   └── src/
│       ├── models/          # Data models
│       │   ├── transaction_model.dart
│       │   └── category_model.dart
│       ├── services/        # Business logic
│       │   ├── transaction_service.dart
│       │   └── category_service.dart
│       └── routes/          # API routes
│           ├── transaction_routes.dart
│           └── category_routes.dart
├── pubspec.yaml
└── analysis_options.yaml
```

## Cài đặt

```bash
cd backend
dart pub get
```

## Chạy server

```bash
dart run bin/server.dart
```

Server sẽ chạy tại `http://localhost:8080`

## API Endpoints

### Giao dịch (Transactions)

| Method | Endpoint                                  | Mô tả                   |
| ------ | ----------------------------------------- | ----------------------- |
| GET    | `/api/v1/transactions`                    | Lấy tất cả giao dịch    |
| GET    | `/api/v1/transactions/:id`                | Lấy giao dịch theo ID   |
| POST   | `/api/v1/transactions`                    | Tạo giao dịch mới       |
| PUT    | `/api/v1/transactions/:id`                | Cập nhật giao dịch      |
| DELETE | `/api/v1/transactions/:id`                | Xoá giao dịch           |
| GET    | `/api/v1/transactions/stats/summary`      | Thống kê tổng quan      |
| GET    | `/api/v1/transactions/stats/last7days`    | Chi tiêu 7 ngày gần đây |
| GET    | `/api/v1/transactions/month/:year/:month` | Giao dịch theo tháng    |

### Danh mục (Categories)

| Method | Endpoint                        | Mô tả                                   |
| ------ | ------------------------------- | --------------------------------------- |
| GET    | `/api/v1/categories`            | Lấy tất cả danh mục                     |
| GET    | `/api/v1/categories/type/:type` | Lấy danh mục theo loại (income/expense) |
| GET    | `/api/v1/categories/:id`        | Lấy danh mục theo ID                    |
| POST   | `/api/v1/categories`            | Tạo danh mục mới                        |
| DELETE | `/api/v1/categories/:id`        | Xoá danh mục                            |

### Các endpoint khác

| Method | Endpoint  | Mô tả         |
| ------ | --------- | ------------- |
| GET    | `/`       | Thông tin API |
| GET    | `/health` | Health check  |

## Ví dụ Request

### Tạo giao dịch mới

```bash
curl -X POST http://localhost:8080/api/v1/transactions \
  -H "Content-Type: application/json" \
  -d '{"amount": 50000, "category": "food", "type": "expense", "note": "Ăn trưa"}'
```

### Lấy thống kê

```bash
curl http://localhost:8080/api/v1/transactions/stats/summary
```
