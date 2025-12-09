import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// App root – now Stateful to allow future theming or global state changes
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomePage(),
        '/details': (_) => const DetailsScreen(),
      },
      initialRoute: '/',
    );
  }
}

/// Home screen – Stateful
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Key để mở Drawer từ IconButton
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Giả lập dữ liệu: Chi tiêu trong nhiều ngày (sẽ lấy 7 ngày gần nhất)
  List<Map<String, dynamic>> getSpendingData() {
    return [
      {"day": "2025-12-01", "amount": 300},
      {"day": "2025-12-02", "amount": 500},
      {"day": "2025-12-03", "amount": 700},
      {"day": "2025-12-04", "amount": 200},
      {"day": "2025-12-05", "amount": 900}, // lớn nhất
      {"day": "2025-12-06", "amount": 400},
      {"day": "2025-12-07", "amount": 600},
      {"day": "2025-12-08", "amount": 250}, // ngoài phạm vi 7 ngày
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // Drawer (menu bên trái)
      drawer: const AppSideMenu(),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Đảm bảo nội dung cuộn được trên màn hình ngắn
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        const Column(
                          children: [
                            Text(
                              'Tổng số dư',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$15,825.40',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
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

                    // Biểu đồ tròn hiển thị phần trăm chi tiêu
                    SizedBox(
                      height: 140,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: PieChartWidget()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Biểu đồ cột: nút Chi tiết sẽ điều hướng sang screen khác
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
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        '/details',
                                        arguments: getSpendingData(),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Chi tiết"),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.arrow_forward_ios,
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
                                  spendingData: getSpendingData(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danh sách các danh mục – đúng chiều cao, cuộn theo SingleChildScrollView
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          child: const Icon(
                            Icons.category,
                            color: Colors.redAccent,
                          ),
                        ),
                        title: Text('Danh mục $index'),
                        subtitle: const Text('Tiền đã chi: \$1000'),
                        trailing: const Text(
                          '-\$500.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Drawer menu bên trái – Stateful
class AppSideMenu extends StatefulWidget {
  const AppSideMenu({super.key});

  @override
  State<AppSideMenu> createState() => _AppSideMenuState();
}

class _AppSideMenuState extends State<AppSideMenu> {
  int _selectedIndex = 0;

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Tùy chọn hành vi khi chọn menu:
    // Ví dụ điều hướng hoặc hiển thị SnackBar
    Navigator.of(context).pop(); // Đóng Drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chọn: ${_menuItems[index].title}')),
    );
  }

  final List<_MenuItem> _menuItems = const [
    _MenuItem(Icons.home, 'Trang chủ'),
    _MenuItem(Icons.pie_chart, 'Biểu đồ'),
    _MenuItem(Icons.list_alt, 'Danh mục'),
    _MenuItem(Icons.settings, 'Cài đặt'),
    _MenuItem(Icons.info, 'Giới thiệu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
              accountName: Text('Province Vu'),
              accountEmail: Text('provincevu@example.com'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  final selected = index == _selectedIndex;
                  return ListTile(
                    leading:
                        Icon(item.icon, color: selected ? Colors.blue : null),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color: selected ? Colors.blue : null,
                      ),
                    ),
                    onTap: () => _onSelect(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  const _MenuItem(this.icon, this.title);
}

/// Biểu đồ tròn (đã là Stateful)
class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  double percent = 0.9; // ví dụ cho phép thay đổi sau này

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 20,
            backgroundColor: Colors.grey.shade300,
            color: Colors.redAccent,
          ),
        ),
        Text(
          "${(percent * 100).round()}%",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Biểu đồ cột – chuyển sang Stateful để dễ mở rộng/animate sau này
class BarChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> spendingData;

  const BarChartWidget({super.key, required this.spendingData});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    final recentData =
        widget.spendingData.reversed.take(7).toList().reversed.toList();

    final amounts =
        recentData.map((e) => (e['amount'] as num).toDouble()).toList();

    final double maxValue =
        amounts.isEmpty ? 0 : amounts.reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double topLabelHeight = 18.0;
        const double bottomLabelHeight = 14.0;
        const double verticalSpacing = 6.0;

        final double availableHeight = constraints.maxHeight;
        double maxBarHeight = availableHeight -
            topLabelHeight -
            bottomLabelHeight -
            (verticalSpacing * 2);
        if (maxBarHeight < 0) maxBarHeight = 0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: recentData.map((data) {
            final double amount = (data['amount'] as num).toDouble();
            final double scaledHeight =
                maxValue > 0 ? (amount / maxValue) * maxBarHeight : 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: topLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${amount.toInt()}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                Container(
                  height: scaledHeight,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: verticalSpacing),
                SizedBox(
                  height: bottomLabelHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (data['day'] as String).substring(5),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

/// Details screen – Stateful, nhận dữ liệu qua arguments khi điều hướng
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Map<String, dynamic>> _data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _data = (args is List<Map<String, dynamic>>) ? args : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết chi tiêu')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _data.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _data[index];
          return ListTile(
            title: Text(item['day'].toString()),
            trailing: Text('\$${item['amount']}'),
          );
        },
      ),
    );
  }
}
