/// Hệ thống đa ngôn ngữ - Tiếng Việt và Tiếng Anh
class AppStrings {
  static String _language = 'vi';

  static void setLanguage(String lang) {
    _language = lang;
  }

  static String get language => _language;
  static bool get isVietnamese => _language == 'vi';

  // App
  static String get appName =>
      isVietnamese ? 'Quản lý Chi tiêu' : 'Expense Manager';

  // Menu
  static String get home => isVietnamese ? 'Trang chủ' : 'Home';
  static String get statisticByMonth =>
      isVietnamese ? 'Thống kê theo tháng' : 'Monthly Statistics';
  static String get statisticByCategory =>
      isVietnamese ? 'Thống kê theo danh mục' : 'Category Statistics';
  static String get backupRestore =>
      isVietnamese ? 'Sao lưu & Khôi phục' : 'Backup & Restore';
  static String get settings => isVietnamese ? 'Cài đặt' : 'Settings';

  // Home Screen
  static String get totalBalance =>
      isVietnamese ? 'Tổng số dư' : 'Total Balance';
  static String get income => isVietnamese ? 'Thu nhập' : 'Income';
  static String get expense => isVietnamese ? 'Chi tiêu' : 'Expense';
  static String get last7Days =>
      isVietnamese ? 'Chi tiêu 7 ngày gần đây' : 'Last 7 days expenses';
  static String get noData => isVietnamese ? 'Không có dữ liệu' : 'No data';

  // Add Expense Screen
  static String get addTransaction =>
      isVietnamese ? 'Thêm giao dịch' : 'Add Transaction';
  static String get editTransaction =>
      isVietnamese ? 'Sửa giao dịch' : 'Edit Transaction';
  static String get amount => isVietnamese ? 'Số tiền' : 'Amount';
  static String get enterAmount =>
      isVietnamese ? 'Nhập số tiền' : 'Enter amount';
  static String get category => isVietnamese ? 'Danh mục' : 'Category';
  static String get selectCategory =>
      isVietnamese ? 'Chọn danh mục' : 'Select category';
  static String get note => isVietnamese ? 'Ghi chú' : 'Note';
  static String get enterNote => isVietnamese ? 'Nhập ghi chú' : 'Enter note';
  static String get date => isVietnamese ? 'Ngày' : 'Date';
  static String get save => isVietnamese ? 'Lưu' : 'Save';
  static String get cancel => isVietnamese ? 'Hủy' : 'Cancel';
  static String get delete => isVietnamese ? 'Xóa' : 'Delete';
  static String get edit => isVietnamese ? 'Sửa' : 'Edit';

  // Statistics
  static String get filterBy => isVietnamese ? 'Lọc theo' : 'Filter by';
  static String get month => isVietnamese ? 'Tháng' : 'Month';
  static String get year => isVietnamese ? 'Năm' : 'Year';
  static String get selectMonth => isVietnamese ? 'Chọn tháng' : 'Select month';
  static String get selectYear => isVietnamese ? 'Chọn năm' : 'Select year';
  static String get total => isVietnamese ? 'Tổng' : 'Total';
  static String get transactions => isVietnamese ? 'giao dịch' : 'transactions';

  // Transaction History
  static String get transactionHistory =>
      isVietnamese ? 'Lịch sử giao dịch' : 'Transaction History';
  static String get noTransactions =>
      isVietnamese ? 'Không có giao dịch nào' : 'No transactions';
  static String get deleteConfirm =>
      isVietnamese ? 'Xác nhận xóa' : 'Confirm Delete';
  static String get deleteTransactionConfirm => isVietnamese
      ? 'Bạn có chắc muốn xóa giao dịch này?'
      : 'Are you sure you want to delete this transaction?';
  static String get transactionDeleted =>
      isVietnamese ? 'Đã xóa giao dịch' : 'Transaction deleted';
  static String get transactionUpdated =>
      isVietnamese ? 'Đã cập nhật giao dịch' : 'Transaction updated';

  // Settings
  static String get theme => isVietnamese ? 'Giao diện' : 'Theme';
  static String get lightMode => isVietnamese ? 'Sáng' : 'Light';
  static String get darkMode => isVietnamese ? 'Tối' : 'Dark';
  static String get languageLabel => isVietnamese ? 'Ngôn ngữ' : 'Language';
  static String get vietnamese => isVietnamese ? 'Tiếng Việt' : 'Vietnamese';
  static String get english => isVietnamese ? 'Tiếng Anh' : 'English';

  // Backup & Restore
  static String get backup => isVietnamese ? 'Sao lưu' : 'Backup';
  static String get restore => isVietnamese ? 'Khôi phục' : 'Restore';
  static String get backupSuccess =>
      isVietnamese ? 'Sao lưu thành công' : 'Backup successful';
  static String get restoreSuccess =>
      isVietnamese ? 'Khôi phục thành công' : 'Restore successful';
  static String get backupFailed =>
      isVietnamese ? 'Sao lưu thất bại' : 'Backup failed';
  static String get restoreFailed =>
      isVietnamese ? 'Khôi phục thất bại' : 'Restore failed';

  // Categories
  static String get food => isVietnamese ? 'Ăn uống' : 'Food';
  static String get transport => isVietnamese ? 'Đi lại' : 'Transport';
  static String get health => isVietnamese ? 'Sức khỏe' : 'Health';
  static String get education => isVietnamese ? 'Giáo dục' : 'Education';
  static String get family => isVietnamese ? 'Gia đình' : 'Family';
  static String get shopping => isVietnamese ? 'Mua sắm' : 'Shopping';
  static String get pets => isVietnamese ? 'Thú cưng' : 'Pets';
  static String get other => isVietnamese ? 'Khác' : 'Other';
  static String get salary => isVietnamese ? 'Lương' : 'Salary';
  static String get savings =>
      isVietnamese ? 'Lãi tiết kiệm' : 'Savings Interest';
  static String get bonus => isVietnamese ? 'Thưởng' : 'Bonus';

  // Common
  static String get ok => isVietnamese ? 'Đồng ý' : 'OK';
  static String get yes => isVietnamese ? 'Có' : 'Yes';
  static String get no => isVietnamese ? 'Không' : 'No';
  static String get error => isVietnamese ? 'Lỗi' : 'Error';
  static String get success => isVietnamese ? 'Thành công' : 'Success';
  static String get loading => isVietnamese ? 'Đang tải...' : 'Loading...';
  static String get noNote => isVietnamese ? 'Không có ghi chú' : 'No note';
}
