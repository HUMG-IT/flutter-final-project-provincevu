import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/charts/bar_chart.dart';
import 'package:flutter_final_project_provincevu/side_menu.dart';
// import 'package:flutter_final_project_provincevu/charts/pie_chart.dart';
import 'package:flutter_final_project_provincevu/utils/currency.dart'
    as currency;
import 'package:flutter_final_project_provincevu/widgets/finance_summary_card.dart';
import 'package:localstore/localstore.dart';

/// Home screen – Stateful
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Key để mở Drawer từ IconButton
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Localstore instance
  final db = Localstore.instance;

  /// State: Thu nhập, Chi tiêu, Tổng số dư và dữ liệu chi theo ngày
  double thuNhap = 0; // Thu nhập
  double chiTieu = 0; // Chi tiêu
  int tongSoDu = 0; // Tổng số dư = thuNhap - chiTieu
  Map<String, dynamic> _spendingDocs = {}; // bản đồ {date: {amount: ...}}

  /// Stream lắng nghe thay đổi dữ liệu spending (tùy chọn)
  Stream<Map<String, dynamic>>? _spendingStream;

  // ========= Helpers cho định dạng VND =========

  // Định dạng hiển thị tiền VND dùng utils
  Widget vndText(
    num amount, {
    Color? color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.bold,
    bool negative = false,
  }) {
    return currency.vndText(
      amount,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      negative: negative,
    );
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  /// Tải dữ liệu từ Localstore (finance/totals và collection spending)
  Future<void> _initLoad() async {
    await _loadFinance();
    await _loadSpending();

    // Khởi tạo stream để lắng nghe thay đổi nếu muốn UI tự động cập nhật
    _spendingStream = db.collection('spending').stream;
    _spendingStream?.listen((event) {
      // event có dạng {docId: {amount: ...}}
      setState(() {
        _spendingDocs.addAll(event);
      });
    });
  }

  /// Load Thu nhập/Chi tiêu từ doc finance/totals
  Future<void> _loadFinance() async {
    final totals = await db.collection('finance').doc('totals').get();
    setState(() {
      thuNhap = (totals?['income'] as num?)?.toDouble() ?? 10000000;
      chiTieu = (totals?['expenses'] as num?)?.toDouble() ?? 4500000;
      tongSoDu = (thuNhap - chiTieu).toInt();
    });
  }

  /// Load dữ liệu chi tiêu từng ngày từ collection spending
  Future<void> _loadSpending() async {
    final docs = await db.collection('spending').get();
    setState(() {
      _spendingDocs = docs ?? {};
    });
  }

  /// Save Thu nhập/Chi tiêu vào finance/totals
  Future<void> _saveFinance() async {
    await db.collection('finance').doc('totals').set({
      'income': thuNhap,
      'expenses': chiTieu,
      'updated_at': DateTime.now().toIso8601String(),
    });
    setState(() {
      tongSoDu = (thuNhap - chiTieu).toInt();
    });
  }

  /// Thêm chi tiêu cho một ngày (nếu có sẵn thì cộng dồn)
  Future<void> _addDailySpending(String date, double amount) async {
    final existing = _spendingDocs[date];
    final currentAmount = (existing?['amount'] as num?)?.toDouble() ?? 0.0;
    final newAmount = currentAmount + amount;
    await db.collection('spending').doc(date).set({
      'amount': newAmount,
      'updated_at': DateTime.now().toIso8601String(),
    });
    await _loadSpending();
  }

  /// Lấy 7 ngày gần nhất để hiển thị cho BarChartWidget (từ Localstore)
  List<Map<String, dynamic>> getSpendingDataFromLocalstore() {
    // _spendingDocs có dạng { 'YYYY-MM-DD': { 'amount': <double> }, ... }
    final entries = _spendingDocs.entries
        .map(
          (e) => {
            'day': e.key,
            'amount': (e.value['amount'] as num?)?.toDouble() ?? 0.0,
          },
        )
        .toList();

    // Sắp xếp theo ngày tăng dần để lấy 7 gần nhất theo thứ tự
    entries.sort((a, b) => (a['day'] as String).compareTo(b['day'] as String));

    // Lấy 7 cuối cùng (gần nhất), rồi đảm bảo thứ tự từ cũ đến mới
    final last7 = entries.length <= 7
        ? entries
        : entries.sublist(entries.length - 7);
    return last7;
  }

  /// Demo: thêm chi tiêu ngày hôm nay 300.000 đ
  Future<void> _demoAddToday() async {
    final now = DateTime.now();
    final date =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    await _addDailySpending(date, 300000);
  }

  /// Demo: cập nhật Thu nhập/Chi tiêu
  Future<void> _demoUpdateFinance() async {
    // Ví dụ chỉnh tăng thu nhập thêm 1 triệu
    setState(() {
      thuNhap += 1000000;
    });
    await _saveFinance();
  }

  @override
  Widget build(BuildContext context) {
    final spendingData = getSpendingDataFromLocalstore();

    return Scaffold(
      key: _scaffoldKey,

      // Drawer (menu bên trái)
      drawer: AppSideMenu(),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Thanh trên cùng: menu, số dư, đổi giao diện
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Mở Drawer
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Tổng số dư',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            vndText(
                              tongSoDu,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.dark_mode),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Biểu đồ tròn hiển thị phần trăm chi tiêu + tiêu đề và tháng/năm
                    FinanceSummaryCard(
                      thuNhap: thuNhap,
                      chiTieu: chiTieu,
                      onUpdate: _demoUpdateFinance,
                    ),
                    const SizedBox(height: 20),

                    // Biểu đồ cột: dữ liệu từ Localstore
                    SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Chi tiêu 7 ngày gần đây',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _demoAddToday,
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Thêm hôm nay +300k"),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.add,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: BarChartWidget(
                                  spendingData: spendingData,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danh sách các danh mục – ví dụ hiển thị chi của hôm nay
                    ListView.builder(
                      itemCount: _spendingDocs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final entry = _spendingDocs.entries.elementAt(index);
                        final date = entry.key;
                        final amount =
                            (entry.value['amount'] as num?)?.toDouble() ?? 0.0;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.redAccent.withValues(
                              alpha: 0.1,
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.redAccent,
                            ),
                          ),
                          title: Text('Ngày $date'),
                          subtitle: Row(
                            children: [
                              const Text('Tiền đã chi: '),
                              vndText(
                                amount,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ],
                          ),
                          trailing: vndText(
                            amount,
                            color: Colors.red,
                            fontSize: 14,
                            negative: true,
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // nút hình tròn
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // hành động khi nhấn nút
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
